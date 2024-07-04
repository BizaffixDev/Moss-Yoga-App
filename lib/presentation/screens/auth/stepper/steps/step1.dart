import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/user_level.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/bottom_continue_buttons.dart';
import '../../../../providers/login_provider.dart';
import '../components/option_box.dart';
import '../components/progress_bar_widget.dart';

class LevelsStepView extends ConsumerStatefulWidget {
  const LevelsStepView({Key? key}) : super(key: key);

  @override
  ConsumerState<LevelsStepView> createState() => _LevelsStepViewState();
}

class _LevelsStepViewState extends ConsumerState<LevelsStepView> {
  int optionSelected = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(alignment: AlignmentDirectional.topCenter, children: [
          //main top container with step bar and heading text
          Container(
            height: 550.h,
            width: 390.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Drawables.levelBg,
                  ),
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child:  Align(
                    alignment: Alignment.bottomCenter,
                    child: ProgressBarWidget(
                      step: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 140.h
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      "Choose your Level",
                      style: manropeHeadingTextStyle.copyWith(
                          fontSize: 34.sp, color: Colors.white, height: 1.2),
                    ),
                  ),
                )
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OptionsWidget(
                      id: 1,
                      text: "Beginner",
                      image: optionSelected == 1
                          ? Drawables.baginnerWhite
                          : Drawables.baginnerBlack,
                      color: optionSelected == 1
                          ? AppColors.primaryColor
                          : const Color(0xFFF7F5FA),
                      textcolor:
                          optionSelected == 1 ? Colors.white : Colors.black,
                      onTap: () {
                        print("select 1");
                        ref.read(userTypeProvider.notifier).state =
                            UserLevel(userType: UserType.Beginner);
                        setState(() {
                          optionSelected = 1;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OptionsWidget(
                      id: 3,
                      text: "Advance",
                      image: optionSelected == 3
                          ? Drawables.advanceWhite
                          : Drawables.advanceBlack,
                      color: optionSelected == 3
                          ? AppColors.primaryColor
                          : const Color(0xFFF7F5FA),
                      textcolor:
                          optionSelected == 3 ? Colors.white : Colors.black,
                      onTap: () {
                        print("select 2");
                        ref.read(userTypeProvider.notifier).state =
                            UserLevel(userType: UserType.Advanced);
                        setState(() {
                          optionSelected = 3;
                        });
                      },
                    ),
                     SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                OptionsWidget(
                  id: 2,
                  text: "Intermediate",
                  image: optionSelected == 2
                      ? Drawables.intermediateWhite
                      : Drawables.intermediateBlack,
                  color: optionSelected == 2
                      ? AppColors.primaryColor
                      : const Color(0xFFF7F5FA),
                  textcolor: optionSelected == 2 ? Colors.white : Colors.black,
                  onTap: () {
                    ref.read(userTypeProvider.notifier).state =
                        UserLevel(userType: UserType.Intermediate);
                    setState(() {
                      optionSelected = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: SizedBox(
        // height: CommonFunctions.deviceHeight(context) * 0.2,
        child: BottomContinueButton(
          continueTap: () {
            if (optionSelected == 0) {
              UIFeedback.showSnackBar(context, "Please select your level",
                  stateType: StateType.error, height: 280);
            } else {
              print(
                  "User LEVEL CONTINUE===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
              context.push(PagePath.intention);
            }
          },
          notNowTap: () {
            ref.read(userTypeProvider.notifier).state =
                UserLevel(userType: UserType.None);
            print(
                "User LEVEL NOT NOW ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");

            context.push(PagePath.intention);
          },
        ),
      ),
    );
  }
}
