import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../../../../../app/utils/common_functions.dart';
import '../../../../../common/resources/text_styles.dart';


class CustomTeacherCardOnDemand extends StatelessWidget {
  CustomTeacherCardOnDemand({
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(8.r),topLeft: Radius.circular(8.r)
          ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
                    180.h :
                    CommonFunctions.deviceWidth(context) <=393 ?
                    198.h :
                    250.h :
                    175.h,
                    //230.h,
                    //175.h, for IOS
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
              height: 48,
              width: double.maxFinite,
              // padding: const EdgeInsets.only(top: 0, bottom: 0, left: 34, right: 34),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   // borderRadius: BorderRadius.circular(8),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.5),
              //       spreadRadius: 2,
              //       blurRadius: 5,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
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
                            fontSize: 16,
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
              height: 40.h,
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




    /*
      Padding(
      padding:  const EdgeInsets.only(
          left: 8, top: 8, right: 8, bottom: 8),
      child: Card(

        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Container(


          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r)),

          ),
          child: Column(
            children: [
              //IMAGE
              Expanded(
                child: Container(

                  height: 172.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/teacher_card_dummy_2.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        top: 11.h,
                      ),
                      child: Container(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.golden,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '4.8',
                              style: manropeSubTitleTextStyle
                                  .copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                color: Colors.white,
                height: 48.h,

                child: Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 80.w,
                                child: Text(
                                  teacherName,
                                  style: manropeHeadingTextStyle
                                      .copyWith(
                                    fontSize: 16.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Yoga Expert',
                                style: manropeSubTitleTextStyle
                                    .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8.w),
                        child: Image.asset(
                          "assets/images/save_instagram_bookmark.png",
                          color: Colors.black,
                          fit: BoxFit.cover,
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: onTap,
                child: Container(

                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 36.h,


                  // padding:
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Book Now',
                            style:
                            manropeHeadingTextStyle.copyWith(
                                color: AppColors.secondary90,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700)),
                        // const SizedBox(
                        //   width: 15,
                        // ),
                        Text(
                          "\$" "${20}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
    */


  }
}




/*class CustomTeacherCardOnDemand extends StatefulWidget {
  CustomTeacherCardOnDemand({
    required this.imagePath,
    required this.teacherName,
    required this.onTap,
    required this.rating,
    required this.saveTeacher,
    required this.saveIcon,
    required this.requestText,
    required this.price,
    required this.occupation,
    super.key,
  });

  final String imagePath;
  String teacherName;
  String requestText;
  VoidCallback saveTeacher;
  IconData saveIcon;
  VoidCallback onTap;
  String rating;
  String price;
  String occupation;

  @override
  State<CustomTeacherCardOnDemand> createState() =>
      _CustomTeacherCardOnDemandState();
}

class _CustomTeacherCardOnDemandState extends State<CustomTeacherCardOnDemand> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 330.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          //color: Colors.white,
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
            Expanded(
              child: Container(
                height: 170.h,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      child: Image.asset(
                        //
                        widget.imagePath,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 170.h,
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
                              widget.rating,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              color: Colors.white,
              height: 50.h,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.teacherName.length <= 14
                          ? Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          top: 9,
                          bottom: 2,
                        ),
                        child: Text(
                          widget.teacherName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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
                          '${widget.teacherName.substring(0, 11)}..',
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
                          widget.occupation,
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
                    onTap: widget.saveTeacher,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                        top: 15,
                        bottom: 15,
                      ),
                      child: Icon(
                        widget.saveIcon,
                        color: AppColors.primaryColor,
                      ),


                      *//*Image.asset(
                        "assets/images/save_instagram_bookmark.png",
                        color: Colors.black,
                        fit: BoxFit.cover,
                        height: 15,
                      ),*//*
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 35.h,
              width: double.maxFinite,
              margin: EdgeInsets.only(right: 0.5),
              // padding:
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: const BorderRadius.only(
                  // topRight:  Radius.circular(3),
                  // bottomLeft: Radius.circular(5),
                  // bottomRight: Radius.circular(5),
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
                  const Padding(
                    padding: EdgeInsets.only(
                      // top: 11,
                      left: 8,
                      // bottom: 9,
                    ),
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          color: AppColors.secondary90,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 15,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      widget.price,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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

      *//*Padding(
      padding: EdgeInsets.only(left: 23, top: 17),
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(
            width: 1,
            color: Colors.transparent,
          ),
        ),
        // width: 165,
        width: 166,
        height: 230,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                //
                widget.imagePath,
                fit: BoxFit.cover,
                width: 180,
                height: 180,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 119.w, top: 10),
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.golden,
                      size: 18,
                    ),
                    Text(
                      '4.8/5',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 125),
              child: SizedBox(
                height: 34,
                width: 163,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: SingleChildScrollView(
                      // scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.teacherName.length <= 14
                                        ? Text(
                                            widget.teacherName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: AppColors.white),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            '${widget.teacherName.substring(0, 11)}..',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: AppColors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    // Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  'Yoga Expert',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0, top: 2),
                            child: Text(
                              "\$" + "${20}",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 160),
              child: Container(
                margin: EdgeInsets.only(right: 0.5),
                padding:
                    EdgeInsets.only(top: 11, bottom: 11, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.only(
                    // topRight:  Radius.circular(3),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  border: Border.all(width: 1, color: Colors.transparent),
                ),
                child: Row(
                  // crossAxisAlignment:
                  //     CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      // width: 40,
                      width: 15,
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 0.0),
                        child: Image.asset(
                            "assets/images/save_instagram_bookmark.png",
                            color: AppColors.black,
                            fit: BoxFit.cover,
                            width: 15,
                            height: 15)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );*//*
  }
}*/
