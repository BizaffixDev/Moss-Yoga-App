import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/colors.dart';

class SocialLogin extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const SocialLogin({
    super.key, required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        height: 53.h,
        width: 109.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryColor,),

        ),
        child: Center(
          child: SvgPicture.asset(icon,height: 30,),
        ),
      ),
    );
  }
}