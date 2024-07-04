import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';


class RoleButtons extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback? onTap;
  final Color bgColor;
  final Color txtColor;
  final int? id;
  final Border? border;
   const RoleButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.bgColor,
     required this.txtColor,
    this.onTap,
     this.id,
     this.border,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: onTap,
      splashColor: AppColors.primaryColor,
      child: Container(
        height: 120.h,
        width: 171.w,
        decoration: BoxDecoration(
            border:border,
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0,1),
            ),
          ]

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            //Image.asset(icon,height: 50,),
            Text(
              text,
              style: manropeHeadingTextStyle.copyWith(
                fontSize: 16.sp,
                color:txtColor,
              ),
            )
          ],
        ),
      ),



     /* Container(
        height: 117,
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              height: 34,
              width: 34,
            ),

            // Image.asset(icon,
            // height: 34,
            // width: 34,),
            SizedBox(
              height: 12,
            ),
            Text(
              text,
              style: kHeading3TextStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),*/
    );
  }
}
