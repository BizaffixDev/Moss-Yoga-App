
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

import '../../../../../app/utils/common_functions.dart';

class CustomTeacherCardTopRated extends StatelessWidget {
  CustomTeacherCardTopRated({
    required this.imagePath,
    required this.teacherName,
    required this.onTap,
    required this.saveTeacher,
    required this.teacherOccupation,
    required this.saveIcon,
    required this.rating,
    required this.price,
    this.rightMrgin = 0,
    super.key,
    required int teacherId,
  });

  String imagePath;
  String teacherName;
  VoidCallback onTap;
  VoidCallback saveTeacher;
  String teacherOccupation;
  IconData saveIcon;
  String rating;
  String price;
  double? rightMrgin;

  @override
  Widget build(BuildContext context) {
    return




      GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
         // color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],

          border: Border.all(
            width: 1,
            color: Colors.transparent,
          ),
        ),

        child: Column(
          children: [


            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  child: Image.asset(
                    //
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: Platform.isAndroid ?
                    CommonFunctions.deviceWidth(context) <=360 ?
                    182.h :
                    CommonFunctions.deviceWidth(context) <=393 ?
                    198.h :
                    260.h :
                    174.h,

                    //174.h,//for iphone
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 4),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.golden,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          rating,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              height:54.h,
              //height:CommonFunctions.deviceHeight(context) >= 2778.0 ? 51.h :  47.h,
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      teacherName.length <= 14
                          ? Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          top: 9,
                          bottom: 2,
                        ),
                        child: Text(
                          teacherName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          // top: 9,
                          bottom: 2,
                        ),
                        child: Text(
                          '${teacherName.substring(0, 11)}..',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8, bottom: 0, right: 0),
                        child: Text(
                          teacherOccupation,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: saveTeacher,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                        top: 15,
                        bottom: 15,
                      ),
                      child: Icon(
                        saveIcon,
                        color: AppColors.primaryColor,
                      ),


                      // Image.asset(
                      //   "assets/images/save_instagram_bookmark.png",
                      //   color: Colors.black,
                      //   fit: BoxFit.cover,
                      //   height: 15,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 44.h,
              width: double.maxFinite,
              margin: EdgeInsets.only(right: 0.5),
              // padding:
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius:  BorderRadius.only(
                  // topRight:  Radius.circular(3),
                  bottomLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(width: 1, color: Colors.transparent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Padding(
                    padding: EdgeInsets.only(
                      // top: 11,
                      left: 8,
                      // bottom: 9,
                    ),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          color: AppColors.secondary90,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 15,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );







  }
}
