import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/page_path.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/text_styles.dart';

class UpComingWidget extends StatelessWidget {
  final String time;
  final String day;
  final String date;
  final String teacherName;
  final String yogaType;

  // final String badgeIcon;
  final VoidCallback cancelSession;
  final VoidCallback reschedule;
  final VoidCallback join;
  final String country;
  final String channelName;

  const UpComingWidget({
    super.key,
    required this.time,
    required this.day,
    required this.date,
    required this.teacherName,
    required this.yogaType,
    // required this.badgeIcon,
    required this.cancelSession,
    required this.reschedule,
    required this.join,
    required this.country,
    required this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.primaryColor.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(
                        "$day\n $date",
                        style: manropeSubTitleTextStyle.copyWith(
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
                            color: const Color(0xFFC4C4BC), width: 0.3)),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  height: 165.h,
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
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          yogaType,
                          style: manropeSubTitleTextStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        trailing: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final teacherNamee = teacherName;
                                final yogaStyle = yogaType;
                                final country1 = country;
                                final channelNamee = channelName;

                                context.push(
                                    '${PagePath.lobbyWaitStudent}?teacherName=$teacherNamee&yogaStyle=$yogaStyle&country=$country1&channelName=$channelNamee');
                              },
                              child: Container(
                                width: 62.w,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "Join",
                                    style: manropeHeadingTextStyle.copyWith(
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
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
                                    color: Color(0xFF4A934A),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Scheduled",
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: cancelSession,
                                child: Center(
                                    child: Text(
                                  "Cancel Session",
                                  style: manropeHeadingTextStyle.copyWith(
                                      color: const Color(0xFF828282),
                                      fontSize: 14.sp,
                                      height: 1.2),
                                )),
                              ),
                            ),
                            Container(
                              height: 39.h,
                              width: 1.14.w,
                              color: const Color(0xFFE9ECF2),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: reschedule,
                                child: Center(
                                    child: Text(
                                  "Reschedule",
                                  style: manropeHeadingTextStyle.copyWith(
                                      fontSize: 14.sp, height: 1.2),
                                )),
                              ),
                            ),
                          ],
                        ),
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
