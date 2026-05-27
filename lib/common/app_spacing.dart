import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing system (based on 4pt grid)
/// Usage: Gaps.h16, Gaps.w8, Insets.all16
class Gaps {
  // Heights (vertical space)
  static SizedBox h4 = SizedBox(height: 4.h);
  static SizedBox h8 = SizedBox(height: 8.h);
  static SizedBox h12 = SizedBox(height: 12.h);
  static SizedBox h16 = SizedBox(height: 16.h);
  static SizedBox h20 = SizedBox(height: 20.h);
  static SizedBox h24 = SizedBox(height: 24.h);
  static SizedBox h32 = SizedBox(height: 32.h);
  static SizedBox h40 = SizedBox(height: 40.h);

  // Widths (horizontal space)
  static SizedBox w4 = SizedBox(width: 4.w);
  static SizedBox w8 = SizedBox(width: 8.w);
  static SizedBox w12 = SizedBox(width: 12.w);
  static SizedBox w16 = SizedBox(width: 16.w);
  static SizedBox w20 = SizedBox(width: 20.w);
  static SizedBox w24 = SizedBox(width: 24.w);
  static SizedBox w32 = SizedBox(width: 32.w);
  static SizedBox w40 = SizedBox(width: 40.w);
}

/// Predefined EdgeInsets for paddings/margins
class Insets {
  static EdgeInsets all8 = EdgeInsets.all(8.w);
  static EdgeInsets all16 = EdgeInsets.all(16.w);
  static EdgeInsets all24 = EdgeInsets.all(24.w);

  static EdgeInsets h16v8 = EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
  static EdgeInsets h20v12 = EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
  static EdgeInsets h24v16 = EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
}
