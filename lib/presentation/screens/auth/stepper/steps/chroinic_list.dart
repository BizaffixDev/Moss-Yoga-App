import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/data/models/chronic_response_model.dart';

import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/bottom_continue_buttons.dart';
import '../../../../../common/app_specific_widgets/custom_text_field.dart';
import '../../../../../common/app_specific_widgets/loader.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';
import '../../../../providers/login_provider.dart';
import '../../../../providers/screen_state.dart';
import '../../login/states/login_states.dart';
import '../components/progress_bar_widget.dart';
import '../components/question_text.dart';

class ChronicListStep extends ConsumerStatefulWidget {
  const ChronicListStep({Key? key}) : super(key: key);

  @override
  ConsumerState<ChronicListStep> createState() => _ChronicListStepState();
}

class _ChronicListStepState extends ConsumerState<ChronicListStep> {
  bool otherSelect = false;
  final otherController = TextEditingController();


  // final authNotifier = AuthNotifier(
  //   ref: Ref(),
  //   loginRepository: GetIt.I.,
  //   chronicRepository: ChronicRepository(),
  // );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // ref.read(authNotifyProvider.notifier).getChronicList(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authNotifyProvider.notifier).getChronicList(context);

    });
    //AuthNotifier(ref: , loginRepository: null, chronicRepository: null).getChronicList(context);
  }





  @override
  Widget build(BuildContext context) {

    List<ChronicResponseModel> chrlist = ref.watch(chronicConditionResponseListProvider);
    ref.listen(authNotifyProvider, (previous, screenState) {
      if (screenState is ChronicalListErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is ChronicalLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is ChronicSuccessfulState) {
         // chrlist =  screenState.chronicResponseList;
          //print("chrListt ${chrlist[0].chronicConditionName}");
          setState(() {

          });
       // GoRouter.of(context).go(PagePath.homeScreen);
        dismissLoading(context);
      }
    });


    // final conditions = ref.watch(chronicConditionRequestProvider);



    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                      step: 3,
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
                  height: 60.h,
                ),


                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: const QuestionText(
                      text: "Select your Chronic Conditions"),
                ),


                chrlist.isEmpty ? Container() : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: chrlist.length,
                  itemBuilder: (context, index) {
                    //final condition = conditions[index];
                    return Container(
                      height: 50,
                      width: 313,
                      margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: CheckboxListTile(
                          activeColor: AppColors.primaryColor,
                          value: chrlist[index].isActive,
                          title: Row(
                            children: [
                              Image.asset(
                                chrlist[index].chronicConditionId == 1 ? Drawables.mental
                                    : chrlist[index].chronicConditionId == 2 ?  Drawables.bloodPressure
                                    :chrlist[index].chronicConditionId == 3 ?  Drawables.asthma
                                    : Drawables.bloodPressure ,
                                height: 16.h,
                                width: 15.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                chrlist[index].chronicConditionName,
                              ),
                            ],
                          ),


                          onChanged: (value) {
                            setState(() {
                              chrlist[index].isActive = value!;


                            if (value == true) {
                              print("THIS IS THE LIST BEFORE ${ref.read(chronicConditionRequestProvider)}");
                              ref
                                  .read(chronicConditionRequestProvider.notifier)
                                  .state
                                  .add(
                                chrlist[index].chronicConditionName,
                              );
                              print("THIS IS THE LIST AFTER ${ref.read(chronicConditionRequestProvider)}");
                            }else{
                              print("THIS IS THE LIST BEFORE REMOVE ${ref.read(chronicConditionRequestProvider)}");
                              ref
                                  .read(chronicConditionRequestProvider.notifier)
                                  .state
                                  .remove(
                                chrlist[index].chronicConditionName,
                              );
                              print("THIS IS THE LIST AFTER REMOVE ${ref.read(chronicConditionRequestProvider)}");
                            }

                        /*      if (value == true) {
                                print("THIS IS THE LIST BEFORE ${ref.read(chronicConditionRequestProvider)}");
                                ref.read(chronicConditionRequestProvider.notifier).addItem(
                                  ChronicResponseModel(
                                    chronicConditionId: chrlist[index].chronicConditionId,
                                    chronicConditionName: chrlist[index].chronicConditionName,
                                    cCDescription: chrlist[index].cCDescription,
                                    isActive: chrlist[index].isActive,
                                  ),
                                );
                                print("THIS IS THE LIST AFTER ${ref.read(chronicConditionRequestProvider)}");
                              } else {
                                print("THIS IS THE LIST BEFORE REMOVE ${ref.read(chronicConditionRequestProvider)}");
                                ref.read(chronicConditionRequestProvider.notifier).removeItem(
                                  ChronicResponseModel(
                                    chronicConditionId: chrlist[index].chronicConditionId,
                                    chronicConditionName: chrlist[index].chronicConditionName,
                                    cCDescription: chrlist[index].cCDescription,
                                    isActive: chrlist[index].isActive,
                                  ),
                                );
                                print("THIS IS THE LIST AFTER REMOVE ${ref.read(chronicConditionRequestProvider)}");
                              }*/
                            });
                          }
                      ),
                    );
                  },
                ),


                chrlist.isEmpty ? Container():
                Container(
                  height: 50,
                  width: 330,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: otherSelect,
                      title: Row(
                        children: [
                          Image.asset(
                            Drawables.other,
                            height: 16.h,
                            width: 15.w,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                              "Others"
                          ),
                        ],
                      ),
                      onChanged: (value){

                        setState(() {
                          otherSelect = value!;
                          ref.read(chronicOtherConditionProvider.notifier).state = otherController.text;
                        });
                      }
                  ),
                ),

                otherSelect ?
                CustomTextField(
                  controller: otherController,
                  labelText: "Othe Medical Condition",
                  hintText: "Enter your chronic conditions",



                ) : Container(),
              ],
            )
          ],
        ),
      ),

      bottomNavigationBar: BottomContinueButton(
        continueTap: (){
          if(chrlist[0].isActive == false &&
              chrlist[1].isActive == false &&
              chrlist[2].isActive == false &&
              otherSelect == false
          ){
            UIFeedback.showSnackBar(context, "Please select any condition",
                stateType: StateType.error,
                height: 280);
          }else if(  otherSelect == true && otherController.text.isEmpty){
            UIFeedback.showSnackBar(context, "Please mention any other condition",
                stateType: StateType.error,
                height: 280);
          }
          else{

              ref.read(chronicOtherConditionProvider.notifier).state = otherController.text;

            print("ON STEP 3 User LEVEL ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
            print("ON STEP 3 User INTENTION ===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");

            print("CHRONICAL OTHER  ===== ${ref.read(chronicOtherConditionProvider)}");
            print("CHRONIC LIST PROVIDER ===== ${ref.read(chronicConditionRequestProvider)}");

            context.push(PagePath.traumaQuestion);
          }

        },
        notNowTap: (){
          print("ON STEP 3 User LEVEL ===== ${ref.read(userTypeProvider.notifier).state.userType.name}");
          print("ON STEP 3 User INTENTION ===== ${ref.read(userIntentionProvider.notifier).state.userIntention.name}");
          ref.read(chronicOtherConditionProvider.select((value) => value = ""));
          print("CHRONIC LIST PROVIDER ===== ${ref.read(chronicConditionRequestProvider)}");
          print("CHRONICAL OTHER  ===== ${ref.read(chronicOtherConditionProvider)}");
          context.push(PagePath.traumaQuestion);
        },
      ),
    );
  }
}
