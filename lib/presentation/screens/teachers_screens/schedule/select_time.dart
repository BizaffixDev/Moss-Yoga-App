import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/data/models/duration_session_model.dart';
import 'package:moss_yoga/presentation/providers/home_provider.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/states/home_teacher_states.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_providers/home_teacher_provider.dart';

import 'components/select_text_row.dart';

class ScheduleTimeScreen extends ConsumerStatefulWidget {
  const ScheduleTimeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleTimeScreen> createState() => _ScheduleTimeScreenState();
}

class _ScheduleTimeScreenState extends ConsumerState<ScheduleTimeScreen> {
  var hourStart = 0;
  var hourEnd = 0;
  var minuteStart = 0;
  var minuteEnd = 0;
  var timeFormatStart = "";
  var timeFormatEnd = "";
 // int? durationIndex;
  bool add2ndField = false;
  bool add3rdField = false;
  final TextEditingController budget1Conteroller = TextEditingController(text: "\$");
  final TextEditingController budget2Conteroller = TextEditingController(text: "\$");
  final TextEditingController budget3Conteroller = TextEditingController(text: "\$");

  // String selectedGender = '';
  //String selectedDuration = DurationSessions.first;




  int durationIndex = 0;
  List<String> allDurations2ndField = ["30 min", "60 min", "90 min"];
  String selectedDuration2ndField = "30 min";


  List<String> allDurations3rdField = ["30 min", "60 min", "90 min"];
  String selectedDuration3rdField = "30 min";



  void _onDurationButtonTap(int index) {
    setState(() {
      durationIndex = index;
    });
  }


  List<String> allDurations = ["30 min", "60 min", "90 min"];
  List<String> selectedDurations = [];
  void _onDurationCheckboxChanged(String duration, bool checked) {
    setState(() {
      if (checked) {
        selectedDurations.add(duration);
      } else {
        selectedDurations.remove(duration);
      }

      if (selectedDurations.contains('30 min')) {
        ref.read(scheduleSlotFirstTimeTeacherProvider.notifier).state = '30';
      } else {
        ref.read(scheduleSlotFirstTimeTeacherProvider.notifier).state = '';
      }

      if (selectedDurations.contains('60 min')) {
        ref.read(scheduleSlotSecondTimeTeacherProvider.notifier).state = '60';
      } else {
        ref.read(scheduleSlotSecondTimeTeacherProvider.notifier).state = '';
      }

      if (selectedDurations.contains('90 min')) {
        ref.read(scheduleSlotThirdTimeTeacherProvider.notifier).state = '90';
      } else {
        ref.read(scheduleSlotThirdTimeTeacherProvider.notifier).state = '';
      }
    });
  }


  @override
  void initState() {
    super.initState();




    //selectedDuration = DurationSessions.getAllDurations(durationIndex)[0];
  }





  @override
  Widget build(BuildContext context) {

    ref.listen<TeacherHomeStates>(homeNotifierTeacherProvider, (previous, screenState) async {
      if (screenState is ScheduleDateTimeErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 200);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 200);
          dismissLoading(context);
        } else {
          print("This is the error thats not: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 200);
          dismissLoading(context);
        }
      } else if (screenState is ScheduleDateTimeLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is ScheduleDateTimeSuccessfulState) {
        dismissLoading(context);

        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              // <-- SEE HERE
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 388.h,
                width: 391.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 119.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                      ),
                      child: Container(
                        height: 90.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB5BF8F),
                        ),
                        child: Center(
                          child: SvgPicture.asset(Drawables.tickWhite),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      "Successful",
                      style: manropeHeadingTextStyle,
                    ),
                    Text(
                      "Your schedule has been created",
                      style: manropeSubTitleTextStyle.copyWith(
                        color: const Color(0xFF7F9195),
                        fontSize: 16.sp,
                      ),
                    ),

