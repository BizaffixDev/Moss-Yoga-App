import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/data/models/physical_response_model.dart';

import '../../../../../app/utils/common_functions.dart';
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



class PhysicalListStep extends ConsumerStatefulWidget {
  const PhysicalListStep({Key? key}) : super(key: key);

  @override
  ConsumerState<PhysicalListStep> createState() => _ChronicListStepState();
}

class _ChronicListStepState extends ConsumerState<PhysicalListStep> {
  bool value = false;
  bool otherSelect = false;
  final otherController = TextEditingController();

/*
  final conditions = [
    StudentConditions(title: "Hips"),
    StudentConditions(title: "Shoulder"),
    StudentConditions(title: "Ankle"),
    StudentConditions(title: "Others"),
  ];
*/

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authNotifyProvider.notifier).getPhysicalList(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    final injuries = ref.watch(physicalConditionProvider);
    List<PhysicalResponseModel> phylist = ref.watch(physicalConditionResponseListProvider);

    ref.listen(authNotifyProvider, (previous, screenState) {
      if (screenState is AuthErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is PhysicaLoadingState) {
        debugPrint('Loading');
        showLoading(context);

        // setState(() {});
      } else if (screenState is PhysicalSuccessfulState) {
        // chrlist =  screenState.chronicResponseList;
        //print("chrListt ${chrlist[0].chronicConditionName}");
        dismissLoading(context);
        setState(() {

        });
        // GoRouter.of(context).go(PagePath.homeScreen);

      }
    });


    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:  Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            height: CommonFunctions.deviceHeight(context) * 0.32,
            width: CommonFunctions.deviceWidth(context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Drawables.stepperTopBg,
                  ),
                  fit: BoxFit.cover,
                  scale: 50),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: ProgressBarWidget(
                    step: 4,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    Drawables.appLogo,
                    height: 100,
                    width: 100,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: CommonFunctions.deviceHeight(context) * 0.04,
                  ),


                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                    child: const QuestionText(
                        text: "Select your Physical Injuries?"),
                  ),


                  phylist.isEmpty ? Container() : ListView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: phylist.length,
                    itemBuilder: (context, index) {
                      //final condition = conditions[index];
                      return Container(
                        height: 45,
                        width: 313,
                        margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.greyColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: CheckboxListTile(
                            activeColor: AppColors.primaryColor,
                            value: phylist[index].isActive,
                            title: Row(
                              children: [
                                Image.asset(
                                  phylist[index].physicalInjuryId == 1 ? Drawables.hips
                                      : phylist[index].physicalInjuryId == 2 ?  Drawables.shoulder
                                      :phylist[index].physicalInjuryId == 3 ?  Drawables.ankle
                                      : Drawables.bloodPressure ,
                                  height: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  phylist[index].injuryName,
                                ),
                              ],
                            ),
                            onChanged: (value) {
                              setState(() {
                                phylist[index].isActive = value!;
                                ref.read(physicalConditionRequestProvider).add(
                                    PhysicalResponseModel(
                                        physicalInjuryId:
                                        phylist[index].physicalInjuryId,
                                        injuryName:
                                        phylist[index].injuryName,
                                        injuryDescription: phylist[index].injuryDescription,
                                        isActive: phylist[index].isActive));
                              });
                              print("VALUE =======  $value");
                            }),
                      );
                    },
                  ),


                  phylist.isEmpty ? Container():
                  Container(
                    height: 50,
                    width: 313,
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                              height: 25,
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
                            otherController.text = ref.read(physcialOtherConditionProvider);
                          });
                        }
                    ),
                  ),

                  otherSelect ?
                  CustomTextField(
                    controller: otherController,
                    labelText: "Othe Physical Injuries",
                    hintText: "Enter your physcial injuries",

                  ) : Container(),



                ],
              ),
            ),
          )
        ],
      ),








      bottomNavigationBar: BottomContinueButton(
        continueTap: (){
          if(phylist[0].isActive == false &&
              phylist[1].isActive == false &&
              phylist[2].isActive == false &&
              otherSelect == false
          ){
            UIFeedback.showSnackBar(context, "Please select any injury");
          }else if(  otherSelect == true && otherController.text.isEmpty){
            UIFeedback.showSnackBar(context, "Please mention any other physical injury");
          }

          else{
            setState(() {
              otherController.text = ref.read(physcialOtherConditionProvider);
            });
            context.push(PagePath.homeScreen);
          }

        },
        notNowTap: (){
          context.push(PagePath.homeScreen);
        },
      ),
    );






    /*  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),

            const ProgressBarWidget(
              step: 3,
            ),


            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
              child: const QuestionText(
                  text: "Select Your physical injuries?"),
            ),


            SizedBox(
              height: size.height * 0.03,
            ),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: phylist.length,
              itemBuilder: (context, index) {
                final injury = injuries[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      value: phylist[index].isActive,
                      title: Row(
                        children: [
                          Image.asset("assets/images/user.png", height: 25,),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(phylist[index].injuryName,),
                        ],
                      ),

                      onChanged: (value) {
                        setState(() {
                          phylist[index].isActive = value!;
                          ref.read(physicalConditionRequestProvider).add(
                              PhysicalResponseModel(
                                  physicalInjuryId:
                                  phylist[index].physicalInjuryId,
                                  injuryName:
                                  phylist[index].injuryName,
                                  injuryDescription: phylist[index].injuryDescription,
                                  isActive: phylist[index].isActive));
                        });
                        print("VALUE =======  $value");
                      }),
                );
              },
            ),

            phylist.length < 1 ? Container():
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(8)),
              child: CheckboxListTile(
                  activeColor: AppColors.primaryColor,
                  value: otherSelect,
                  title: Row(
                    children: [
                      Image.asset(
                        "assets/images/user.png",
                        height: 25,
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
                      otherController.text = ref.read(physcialOtherConditionProvider);
                    });
                  }
              ),
            ),


          otherSelect  ?
             CustomTextField(
               controller: otherController,
              labelText: "Othet Physical Injury",
              hintText: "Enter your other physical injury",


            ) : Container(),


            SizedBox(
              height: size.height * 0.05,
            ),

            CustomButton(
              text: "Continue",
              onTap: (){
                if(phylist[0].isActive == false &&
                    phylist[1].isActive == false &&
                    phylist[2].isActive == false &&
                    otherSelect == false
                ){
                  UIFeedback.showSnackBar(context, "Please select any physical injury");
                }else if(   otherSelect == true && otherController.text.isEmpty){
                  UIFeedback.showSnackBar(context, "Please mention any other physical injury");
                }

                else{
                  setState(() {
                    otherController.text = ref.read(physcialOtherConditionProvider);
                  });
                  context.go(PagePath.homeScreen);
                }
              },
            ),

             NotNowText(
               onTap: ()=>context.go(PagePath.homeScreen),
             ),





          ],
        ),
      ),
    );*/
  }



}




