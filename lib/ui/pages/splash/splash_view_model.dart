import 'package:flutter/material.dart';
import 'splash_page.dart';

import '../../../core/api/api.dart';
import '../../../core/api/providers/index.dart';
import '../../../core/remote_config/index.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/notification_util.dart';
import 'package:kargoo_core/kargoo_core.dart' hide PreferenceManager, PreferenceKeys, Palette;
import 'package:eagle_cargo/core/preferences/preferences_util.dart';
import 'package:eagle_cargo/core/preferences/preference_keys.dart';
import 'package:eagle_cargo/core/utils/dev_constants.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_auth/smart_auth.dart';

abstract class SplashViewModel extends State<SplashPage>{
  final _notificationUtil = NotificationUtil();
  bool apiError = false;

  @override
  void initState() {
    super.initState();
    _initFCM();
    _requestSmsConsentOnce();
    startAppFlow();
  }

  // Starts the SMS User Consent listener the first time the app is ever
  // opened, so the system "Allow app to read this message?" dialog can
  // fire even if the OTP SMS arrives before the user reaches the OTP page.
  // The OTP page starts its own listener too; that simply re-registers it.
  void _requestSmsConsentOnce() {
    final alreadyRequested = PreferenceManager.instance.getBoolValue(
      PreferenceKeys.SMS_CONSENT_REQUESTED,
    );
    if (alreadyRequested) return;

    PreferenceManager.instance.setBoolValue(
      PreferenceKeys.SMS_CONSENT_REQUESTED,
      true,
    );
    SmartAuth.instance.getSmsWithUserConsentApi();
  }

  // -----------------------------
  // FCM INITIALIZATION
  // -----------------------------
  void _initFCM() {
    _notificationUtil.requestPermissions();
    _notificationUtil.initNotificationUtil(
      onSelectNotification: (v) {},
      context: context,
    );

    FirebaseMessaging.onMessage.listen(
      (msg) => _notificationUtil.showNotification(msg: msg),
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (msg) => _notificationUtil.showNotification(msg: msg),
    );
  }

  // -----------------------------
  // MAIN FLOW
  // -----------------------------
  Future<void> startAppFlow() async {
    await Future.delayed(const Duration(milliseconds: 800)); // small delay

    if (!await hasInternet()) return;

    await _initRemoteConfig();
    await _loginUser();
  }

  Future<bool> hasInternet() async {
    final List<ConnectivityResult> result = await Connectivity()
        .checkConnectivity();

    // If the list contains 'none', or if it's empty, there's no connection
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      return false;
    }
    return true;
  }

  // -----------------------------
  // REMOTE CONFIG
  // -----------------------------
  Future<void> _initRemoteConfig() async {
    final remoteConfig = RemoteConfigService();

    API.host = remoteConfig.getString(RemoteConfigKeys.host);
    DevConstants.playStore = remoteConfig.getString(RemoteConfigKeys.playStore);
    DevConstants.appleStore = remoteConfig.getString(
      RemoteConfigKeys.appleStore,
    );
    DevConstants.alipay = remoteConfig.getString(RemoteConfigKeys.alipay);
    DevConstants.wechat = remoteConfig.getString(RemoteConfigKeys.wechat);

    context.read<FirebaseTopicsProvider>().addTopic("eagle_cargo-users");
  }

  // -----------------------------
  // LOGIN + LOAD TRANSLATIONS
  // -----------------------------
  Future<void> _loginUser() async {
    await context.read<TranslationProvider>().initialize(
      host: API.host,
      path: API.translations,
    );

    try {
      await context.read<AuthProvider>().initData(
        onDone: () async {
          // load all translations first
          // final isFirstApp = PreferenceManager.instance.getBoolValue(
          //   PreferenceKeys.IS_FIRST_APP,
          // );
          // if (isFirstApp) {
          // Navigator.pushReplacementNamed(context, Routes.onboarding);
          // } else {
          Navigator.pushReplacementNamed(context, Routes.main);
          // }
        },
        onError: (err) {
          if (err is ApiException && err.statusCode == 401) {
            Navigator.pushReplacementNamed(context, Routes.login);
          } else if (err != null) {
            setState(() {
              apiError = true;
            });
          } else {
            Navigator.pushReplacementNamed(context, Routes.login);
          }
        },
      );
    } catch (e) {
      debugPrint("Login error: $e");
      setState(() {
        apiError = true;
      });
    }
  }
}