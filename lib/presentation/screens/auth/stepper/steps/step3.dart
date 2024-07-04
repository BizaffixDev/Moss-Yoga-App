import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';

import '../../../../../app/utils/common_functions.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../providers/login_provider.dart';
import '../components/not_now_text.dart';
import '../components/progress_bar_widget.dart';
import '../components/question_text.dart';

class ChronicConditionQuestionStep extends ConsumerStatefulWidget {
  const ChronicConditionQuestionStep({Key? key}) : super(key: key);

  @override
  ConsumerState<ChronicConditionQuestionStep> createState() =>
      _ChronicConditionQuestionStepState();
}

class _ChronicConditionQuestionStepState
    extends ConsumerState<ChronicConditionQuestionStep> {
  bool value = false;

  // final conditions = [
  //   CheckboxState(title: "Mental Disorder"),
  //   CheckboxState(title: "Blood Pressure"),
  //   CheckboxState(title: "Asthma"),
  //   CheckboxState(title: "Others"),
  // ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
                    step: 3,
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
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: const QuestionText(
                      text: "Do you suffer from any Chronic Conditions?"),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Yes",
                  onTap: () {
                    print("ON STEP 3 User LEVEL ===== ${ref
                        .read(userTypeProvider.notifier)
                        .state
                        .userType
                        .name}");
                    print("ON STEP 3 User INTENTION ===== ${ref
                        .read(userIntentionProvider.notifier)
                        .state
                        .userIntention
                        .name}");
                    context.push(PagePath.chronicList);
                  },
                  btnColor: Colors.white,
                  border: Border.all(color: AppColors.primaryColor,),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomButton(
                  text: "No",
                  onTap: () {
                    print("ON STEP 3 User LEVEL ===== ${ref
                        .read(userTypeProvider.notifier)
                        .state
                        .userType
                        .name}");
                    print("ON STEP 3 User INTENTION ===== ${ref
                        .read(userIntentionProvider.notifier)
                        .state
                        .userIntention
                        .name}");
                    ref.read(chronicConditionResponseListProvider.select((
                        value) => value = []));
                    print("CHRONIC LIST PROVIDER ===== ${ref.read(
                        chronicConditionResponseListProvider)}");
                    context.push(PagePath.traumaQuestion);
                  },
                  btnColor: Colors.white,
                  border: Border.all(color: AppColors.primaryColor,),
                ),


              ],
            ),
          )
        ],
      ),

      bottomNavigationBar: SizedBox(
        height: CommonFunctions.deviceHeight(context) * 0.16,
        width: CommonFunctions.deviceWidth(context),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NotNowText(
              onTap: () {
                print("ON STEP 3 User LEVEL ===== ${ref
                    .read(userTypeProvider.notifier)
                    .state
                    .userType
                    .name}");
                print("ON STEP 3 User INTENTION ===== ${ref
                    .read(userIntentionProvider.notifier)
                    .state
                    .userIntention
                    .name}");
                ref.read(chronicConditionResponseListProvider.select((value) =>
                value = []));
                print("CHRONIC LIST PROVIDER ===== ${ref.read(
                    chronicConditionResponseListProvider)}");
                context.push(PagePath.traumaQuestion);
              },)

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
