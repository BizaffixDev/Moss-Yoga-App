import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../resources/text_styles.dart';

class CustomRichText extends StatelessWidget {
  final String text1;
  final String? text2;
  final VoidCallback? onTap;

  const CustomRichText({
    super.key,
    required this.text1,
    this.text2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text1,
            style: manropeSubTitleTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF15104D),
            ),
          ),
          TextSpan(
            text: text2,
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: manropeSubTitleTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                decoration: TextDecoration.underline),
          ),
        ]),
      ),
    );
  }
}
