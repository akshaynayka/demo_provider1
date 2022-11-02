import 'package:package_info_plus/package_info_plus.dart';

import '../values/strings_en.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

setScreenValue(String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('tabScreen', value);
}

Future<String?> getScreenValue() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('tabScreen');
}

Future<PackageInfo> getPackageInfo() async {
  final info = await PackageInfo.fromPlatform();

  // print('APP NAME -->${info.appName}');
  // print('buildNumber -->${info.buildNumber}');
  // print('buildSignature -->${info.buildSignature}');
  // print('packageName -->${info.packageName}');
  // print('version -->${info.version}');

  return info;
}

displaySnackbar(BuildContext ctx, title, value) {
  if (value != null && value != '') {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('$title $value'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

Future<void> showErrorDialog(String message, BuildContext context) async {
  await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text(TITLE_ERROR_OCCURED),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(
                  TITLE_OKAY,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ));
}
