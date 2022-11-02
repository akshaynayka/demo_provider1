import 'package:flutter/material.dart';

import '../values/strings_en.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(TITLE_LOADING),
      ),
    );
  }
}
