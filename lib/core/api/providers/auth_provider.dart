import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide PreferenceManager, PreferenceKeys, Palette;
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/auth_model.dart';
import 'package:eagle_cargo/core/api/services/auth_service.dart';
import 'package:eagle_cargo/core/preferences/preference_keys.dart';
import 'package:eagle_cargo/core/preferences/preferences_util.dart';

enum ProfileState { profile, login, register, otp }

class AuthProvider extends ChangeNotifier {
  final PreferenceManager cache = PreferenceManager.instance;
  String? token;
  bool isLoggedIn = false;
  User? _profile;
  User? get profile => _profile;
  String _fullname = "";
  String _phone = "";
  String _email = "";
  bool _isRegistrationRequired = false;
  bool get isRegistrationRequired => _isRegistrationRequired;
  ProfileState _profileState = ProfileState.login;
  ProfileState get profileState => _profileState;

  String get fullname => _fullname;
  String get phone => _phone;
  String get email => _email;
  set profileState(ProfileState state) {
    _profileState = state;
    notifyListeners();
  }

  Future<void> initData({Function? onDone, Function(dynamic)? onError}) async {
    // return _prefs.then((prefs) async {
    token = cache.getStringValue(PreferenceKeys.USER_TOKEN);
    if (token != null && (token?.isNotEmpty ?? false)) {
      API.userToken = token ?? "";
      return getProfile(
        onSuccess: () {
          onDone?.call();
          isLoggedIn = true;
          _saveInCache.call();
          profileState = ProfileState.profile;
          notifyListeners();
        },
        onError: (err) {
          if (err is ApiException && err.statusCode == 401) {
            logout();
          }
          onError?.call(err);
        },
      );
    } else {
      onError?.call(null);
    }
  }

  void setToken(String? value) {
    token = value;
    API.userToken = value ?? "";
    notifyListeners();
  }

