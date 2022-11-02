import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';

Future<Map> getDeviceInfo() async {
  String? deviceName;
  String? deviceVersion;
  String? identifier;
  Map? allInfo;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.release;
      identifier = build.androidId; //UUID for Android
      allInfo = {
        'version.securityPatch': build.version.securityPatch,
        'version.sdkInt': build.version.sdkInt,
        'version.release': build.version.release,
        'version.previewSdkInt': build.version.previewSdkInt,
        'version.incremental': build.version.incremental,
        'version.codename': build.version.codename,
        'version.baseOS': build.version.baseOS,
        'board': build.board,
        'bootloader': build.bootloader,
        'brand': build.brand,
        'device': build.device,
        'display': build.display,
        'fingerprint': build.fingerprint,
        'hardware': build.hardware,
        'host': build.host,
        'id': build.id,
        'manufacturer': build.manufacturer,
        'model': build.model,
        'product': build.product,
        'supported32BitAbis': build.supported32BitAbis,
        'supported64BitAbis': build.supported64BitAbis,
        'supportedAbis': build.supportedAbis,
        'tags': build.tags,
        'type': build.type,
        'isPhysicalDevice': build.isPhysicalDevice,
        'androidId': build.androidId,
        'systemFeatures': build.systemFeatures,
      };
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.utsname.release;
      identifier = data.identifierForVendor; //UUID for iOS
      // 'device_name': '',
      //   'device_version': '',
      //   'device_identification': '',
      //   'app_version': '',
      //   'token': '',
      //   'extra_info'
    }
  } on PlatformException {
    if (kDebugMode) {
      print('Failed to get platform version');
    }
  }

//if (!mounted) return;
  return {
    'deviceName': deviceName,
    'deviceVersion': deviceVersion,
    'identifier': identifier,
    'allInfo': allInfo,
  };
}
