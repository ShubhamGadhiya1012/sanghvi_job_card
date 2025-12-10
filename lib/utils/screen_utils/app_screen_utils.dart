import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScreenUtils {
  static double get height => ScreenUtil().screenHeight;
  static double get width => ScreenUtil().screenWidth;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }
}
