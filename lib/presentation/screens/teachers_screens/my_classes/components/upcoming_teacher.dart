import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/text_styles.dart';

class UpcomingTeacherWidget extends StatelessWidget {
  final String studentName;
  final String occupation;
  final String day;
  final String date;
  final String time;
  final String budget;
  final VoidCallback cancelSession;
  final VoidCallback startSession;
  const UpcomingTeacherWidget({
    super.key, required this.studentName, required this.occupation, required this.day, required this.date, required this.time, required this.budget, required this.cancelSession, required this.startSession,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [


          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //DAY DATE
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  //Time Text
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

              //TEACHER LISTING
              Expanded(
                child: Container(
                  margin:
                  EdgeInsets.symmetric(vertical: 10.h),
                  height: 150.h,
                  width: 331.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Starts in',
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: 14,
                                      color:
                                      AppColors.black),
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      // Single tapped.
                                    },
                                ),
                                TextSpan(
                                    text: ' 04:12',
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight.w700,
                                        fontSize: 14,
                                        color: AppColors
                                            .redColor),
                                    recognizer:
                                    DoubleTapGestureRecognizer()
                                      ..onDoubleTap =
                                          () {
                                        DialogButton(
                                          onPressed:
                                              () {},
                                          child: const Text(
                                              'Goto your meeting Room'),
                                        );
                                      }),
                              ],
                            ),
                          ),
                        ),
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
                        title: Text(
                          studentName,
                          style: manropeHeadingTextStyle
                              .copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          occupation,
                          style: manropeSubTitleTextStyle
                              .copyWith(
                            fontSize: 14.sp,
                            color: const Color(0xFF828282),
                          ),
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              "$budget",
                              style: manropeHeadingTextStyle
                                  .copyWith(
                                  color: AppColors
                                      .primaryColor,
                                  fontSize: 12.sp),
                            ),
                            Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Container(
                                  height: 6.84.h,
                                  width: 6.84.w,
                                  decoration:
                                  const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                    Color(0xFF4A934A),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Scheduled",
                                  style:
                                  manropeSubTitleTextStyle
                                      .copyWith(
                                    fontSize: 8.sp,
                                    fontWeight:
                                    FontWeight.w500,
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
                                    child:
                                    Text(
                                      "Cancel Session",
                                      style: manropeHeadingTextStyle.copyWith(
                                          color: const Color(0xFF828282), fontSize: 14.sp,height: 1.2),
                                    )

                                ),
                              ),
                            ),

                            Container(
                              height: 39.h,
                              width: 1.14.w,
                              color: const Color(0xFFE9ECF2),

                            ),


                            Expanded(
                              child: GestureDetector(
                                onTap: startSession,
                                child: Center(
                                    child:
                                    Text(
                                      "Start Session",
                                      style: manropeHeadingTextStyle.copyWith(
                                          fontSize: 14.sp,height: 1.2),
                                    )

                                ),
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