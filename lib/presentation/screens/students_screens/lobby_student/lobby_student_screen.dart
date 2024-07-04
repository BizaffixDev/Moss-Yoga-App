import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/agora_provider/agora_providers.dart';
import 'package:moss_yoga/presentation/providers/home_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';

class LobbyWaitStudent extends ConsumerStatefulWidget {
  LobbyWaitStudent(
      {this.teacherName,
      this.yogaStyle,
      this.country,
      this.channelName,
      Key? key})
      : super(key: key);

  String? teacherName;
  String? yogaStyle;
  String? country;
  String? channelName;

  @override
  ConsumerState<LobbyWaitStudent> createState() => _LobbyStudentState();
}

class _LobbyStudentState extends ConsumerState<LobbyWaitStudent> {
  @override
  void initState() {
    super.initState();

    ///Should be an api to check time remainng and to join session.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.neutral53),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const Text(
            'Lobby',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.darkSecondaryGray),
          ),
        ),
        endDrawer: DrawerScreen(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Drawables.timeIcon,
                            color: Colors.white,
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "05:30 min",
                            style: manropeHeadingTextStyle.copyWith(
                                color: Colors.white, height: 1.2),
                          ),
                        ],
                      ),
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
                                    height: 125.h,
                                    width: 118.w,
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
                                        Text(
                                          widget.teacherName ?? "Jane Cyrus",
                                          style:
                                              manropeHeadingTextStyle.copyWith(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        Text(
                                          widget.yogaStyle ?? "Ashtanga Yoga",
                                          style:
                                              manropeHeadingTextStyle.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            height: 1.3,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 5.h,
                                        ),

                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                widget.yogaStyle == null
                                                    ? " New York, US"
                                                    : " ${widget.yogaStyle}",
                                                style: manropeHeadingTextStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.sp,
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                        "Set your Camera Position at certain angle",
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
                                        "Place your mat as per instructor guidelines",
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
                            Text(
                              "Your Teacher will let you in soon",
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: Color(0xFF7F9195),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomButton(
                                m: 0,
                                btnColor: AppColors.primaryColor,
                                textColor: Colors.white,
                                text: "Join Session",
                                onTap: () async {
                                  ///Ask for the permissions before going in.
                                  await [
                                    Permission.camera,
                                    Permission.microphone
                                  ].request();

                                  ///send the client ID
                                  var user = await ref
                                      .read(homeNotifierProvider.notifier)
                                      .getStudentData();

                                  var channelName = widget.channelName;
                                  var userName = ref
                                      .read(studentObjectProvider.notifier)
                                      .state
                                      .username;

                                  ///Use this, server broke so I did manual
                                  var userId = ref
                                      .read(studentObjectProvider.notifier)
                                      .state
                                      .userId;

                                  print(
                                      'this is the channel name being sent from student $channelName');

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

  int getRandomNumberBetween(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }
}
