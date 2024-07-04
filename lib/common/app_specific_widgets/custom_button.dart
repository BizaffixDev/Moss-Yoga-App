import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';

import '../resources/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? btnColor;
  final Color? textColor;
  final double? h;
  final double? w;
  final double? m;
  final Border? border;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.btnColor = const Color(0XFFE8E8E8),
    this.textColor = Colors.black,
    this.border,
    this.h = 0.07,
    this.w = 0.8,
    this.m = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: CommonFunctions.deviceHeight(context) * h!,
        width: CommonFunctions.deviceWidth(context) * w!,
        margin:  EdgeInsets.symmetric(horizontal: m!),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: btnColor,
        border: border,
        ),

        child: Center(
          child: Text(
            text,
            style: manropeHeadingTextStyle.copyWith(
              fontSize: 20.sp,
                height: 1.2,
                fontWeight: FontWeight.w700, color: textColor),
          ),
        ),
      ),
    );
  }
}
