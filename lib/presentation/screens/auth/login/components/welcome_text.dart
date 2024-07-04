import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/text_styles.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 32.w,right: 215.w,top: 129.h),
          child: FittedBox(
            child: Text(
              "Welcome",
              style: manropeHeadingTextStyle.copyWith(
                color: Colors.white,
                fontSize: 32.sp,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 32.w,right: 65.w),
          child: FittedBox(
            child: Text(
              "Please Log in to continue using our app",
              style: manropeSubTitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }
}