import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:eagle_cargo/core/api/api.dart';
import 'package:eagle_cargo/core/api/models/auth_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String phone,
    required String name,
    required String password,
    String? email,
    String? locationGuid,
  }) async {
    try {
      final json = await BaseClient.post(
        API.host,
        API.register,
        headers: API.headers,
        body: {
          "phone": phone,
          "fullname": name,
          "email": email,
          "password": password,
          "location_guid": locationGuid,
        },
      );
      return {"data": AuthModel.fromJson(json)};
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        return {"statusCode": 409, "error": "Conflict", "message": e.message};
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> registerUnsafe({
    required String phone,
    required String name,
    required String password,
    String? email,
    String? locationGuid,
  }) async {
    try {
      final json = await BaseClient.post(
        API.host,
        API.registerUnsafe,
        headers: API.headers,
        body: {
          "phone": phone,
          "fullname": name,
          "email": email,
          "password": password,
          "location_guid": locationGuid,
        },
      );
      return {"data": AuthModel.fromJson(json)};
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        return {"statusCode": 409, "error": "Conflict", "message": e.message};
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> login({required String phone}) async {
    try {
      final json = await BaseClient.post(
        API.host,
        API.login,
        headers: API.headers,
        body: {"phone": phone},
      );
      return {"message": json['message'], "status": json['status']};
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        return {"message": e.message, "status": false};
      }
      rethrow;
    }
  }

  static Future<AuthModel?> loginUnsafe({
    required String phone,
    required String password,
  }) async {
    final json = await BaseClient.post(
      API.host,
      API.loginUnsafe,
      headers: API.headers,
      body: {"identifier": phone, "password": password},
    );
    return AuthModel.fromJson(json);
  }

  static Future<AuthModel?> verify({
    required String phone,
    required String otp,
  }) async {
    final json = await BaseClient.post(
      API.host,
      API.verifyAuth,
      headers: API.headers,
      body: {"phone": phone, "otp_code": otp},
    );
    return AuthModel.fromJson(json);
  }

  static Future<User?> profile() async {
    final json = await BaseClient.get(
      API.host,
      API.profile,
      headers: API.headers,
    );
    return User.fromJson(json);
  }

  static Future<bool> resendOtp({required String phone}) async {
    try {
      await BaseClient.post(
        API.host,
        API.resendOtp,
        headers: API.headers,
        body: {"phone": phone},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateFcm({required String token}) async {
    try {
      await BaseClient.patch(
        API.host,
        API.updateFcm,
        headers: API.headers,
        body: {'fcm_token': token},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProfile({
    String? fullname,
    String? locationGuid,
  }) async {
    try {
      await BaseClient.patch(
        API.host,
        API.profile,
        headers: API.headers,
        body: {"fullname": fullname, "location_guid": locationGuid},
      );
      return true;
    } catch (e) {
      debugPrint("Update profile error: $e");
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    try {
      await BaseClient.post(
        API.host,
        API.deleteAccount,
        headers: API.headers,
        body: {},
      );
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }
}
