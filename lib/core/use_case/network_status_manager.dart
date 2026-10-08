import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

typedef NetworkCallBack = void Function(NetworkResult result);

abstract class INetworkChangeManager {
  Future<NetworkResult> checkNetworkFirstTime();
  void handleNetworkChange(NetworkCallBack onChange);
  void dispose();
}

class NetworkChangeManager extends INetworkChangeManager {
  late final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkChangeManager() {
    _connectivity = Connectivity();
  }

  @override
  Future<NetworkResult> checkNetworkFirstTime() async {
    final connectivityResult = await (_connectivity.checkConnectivity());
    return NetworkResult.checkConnectivityResult(connectivityResult);
  }

  @override
  void handleNetworkChange(NetworkCallBack onChange) {
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      onChange.call(NetworkResult.checkConnectivityResult(event));
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
  }
}

enum NetworkResult {
  on,
  off;

  static NetworkResult checkConnectivityResult(
    List<ConnectivityResult> results,
  ) {
    if (results.contains(ConnectivityResult.none)) {
      return NetworkResult.off;
    }
    if (results.isEmpty) {
      return NetworkResult.off;
    }

    // If it contains any of the "on" results, return on
    final onResults = {
      ConnectivityResult.bluetooth,
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
      ConnectivityResult.other,
    };

    if (results.any((result) => onResults.contains(result))) {
      return NetworkResult.on;
    }

    return NetworkResult.off;
  }
}
