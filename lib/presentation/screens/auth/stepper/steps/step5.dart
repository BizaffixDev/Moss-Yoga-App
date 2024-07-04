import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/data/models/surgery_model.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';
import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/loader.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';
import '../../../../providers/login_provider.dart';
import '../../../../providers/screen_state.dart';
import '../components/not_now_text.dart';
import '../components/progress_bar_widget.dart';
import '../components/question_text.dart';

class InjuryQuestionStep extends ConsumerStatefulWidget {
  const InjuryQuestionStep({Key? key}) : super(key: key);

  @override
  ConsumerState<InjuryQuestionStep> createState() => _InjuryQuestionStepState();
}

class _InjuryQuestionStepState extends ConsumerState<InjuryQuestionStep> {
  bool value = false;
  bool isTapped = false;

  // final conditions = [
  //   CheckboxState(title: "Mental Disorder"),
  //   CheckboxState(title: "Blood Pressure"),
  //   CheckboxState(title: "Asthma"),
  //   CheckboxState(title: "Others"),
  // ];

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifyProvider, (previous, screenState) {
      if (screenState is AuthErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is ProflingStudentLoadingState) {
        debugPrint('Loading');
        showLoading(context);

        // setState(() {});
      } else if (screenState is ProflingStudentSuccessfulState) {
        // chrlist =  screenState.chronicResponseList;gui ug
        //print("chrListt ${chrlist[0].chronicConditionName}");

        dismissLoading(context);
        setState(() {});
        GoRouter.of(context).go(PagePath.homeScreen);
      }
    });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            height:Platform.isAndroid  ? 300.h : 280.h,
            width: 390.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Drawables.stepperTopBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: ProgressBarWidget(
                    step: 5,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    child: Image.asset(
                      Drawables.appLogo,
                      height: 144.h,
                      width: 146.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  child: const QuestionText(
                      text:
                          "Have you experienced any minor injuries in the last 6 months?"),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Yes",
                  onTap: () async {
                    ref.read(userHasSurgeryProvider.notifier).state =
                        HasSurgeryModel(hasSurgery: HasSurgery.Yes);
                    print(
                        "ON STEP 3 User LEVEL ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
                    print(
                        "ON STEP 3 User INTENTION ===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");
                    print(
                        "CHRONIC LIST PROVIDER ===== ${ref.read(chronicConditionResponseListProvider)}");
                    print(
                        "TRAUMA CONDITION ===== ${ref.read(traumaConditionProvider)}");
                    print(
                        "HAS SURGERY ===== ${ref.read(userHasSurgeryProvider)}");
                    await ref
                        .read(authNotifyProvider.notifier)
                        .postStudentProfile();
                  },
                  btnColor:
                      isTapped == true ? AppColors.primaryColor : Colors.white,
                  textColor: isTapped == true ? Colors.white : Colors.black,
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomButton(
                  text: "No",
                  onTap: () async {
                    ref.read(userHasSurgeryProvider.notifier).state =
                        HasSurgeryModel(hasSurgery: HasSurgery.No);
                    print(
                        "ON STEP 3 User LEVEL ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
                    print(
                        "ON STEP 3 User INTENTION ===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");
                    print(
                        "CHRONIC LIST PROVIDER ===== ${ref.read(chronicConditionResponseListProvider)}");
                    print(
                        "TRAUMA CONDITION ===== ${ref.read(traumaConditionProvider)}");
                    print(
                        "HAS SURGERY ===== ${ref.read(userHasSurgeryProvider)}");

                    await ref
                        .read(authNotifyProvider.notifier)
                        .postStudentProfile();
                    setState(() {
                      isTapped = true;
                    });
                    print("to home");
                  },
                  btnColor: Colors.white,
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 100.h,
        width: 390.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NotNowText(
              onTap: () async {
                print(
                    "ON STEP 3 User LEVEL ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
                print(
                    "ON STEP 3 User INTENTION ===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");
                print(
                    "CHRONIC LIST PROVIDER ===== ${ref.read(chronicConditionResponseListProvider)}");
                print(
                    "TRAUMA CONDITION ===== ${ref.read(traumaConditionProvider)}");
                await ref
                    .read(authNotifyProvider.notifier)
                    .postStudentProfile();
                setState(() {
                  isTapped = true;
                });
                print("to HomeScreen Adios!!!!");
                // context.go(PagePath.homeScreen);
              },
            )
          ],
        ),
      ),
    );
  }

// Widget buildSingleCheckBox(CheckboxState checkbox){
//   return CheckboxListTile(
//       activeColor: Color(0xFF536770),
//       value: checkbox.value,
//       title: Row(
//         children: [
//           Image.asset("assets/images/brain.png"),
//           SizedBox(width: 10,),
//           Text(checkbox.title),
//         ],
//       ),
//
//       onChanged: (value) {
//         setState(() {
//           checkbox.value= value!;
//         });
//       });
// }
}