                    SizedBox(
                      height: 24.h,
                    ),
                    CustomButton(text: "Go Back to My Classes", onTap: (){
                      context.go(PagePath.myClassesTeacher);
                    })
                  ],
                ),
              );
            });
        // setState(() {});
      }
    });


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Add Schedule",
          style: manropeHeadingTextStyle.copyWith(
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SelectTextWIthStepCount(
              title: "Select Time",
              step: "2",
            ),

            SizedBox(
              height: 26.h,
            ),

            //START TEXT
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "Start",
                style: manropeSubTitleTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),

            SizedBox(
              height: 17.h,
            ),

            //START TIME PICKER
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  height: 60.h,
                  width: 125.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NumberPicker(
                        itemCount: 1,
                        minValue: 0,
                        maxValue: 12,
                        value: hourStart,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: 40.w,
                        itemHeight: 40.h,
                        onChanged: (value) {
                          setState(() {
                            hourStart = value;
                          });
                          print("HOUR START == $hourStart");
                        },
                        textStyle:
                            manropeSubTitleTextStyle.copyWith(fontSize: 18.sp),
                        selectedTextStyle:
                            manropeHeadingTextStyle.copyWith(fontSize: 21.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.h),
                        child: Text(
                          ":",
                          style:
                              manropeHeadingTextStyle.copyWith(fontSize: 18.sp),
                        ),
                      ),
                      NumberPicker(
                        itemCount: 1,
                        minValue: 0,
                        maxValue: 59,
                        value: minuteStart,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: 40.w,
                        itemHeight: 40.h,
                        onChanged: (value) {
                          setState(() {
                            minuteStart = value;
                          });
                          print("MINUTE START == $minuteStart");
                        },
                        textStyle:
                            manropeSubTitleTextStyle.copyWith(fontSize: 18.sp),
                        selectedTextStyle:
                            manropeHeadingTextStyle.copyWith(fontSize: 21.sp),
                      ),
                    ],
                  ),
                ),

                //AM
                GestureDetector(
                  onTap: () {
                    setState(() {
                      timeFormatStart = "AM";
                    });

                    print("FORMAT START $timeFormatStart");
                  },
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: timeFormatStart == "AM"
                          ? AppColors.primaryColor.withOpacity(0.8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        "am",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: timeFormatStart == "AM"
                              ? AppColors.white
                              : Colors.black,
                            height: 1.2
                        ),
                      ),
                    ),
                  ),
                ),

                //PM
                GestureDetector(
                  onTap: () {
                    setState(() {
                      timeFormatStart = "PM";
                    });
                    print("FORMAT START $timeFormatStart");
                  },
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: timeFormatStart == "PM"
                          ? AppColors.primaryColor.withOpacity(0.8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        "pm",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: timeFormatStart == "PM"
                              ? AppColors.white
                              : Colors.black,
                          height: 1.2
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 24.h,
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "End",
                style: manropeSubTitleTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),

            SizedBox(
              height: 17.h,
            ),

            //END TIME PICKER
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  height: 60.h,
                  width: 125.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NumberPicker(
                        itemCount: 1,
                        minValue: 0,
                        maxValue: 12,
                        value: hourEnd,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: 40.w,
                        itemHeight: 40.h,
                        onChanged: (value) {
                          setState(() {
                            hourEnd = value;
                          });
                          print("HOUR == $hourEnd");
                        },
                        textStyle:
                            manropeSubTitleTextStyle.copyWith(fontSize: 18.sp),
                        selectedTextStyle:
                            manropeHeadingTextStyle.copyWith(fontSize: 21.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.h),
                        child: Text(
                          ":",
                          style:
                              manropeHeadingTextStyle.copyWith(fontSize: 18.sp),
                        ),
                      ),
                      NumberPicker(
                        itemCount: 1,
                        minValue: 0,
                        maxValue: 59,
                        value: minuteEnd,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: 40.w,
                        itemHeight: 40.h,
                        onChanged: (value) {
                          setState(() {
                            minuteEnd = value;
                          });
                          print("MINUTE END == $minuteEnd");
                        },
                        textStyle:
                            manropeSubTitleTextStyle.copyWith(fontSize: 18.sp),
                        selectedTextStyle:
                            manropeHeadingTextStyle.copyWith(fontSize: 21.sp),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      timeFormatEnd = "AM";
                    });
                    print("TIME FORMAT END == $timeFormatEnd");
                  },
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: timeFormatEnd == "AM"
                          ? AppColors.primaryColor.withOpacity(0.8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        "am",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: timeFormatEnd == "AM"
                              ? AppColors.white
                              : Colors.black,
                            height: 1.2
                        ),
                      ),
                    ),
                  ),
                ),

                //PM
                GestureDetector(
                  onTap: () {
                    setState(() {
                      timeFormatEnd = "PM";
                    });
                    print("TIME FORMAT END == $timeFormatEnd");
                  },
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: timeFormatEnd == "PM"
                          ? AppColors.primaryColor.withOpacity(0.8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        "pm",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: timeFormatEnd == "PM"
                              ? AppColors.white
                              : Colors.black,
                            height: 1.2
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 32.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Duration of session",
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),

            SizedBox(
              height: 24.h,
            ),

            /*
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _onDurationButtonTap(0);

                      String slotTime = "${DurationSessions.first}";
                      // String pricing = "${durationList[0].budget}";

                      ref
                          .read(scheduleSlotFirstTimeTeacherProvider.notifier)
                          .state = slotTime;
                      //ref.read(scheduleBudgetTeacherProvider.notifier).state = pricing;

                      print(
                          "SLOT TIME === ${ref.read(scheduleSlotFirstTimeTeacherProvider.notifier).state}");
                      //print("PRICING === ${ ref.read(scheduleBudgetTeacherProvider.notifier).state}");

                      print(durationIndex.toString());
                    },
                    child: Container(
                      height: 48.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: durationIndex == 0
                              ? AppColors.primaryColor.withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          )),
                      child: Center(
                        child: Text(
                          "${DurationSessions.first}",
                          style: manropeHeadingTextStyle.copyWith(
                            color: durationIndex == 0
                                ? AppColors.white
                                : Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _onDurationButtonTap(1);


                      String slotTime = "${DurationSessions.second}";
                      //String pricing = "${durationList[1].budget}";

                      ref
                          .read(scheduleSlotFirstTimeTeacherProvider.notifier)
                          .state = slotTime;
                      // ref.read(scheduleBudgetTeacherProvider.notifier).state = pricing;

                      print(
                          "SLOT TIME === ${ref.read(scheduleSlotFirstTimeTeacherProvider.notifier).state}");
                      //print("PRICING === ${ ref.read(scheduleBudgetTeacherProvider.notifier).state}");


                      print(durationIndex.toString());
                    },
                    child: Container(
                      height: 48.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: durationIndex == 1
                              ? AppColors.primaryColor.withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          )),
                      child: Center(
                        child: Text(
                          "${DurationSessions.second}",
                          style: manropeHeadingTextStyle.copyWith(
                            color: durationIndex == 1
                                ? AppColors.white
                                : Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  GestureDetector(
                    onTap: () {

                      _onDurationButtonTap(2);
                      String slotTime = "${DurationSessions.third}";
                      //String pricing = "${durationList[2].budget}";

                      ref
                          .read(scheduleSlotFirstTimeTeacherProvider.notifier)
                          .state = slotTime;
                      //ref.read(scheduleBudgetTeacherProvider.notifier).state = pricing;

                      print(
                          "SLOT TIME PROVIDER VALUE === ${ref.read(scheduleSlotFirstTimeTeacherProvider.notifier).state}");

                      print(
                          "SLOT TIME === $slotTime");


                      //print(durationIndex.toString());
                    },
                    child: Container(
                      height: 48.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: durationIndex == 2
                              ? AppColors.primaryColor.withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          )),
                      child: Center(
                        child: Text(
                          "${DurationSessions.third}",
                          style: manropeHeadingTextStyle.copyWith(
                            color: durationIndex == 2
                                ? AppColors.white
                                : Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            */

            // Duration Selection Checkboxes
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(

                children: allDurations.map((duration) {
                  bool isChecked = selectedDurations.contains(duration);
                  return GestureDetector(
                    onTap: () => _onDurationCheckboxChanged(duration, !isChecked),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      // Customize the checkbox for each duration option
                      height: 48,
                      width: 80,
                      decoration: BoxDecoration(
                        color: isChecked ? AppColors.primaryColor.withOpacity(0.8) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          duration,
                          style: manropeHeadingTextStyle.copyWith(
                            color: isChecked ? AppColors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),



            SizedBox(
              height: 32.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Budget",
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),


            SizedBox(height: 10.h,),


            Column(
              children: selectedDurations.map((duration) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  margin: EdgeInsets.symmetric(horizontal: 24.w,vertical: 10.h),
                  height: 48.h,
                  width: 313.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFAFAD98),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: duration == '30 min' ? budget1Conteroller
                                : duration == '60 min' ? budget2Conteroller
                                : duration == '90 min' ? budget3Conteroller
                                : null,
                            style: manropeHeadingTextStyle.copyWith(fontSize: 20.sp),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            onChanged: (String? value) {
                              setState(() {

                                if (duration == '30 min') {
                                  ref.read(scheduleBudgetFirstTeacherProvider.notifier).state = value!.substring(1);
                                } else if (duration == '60 min') {
                                  ref.read(scheduleBudgetSecondTeacherProvider.notifier).state = value!.substring(1);
                                } else if (duration == '90 min') {
                                  ref.read(scheduleBudgetThirdTeacherProvider.notifier).state = value!.substring(1);
                                }

                               /* if (duration == '30 min') {
                                  budget1Conteroller.text = value!;
                                  ref.read(scheduleBudgetFirstTeacherProvider.notifier).state = budget1Conteroller.text.substring(1,);
                                } else if (duration == '60 min') {
                                  budget2Conteroller.text = value!;
                                  ref.read(scheduleBudgetSecondTeacherProvider.notifier).state =  budget2Conteroller.text.substring(1,);
                                } else if (duration == '90 min') {
                                  budget3Conteroller.text = value!;
                                  ref.read(scheduleBudgetSecondTeacherProvider.notifier).state = budget3Conteroller.text.substring(1,);
                                }*/
                              });
                              // ...
                            },
                          ),
                        ),

                        // Show selected duration text
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 34.h,
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: AppColors.greyTextColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            duration,
                            style: manropeSubTitleTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),






          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        width: 390.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Save Schedule",
              onTap: () async {
                var timestartRef = ref
                    .read(scheduleTimeStartTeacherListProvider.notifier)
                    .state;
                var timeEndRef =
                    ref.read(scheduleTimeEndTeacherListProvider.notifier).state;

                String timestart = "0$hourStart:0$minuteStart $timeFormatStart";
                String timeEnd = "0$hourEnd:0$minuteEnd $timeFormatEnd";


                String firstSLot = ref.read(scheduleSlotFirstTimeTeacherProvider);
                String secondSLot = ref.read(scheduleSlotSecondTimeTeacherProvider);
                String thirdSLot = ref.read(scheduleSlotThirdTimeTeacherProvider);



                ref.read(scheduleTimeStartTeacherListProvider.notifier).state =
                    //timestart;
                CommonFunctions.convertTimeTo24HourFormat(timestart);
                ref.read(scheduleTimeEndTeacherListProvider.notifier).state =
                    //timeEnd;
                CommonFunctions.convertTimeTo24HourFormat(timeEnd);

                print(
                    "START: ${ref.read(scheduleTimeStartTeacherListProvider.notifier).state}");
                print(
                    "END: ${ref.read(scheduleTimeEndTeacherListProvider.notifier).state}");
                print("TIME SLOT 30: ${ref.read(scheduleSlotFirstTimeTeacherProvider.notifier).state}");
                print("TIME SLOT 60: ${ref.read(scheduleSlotSecondTimeTeacherProvider.notifier).state}");
                print("TIME SLOT 90: ${ref.read(scheduleSlotThirdTimeTeacherProvider.notifier).state}");
                print(
                    "BUDGET 1 : ${ref.read(scheduleBudgetFirstTeacherProvider.notifier).state}");
                print(
                    "BUDGET 2 : ${ref.read(scheduleBudgetSecondTeacherProvider.notifier).state}");
                print(
                    "BUDGET 3 : ${ref.read(scheduleBudgetThirdTeacherProvider.notifier).state}");

                print(
                    "24 HR FORMAT START: ${ref.read(scheduleTimeStartTeacherListProvider.notifier).state}");

                print(
                    "24 HR FORMAT END: ${ref.read(scheduleTimeEndTeacherListProvider.notifier).state}");

                if (hourStart == 0 && minuteStart == 0) {
                  UIFeedback.showSnackBar(
                      context, "Please select correct start time",
                      height: 200);
                } else if (hourEnd == 0 && minuteEnd == 0) {
                  UIFeedback.showSnackBar(
                      context, "Please select correct end time",
                      height: 200);
                } else if (hourStart == 0) {
                  UIFeedback.showSnackBar(
                      context, "Please select correct start time",
                      height: 200);
                } else if (hourEnd == 0) {
                  UIFeedback.showSnackBar(
                      context, "Please select correct end time",
                      height: 200);
                } else if (timeFormatStart == "") {
                  UIFeedback.showSnackBar(context, "Please select time format",
                      height: 200);
                } else if (timeFormatEnd == "") {
                  UIFeedback.showSnackBar(context, "Please select time format",
                      height: 200);
                } else if (durationIndex != 0 &&
                    durationIndex != 1 &&
                    durationIndex != 2) {
                  UIFeedback.showSnackBar(context, "Please select time slot",
                      height: 200);
                }
                // else if(firstSLot == secondSLot || firstSLot == thirdSLot || secondSLot == thirdSLot){
                //   UIFeedback.showSnackBar(context, "Duration Slots must be different.",
                //       height: 200);
                // }
                else {
                  print("success");
                  await ref.read(homeNotifierTeacherProvider.notifier).addScheduleByTeacher();
                }
              },
              btnColor: AppColors.primaryColor,
              textColor: Colors.white,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
