import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkConfig {
  var _connectionStatus = "Unknown";

  StreamController<ConnectivityResult> connectionStatusController =
      StreamController<ConnectivityResult>();

  NetworkConfig() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(result);
    });
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}

enum ConnectivityStatus { WiFi, Cellular, Offline }
