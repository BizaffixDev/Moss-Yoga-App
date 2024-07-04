import 'package:flutter/material.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class NotNowText extends StatelessWidget {
  final VoidCallback onTap;
  const NotNowText({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  Text("Skip",
        style:manropeHeadingTextStyle.copyWith(
          fontSize: 16,
          color: AppColors.primaryColor
        ),),
    );
  }
}