import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'remote_config_defaults.dart';

import 'remote_config_keys.dart';

class RemoteConfigService {
  RemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance; // MODIFIED

  static RemoteConfigService? _instance; // NEW
  factory RemoteConfigService() => _instance ??= RemoteConfigService._(); // NEW

  final FirebaseRemoteConfig _remoteConfig;

  String getString(String key) => _remoteConfig.getString(key); // NEW
  bool getBool(String key) => _remoteConfig.getBool(key); // NEW
  int getInt(String key) => _remoteConfig.getInt(key); // NEW
  double getDouble(String key) => _remoteConfig.getDouble(key); // NEW

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
            fetchTimeout: const Duration(minutes: 1),
            minimumFetchInterval: const Duration(minutes: 30)),
      );
  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
        const {
          RemoteConfigKeys.host: RemoteConfigDefaults.host,
          RemoteConfigKeys.playStore: RemoteConfigDefaults.playStore,
          RemoteConfigKeys.appleStore: RemoteConfigDefaults.appleStore,
          RemoteConfigKeys.tile: RemoteConfigDefaults.tile,
          RemoteConfigKeys.alipay: RemoteConfigDefaults.alipay,
          RemoteConfigKeys.wechat: RemoteConfigDefaults.wechat,
        },
      );
  Future<void> fetchAndActivate() {
    return _remoteConfig.fetchAndActivate().then((updated) {
      if (updated) {
        debugPrint('The config has been updated.');
      } else {
        debugPrint('The config is not updated..');
      }
    }).catchError((err) {
      debugPrint('The config error: $err');
    });
  }

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate().catchError((err) {
      debugPrint("Remote Config Error: $err");
    });
  }
}

final message = RemoteConfigService().getString(RemoteConfigKeys.host);
