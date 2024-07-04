import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/bottom_continue_buttons.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';
import '../../../../providers/login_provider.dart';
import '../../../../providers/screen_state.dart';
import '../components/progress_bar_widget.dart';
import '../components/question_text.dart';

class TraumatStep extends ConsumerStatefulWidget {
  const TraumatStep({Key? key}) : super(key: key);

  @override
  ConsumerState<TraumatStep> createState() => _TraumatStepState();
}

class _TraumatStepState extends ConsumerState<TraumatStep> {
  bool otherSelect = false;
  final traumaTextController = TextEditingController();

  // final authNotifier = AuthNotifier(
  //   ref: Ref(),
  //   loginRepository: GetIt.I.,
  //   chronicRepository: ChronicRepository(),
  // );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final conditions = ref.watch(chronicConditionRequestProvider);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
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
                      step: 4,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 35.w),
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

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: const QuestionText(text: "What kind of trauma?"),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  height: 100.h,
                  width: 313.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F5FA),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child:  TextField(
                    controller: traumaTextController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: "Enter your text here",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: 301.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(Drawables.notice),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          "For example:\nMajor traumas includes: surgeries, physical abuse, vehicular accidents etc.\nMinor traumas includes: sprained ankles/wrists, lower back pain etc.",
                          style: manropeSubTitleTextStyle.copyWith(
                              fontSize: 12.sp,
                              color: const Color(0xFF5A5A5A),
                              height: 1.2
                          ),),),
                    ],
                  ),
                ),
              ],
            )


          ],
        ),
      ),


      bottomNavigationBar: BottomContinueButton(
        continueTap: () {

          if(traumaTextController.text.isEmpty){
            UIFeedback.showSnackBar(context, "Please Provide relevant details to proceed.",
                stateType: StateType.error,
                height: 280);
          }else{

              ref.read(traumaConditionProvider.notifier).state = traumaTextController.text;

              print("ON STEP 3 User LEVEL ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
              print("ON STEP 3 User INTENTION ===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");

              print("CHRONICAL OTHER  ===== ${ref.read(chronicOtherConditionProvider)}");
              print("TRAUMA  ===== ${ref.read(traumaConditionProvider)}");
              print("CHRONIC LIST PROVIDER ===== ${ref.read(chronicConditionRequestProvider)}");

            context.push(PagePath.injuryQuestion);
          }




        },
        notNowTap: () {
          context.push(PagePath.injuryQuestion);
        },
      ),
    );
  }
}
