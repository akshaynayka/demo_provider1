import 'package:flutter/material.dart';

// const primaryColor = Color.fromRGBO(248, 177, 255, 1);
const primaryColor = Color(0xfff2a5cf);
// const primaryColor = Colors.black;
// const primaryColor = Colors.green;
// const primaryColor = Color(0xff14142a);
// const appBarTitleColor = Colors.black;
const appBarTitleColor = Colors.white;
const buttonTextColor = Colors.black;
// const buttonTextColor = Colors.white;
const backgroundColor = Colors.white;
const textColor = Colors.black;
// const textColor = Colors.white;
const subtitleColor = Color(0xff8c8c8c);
// const textInputTitleColor = Colors.black;
const textInputTitleColor = Color(0xff8c8c8c);
const emptyFieldColor = Color.fromARGB(240, 238, 238, 238);
const borderColorLightBlack = Colors.black12;
const favoritColor = Colors.red;
List<Color> colorSwatch = [
  Colors.pink.shade300,
  Colors.pink.shade100,
];
const Map<int, Color> appColorSwatch = {
  50: primaryColor,
  100: primaryColor,
  200: primaryColor,
  300: primaryColor,
  400: primaryColor,
  500: primaryColor,
  600: primaryColor,
  700: primaryColor,
  800: primaryColor,
  900: primaryColor,
};

Color statusColors(String status) {
  if (status == 'Booked') {
    return primaryColor.withOpacity(0.9);
  } else if (status == 'Confirm') {
    return Colors.green.shade300;
  } else if (status == 'Complete') {
    return Colors.blueGrey.shade200;
  } else {
    return Colors.red.shade300;
  }
}

const bool secondStyleUi = true;
// const bool secondStyleUi = false;
