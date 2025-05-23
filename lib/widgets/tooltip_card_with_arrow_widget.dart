import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double curveHeight = 40.h;
    final double sideBumpRadius = 30.w;

    final path = Path();
    path.moveTo(0, curveHeight);

    // Left bump
    path.quadraticBezierTo(
      sideBumpRadius / 2, 0,
      sideBumpRadius * 1.2, 0,
    );

    // Curve up to center dip
    path.quadraticBezierTo(
      size.width / 2, -curveHeight,
      size.width - sideBumpRadius * 1.2, 0,
    );

    // Right bump
    path.quadraticBezierTo(
      size.width - sideBumpRadius / 2, 0,
      size.width, curveHeight,
    );

    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
