import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer.dart';
import 'package:moss_yoga/common/app_specific_widgets/teacherdrawer.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/home_provider.dart';
import 'package:moss_yoga/presentation/providers/teachers_providers/home_teacher_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../providers/student_profiling_provider/student_account_provider.dart';

class LobbyWaitTeacher extends ConsumerStatefulWidget {
  LobbyWaitTeacher(
      {this.studentName,
      this.chronicConditions,
      this.trauma,
      this.channelName,
      Key? key})
      : super(key: key);

  String? studentName;
  String? chronicConditions;
  String? trauma;
  String? channelName;

  @override
  ConsumerState<LobbyWaitTeacher> createState() => _LobbyStudentState();
}

class _LobbyStudentState extends ConsumerState<LobbyWaitTeacher> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const Text(
            'Lobby',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        endDrawer: TeacherDrawer(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: 844.h,
            width: 390.w,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(37),
                topRight: Radius.circular(37),
              ),
              image: DecorationImage(
                image: AssetImage(Drawables.authPlainBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        height: 650.h,
                        width: 390.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(37),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 187.h,
                              width: 323.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //image
                                  Container(
                                    height: 116.h,
                                    width: 116.w,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/teacher.png"),
                                          fit: BoxFit.cover,
                                        )),
                                  ),

                                  const SizedBox(
                                    width: 20,
                                  ),

                                  //INFO
                                  Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //name
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.studentName ?? "John Doe",
                                              style: manropeHeadingTextStyle
                                                  .copyWith(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30.w,
                                            ),
                                            SvgPicture.asset(Drawables.message,height: 20.h,),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Chronic Conditions:",
                                              style: manropeSubTitleTextStyle
                                                  .copyWith(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14.sp,
                                                height: 1.3,
                                              ),
                                            ),
                                            // Container(
                                            //   height: 5.h,
                                            //   width: 5.h,
                                            //   decoration: BoxDecoration(
                                            //     color: AppColors.primaryColor,
                                            //     shape: BoxShape.circle,
                                            //   ),
                                            // ),
                                            Text(
                                              widget.chronicConditions ??
                                                  " Stroke",
                                              style: manropeSubTitleTextStyle
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Trauma:",
                                              style: manropeSubTitleTextStyle
                                                  .copyWith(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14.sp,
                                                height: 1.3,
                                              ),
                                            ),
                                            // Container(
                                            //   height: 5.h,
                                            //   width: 5.h,
                                            //   decoration: BoxDecoration(
                                            //     color: AppColors.primaryColor,
                                            //     shape: BoxShape.circle,
                                            //   ),
                                            // ),
                                            Text(
                                              widget.trauma == null
                                                  ? " N/A"
                                                  : " ${widget.trauma}",
                                              style: manropeSubTitleTextStyle
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 10.h,
                                        ),

                                        ///View Details Card commented for now
                                        // GestureDetector(
                                        //   onTap: () {},
                                        //   child: Text(
                                        //     "View Details",
                                        //     style: manropeSubTitleTextStyle
                                        //         .copyWith(
                                        //       fontWeight: FontWeight.w700,
                                        //       fontSize: 14.sp,
                                        //       height: 1.3,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please Make Sure: ",
                                    style: manropeHeadingTextStyle.copyWith(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "You have a good internet connection",
                                        style:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "Do not leave the app in between the session.",
                                        style:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            CustomButton(
                                m: 0,
                                btnColor: AppColors.primaryColor,
                                textColor: Colors.white,
                                text: "Start Session",
                                onTap: () async {
                                  ///Ask for the permissions before going in.
                                  await [
                                    Permission.camera,
                                    Permission.microphone
                                  ].request();

                                  ///send the client ID
                                  var user = await ref
                                      .read(
                                          homeNotifierTeacherProvider.notifier)
                                      .getTeacherName();

                                  var channelName = widget.channelName;
                                  var userName = ref
                                      .read(teacherObjectProvider.notifier)
                                      .state
                                      .username;

                                  ///Use this, server broke so I did manual
                                  var userId = ref
                                      .read(teacherObjectProvider.notifier)
                                      .state
                                      .userId;

                                  print(
                                      'this is the channel name being sent from teacher $channelName');

                                  ///If Server breaks uncomment this for testing
                                  // var userName =
                                  //     'Testing guy ${getRandomNumberBetween(10, 100)}';
                                  // var userId = getRandomNumberBetween(10, 100);
                                  GoRouter.of(context).push(
                                      '${PagePath.agoraVideoScreen}?channelName=$channelName&userName=$userName&uid=$userId');
                                  // PagePath.agoraVideoScreen);
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
