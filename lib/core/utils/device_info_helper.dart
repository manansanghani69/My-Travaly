import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoHelper {
  DeviceInfoHelper._();

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) {
      final info = await deviceInfoPlugin.webBrowserInfo;
      return <String, dynamic>{
        'browserName': info.browserName.name,
        'appCodeName': info.appCodeName,
        'appName': info.appName,
        'appVersion': info.appVersion,
        'deviceMemory': info.deviceMemory,
        'language': info.language,
        'platform': info.platform,
        'userAgent': info.userAgent,
      };
    }

    if (Platform.isAndroid) {
      final info = await deviceInfoPlugin.androidInfo;
      return <String, dynamic>{
        'device': info.device,
        'brand': info.brand,
        'model': info.model,
        'manufacturer': info.manufacturer,
        'androidId': info.id,
        'product': info.product,
        'hardware': info.hardware,
        'sdkInt': info.version.sdkInt,
        'release': info.version.release,
        'incremental': info.version.incremental,
        'fingerprint': info.fingerprint,
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    }

    if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      return <String, dynamic>{
        'name': info.name,
        'systemName': info.systemName,
        'systemVersion': info.systemVersion,
        'model': info.model,
        'localizedModel': info.localizedModel,
        'identifierForVendor': info.identifierForVendor,
        'utsname': <String, dynamic>{
          'sysname': info.utsname.sysname,
          'nodename': info.utsname.nodename,
          'release': info.utsname.release,
          'version': info.utsname.version,
          'machine': info.utsname.machine,
        },
        'isPhysicalDevice': info.isPhysicalDevice,
      };
    }

    if (Platform.isWindows) {
      final info = await deviceInfoPlugin.windowsInfo;
      return <String, dynamic>{
        'computerName': info.computerName,
        'numberOfCores': info.numberOfCores,
        'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
        'userName': info.userName,
        'deviceId': info.deviceId,
        'buildLab': info.buildLab,
        'productName': info.productName,
        'releaseId': info.releaseId,
      };
    }

    if (Platform.isMacOS) {
      final info = await deviceInfoPlugin.macOsInfo;
      return <String, dynamic>{
        'computerName': info.computerName,
        'model': info.model,
        'kernelVersion': info.kernelVersion,
        'osRelease': info.osRelease,
        'arch': info.arch,
        'majorVersion': info.majorVersion,
        'minorVersion': info.minorVersion,
        'patchVersion': info.patchVersion,
        'activeCPUs': info.activeCPUs,
        'memorySize': info.memorySize,
        'systemGUID': info.systemGUID,
      };
    }

    if (Platform.isLinux) {
      final info = await deviceInfoPlugin.linuxInfo;
      return <String, dynamic>{
        'name': info.name,
        'version': info.version,
        'id': info.id,
        'idLike': info.idLike,
        'versionCodename': info.versionCodename,
        'versionId': info.versionId,
        'prettyName': info.prettyName,
        'machineId': info.machineId,
      };
    }

    final baseInfo = await deviceInfoPlugin.deviceInfo;
    return Map<String, dynamic>.from(baseInfo.data);
  }
}
