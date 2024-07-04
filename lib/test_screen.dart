
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/home_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/students_screens/home/components/custom_featured_poses_card.dart';
import 'package:moss_yoga/presentation/screens/students_screens/home/home_states.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../data/models/yoga_poses_response_model.dart';
import '../../../../data/models/yoga_styles_response_model.dart';

class HomeScreenTeacher extends ConsumerStatefulWidget {
  const HomeScreenTeacher({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends ConsumerState<HomeScreenTeacher> {
  final double _dragExtent = 0;
  final double _dragPosition = 0.0;

  bool _online = false;

  String result = "Let's slide!";

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeStates>(homeNotifierProvider, (previous, screenState) async {
      // if(screenState is LoginListState){
      //   list = screenState.val as List;
      // }
      if (screenState is HomeSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }
      if (screenState is HomeErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          // dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is HomeLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });

    List<PosesResponseModel> posesList = ref.watch(allPosesProvider);
    List<YogaStylesResponseModel> stylesList = ref.watch(allYogaStylesProvider);
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Scaffold(
          // backgroundColor: AppColors.primaryColor,
          // key: UniqueKey(),
          // backgroundColor: AppColors.primaryColor,

          // extendBody: true,
          appBar: AppBar(
            // iconTheme: IconThemeData(color: AppColors.darkGreenGray),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                Drawables.appBarLogo,
                height: 29.32.h,
                width: 87.77.w,
              ),
            ),
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            // iconTheme: const IconThemeData(color: AppColors.greyColor),
          ),
          endDrawer: Drawer(
            backgroundColor: AppColors.neutral53,
            child: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(
                    color: Colors.black), // Set the desired icon color
              ),
              child: const Text('Test'),
            ),
          ),
          body: Column(
            children: [
              //MAIN GREEN HEADER
              Container(
                height: 150.h,
                width: 390.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 36.w, right: 50.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Jenny,',
                            style: manropeHeadingTextStyle.copyWith(
                                color: Colors.white, fontSize: 20.sp),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "You have 04 sessions today",
                            style: manropeSubTitleTextStyle.copyWith(
                                color: Colors.white, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                //argin: const EdgeInsets.symmetric(vertical: 10),
                                height: 7.81.h,
                                width: 152.w,
                                decoration: const BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: FAProgressBar(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  currentValue: 50,
                                  //int.parse("${snapshot.data}"),
                                  //int.parse("${SPHelper.sp.get("mechanic_wallet")}"),
                                  maxValue: 90,
                                  displayTextStyle: manropeSubTitleTextStyle,
                                  changeProgressColor: const Color(0xFFA0BD74),
                                  progressColor: const Color(0xFFA0BD74),
                                  displayText: ' ',
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "50/90",
                                style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Stack(children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFF3EBE6),
                          radius: 40.r,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(Drawables.teacherProfile),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Center(
                            child: Image.asset(
                              Drawables.badgeTeacher,
                              height: 32.h,
                              width: 46.w,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: SWIPPER
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 20.w),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         // image: DecorationImage(
                      //         //   image: AssetImage(
                      //         //       'assets/home/background_container.png'),
                      //         //   fit: BoxFit.cover,
                      //         // ),
                      //         gradient: LinearGradient(
                      //           begin: Alignment.topCenter,
                      //           end: Alignment.bottomCenter,
                      //           colors: [
                      //             Color(0xFFFFFFFF),
                      //             Colors.grey.withOpacity(0.1),
                      //             Color(0xFFFFFFFF),
                      //           ],
                      //         ),
                      //       ),
                      //       child: HorizontalSlidableButton(
                      //         width: MediaQuery.of(context).size.width,
                      //         height: 76.h,
                      //         buttonWidth: 60.w,
                      //         // color: AppColors.white,
                      //         dismissible: false,
                      //         label: _online == true
                      //             ? Container(
                      //                 margin: EdgeInsets.only(top: 6.h),
                      //                 child: Center(
                      //                   child: SvgPicture.asset(
                      //                     "assets/images/green_elipse.svg",
                      //                     width: 60.w,
                      //                     fit: BoxFit.cover,
                      //                   ),
                      //                 ),
                      //               )
                      //             : Container(
                      //                 margin: EdgeInsets.only(top: 6.h),
                      //                 child: Center(
                      //                   child: SvgPicture.asset(
                      //                     "assets/images/red_elipse.svg",
                      //                     width: 60.w,
                      //                     fit: BoxFit.cover,
                      //                   ),
                      //                 ),
                      //               ),
                      //         child: Center(
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "On Demand",
                      //                 style: manropeHeadingTextStyle.copyWith(
                      //                     fontSize: 16.sp),
                      //               ),
                      //               Text(
                      //                 _online == false
                      //                     ? "Swipe to go online"
                      //                     : "Swipe to go offline",
                      //                 style: manropeHeadingTextStyle.copyWith(
                      //                   fontSize: 16.sp,
                      //                   color: Color(0xFF828282),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         onChanged: (position) {
                      //           setState(() {
                      //             if (position == SlidableButtonPosition.end) {
                      //               result = 'Button is on the right';
                      //               _online = true;
                      //             } else {
                      //               result = 'Button is on the left';
                      //               _online = false;
                      //             }
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:

                              // SlideAction(
                              //
                              //   thumbWidth: 80,
                              //
                              //   trackBuilder: (buildContext, currentState) {
                              //     return Container(
                              //       decoration: BoxDecoration(
                              //
                              //         gradient: LinearGradient(
                              //           begin: Alignment.topCenter,
                              //           end: Alignment.bottomCenter,
                              //
                              //
                              //           colors: [
                              //             Color(0xFFFFFFFF),
                              //             Colors.grey.withOpacity(0.1),
                              //             Color(0xFFFFFFFF),
                              //
                              //
                              //           ],
                              //         ),
                              //         border: Border.all(
                              //           color: Colors.grey,
                              //         ),
                              //         borderRadius: BorderRadius.all(
                              //           Radius.circular(50.r),
                              //         ),
                              //       ),
                              //       child: Center(
                              //         child: Opacity(
                              //           opacity: lerpDouble(
                              //               1,
                              //               0,
                              //               currentState.thumbFractionalPosition *
                              //                   2)!
                              //               .clamp(0.0, 1.0),
                              //           child: Column(
                              //             children: [
                              //               Text(
                              //                 "On Demand",
                              //                 style: manropeHeadingTextStyle.copyWith(
                              //                   fontSize: 16.sp
                              //                 ),
                              //               ),
                              //               Text(
                              //                 _online == false ? "Swipe to go online" : "Swipe to go offline"  ,
                              //                 style: manropeHeadingTextStyle.copyWith(
                              //                     fontSize: 16.sp,
                              //                   color: Color(0xFF828282),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   thumbBuilder: (context, currentState) {
                              //     return Container(
                              //       padding: EdgeInsets.all(12),
                              //       margin: const EdgeInsets.all(4.0),
                              //       decoration: BoxDecoration(
                              //         gradient:  LinearGradient(
                              //           begin: Alignment.topCenter,
                              //           end: Alignment.bottomCenter,
                              //           colors: [
                              //             _online == true ?  Color(0xFF51563F) :  Color(0xFF674646),
                              //             _online == true ?  Color(0xFFA3BC90) :  Color(0xFFD75757),
                              //
                              //           ],
                              //         ),
                              //         border: Border.all(
                              //           color: Colors.grey,
                              //         ),
                              //         shape: BoxShape.circle,
                              //
                              //       ),
                              //       child:  SvgPicture.asset(Drawables.sliderArrow,height: 15.h,width: 13.w,),
                              //     );
                              //   },
                              //   action: () async {
                              //       setState(() {
                              //         _online = !_online;
                              //       });
                              //   },
                              // ),

                              Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFFFFFFF),
                                  Colors.grey.withOpacity(0.1),
                                  const Color(0xFFFFFFFF),
                                ],
                              ),
                            ),
                            child: HorizontalSlidableButton(
                              width: MediaQuery.of(context).size.width,
                              height: 76.h,
                              buttonWidth: 60.w,
                              color: AppColors.primaryColor.withOpacity(0.2),
                              dismissible: false,
                              label: _online == true
                                  ? Container(
                                      margin: EdgeInsets.only(top: 6.h),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/green_elipse.svg",
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 6.h),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/red_elipse.svg",
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "On Demand",
                                      style: manropeHeadingTextStyle.copyWith(
                                          fontSize: 16.sp),
                                    ),
                                    Text(
                                      _online == false
                                          ? "Swipe to go online"
                                          : "Swipe to go offline",
                                      style: manropeHeadingTextStyle.copyWith(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF828282),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onChanged: (position) {
                                setState(() {
                                  if (position == SlidableButtonPosition.end) {
                                    result = 'Button is on the right';
                                    _online = true;
                                  } else {
                                    result = 'Button is on the left';
                                    _online = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      //Timeline Text

                      Container(
                        margin: EdgeInsets.only(left: 25.w),
                        child: Text(
                          "Timeline",
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 17.sp,
                          ),
                        ),
                      ),

                      //Upcoming Classes
                      const UpcomingClasses(),

                      //Weekly Summary
                      const WeeklySummary(),

                      ///Featured Poses Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Featured Poses',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),

                      /// Featured Poses Cards
                      posesList.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(left: 23, top: 1),
                              child: Text(
                                'No Poses Avaialble right now',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.darkGreyHeading1),
                              ),
                            )
                          : SizedBox(
                              height:
                                  CommonFunctions.deviceHeight(context) * 0.2,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: posesList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: FeaturedPosesCard(
                                      imagePath:
                                          'assets/images/user_profile_video_session.png',
                                      title: posesList[index].poseName,
                                    ),
                                  );
                                },
                              ),
                            ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Explore Yoga Styles',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      // stylesList
                      ///Explore Yoga Styles Image Cards
                      SizedBox(
                        // height: CommonFunctions.deviceHeight(context) * 0.5,
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          children: List.generate(
                            stylesList.length,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 23, top: 17, right: 13),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  width: 165,
                                  height: 220,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: Image.asset(
                                          'assets/images/yoga_style_1.png',
                                          fit: BoxFit.cover,
                                          width: 180,
                                          height: 180,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, top: 150, right: 25),
                                        child: SizedBox(
                                          height: 34,
                                          child: ClipRect(
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            stylesList[index]
                                                                .styleName,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: AppColors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('You may also like',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 21.w),
                        height: 102.h,
                        width: 347.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F5FA),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 7.h),
                          height: 91.h,
                          width: 203.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Yoga for Anxiety",
                                      style: manropeHeadingTextStyle.copyWith(
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 160.4.w,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Drawables.yogaForAnxiety),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklySummary extends StatelessWidget {
  const WeeklySummary({
    super.key,
  });

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
                        value: 0.2,
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
                          "2h 20m",
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
                        color: AppColors.primaryColor,
                        value: 0.3,
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
                          "04",
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

class UpcomingClasses extends StatelessWidget {
  const UpcomingClasses({
    super.key,
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
                "02",
                style: manropeSubTitleTextStyle.copyWith(
                  fontSize: 24.sp,
                ),
              ),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Time Text
                Text(
                  "8:00 AM",
                  style: manropeSubTitleTextStyle.copyWith(
                    fontSize: 14.sp,
                  ),
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
                            color: AppColors.primaryColor.withOpacity(0.7),
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
                          height: 175.h,
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
                      children: [
                        Container(
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

                          /* Center(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.asset(Drawables.teacherProfile),
                            ),
                            title:Text("Libianca",style: manropeHeadingTextStyle.copyWith(
                              fontSize: 14.sp,
                            ),),
                            subtitle: Text("Power Yoga",style: manropeSubTitleTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),),
                            trailing: Column(
                              children: [
                                Container(

                                  height: 22.49.h,
                                  width: 57.24.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(color: Color(0xFFB5BF8F))
                                  ),
                                  child: Center(
                                    child:Text("Start",style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                      textAlign: TextAlign.center,),
                                  ),
                                ),
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
                                    Text("Scheduled",style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
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

                          /* Center(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.asset(Drawables.teacherProfile),
                            ),
                            title:Text("Libianca",style: manropeHeadingTextStyle.copyWith(
                              fontSize: 14.sp,
                            ),),
                            subtitle: Text("Power Yoga",style: manropeSubTitleTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),),
                            trailing: Column(
                              children: [
                                Container(

                                  height: 22.49.h,
                                  width: 57.24.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(color: Color(0xFFB5BF8F))
                                  ),
                                  child: Center(
                                    child:Text("Start",style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                      textAlign: TextAlign.center,),
                                  ),
                                ),
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
                                    Text("Scheduled",style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
