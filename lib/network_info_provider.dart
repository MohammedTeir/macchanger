import 'package:network_info_plus/network_info_plus.dart';
import 'dart:developer' as developer;

class NetworkInfoData {
  final String name;
  final String ipAddress;
  final String macAddress;

  NetworkInfoData({required this.name, required this.ipAddress, required this.macAddress});
}

class NetworkInfoProvider {
  final _networkInfo = NetworkInfo();

  Future<List<NetworkInfoData>> getNetworkInterfaces() async {
    final List<NetworkInfoData> interfaces = [];

    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiBSSID = await _networkInfo.getWifiBSSID(); // This is the MAC address of the access point

      if (wifiName != null && wifiIP != null && wifiBSSID != null) {
        // Note: getWifiBSSID() returns the MAC of the AP, not the device.
        // We will need a different method to get the device's MAC for wlan0
        // For now, we will use a placeholder.
        interfaces.add(NetworkInfoData(name: wifiName, ipAddress: wifiIP, macAddress: "XX:XX:XX:XX:XX:XX"));
      }
    } catch (e, s) {
      // Handle exceptions
      developer.log('Error getting Wi-Fi info', name: 'myapp.network_info_provider', error: e, stackTrace: s);
    }

    // In a real root app, we would use shell commands to get all interfaces,
    // like `ip addr` or `ifconfig`, and parse the output.
    // For now, we will just return the Wi-Fi interface if available.

    return interfaces;
  }
}
