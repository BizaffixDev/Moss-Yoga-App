import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/text_styles.dart';

class CancelledWidget extends StatelessWidget {
  final String time;
  final String day;
  final String date;
  final String teacherName;
  final String yogaType;
  //final String badgeIcon;
  final VoidCallback availableTeachersTap;

  const CancelledWidget({
    super.key,
    required this.time,
    required this.day,
    required this.date,
    required this.teacherName,
    required this.yogaType,
    //required this.badgeIcon,
    required this.availableTeachersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Time Text
          Row(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    time,
                    style: manropeSubTitleTextStyle.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  Container(
                    height: 65.84.h,
                    width: 49.38.w,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10.r),
                      color: AppColors.primaryColor
                          .withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(
                        "$day\n $date",
                        style: manropeSubTitleTextStyle
                            .copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                        color: const Color(0xFFC4C4BC),
                        border: Border.all(
                            color: const Color(0xFFC4C4BC),
                            width: 0.3)),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  height: 140.h,
                  width: 331.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                          child: Image.asset(
                            Drawables.teacherProfile,
                            height: 71.h,
                            width: 71.w,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              teacherName,
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            //SvgPicture.asset(badgeIcon)
                            //assets/svgs/my_teacher/badge-silver.svg
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              yogaType,
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 6.84.h,
                                  width: 6.84.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Cancelled",
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: availableTeachersTap,
                        child: Center(
                            child: Text(
                              "View Avalailable Teachers",
                              style: manropeHeadingTextStyle.copyWith(
                                  fontSize: 14.sp, height: 1.2),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
