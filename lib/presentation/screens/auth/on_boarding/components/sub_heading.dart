import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class SubHeading extends StatelessWidget {
  const SubHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin:  EdgeInsets.symmetric(horizontal: 42,vertical: 60.h),
      child: Text("The ultimate wellness tool for\ncultivating your longevity.",
        textAlign: TextAlign.center,
        style:manropeSubTitleTextStyle.copyWith(
          color: AppColors.white,
          height: 1.2,
          fontWeight: FontWeight.w500

        ),),
    );
  }
}
