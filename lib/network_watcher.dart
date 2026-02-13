import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

typedef NetworkChangeCallback = void Function(List<ConnectivityResult> result);

class NetworkWatcher {
  final NetworkChangeCallback onNetworkChange;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkWatcher({required this.onNetworkChange}) {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      onNetworkChange(result);
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}
