import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class UpcomingClasses extends StatelessWidget {
  List teacherCardList;
  int upcomingClassesNo;

  UpcomingClasses({
    super.key,
    required this.teacherCardList,
    required this.upcomingClassesNo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 31.w, right: 31.w),
        child: ExpansionTile(
          title: Text(
            "Upcoming Classes",
            style: manropeHeadingTextStyle.copyWith(
              fontSize: 14.sp,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                upcomingClassesNo.toString(),
                style: manropeSubTitleTextStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor),
              ),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
          children: [
            teacherCardList.isEmpty
                ? Container(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: const Center(
                      child: Text('No Upcoming Classes'),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Time Text
                      Text(
                        "8:00 AM",
                        style: manropeSubTitleTextStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.neutral53),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //DAY DATE
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 65.84.h,
                                width: 49.38.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: AppColors.primaryColorlight,
                                ),
                                child: Center(
                                  child: Text(
                                    "Sat\n 15",
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

                          //TEACHER LISTING

                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(teacherCardList.length,
                                  (index) {
                                return Container(
                                  padding: EdgeInsets.only(right: 24.w),
                                  height: 81.h,
                                  width: 275.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F5FA),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8.h),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          child: Image.asset(
                                              Drawables.teacherProfile),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 80.w,
                                            child: Text(
                                              teacherCardList[index].teacherName,
                                              style: manropeHeadingTextStyle
                                                  .copyWith(
                                                fontSize: 14.sp,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            "Power Yoga",
                                            style: manropeSubTitleTextStyle
                                                .copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
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
                                            style: manropeSubTitleTextStyle
                                                .copyWith(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              })),
                          // Container(
                          //   height: 81.h,
                          //   child: ListView.builder(
                          //     itemCount: teacherCardList.length,
                          //     // Replace numberOfItems with the actual number of items in the list
                          //     itemBuilder: (BuildContext context, int index) {
                          //       // Check if it's the first item in the list
                          //       if (index == 0) {
                          //         // No SizedBox above the first child
                          //         return Column(
                          //           children: [
                          //             UpcomingClassesTeacherCard(
                          //               name: 'Yogi',
                          //               yogaStyle: 'Fire Yoga',
                          //             ),
                          //             SizedBox(height: 10.h),
                          //             // Spacing after the first child
                          //           ],
                          //         );
                          //       } else {
                          //         // SizedBox before and after each child other than the first one
                          //         return Column(
                          //           children: [
                          //             SizedBox(height: 10.h),
                          //             // Spacing before each child other than the first one
                          //             UpcomingClassesTeacherCard(
                          //               name: 'Yogi',
                          //               yogaStyle: 'Fire Yoga',
                          //             ),
                          //             SizedBox(height: 10.h),
                          //             // Spacing after each child other than the first one
                          //           ],
                          //         );
                          //       }
                          //     },
                          //   ),
                          // )

                          // UpcomingClassesTeacherCard(
                          //     name: 'Yogi', yogaStyle: 'Fire Yoga'),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                        ],
                      ),
                    ],
                  ),
          ],
        ));
  }
}

class UpcomingClassesTeacherCard extends StatelessWidget {
  UpcomingClassesTeacherCard({
    super.key,
    required this.name,
    required this.yogaStyle,
  });

  String name;
  String yogaStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 24.w),
      height: 81.h,
      width: 275.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(Drawables.teacherProfile),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Libianca",
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "Power Yoga",
                style: manropeSubTitleTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
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
    );
  }
}
