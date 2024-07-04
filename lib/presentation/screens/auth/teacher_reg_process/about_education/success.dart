import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/app_providers.dart';

import '../../../../../app/utils/common_functions.dart';
import '../../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';

class TeacherRegProcessSuccess extends ConsumerStatefulWidget {
  const TeacherRegProcessSuccess({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherRegProcessSuccess> createState() =>
      _TeacherRegProcessSuccessState();
}

class _TeacherRegProcessSuccessState
    extends ConsumerState<TeacherRegProcessSuccess> {
  @override
  Widget build(BuildContext context) {
    bool isLocked = ref.read(isLockedTeacherProvider);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              fit: StackFit.passthrough,
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  height: 275.h,
                  width: 390.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        Drawables.stepperTopbg,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Image.asset(
                            Drawables.logo,
                            height: 144.h,
                            width: 146.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Success !",
                      style: manropeHeadingTextStyle.copyWith(
                        fontSize: 28.sp,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.15),
                        child: Text(
                          "Our team will verify your information to ensure authenticity. Till then you can explore the Teacher Application.",
                          textAlign: TextAlign.center,
                          style: manropeSubTitleTextStyle.copyWith(
                              height: 1.2,
                              fontSize: 14.sp,
                              color: const Color(0xFF536063)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.15),
                          child: Text(
                            "You're almost there!",
                            style: manropeSubTitleTextStyle.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  CommonFunctions.deviceWidth(context) * 0.15),
                          leading: Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                          ),
                          title: Text(
                            'Step 1: Profile Completion ',
                            style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14.sp, color: AppColors.primaryColor),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  CommonFunctions.deviceWidth(context) * 0.15),
                          leading: Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor.withOpacity(0.2),
                          ),
                          title: Text(
                            'Step 2: Profile Verification ',
                            style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.primaryColor.withOpacity(0.2)),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  CommonFunctions.deviceWidth(context) * 0.15),
                          leading: Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor.withOpacity(0.2),
                          ),
                          title: Text(
                            'Step 3: Go Online',
                            style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.primaryColor.withOpacity(0.2)),
                          ),
                        ),
                      ],
                    ),

                    // SizedBox(
                    //   height: size.height * 0.001,
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 111.h,
          width: 390.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Go to Home",
                onTap: () {
                  isLocked
                      ? context.go(PagePath.homeScreenTeacher)
                      : context.go(PagePath.homeScreenTeacherLocked);
                },
                btnColor: AppColors.primaryColor,
                textColor: Colors.white,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