  void setLogin(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  void _saveInCache() {
    API.userToken = token ?? "";
    debugPrint("Token set to $token");
    cache.setStringValue(PreferenceKeys.USER_TOKEN, token ?? '');
    cache.setStringValue(PreferenceKeys.USER_FULLNAME, _fullname);
    cache.setStringValue(PreferenceKeys.USER_PHONE, _phone);
    cache.setStringValue(PreferenceKeys.USER_MAIL, _email);
  }

  Future<void> initLogin({
    required String phone,
    Function? onSuccess,
    Function? onError,
    Function? onRegisterRequired,
    Function? onDeletedAccount,
  }) {
    return AuthService.login(phone: phone)
        .then((v) {
          if (v['status'] == 'registration_required') {
            _isRegistrationRequired = true;
            onRegisterRequired?.call();
            _phone = phone;
            notifyListeners();
            return;
          }
          if (v['status'] == 'login_required') {
            _phone = phone;
            onSuccess?.call();
          }
          if (v['status'] == 'deleted' || v['message'] == 'deleted') {
            onDeletedAccount?.call();
          }
        })
        .catchError((err) {
          debugPrint(err.toString());
          onError?.call();
        });
  }

  Future<void> loginWithPassword({
    required String phone,
    required String password,
    Function? onSuccess,
    Function? onError,
  }) async {
    try {
      final result = await AuthService.loginUnsafe(
        phone: phone,
        password: password,
      );
      if (result?.accessToken != null) {
        token = result?.accessToken;
        API.userToken = token!;
        _phone = phone;
        isLoggedIn = true;

        await getProfile();
        _saveInCache();

        profileState = ProfileState.profile;
        notifyListeners();

        onSuccess?.call();
      } else {
        onError?.call();
      }
    } catch (e) {
      debugPrint('Login password error: $e');
      onError?.call();
    }
  }

  Future<void> verify({
    required String phone,
    required String otp,
    Function? onSuccess,
    Function? onRegisterRequired,
    Function? onError,
  }) async {
    try {
      final result = await AuthService.verify(phone: phone, otp: otp);
      if (result?.status == 'registration_verified') {
        _isRegistrationRequired = true;
        onRegisterRequired?.call();
        notifyListeners();
      }
      if (result?.status == 'login_success') {
        token = result?.accessToken;
        API.userToken = token!;
        _phone = phone;
        isLoggedIn = true;

        await getProfile(); // ✅ fetch profile first
        _saveInCache(); // ✅ now cache correct data

        profileState = ProfileState.profile;
        notifyListeners();

        onSuccess?.call();
      }
    } catch (e) {
      debugPrint('Verify error: $e');
      onError?.call();
    }
  }

  Future<void> register({
    required String name,
    required String password,
    String? email,
    String? locationGuid,
    Function? onSuccess,
    Function? onAlreadyRegistered,
    Function? onError,
  }) {
    Future<Map<String, dynamic>> registerFuture = AuthService.register(
      phone: _phone,
      name: name,
      email: email,
      password: password,
      locationGuid: locationGuid,
    );

    return registerFuture
        .then((v) {
          if (v['data'] is AuthModel) {
            token = v['data'].accessToken;
            _phone = phone;
            isLoggedIn = true;
            _saveInCache.call();
            getProfile.call();
            onSuccess?.call();
            notifyListeners();
          }
        })
        .catchError((err) {
          debugPrint(err.toString());
          onError?.call();
        });
  }

  Future<void> getProfile({Function? onSuccess, Function(dynamic)? onError}) {
    return AuthService.profile()
        .then((v) {
          _profile = v;
          _fullname = v?.fullname ?? '';
          _phone = v?.phone ?? '';
          _email = v?.email ?? '';
          onSuccess?.call();
          notifyListeners();
        })
        .catchError((err) {
          debugPrint(err.toString());
          onError?.call(err);
        });
  }

  Future<void> updateProfile({
    String? name,
    String? locationGuid,
    Function? onSuccess,
    Function? onError,
  }) async {
    final res = await AuthService.updateProfile(
      fullname: name,
      locationGuid: locationGuid,
    );
    if (res) {
      await getProfile(); // Refresh profile after update
      onSuccess?.call();
    } else {
      onError?.call();
    }
  }

  Future<void> resendOtp({Function? onSuccess, Function? onError}) {
    return AuthService.resendOtp(phone: _phone)
        .then((v) {
          return v ? onSuccess?.call() : onError?.call();
        })
        .catchError((err) {
          debugPrint("$err");
          onError?.call();
        });
  }

  void logout({Function? onSuccess}) {
    isLoggedIn = false;
    API.userToken = "";
    if (onSuccess != null) onSuccess.call();
    notifyListeners();
    cache.clearAll();
    profileState = ProfileState.login;
  }

  Future<void> deleteAccount({Function? onSuccess, Function? onError}) async {
    try {
      final response = await AuthService.deleteAccount();
      debugPrint("Delete account response: $response");
      // Cleanup on success
      isLoggedIn = false;
      API.userToken = "";
      cache.clearAll();
      notifyListeners();
      onSuccess?.call(); // This will now always run on success
    } catch (err) {
      debugPrint("Account delete error: $err");
      onError?.call();
    }
  }

  Future<String?> _getFCMTokenSafely() async {
    try {
      // final fcm = FirebaseMessaging.instance; // <--- Uncomment this
      // String? token = await fcm.getToken();   // <--- Uncomment this
      // return (token?.isEmpty ?? true) ? null : token; // <--- Uncomment this

      // Placeholder return value if not using the actual package for now:
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint("Attempting to retrieve FCM Token...");
      return token; // Replace with real logic
    } catch (e) {
      debugPrint("Error fetching FCM token: $e");
      return null; // Return null on any Firebase error
    }
  }

  Future<void> updateFcm({Function? onSuccess, Function? onError}) async {
    final fcmToken = await _getFCMTokenSafely();
    debugPrint("FCM Token retrieved for login: $fcmToken");
    return AuthService.updateFcm(token: fcmToken ?? "")
        .then((v) {
          onSuccess?.call();
          notifyListeners();
        })
        .catchError((err) {
          debugPrint(err.toString());
          onError?.call();
        });
  }
}
