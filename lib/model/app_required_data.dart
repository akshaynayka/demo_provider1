import 'package:flutter/material.dart';

class AppRequiredData with ChangeNotifier {
  final String? minBuildNumber;
  final String? playStoreBuildNumber;

  AppRequiredData({
    this.minBuildNumber,
    this.playStoreBuildNumber,
  });
}
