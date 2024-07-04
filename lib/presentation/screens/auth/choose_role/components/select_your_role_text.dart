import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';


class SelectYourRoleText extends StatelessWidget {
  const SelectYourRoleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: Text(
          "Select Your Role",
          style: manropeHeadingTextStyle.copyWith(
            fontSize: 22.sp,
            color: AppColors.primaryColor,

          ),
        ),
      );
  }
}