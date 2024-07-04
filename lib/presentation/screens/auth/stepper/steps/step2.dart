import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/data/models/user_intention.dart';
import '../../../../../app/utils/common_functions.dart';
import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/bottom_continue_buttons.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';
import '../../../../../common/resources/text_styles.dart';
import '../../../../providers/login_provider.dart';
import '../../../../providers/screen_state.dart';
import '../components/option_box.dart';
import '../components/progress_bar_widget.dart';

class IntentionsStepView extends ConsumerStatefulWidget {
  const IntentionsStepView({Key? key}) : super(key: key);

  @override
  ConsumerState<IntentionsStepView> createState() => _IntentionsStepViewState();
}

class _IntentionsStepViewState extends ConsumerState<IntentionsStepView> {
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
            height: 545.h,
            width: 390.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Drawables.intentionBg,

                  ),
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ProgressBarWidget(
                      step: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: CommonFunctions.deviceHeight(context) * 0.2,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      "Set your Intention",
                      style: manropeHeadingTextStyle.copyWith(
                          fontSize: 34.sp, color: Colors.white, height: 1.2),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Positioned(
          //   top: CommonFunctions.deviceHeight(context) * 0.43,
          //   left: CommonFunctions.deviceWidth(context) * 0.08,
          //   right: CommonFunctions.deviceWidth(context) * 0.05,
          //   child: ,
          // ),
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
                      text: "Physical",
                      image: optionSelected == 1
                          ? Drawables.physicalWhite
                          : Drawables.physicalBlack,
                      color: optionSelected == 1
                          ? AppColors.primaryColor
                          : const Color(0xFFF7F5FA),
                      textcolor:
                          optionSelected == 1 ? Colors.white : Colors.black,
                      onTap: () {
                        ref.read(userIntentionProvider.notifier).state =
                                UserIntentionModel(
                                    userIntention: UserIntention.Physical)
                            //UserLevel(userType: UserType.Beginner)
                            ;
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
                      text: "Mental",
                      image: optionSelected == 3
                          ? Drawables.mentalWhite
                          : Drawables.mentalBlack,
                      color: optionSelected == 3
                          ? AppColors.primaryColor
                          : const Color(0xFFF7F5FA),
                      textcolor:
                          optionSelected == 3 ? Colors.white : Colors.black,
                      onTap: () {
                        ref.read(userIntentionProvider.notifier).state =
                                UserIntentionModel(
                                    userIntention: UserIntention.Mental)
                            //UserLevel(userType: UserType.Beginner)
                            ;
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
                  text: "Spiritual",
                  image: optionSelected == 2
                      ? Drawables.sprituaWhite
                      : Drawables.spritualBlack,
                  color: optionSelected == 2
                      ? AppColors.primaryColor
                      : const Color(0xFFF7F5FA),
                  textcolor: optionSelected == 2 ? Colors.white : Colors.black,
                  onTap: () {
                    ref.read(userIntentionProvider.notifier).state =
                            UserIntentionModel(
                                userIntention: UserIntention.Spiritual)
                        //UserLevel(userType: UserType.Beginner)
                        ;
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
      bottomNavigationBar: BottomContinueButton(
        continueTap: () {
          if (optionSelected == 0) {
            UIFeedback.showSnackBar(context, "Please select your intention",
                stateType: StateType.error, height: 280);
          } else {
            print(
                "User INTENTION CONTINUE===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");
            context.push(PagePath.chronicQuestion);
          }
        },
        notNowTap: () {
          ref.read(userIntentionProvider.notifier).state =
              UserIntentionModel(userIntention: UserIntention.None);
          print(
              "User INTENTION NOT NOW===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");
          context.push(PagePath.chronicQuestion);
        },
      ),

      /*  SafeArea(
        child: Column(
          children: [
            // const Padding(
            //   padding:  EdgeInsets.only(left: 20,right: 20),
            //   child: StepProgressWidget(currentStep: 0, steps: 4),
            // ),

            SizedBox(
              height: 10,
            ),

            const ProgressBarWidget(
              currentValue: 1,
            ),

            Container(height: size.height * 0.17, child: LogoImage()),

            const QuestionText(
              text: "What's your Intention?",
            ),

            SizedBox(
              height: size.height * 0.06,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OptionsWidget(
                  id: 1,
                  text: "Physical",
                  image: "assets/images/user.png",
                  color: optionSelected == 1 ? Colors.grey.withOpacity(0.4) : Color(0xFFF6F6F6),
                  onTap: () {
                    ref.read(userIntentionProvider.notifier).state ==
                            UserIntentionModel(
                                userIntention: UserIntention.Physical)
                        //UserLevel(userType: UserType.Beginner)
                        ;
                    setState(() {
                      optionSelected = 1;
                    });
                  },
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                OptionsWidget(
                  id: 2,
                  text: "Spiritual",
                  image: "assets/images/user.png",
                  color: optionSelected == 2 ? Colors.grey.withOpacity(0.4) : Color(0xFFF6F6F6),
                  onTap: () {
                    ref.read(userIntentionProvider.notifier).state ==
                        UserIntentionModel(
                            userIntention: UserIntention.Spiritual);
                    setState(() {
                      optionSelected = 2;
                    });
                  },
                ),
              ],
            ),

            SizedBox(
              height: size.height * 0.02,
            ),

            OptionsWidget(
              id: 3,
              text: "Mental",
              image: "assets/images/user.png",
              color: optionSelected == 3 ? Colors.grey.withOpacity(0.4) : Color(0xFFF6F6F6),
              onTap: () {
                ref.read(userIntentionProvider.notifier).state ==
                    UserIntentionModel(userIntention: UserIntention.Mental);
                setState(() {
                  optionSelected = 3;
                });
              },
            ),

            SizedBox(
              height: size.height * 0.08,
            ),

        CustomButton(
                onTap: (){
                 if(optionSelected == 0){
                   UIFeedback.showSnackBar(context, "Please select your intention");
                 }else{
                   context.push(PagePath.level);
                 }

                },
                text: "Continue",
              ),


             NotNowText(
               onTap: ()=>context.go(PagePath.level),
             )
          ],
        ),
      ),*/
    );
  }
}
