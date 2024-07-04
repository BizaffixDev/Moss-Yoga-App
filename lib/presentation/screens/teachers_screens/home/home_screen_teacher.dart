import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer_teacher.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/get_teacher_no_of_session_response_model.dart';
import 'package:moss_yoga/presentation/providers/teachers_providers/home_teacher_provider.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/components/guide_container.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/components/upcoming_classes_widget.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/components/weekly_summary_widget.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/states/home_teacher_states.dart';
import 'package:slidable_button/slidable_button.dart';
import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../data/models/upcoming_classes_home_response_model.dart';
import '../../../../data/models/yoga_poses_response_model.dart';
import '../../../../data/models/yoga_styles_response_model.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_locked_providers/home_teacher_locked_provider.dart';
import '../../students_screens/home/components/custom_featured_poses_card.dart';

class HomeScreenTeacher extends ConsumerStatefulWidget {
  const HomeScreenTeacher({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends ConsumerState<HomeScreenTeacher> {
  // double _dragExtent = 0;
  // double _dragPosition = 0.0;

  bool _online = false;

  @override
  void initState() {
    super.initState();

    ///Default value is false;
    // _online = ref
    //     .read(onlineProvider.notifier)
    //     .state;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(homeNotifierTeacherProvider.notifier).getTeacherName();
      await ref
          .read(homeNotifierTeacherProvider.notifier)
          .getOnlineStatusForTeacher(
            teacherId: ref
                .read(teacherObjectProvider.notifier)
                .state
                .userId
                .toString(),
          );
      _online = ref.read(onlineProvider);
    });
  }

  bool _apiCalled = false;

  String result = "Let's slide!";

  var _resetKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(homeNotifierTeacherProvider.notifier).getPoses();
        await ref.read(homeNotifierTeacherProvider.notifier).getYogaStyles();
        await ref.read(homeNotifierTeacherProvider.notifier).getTeacherData();

        ///CHANGE ID FROM HERE TO INTERNAL AND GET FROM SHARED PREFS.
        await ref.read(homeNotifierTeacherProvider.notifier).getUpcomingClasses(
            id: ref.read(teacherObjectProvider.notifier).state.userId);
        await ref.read(homeNotifierTeacherProvider.notifier).getNoOfSessions(
            id: ref.read(teacherObjectProvider.notifier).state.userId);
        await ref.read(homeNotifierTeacherProvider.notifier).getTeacherName();
        await ref
            .read(homeNotifierTeacherProvider.notifier)
            .getYouMayAlsoLike();

        await ref
            .read(teacherHomeLockedNotifierProvider.notifier)
            .getYogaGuides();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TeacherHomeStates>(homeNotifierTeacherProvider,
        (previous, screenState) async {
      if (screenState is TeacherHomeSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }
      if (screenState is TeacherHomeNoOfSessionsSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }
      if (screenState is TeacherHomeOnDemandButtonSuccessfulState) {
        dismissLoading(context);
        ref.read(onlineProvider.notifier);
        setState(() {
          result = 'Button is on the right';

          ///using provider no need to update here
          _online = true;
        });
      } else if (screenState
          is TeacherHomeOnDemandButtonOfflineSuccessfulState) {
        dismissLoading(context);
        ref.read(onlineProvider.notifier);
        setState(() {
          result = 'Button is on the left';

          ///using provider no need to update here
          _online = false;
        });
        // setState(() {
        //   result = 'Button is on the right';
        //   _online = true;
        // });
      } else if (screenState is TeacherHomeErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          dismissLoading(context);
          UIFeedback.showSnackBar(context, screenState.error.toString());
        }
        if (screenState.errorType == ErrorType.other) {
          Future.delayed(Duration.zero);
          dismissLoading(context);
          debugPrint(
              "This is the error thats not shwoing 1 : ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
        } else {
          dismissLoading(context);
          debugPrint(
              "This is the error thats not shwoing 2: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
        }
      } else if (screenState is TeacherHomeOnDemandButtonErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          setState(() {
            _resetKey = UniqueKey(); // Reset the button.
          });
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
        if (screenState.errorType == ErrorType.other) {
          setState(() {
            _resetKey = UniqueKey(); // Reset the button.
          });
          debugPrint(
              "This is the error thats not shwoing 3: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          setState(() {
            _resetKey = UniqueKey(); // Reset the button.
          });
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is TeacherHomeNoOfSessionsErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          setState(() {
            _resetKey = UniqueKey(); // Reset the button.
          });
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
        if (screenState.errorType == ErrorType.other) {
          setState(() {
            _resetKey = UniqueKey(); // Reset the button.
          });
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          setState(() {
            _resetKey = UniqueKey(); // Reset the button.
          });
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is TeacherHomeLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      }
    });

    // List<PosesResponseModel> posesList = ref.watch(allPosesProvider);
    List<PosesResponseModel> posesList = ref.watch(teacherAllPosesProvider);
    List<UpcomingData> upcomingList = ref.watch(upComingClassesListProvider);
    List<String> youMayLikeList = ref.watch(youMayAlsoLikeProvider);
    GetTeacherNoOfSessionResponseModel noOfSessions =
        ref.watch(getNoOfSessionsTeacherProvider);

    List<YogaStylesResponseModel> stylesList =
        ref.watch(teacherAllYogaStylesProvider);

    var guidesListLength = ref
        .watch(teacherLockedAllYogaGuidesProvider.notifier)
        .getAllItems(ref.watch(teacherLockedAllYogaGuidesProvider));

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        // padding: EdgeInsets.only(top: 20),
        child: Scaffold(
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
          endDrawer: DrawerTeacher(),
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
                  margin: EdgeInsets.only(left: 36.w, right: 25.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Container(
                              width: 200.w,
                              child: Text(
                                'Welcome ${ref.watch(teacherObjectProvider).username == '' ?
                                '' : '${ref.watch(teacherObjectProvider).username},'}',
                                style: manropeHeadingTextStyle.copyWith(
                                    color: Colors.white, fontSize:ref.watch(teacherObjectProvider).username.length <= 7 ?  24.sp : 20.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "You have ${noOfSessions.sessionCount == -1 ? '' : noOfSessions.sessionCount} sessions today",
                            style: manropeSubTitleTextStyle.copyWith(
                                color: Colors.white, fontSize: 16.sp),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       alignment: Alignment.centerLeft,
                          //       //argin: const EdgeInsets.symmetric(vertical: 10),
                          //       height: 7.81.h,
                          //       width: 152.w,
                          //       decoration: const BoxDecoration(
                          //           color: AppColors.greyColor,
                          //           borderRadius: BorderRadius.only(
                          //               topRight: Radius.circular(10),
                          //               bottomRight: Radius.circular(10))),
                          //       child: FAProgressBar(
                          //         borderRadius: const BorderRadius.only(
                          //             topRight: Radius.circular(10),
                          //             bottomRight: Radius.circular(10)),
                          //         currentValue:
                          //             noOfSessions.spendHours.toDouble() == -1
                          //                 ? 10.toDouble()
                          //                 : noOfSessions.spendHours.toDouble(),
                          //         //int.parse("${snapshot.data}"),
                          //         //int.parse("${SPHelper.sp.get("mechanic_wallet")}"),
                          //         maxValue:
                          //             noOfSessions.totalHours.toDouble() == -1
                          //                 ? 100.toDouble()
                          //                 : noOfSessions.totalHours.toDouble(),
                          //         displayTextStyle: manropeSubTitleTextStyle,
                          //         changeProgressColor: Color(0xFFA0BD74),
                          //         progressColor: Color(0xFFA0BD74),
                          //         displayText: ' ',
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: 10.w,
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 5),
                          //       child: Text(
                          //         "${noOfSessions.spendHours == -1 ? '_' : noOfSessions.spendHours} / ${noOfSessions.totalHours == -1 ? '_' : noOfSessions.totalHours}",
                          //         style: manropeSubTitleTextStyle.copyWith(
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w500,
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Color(0xFFF3EBE6),
                        radius: 50.r,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(Drawables.teacherProfile),
                        ),
                      ),
                      //Stack(children: [
                        // CircleAvatar(
                        //   backgroundColor: Color(0xFFF3EBE6),
                        //   radius: 40.r,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(100),
                        //     child: Image.asset(Drawables.teacherProfile),
                        //   ),
                        // ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Center(
                        //     child: Image.asset(
                        //       Drawables.badgeTeacher,
                        //       height: 32.h,
                        //       width: 46.w,
                        //     ),
                        //   ),
                        // ),
                      //]),
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
                              // image: Image.asset('assets/home/background_container.png');
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/home/background_container.png'),
                                fit: BoxFit.cover,
                              ),
                              // gradient: LinearGradient(
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   colors: [
                              //     Color(0xFFFFFFFF),
                              //     Colors.grey.withOpacity(0.1),
                              //     Color(0xFFFFFFFF),
                              //   ],
                              // ),
                            ),
                            child: HorizontalSlidableButton(
                              initialPosition: _online
                                  ? SlidableButtonPosition.end
                                  : SlidableButtonPosition.start,
                              key: _resetKey,
                              width: MediaQuery.of(context).size.width,
                              height: 76.h,
                              buttonWidth: 60.w,
                              // color: AppColors.primaryColor.withOpacity(0.2),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onChanged: (position) async {
                                if (position == SlidableButtonPosition.end) {
                                  await ref
                                      .read(
                                          homeNotifierTeacherProvider.notifier)
                                      .changeOnlineStatusForTeacher(
                                          change: true);
                                } else {
                                  await ref
                                      .read(
                                          homeNotifierTeacherProvider.notifier)
                                      .changeOnlineStatusForTeacher(
                                          change: false);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      //Timeline Text

                      Container(
                        margin: EdgeInsets.only(left: 25.w),
                        child: Text(
                          "TimeLine",
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 17.sp,
                          ),
                        ),
                      ),

                      //Upcoming Classes
                      UpcomingClasses(
                        upcomingClassesNo: upcomingList.length,
                        teacherCardList: upcomingList,
                      ),
                      /*UpcomingClasses(
                          classLength: upcomingList.length,
                          name: upcomingList,
                          occupation: occupation,
                          date: date,
                          day: day,
                          time: time);*/
                      // upcomingList.isEmpty ? Text("No Upcoming Classes") :
                      // Container(
                      //     margin: EdgeInsets.only(left: 31.w, right: 31.w),
                      //     child: ExpansionTile(
                      //       title: Text(
                      //         "Upcoming Classes",
                      //         style: manropeHeadingTextStyle.copyWith(
                      //           fontSize: 14.sp,
                      //         ),
                      //       ),
                      //       trailing: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Text(
                      //             upcomingList.length.toString(),
                      //             style: manropeSubTitleTextStyle.copyWith(
                      //                 fontSize: 20.sp,
                      //                 fontWeight: FontWeight.w700,
                      //                 color: AppColors.primaryColor),
                      //           ),
                      //           Icon(Icons.arrow_drop_down)
                      //         ],
                      //       ),
                      //       children: [
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             //Time Text
                      //             Text(
                      //               "8:00 AM",
                      //               style: manropeSubTitleTextStyle.copyWith(
                      //                   fontSize: 14.sp,
                      //                   fontWeight: FontWeight.w500,
                      //                   color: AppColors.neutral53),
                      //             ),
                      //
                      //             Row(
                      //               mainAxisSize: MainAxisSize.min,
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 //DAY DATE
                      //                 Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   crossAxisAlignment: CrossAxisAlignment.center,
                      //                   children: [
                      //                     Container(
                      //                       height: 65.84.h,
                      //                       width: 49.38.w,
                      //                       decoration: BoxDecoration(
                      //                         borderRadius: BorderRadius.circular(10.r),
                      //                         color: AppColors.primaryColorlight,
                      //                       ),
                      //                       child: Center(
                      //                         child: Text(
                      //                           "${upcomingList[0].bookingDay.substring(0,3)}\n ${upcomingList[0].bookingDate.substring(0,2)}",
                      //                           style: manropeSubTitleTextStyle.copyWith(
                      //                             fontSize: 12.sp,
                      //                             color: Colors.white,
                      //                             fontWeight: FontWeight.w500,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     Container(
                      //                       height: 80.h,
                      //                       decoration: BoxDecoration(
                      //                           color: Color(0xFFC4C4BC),
                      //                           border: Border.all(
                      //                               color: Color(0xFFC4C4BC), width: 0.3)),
                      //                     ),
                      //                   ],
                      //                 ),
                      //
                      //                 //TEACHER LISTING
                      //                 Column(
                      //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                      //                     children: List.generate(upcomingList.length, (index) {
                      //                       return  Container(
                      //                         padding: EdgeInsets.only(right: 24.w),
                      //                         height: 81.h,
                      //                         width: 275.w,
                      //                         decoration: BoxDecoration(
                      //                           color: const Color(0xFFF7F5FA),
                      //                           borderRadius: BorderRadius.circular(8.r),
                      //                         ),
                      //                         child: Row(
                      //                           children: [
                      //                             Container(
                      //                               margin: EdgeInsets.all(8.h),
                      //                               child: ClipRRect(
                      //                                 borderRadius: BorderRadius.circular(12.r),
                      //                                 child: Image.asset(Drawables.teacherProfile),
                      //                               ),
                      //                             ),
                      //                             Column(
                      //                               mainAxisAlignment: MainAxisAlignment.center,
                      //                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                               children: [
                      //                                 Text(
                      //                                   upcomingList[index].teacherName,
                      //                                   style: manropeHeadingTextStyle.copyWith(
                      //                                     fontSize: 14.sp,
                      //                                   ),
                      //                                 ),
                      //                                 Text(
                      //                                   "Power Yoga",
                      //                                   style: manropeSubTitleTextStyle.copyWith(
                      //                                     fontSize: 12.sp,
                      //                                     fontWeight: FontWeight.w500,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                             Spacer(),
                      //                             Row(
                      //                               children: [
                      //                                 Container(
                      //                                   height: 6.84.h,
                      //                                   width: 6.84.w,
                      //                                   decoration: const BoxDecoration(
                      //                                     shape: BoxShape.circle,
                      //                                     color: Color(0xFF4A934A),
                      //                                   ),
                      //                                 ),
                      //                                 SizedBox(
                      //                                   width: 5.w,
                      //                                 ),
                      //                                 Text(
                      //                                   "Scheduled",
                      //                                   style: manropeSubTitleTextStyle.copyWith(
                      //                                     fontSize: 8.sp,
                      //                                     fontWeight: FontWeight.w500,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ],
                      //                         ),
                      //
                      //
                      //                       );
                      //                     })
                      //
                      //
                      //
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     )),

                      //Weekly Summary
                      WeeklySummary(
                          totalTimeNo: '10h 10min',
                          totalTimeChart: 0.4,
                          totalClassesNo: '10',
                          totalClassesChart: 0.2),

                      ///Guides A-Z

                      /// Guides Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Guide A-Z',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 16.sp)),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(PagePath.guide);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style:manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                  ),
                              ),
                            ),
                          ),
                        ],
                      ),


                      SizedBox(height: 10.h,),

                      /// Guides Heading
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 18,
                        ),
                        child: GridView.count(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: 10, vertical: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3,
                          children: List.generate(
                            guidesListLength.length,
                            (index) {
                              return Container(
                                // margin: EdgeInsets.only(top: 30, bottom: 30),
                                // padding: EdgeInsets.only(bottom: 30),
                                child: GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).push(
                                        //'${PagePath.TeacherDetail}?userid=2');
                                        '${PagePath.guideDetail}?id=${guidesListLength[index].keyId}&type=${guidesListLength[index].type}');
                                  },
                                  child: CustomGuideContainer(
                                    text: guidesListLength[index].name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      ///Featured Poses Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Featured Poses',
                                style:  manropeHeadingTextStyle.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.darkGreenGray,
                                  height: 1.2,
                                ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(PagePath.posesViewAllTeacher);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                  ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Featured Poses Cards
                      posesList.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(
                                left: 23,
                                top: 1,
                              ),
                              child: Text(
                                'No Poses Avaialble right now',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.darkGreyHeading1),
                              ),
                            )
                          : Container(
                        padding: EdgeInsets.symmetric(horizontal: 23,),
                        child: SizedBox(
                          height: Platform.isAndroid ?
                          CommonFunctions.deviceWidth(context) <=360 ?
                          370.h :
                          CommonFunctions.deviceWidth(context) <=393 ?
                          358.h :
                          410.h :
                          CommonFunctions.deviceHeight(context) * 0.45,


                          //CommonFunctions.deviceHeight(context) * 0.45,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: posesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        "POSE ID ON CLICK ===== ${posesList[index].poseId}");
                                    GoRouter.of(context).push(
                                      //'${PagePath.TeacherDetail}?userid=2');
                                        '${PagePath.posesDetailGuide}?id=${posesList[index].poseId}');
                                  },
                                  child: FeaturedPosesCard(
                                    imagePath:
                                    'assets/images/user_profile_video_session.png',
                                    title: posesList[index].poseName,
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
                            child: Text(
                              'Explore Yoga Styles',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.darkGreenGray,
                                height: 1.2,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(PagePath.stylesViewAllTeacher);
                            },
                            child:  Padding(
                              padding: EdgeInsets.only(top: 15.0, right: 26),
                              child: Text(
                                'View All',
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // stylesList
                      ///Explore Yoga Styles Image Cards
                      Container(
                        height: Platform.isAndroid ?
                        CommonFunctions.deviceWidth(context) <=360 ?
                        435.h :
                        CommonFunctions.deviceWidth(context) <=393 ?
                        470.h :
                        570.h :
                        410.h,
                        //500.h,
                        margin: EdgeInsets.symmetric(horizontal: 23),
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Color(0x87e5e5e5),
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          children: List.generate(
                            stylesList.length,
                                (index) {
                              return Padding(
                                padding:
                                // const EdgeInsets.only(left: 23, top: 17, right: 13),
                                const EdgeInsets.only(
                                    left: 8, top: 8, right: 8, bottom: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).push(
                                      //'${PagePath.TeacherDetail}?userid=2');
                                        '${PagePath.styleDetailGuide}?id=${stylesList[index].styleId}');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/yoga_style_1.png',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    // width: 162,
                                    // height: 230,

                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: Text(
                                          stylesList[index].styleName,
                                          style: manropeSubTitleTextStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),


                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),



                      ///You May Also Like Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text(
                              'You may also like',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.darkGreenGray,
                                height: 1.2,
                              ),
                            ),
                          ),
                          youMayLikeList.isEmpty
                              ? const Text('')
                              : TextButton(
                            onPressed: () {},
                            child:  Padding(
                              padding: EdgeInsets.only(top: 15.0, right: 26),
                              child: Text(
                                'View All',
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Featured Poses Cards
                      youMayLikeList.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.only(
                          left: 23,
                          top: 1,
                        ),
                        child: Text(
                          'Nothing Available',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.darkGreyHeading1),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.symmetric(horizontal: 23),
                        height:Platform.isAndroid ?
                        CommonFunctions.deviceWidth(context) <=360 ?
                        372.h :
                        CommonFunctions.deviceWidth(context) <=393 ?
                        380.h :
                        420.h :
                        CommonFunctions.deviceHeight(context) * 0.47,

                          child: ListView.builder(
                          shrinkWrap: true,
                          // padding: EdgeInsets.only(bottom: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: youMayLikeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: FeaturedPosesCard(
                                imagePath: 'assets/home/also_like_yoga.png',
                                title: youMayLikeList[index],
                              ),
                            );
                          },
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.primaryColor,
            child: SvgPicture.asset(
                'assets/home/chat-bubble-bottom-center-text.svg'),
          ),
        ),
      ),
    );
  }
}
