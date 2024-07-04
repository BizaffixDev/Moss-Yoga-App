import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class WeeklySummary extends StatelessWidget {
  WeeklySummary({
    super.key,
    required this.totalTimeNo,
    required this.totalTimeChart,
    required this.totalClassesNo,
    required this.totalClassesChart,
  });

  String? totalTimeNo;
  double? totalTimeChart;
  String? totalClassesNo;
  double? totalClassesChart;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 31.w, right: 31.w),
        child: ExpansionTile(
          title: Text(
            "Weekly Summary",
            style: manropeHeadingTextStyle.copyWith(
              fontSize: 14.sp,
            ),
          ),
          trailing: const Icon(Icons.arrow_drop_down),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              height: 110.h,
              width: 314.w,
              decoration: BoxDecoration(
                color: const Color(0xFF9A89B4).withOpacity(0.1),
              ),
              child: Center(
                child: Row(
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        value: totalTimeChart ?? 0.2,
                        strokeWidth: 8,
                        backgroundColor: Colors.black12,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalTimeNo ?? '0H 0Min',
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "Total Time",
                          style: manropeSubTitleTextStyle.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        color: AppColors.primaryColor,
                        value: totalClassesChart ?? 0.2,
                        backgroundColor: Colors.black12,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalClassesNo ?? '0',
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "Classes",
                          style: manropeSubTitleTextStyle.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
