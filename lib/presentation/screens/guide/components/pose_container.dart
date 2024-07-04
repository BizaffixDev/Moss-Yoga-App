
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/text_styles.dart';

class PosesContainer extends StatelessWidget {
  final String poseName;
  final VoidCallback onTap;
  const PosesContainer({
    required this.poseName,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      height: 110.h,
      width: double.maxFinite,
      //312.66.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: Colors.white,

      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.asset('assets/images/pose1.png',
            width: 109.w,
            height: 83.h,
            fit: BoxFit.cover,),
        ),
        title: Text(poseName,style: manropeHeadingTextStyle.copyWith(
          fontSize: 16.sp,
        ),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("This simplest yoga pose teaches bone to stand with majestic teadiness like a mountain.",
              style: manropeSubTitleTextStyle.copyWith(
                fontSize: 14.sp,height: 1.2,
              ),),
            SizedBox(height: 10.h,),
            GestureDetector(
              onTap: onTap,
              child: Text("See more",style: manropeSubTitleTextStyle.copyWith(
                fontSize: 12.sp,height: 1.2,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}