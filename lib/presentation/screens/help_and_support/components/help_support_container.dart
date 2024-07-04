import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../common/resources/text_styles.dart';

class HelpNSupportContainer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const HelpNSupportContainer({
    super.key, required this.title, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left:20.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        width: 300.w,
        height: 50.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black12,
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: manropeSubTitleTextStyle.copyWith(
                fontSize: 16.sp,
              ),
            ),
            HeroIcon(HeroIcons.chevronRight,),
          ],
        ),
      ),
    );
  }
}
