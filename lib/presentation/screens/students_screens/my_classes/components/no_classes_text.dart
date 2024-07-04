import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/text_styles.dart';

class NoClassesText extends StatelessWidget {
  const NoClassesText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 58.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "No classes to show",
            style: manropeHeadingTextStyle.copyWith(
              fontSize: 25.sp,
            ),
          ),
          Text(
            "Book your classes and embark on your\nyoga journey ",
            style: manropeSubTitleTextStyle.copyWith(
                fontSize: 14.sp,
                color: const Color(0xFF7F9195),
                height: 1.2),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 100.h,
          ),
        ],
      ),
    );
  }
}