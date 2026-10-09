import 'dart:io';

import 'package:eagle_cargo/core/utils/dev_constants.dart';

class API {
  static String userToken = "";
  static String _host = "";
  static const String _defaultHost = "https://cargo.sanlyteklip.com.tm";

  static String get host {
    // 1. Check if it's empty, use default
    String currentHost = _host.isEmpty ? _defaultHost : _host;

    // 2. If it's missing 'http', add it automatically
    if (!currentHost.startsWith('http')) {
      return 'http://$currentHost';
    }

    return currentHost;
  }

  static set host(String value) {
    // We trim it here to prevent accidental spaces from the console
    _host = value.trim();
  }

  static String get authority {
    String currentHost = _host.isEmpty ? _defaultHost : _host;
    return currentHost.replaceFirst('http://', '').replaceFirst('https://', '');
  }

  static String firmGuid = "2ad509ac-65cf-4e73-b617-ccebe0ea0dc9";
  static Map<String, String> get headers {
    return userToken.isEmpty
        ? {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.userAgentHeader:
                "EagleCargo/${DevConstants.appVersion}",
            "X-headers-app": "eagle-cargo",
          }
        : {
            HttpHeaders.authorizationHeader: "Bearer $userToken",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.userAgentHeader:
                "EagleCargo/${DevConstants.appVersion}",
            "X-headers-app": "eagle-cargo",
          };
  }

  static const firmDetails = '/api/v1/firms';
  static const firmRates = '/api/v2/firm-rates/firm-service';

  static const notifications = '/api/v2/notifications';
  static const appLogo = '/public/errors/app_logo.png';
  //Auth
  static const login = '/api/v1/auth/smart-login/init';
  static const verifyAuth = '/api/v1/auth/smart-login/verify';
  static const register = '/api/v1/auth/smart-login/register';
  static const resendOtp = '/api/v1/auth/otp/resend';
  static const registerUnsafe = '/api/core/v1/auth/customer/register';
  static const loginUnsafe = '/api/core/v1/auth/customer/login';
  static const deleteAccount = '/api/v2/account/deactivate';
  static const updateFcm = '/api/v2/account/fcm-token';

  //End Aut
  static const profile = '/api/v2/account/profile';

  static const translations = '/api/v1/translations';
  static const translationLanguages = '/api/v1/translations/languages';
  static const locations = '/api/v1/locations';
  static const orders = '/api/v1/orders'; //Get all orders with pagination
  static const trackOrder =
      '/api/v1/orders/track/{orderNumber}'; //Track your order
  static const warehouses = '/api/v1/warehouses/{firmGuid}';
  static const warehousesCore = '/api/core/v1/warehouses/firm/{firmGuid}';
  static const warehouseDetail =
      '/api/core/v1/warehouses/detail/{warehouseGuid}';
  static const warnings = '/api/core/v2/warnings';
  static const paymentInfo = '/api/v2/firm-settings/payment/info';
  static const sliders = '/api/v2/sliders';
}
