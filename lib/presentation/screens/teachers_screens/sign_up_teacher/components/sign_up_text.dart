import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/text_styles.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 32.w,right: 239.w,top: 77.h),
          child: FittedBox(
            child: Text(
              "Sign Up",
              style: manropeHeadingTextStyle.copyWith(
                color: Colors.white,
                fontSize: 32.sp,
              ),
            ),
          ),
        ),

        SizedBox(
          height: 16.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 32.w,right: 65.w),
          child: FittedBox(
            child: Text(
              "Please register with us to start your\njourney",
              style: manropeSubTitleTextStyle.copyWith(
                height: 1.2,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }
}