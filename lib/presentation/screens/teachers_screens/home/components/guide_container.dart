import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class CustomGuideContainer extends StatelessWidget {
  final String text;

  // final bool isFirst;

  const CustomGuideContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
     padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(
          color: AppColors.neutral53,
          width: 0.5, // Adjust the width as needed
        ),
        // converted from hex color #7C8364
        borderRadius: BorderRadius.circular(10), // zero radius for sharp edges
      ),
      child: Center(
        child: Text(
          text,
          overflow:TextOverflow.clip,
          textAlign: TextAlign.center,
          style: manropeSubTitleTextStyle.copyWith(
            fontSize: 14.sp,
            height: 1.2,
            color: Color(0xFF535353),
          )
        ),
      ),
    );
  }
}
