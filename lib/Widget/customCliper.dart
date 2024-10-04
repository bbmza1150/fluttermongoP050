import 'package:flutter/material.dart';

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = Path();

    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);

    /// [Top Left corner]
    var topLeftControlPoint = const Offset(0, 0);
    var topLeftEndPoint = Offset(width * .25, height * .25);
    path.quadraticBezierTo(topLeftControlPoint.dx, topLeftControlPoint.dy,
        topLeftEndPoint.dx, topLeftEndPoint.dy);

    /// [Left Middle]
    var leftMiddleControlPoint = Offset(width * .5, height * .5);
    var leftMiddleEndPoint = Offset(width * .25, height * .75);
    path.quadraticBezierTo(leftMiddleControlPoint.dx,
        leftMiddleControlPoint.dy, leftMiddleEndPoint.dx, leftMiddleEndPoint.dy);

    /// [Bottom Left corner]
    var bottomLeftControlPoint = Offset(0, height);
    var bottomLeftEndPoint = Offset(width, height);
    path.quadraticBezierTo(bottomLeftControlPoint.dx,
        bottomLeftControlPoint.dy, bottomLeftEndPoint.dx, bottomLeftEndPoint.dy);

    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}