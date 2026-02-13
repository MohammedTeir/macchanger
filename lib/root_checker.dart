import 'dart:io';

class RootChecker {
  Future<bool> isDeviceRooted() async {
    // A common approach is to check for the presence of superuser binaries.
    // This is not foolproof, but it's a good first check.
    final suPaths = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su',
      '/su/bin/su',
    ];

    for (final path in suPaths) {
      if (await File(path).exists()) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isBusyBoxInstalled() async {
    // Check for the busybox binary in common locations.
    final busyboxPaths = [
      '/system/bin/busybox',
      '/system/xbin/busybox',
      '/sbin/busybox',
      '/vendor/bin/busybox',
    ];

    for (final path in busyboxPaths) {
      if (await File(path).exists()) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isIproute2Installed() async {
    // The 'ip' command is part of iproute2
    final ipPaths = [
      '/system/bin/ip',
    ];

    for (final path in ipPaths) {
      if (await File(path).exists()) {
        return true;
      }
    }

    return false;
  }
}