import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/text_styles.dart';

class ViewDetailTopContainer extends StatelessWidget {
  final String image;
  final String teacherName;
  final String yogaType;
  final String badgeIcon;
  const ViewDetailTopContainer({
    super.key, required this.image, required this.teacherName, required this.yogaType, required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
      height: 96.h,
      width: 342.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF7F5FA),

      ),
      child: Row(

        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              bottomLeft: Radius.circular(10.r),
            ),
            child: Image.asset(
              image,
              height: 96.h,
              width: 91.w,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 20.w,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(teacherName,style: manropeHeadingTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),),
                  SizedBox(width:10.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(badgeIcon,height: 10.h,),
                      SizedBox(width: 60.w,),
                      SvgPicture.asset(Drawables.message,height: 25.h,),
                    ],
                  ),








                ],
              ),
              Text(yogaType,style: manropeSubTitleTextStyle.copyWith(
                fontSize: 14.sp,
              ),),
            ],
          ),
        ],
      ),
    );
  }
}