import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Transport {
  final String key;
  final String name;
  final IconData icon;

  Transport(this.key, this.name, this.icon);
}

class DevConstants {
  static String appVersion = '';

  static Future<void> initAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // Format it however you like, e.g., "v1.1.0"
    appVersion = 'v${packageInfo.version}';
  }

  static List<Transport> transports = [
    Transport('air', 'type_air', Icons.airplanemode_active_rounded),
    Transport('road', 'type_road', Icons.local_shipping_rounded),
    Transport('sea', 'type_sea', Icons.directions_boat_rounded),
    Transport('rail', 'type_rail', Icons.train),
  ];
  static String playStore =
      "https://play.google.com/store/apps/details?id=tm.com.sanlyteklip.eagle";
  static String appleStore =
      "https://apps.apple.com/us/app/EagleCargo/id6756780790";
  static String alipay = '1ta0E88VE-bnLalyETtsRFatxLO3z6JbV';
  static String wechat = '1ta0E88VE-bnLalyETtsRFatxLO3z6JbV';
}
