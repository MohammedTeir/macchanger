import 'dart:io';
import 'dart:developer' as developer;

class MacChanger {
  Future<String?> getMacAddress(String interface) async {
    try {
      final result = await Process.run('su', ['-c', 'cat /sys/class/net/$interface/address']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      } else {
        return null;
      }
    } catch (e, s) {
      developer.log('Error getting MAC address', name: 'myapp.mac_changer', error: e, stackTrace: s);
      return null;
    }
  }

  Future<bool> changeMacAddress(String interface, String newMac) async {
    // Method A: ip link
    bool success = await _tryChangeMacWithIpLink(interface, newMac);
    if (success) return true;

    // Method B: ifconfig
    success = await _tryChangeMacWithIfconfig(interface, newMac);
    if (success) return true;

    // Method C: echo to file (less common, but a good fallback)
    success = await _tryChangeMacWithEcho(interface, newMac);
    return success;
  }

  Future<bool> _tryChangeMacWithIpLink(String interface, String newMac) async {
    try {
      var result = await Process.run('su', ['-c', 'ip link set $interface down']);
      if (result.exitCode != 0) return false;

      result = await Process.run('su', ['-c', 'ip link set dev $interface address $newMac']);
      if (result.exitCode != 0) return false;

      result = await Process.run('su', ['-c', 'ip link set $interface up']);
      return result.exitCode == 0;
    } catch (e, s) {
      developer.log('Error with ip link method', name: 'myapp.mac_changer', error: e, stackTrace: s);
      return false;
    }
  }

  Future<bool> _tryChangeMacWithIfconfig(String interface, String newMac) async {
    try {
      var result = await Process.run('su', ['-c', 'ifconfig $interface down']);
      if (result.exitCode != 0) return false;

      result = await Process.run('su', ['-c', 'ifconfig $interface hw ether $newMac']);
      if (result.exitCode != 0) return false;

      result = await Process.run('su', ['-c', 'ifconfig $interface up']);
      return result.exitCode == 0;
    } catch (e, s) {
      developer.log('Error with ifconfig method', name: 'myapp.mac_changer', error: e, stackTrace: s);
      return false;
    }
  }

  Future<bool> _tryChangeMacWithEcho(String interface, String newMac) async {
    try {
      final result = await Process.run('su', ['-c', 'echo $newMac > /sys/class/net/$interface/address']);
      return result.exitCode == 0;
    } catch (e, s) {
      developer.log('Error with echo method', name: 'myapp.mac_changer', error: e, stackTrace: s);
      return false;
    }
  }
}
