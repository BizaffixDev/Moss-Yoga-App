import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class MainHeading extends StatelessWidget {
  const MainHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 44.5),
      child:  FittedBox(
        child: Text("Personalize your Experience ",
          style: manropeHeadingTextStyle.copyWith(
            fontSize: 22.sp,
          ),
        ),
      ),
    );
  }
}