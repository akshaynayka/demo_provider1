import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClipperLoginStyle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstPoint = Offset(size.width / 5, size.height / 1.7);
    var endPoint = Offset(size.width, size.height / 1.05);
    path.quadraticBezierTo(
        firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (kDebugMode) {
      print('ClipperLoginStyle----debugprint');
    }
    return true;
  }
}

class ClipperLoginStyle2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height / 1.049);
    var firstPoint = Offset(size.width / 5, size.height / 1.5);
    var endPoint = Offset(size.width, size.height / 1.1);
    path.quadraticBezierTo(
        firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (kDebugMode) {
      print('ClipperLoginStyle2-----debugprint');
    }
    return true;
  }
}

class ClipperStyle extends CustomClipper<Path> {
  final bool secondUi;
  ClipperStyle(this.secondUi);

  @override
  Path getClip(Size size) {
    var path = Path();
    if (secondUi) {
      path.lineTo(0, size.height / 1.2);
      var firstPoint = Offset(size.width / 4, size.height / 1);
      var endPoint = Offset(size.width / 2, size.height / 1.15);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);
      var second = Offset(size.width - size.width / 4, size.height / 1.3);
      var end2Point = Offset(size.width, size.height / 1.1);
      path.quadraticBezierTo(second.dx, second.dy, end2Point.dx, end2Point.dy);
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.lineTo(0, size.height / 1.6);
      var firstPoint = Offset(size.width / 4, size.height / 0.9);
      var endPoint = Offset(size.width / 2, size.height / 1.8);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);
      var second = Offset(size.width / 1.4, size.height / 5);
      var end2Point = Offset(size.width, size.height / 3);
      path.quadraticBezierTo(second.dx, second.dy, end2Point.dx, end2Point.dy);
      path.lineTo(size.width, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (kDebugMode) {
      print('ClipperStyle----debugprint');
    }
    return true;
  }
}

class ClipperStyle2 extends CustomClipper<Path> {
  final bool secondUi;
  ClipperStyle2(this.secondUi);
  @override
  Path getClip(Size size) {
    var path = Path();
    if (secondUi) {
      path.lineTo(0, size.height / 1.3);
      var firstPoint = Offset(size.width / 4, size.height / 1);
      var endPoint = Offset(size.width / 2, size.height / 1.15);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);
      var second = Offset(size.width - size.width / 4, size.height / 1.3);
      var end2Point = Offset(size.width, size.height / 1.19);
      path.quadraticBezierTo(second.dx, second.dy, end2Point.dx, end2Point.dy);
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.lineTo(0, size.height / 1.5);
      var firstPoint = Offset(size.width / 4, size.height / 0.97);
      var endPoint = Offset(size.width / 2, size.height / 1.8);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);
      var second = Offset(size.width / 1.4, size.height / 5);
      var end2Point = Offset(size.width, size.height / 3.2);
      path.quadraticBezierTo(second.dx, second.dy, end2Point.dx, end2Point.dy);
      path.lineTo(size.width, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (kDebugMode) {
      print('ClipperStyle2----debugprint');
    }
    return true;
  }
}

class ClipperStyle3 extends CustomClipper<Path> {
  final bool secondUi;
  ClipperStyle3(this.secondUi);
  @override
  Path getClip(Size size) {
    var path = Path();
    if (secondUi) {
      path.lineTo(0, size.height / 1.15);
      var firstPoint = Offset(size.width / 6, size.height / 1.4);
      var endPoint = Offset(size.width / 2, size.height / 1.3);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);
      var second = Offset(size.width - size.width / 4, size.height / 1.1);
      var end2Point = Offset(size.width, size.height / 1.15);
      path.quadraticBezierTo(second.dx, second.dy, end2Point.dx, end2Point.dy);
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.lineTo(0, size.height / 1.5);
      var firstPoint = Offset(size.width / 4, size.height / 0.97);
      var endPoint = Offset(size.width / 2, size.height / 1.8);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, endPoint.dx, endPoint.dy);
      var second = Offset(size.width / 1.4, size.height / 5);
      var end2Point = Offset(size.width, size.height / 3.2);
      path.quadraticBezierTo(second.dx, second.dy, end2Point.dx, end2Point.dy);
      path.lineTo(size.width, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (kDebugMode) {
      print('ClipperStyle3----debugprint');
    }
    return true;
  }
}
