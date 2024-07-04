import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';
import '../../../../providers/home_provider.dart';




class TopDetailSection extends ConsumerStatefulWidget {
  const TopDetailSection({

    super.key,
  });


  @override
  ConsumerState<TopDetailSection> createState() => _TopDetailSectionState();
}

class _TopDetailSectionState extends ConsumerState<TopDetailSection> {
  @override
  Widget build(BuildContext context) {
    String name =  ref.read(teacherNameProvider);
    String rating =  ref.read(teacherRatingProvider);
    double parsedValue = double.parse(rating);
    String formatRating = parsedValue.toStringAsFixed(1);
    return Container(

      height: 380.h,
      width: 390.w,
      decoration:const  BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/teacher.png"),
          fit: BoxFit.cover,

        ),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child:
          Center(
        child: Column(
          children: [
            SizedBox(height: 40.h,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //image
                Container(
                  height: 180.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/teacher.png"),
                        fit: BoxFit.cover,
                      )),
                ),

                const SizedBox(width: 20,),

                //INFO
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //name
                      Text(
                        name,
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                        ),
                      ),

                      Text(
                        "Ashtanga Yoga",
                        style: manropeHeadingTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                            color: Colors.white
                        ),
                      ),

                      Text(
                        "New York, US",
                        style: manropeHeadingTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                            color: Colors.white
                        ),
                      ),

                      const  SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: parsedValue.toDouble(),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            unratedColor: Colors.grey, // Color for unrated stars
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 10,),

                          Text(formatRating,style: manropeSubTitleTextStyle.copyWith(
                              fontSize: 18.sp,
                            color: Colors.white,
                          ),)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            Container(

              width: double.maxFinite,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30),
                topLeft: Radius.circular(30),),

              ),

              child: Column(
                children: [
                  SizedBox(height:5.h),


                  Container(
                    width: double.maxFinite,
                   padding: EdgeInsets.only(left: 20.w,right: 19.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //YEARS

                        Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightGreen.withOpacity(0.3),
                              ),
                              child: Center(
                                child: SvgPicture.asset("assets/images/experience-icon.svg"),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("10 Years",style: manropeHeadingTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),),
                                Text("Experience",style: manropeSubTitleTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  height: 1.2,
                                ),),
                              ],
                            ),
                          ],
                        ),


                        //RATING
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightGreen.withOpacity(0.3),
                              ),
                              child: Center(
                                child: SvgPicture.asset("assets/images/star-icon.svg"),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("1.0",style: manropeHeadingTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),),
                                Text("Rating",style: manropeSubTitleTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  height: 1.2,
                                ),),
                              ],
                            ),
                          ],
                        ),


                        //CLASSES
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightGreen.withOpacity(0.3),
                              ),
                              child: Center(
                                child: SvgPicture.asset("assets/images/time-icon.svg"),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("300",style: manropeHeadingTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),),
                                Text("Classes",style: manropeSubTitleTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  height: 1.2,
                                ),),
                              ],
                            ),
                          ],
                        ),





                      ],

                    ),
                  ),



                  SizedBox(height:10.h),


                  Expanded(
                    child: Container(
                      width: double.maxFinite,

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white

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
      ),


    );
  }
}