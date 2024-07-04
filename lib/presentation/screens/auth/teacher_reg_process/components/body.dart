import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/presentation/screens/auth/choose_role/components/arrow_back_icon.dart';
import '../../../../../app/utils/common_functions.dart';
import '../../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';
import '../../../../providers/login_provider.dart';

class Body extends ConsumerStatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  // var isOpened = false;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addObserver(this);
    Future.delayed(Duration.zero, () {
      ref.read(teacherProfileStatusProvider.notifier).state.status.name ==
              "Incomplete"
          ? showAlert()
          : null;
    });
  }

  showAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Follow the Profile Completion steps and access our Teacher’s Profile.',
                style: manropeSubTitleTextStyle.copyWith(
                  fontSize: 14,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                text: "Continue",
                onTap: () => context.pop(),
                btnColor: Colors.white,
                textColor: AppColors.primaryColor,
                border: Border.all(color: AppColors.primaryColor, width: 1),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileStaus = ref.watch(teacherProfileStatusProvider);
    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: false,
        child: Container(
          // height: 844.h,
          // width: 390.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Drawables.authPlainBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Wrap(
            children: [
              ArrowBackIcon(onTap: () => context.pop()),
              SizedBox(
                width: CommonFunctions.deviceWidth(context) * 0.27,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: CommonFunctions.deviceHeight(context),
                  width: CommonFunctions.deviceWidth(context),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 37,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Elevate Your Yoga Practice with a\nPurpose-Driven Teacher Profile',
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF202526),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        'Following are the steps to follow',
                        style: manropeSubTitleTextStyle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            // onExpansionChanged: (value) {
                            //   setState(() {
                            //     isOpened = !isOpened;
                            //     print('IS OPENED IS NOW ${isOpened}');
                            //   });
                            // },
                            textColor: Colors.black,
                            leading: SvgPicture.asset(
                              Drawables.teacherProfileCompletionIcon1,
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                            ),
                            title: Text(
                              'Profile Completion',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            subtitle: Text(
                              'Wait for 24 hours till we verify your details.',
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 11.sp,
                                color: const Color(0xFF313131),
                                height: 1.2,
                              ),
                            ),
                            trailing: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 74.w,
                                  padding: const EdgeInsets.all(0),
                                  height: 23.h,
                                  decoration: BoxDecoration(
                                    color: profileStaus.status.name ==
                                            "Incomplete"
                                        ? Colors.red.withOpacity(0.2)
                                        : const Color(0xFF356335).withOpacity(0.4),
                                  ),
                                  child: Container(
                                    // alignment: Alignment.topCenter,
                                    // padding: const EdgeInsets.only(bottom: 0),
                                    child: Text(
                                      profileStaus.status.name,
                                      style: manropeSubTitleTextStyle.copyWith(
                                        color: profileStaus.status.name ==
                                                "Incomplete"
                                            ? Colors.red
                                            : Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.check_circle_rounded,
                                ),
                                title: Text(
                                  'About',
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  'Add details about yourself',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                ),
                                onTap: () => context
                                    .push(PagePath.teacherRegProcessAbout),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.check_circle_rounded,
                                ),
                                title: Text(
                                  'Education',
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  'Add details about your academic and professional background.',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                ),
                                onTap: () => context
                                    .push(PagePath.teacherRegProcessAbout),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ListTile(
                            textColor: Colors.black,
                            leading: SvgPicture.asset(
                              Drawables.teacherProfileCompletionIcon2,
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                            ),
                            title: Text(
                              'Profile Verification',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              'Wait for 24 hours till we verify your details.',
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 11,
                                color: const Color(0xFF313131),
                                height: 1.2,
                              ),
                            ),
                            trailing: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 74.w,
                                  padding: const EdgeInsets.only(bottom: 4),
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color:
                                        profileStaus.status.name == "Complete"
                                            ? const Color(0xFFC4BF9C)
                                            : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Pending",
                                      style: manropeSubTitleTextStyle.copyWith(
                                        color: profileStaus.status.name ==
                                                "Incomplete"
                                            ? Colors.white
                                            : Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ListTile(
                            textColor: Colors.black,
                            leading: SvgPicture.asset(
                              Drawables.teacherProfileCompletionIcon3,
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                            ),
                            title: Text(
                              'Go Online',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              'Start your practice with purpose.',
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 11,
                                color: const Color(0xFF313131),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: CustomButton(
                            btnColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            text: "Create Profile",
                            onTap: () async {
                              context.push(PagePath.teacherRegProcessAbout);
                            }),
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
