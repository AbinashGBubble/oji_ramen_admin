import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle _base({
    required FontWeight weight,
    required double size,
    Color color = Colors.white,
    Paint? foreground,
  }) {
    return GoogleFonts.dmSans(
      fontWeight: weight,
      fontSize: size.sp,
      color: foreground == null ? color : null,
      foreground: foreground,
    );
  }

  static TextStyle light({
    double size = 14.0,
    Color color = Colors.white,
  }) =>
      _base(weight: FontWeight.w300, size: size, color: color);

  static TextStyle regular({
    double size = 14.0,
    Color color = Colors.white,
  }) =>
      _base(weight: FontWeight.w400, size: size, color: color);

  static TextStyle medium({
    double size = 14.0,
    Color color = Colors.white,
  }) =>
      _base(weight: FontWeight.w500, size: size, color: color);

  static TextStyle semiBold({
    double size = 14.0,
    Color color = Colors.white,
    Paint? foreground,
  }) =>
      _base(weight: FontWeight.w600, size: size, color: color, foreground: foreground);

  static TextStyle bold({
    double size = 14.0,
    Color color = Colors.white,
  }) =>
      _base(weight: FontWeight.w700, size: size, color: color);

  static TextStyle extraBold({
    double size = 14.0,
    Color color = Colors.white,
  }) =>
      _base(weight: FontWeight.w800, size: size, color: color);

  static TextStyle black({
    double size = 14.0,
    Color color = Colors.white,
  }) =>
      _base(weight: FontWeight.w900, size: size, color: color);
}
