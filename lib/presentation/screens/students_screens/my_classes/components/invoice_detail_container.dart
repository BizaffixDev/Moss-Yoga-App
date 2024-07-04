import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/resources/text_styles.dart';

class InvoiceDetailContainer extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  const InvoiceDetailContainer({
    super.key, required this.icon, required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
      height: 80.h,
      width: 335.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF7F5FA),
      ),

      child: ListTile(
        leading: Container(
          height: 37.h,
          width: 37.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8),

          child: SvgPicture.asset(icon),
        ),
        title: Text(title,style: manropeHeadingTextStyle.copyWith(
          fontSize: 16.sp,
        ),),
        subtitle: Text(subtitle,
        ),
      ),

    );
  }
}