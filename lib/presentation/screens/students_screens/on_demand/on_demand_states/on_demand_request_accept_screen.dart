import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'dart:math' as math;
import '../../../../../common/app_specific_widgets/drawer.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../data/models/teacher_specialty.dart';



class OnDemandRequestAcceptScreen extends ConsumerStatefulWidget {
  const OnDemandRequestAcceptScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnDemandRequestAcceptScreen> createState() => _OnDemandRequestAcceptScreenState();
}

class _OnDemandRequestAcceptScreenState extends ConsumerState<OnDemandRequestAcceptScreen> {
  List<TeacherSpecialty> teacherSpecialtyList = [
    TeacherSpecialty(specialty: "Mediation"),
    TeacherSpecialty(specialty: "Ashtanga Yoga"),
    TeacherSpecialty(specialty: "Fitness"),
    TeacherSpecialty(specialty: "Restorative Yoga"),
    TeacherSpecialty(specialty: "Vinyasa Yoga"),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'On Demand',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.darkSecondaryGray),
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        // iconTheme: const IconThemeData(color: AppColors.greyColor),
      ),
      endDrawer:const DrawerScreen(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text("1",style: manropeHeadingTextStyle.copyWith(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  Container(
                    height: 10.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,

                    ),

                  ),
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text("2",style: manropeHeadingTextStyle.copyWith(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  Container(
                    height: 10.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,

                    ),

                  ),
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,

                    ),
                    child: Center(
                      child: Text("3",style: manropeHeadingTextStyle.copyWith(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text("Request",style: manropeHeadingTextStyle.copyWith(
                      fontSize: 16.sp,

                    ),),
                  ),
                  SizedBox(
                    height: 10.h,
                    width: 20.w,
                  ),

                  Center(
                    child: Text("Pending",style: manropeHeadingTextStyle.copyWith(
                      fontSize: 16.sp,

                    ),),
                  ),

                  SizedBox(
                    height: 10.h,
                    width: 20.w,
                  ),

                  Center(
                    child: Text("Join Now",style: manropeHeadingTextStyle.copyWith(
                      fontSize: 16.sp,

                    ),),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h,),


            Stack(

              children: [



                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 80.h),
                    width: 390.w,
                    height: 300.h,
                    decoration: const BoxDecoration(
                      //color: AppColors.primaryColor,
                        borderRadius:  BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        gradient: LinearGradient(

                          //end: Alignment.center,
                            colors: [
                              Color(0xFF334525),
                              Color(0xFFD7DEBD),

                            ]
                        )
                    ),
                    child:Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50.h,),
                          Text("Request Accepted",style: manropeHeadingTextStyle.copyWith(
                              color: Colors.white
                          ),),
                          Text("Your Video Session with Jessica\nDoe will starts in 04:12",style: manropeSubTitleTextStyle.copyWith(
                              color: Colors.white,
                            height: 1.2

                          ),
                          textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      const SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                        ),
                      ),

                      CustomPaint(
                        painter: CircleProgressPainter(
                          progressColor: AppColors.primaryColor,
                          backgroundColor: Colors.white,
                          strokeWidth: 10,
                          progress: 0.7, // Update the progress value here
                        ),
                        child:  const SizedBox(
                          width: 180,
                          height: 180,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Color(0xFF507D2D),
                            child: Icon(Icons.done,color: Colors.white,
                            size: 100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(

                    margin: EdgeInsets.symmetric(vertical: 350.h),
                    width: 390.w,

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:  BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TEACHER INFO
                        Container(
                          padding: EdgeInsets.only(left: 20.w),
                          width: 375.w,
                          height: 137.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: const Color(0xfff9f9f9)),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: 20.w),
                                child: Text("Payment Details",style: manropeHeadingTextStyle.copyWith(
                                  fontSize: 18.sp,
                                ),),
                              ),

                              Padding(
                                padding:  EdgeInsets.only(left: 20.w),
                                child: Text("Proceed to the payment details",style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2D3536),
                                  height: 1.2,
                                ),),
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
      ),

      bottomNavigationBar: Container(
        height: 137.h,
        width: 390.w,
        decoration:const  BoxDecoration(
          color: Color(0xFFF7F5FA),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          )
        ),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Budget",style: manropeHeadingTextStyle,),
                  Text("\$150",style: manropeHeadingTextStyle,),
                ],
              ),
            ),
            
            CustomButton(text: "Join Now", onTap: (){},
            btnColor: AppColors.primaryColor,
            textColor: Colors.white,),
          ],
        ),
      ),
    );
  }
}


class CircleProgressPainter extends CustomPainter {
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double progress;

  CircleProgressPainter({
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.strokeWidth = 8,
    this.progress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    double sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
