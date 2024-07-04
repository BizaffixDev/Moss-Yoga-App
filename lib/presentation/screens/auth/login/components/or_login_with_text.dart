import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';

class ORLoginWithText extends StatelessWidget {
  ORLoginWithText({
    super.key,
    required this.isLogin,
  });

  bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 47),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          isLogin
              ? Text(
                  "or Login with",
                  style: manropeSubTitleTextStyle.copyWith(fontSize: 12.sp),
                )
              : Text(
                  "or Register with",
                  style: manropeSubTitleTextStyle.copyWith(fontSize: 12.sp),
                ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
