import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/data/models/teacher_detail_schedule_response.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/components/top_detail_section_reschedule.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/my_classes_states.dart';

import '../../../../../app/utils/common_functions.dart';
import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../../common/app_specific_widgets/loader.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';
import '../../../../providers/my_classes_student_provider.dart';
import '../../../../providers/screen_state.dart';
import '../../teacherDetail/components/section_heading.dart';
import '../../teacherDetail/components/top_detail_section.dart';

class RescheduleClassDetailScreen extends ConsumerStatefulWidget {
  const RescheduleClassDetailScreen({required this.bookingId, Key? key})
      : super(key: key);

  final String bookingId;

  @override
  ConsumerState<RescheduleClassDetailScreen> createState() =>
      _TeacherDetailScreenState();
}

class _TeacherDetailScreenState
    extends ConsumerState<RescheduleClassDetailScreen> {
  int? _morningValue = -1;
  int? _selectedIndex;

  int? _afterNoonValue = -1;

  int? _eveningValue = -1;

  int? _nightValue = -1;

  int? _durationValue = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(myClassesStudentNotifierProvider.notifier)
          .getRescheduleTeacherDetails(bookingId: widget.bookingId);
    });
  }

  int _getMonthNumber(String monthName) {
    switch (monthName.toLowerCase()) {
      case 'january':
        return 1;
      case 'february':
        return 2;
      case 'march':
        return 3;
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'june':
        return 6;
      case 'july':
        return 7;
      case 'august':
        return 8;
      case 'september':
        return 9;
      case 'october':
        return 10;
      case 'november':
        return 11;
      case 'december':
        return 12;
      default:
        return -1; // Invalid month name
    }
  }

  @override
  Widget build(BuildContext context) {


    ref.listen<MyClassesStudentStates>(myClassesStudentNotifierProvider,
        (previous, screenState) async {
      if (screenState is RescheduleTeacherDetailsErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      }


      else if (screenState is RescheduleBookingStudentErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          // dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      }

     /* else if (screenState is RescheduleBookingStudentLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      }*/

      else if (screenState is RescheduleTeacherDetailsLoadingState) {
        debugPrint('Loading RESCHDULE');
        print("inside reschedule detail loading screen");
        showLoading(context);
        // setState(() {});
      }

      else if (screenState is RescheduleTeacherDetailsSuccessfulState) {
        setState(() {});
        print("inside reschedule detail success screen");
        dismissLoading(context);

      }

      else if (screenState is RescheduleBookingStudentSuccessfulState) {


        setState(() {});
        dismissLoading(context);
        showModalBottomSheet<void>(
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset("assets/images/success.png"),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Your session has been successful Rescheduled",
                      style: kHintTextStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    CustomButton(
                      text: "Okay, Go To My Classes",
                      onTap: () {
                        context.go(PagePath.myTeachers);
                      },
                      btnColor: AppColors.primaryColor,
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    });


    ref.read(bookingCodeProvider);
    ref.read(bookingDateProvider);
    ref.read(teacherSchedulingDetailCodeProvider);

    var slotPrice = ref.read(selectedDurationPriceProvider);
    List<dynamic> morningList = ref.watch(morningSlots);
    List<dynamic> afternoonList = ref.watch(afternoonSlots);
    List<dynamic> eveningList = ref.watch(eveningSlots);
    List<dynamic> nightList = ref.watch(nightSlots);
    List<String> availableDates = ref.watch(availableDatesProvider);
    List<Slot> durationSLotList = ref.watch(durationSlotsProivider);

    String name = ref.read(teacherNameMyClassProvider);

    String occupation = ref.read(teacherOccupationMyClassProvider);
    //double parsedValue = double.parse(rating);
    //String formatRating = parsedValue.toStringAsFixed(1);
    List<String> specialities =
        ref.read(teacherSpecialityListRescheduleProvider);
    //String about = ref.read(teacherAboutProvider);

    List<DateTime> parsedDates = availableDates.map((dateString) {
      // Remove square brackets and split by comma and space
      List<String> dateParts =
          dateString.replaceAll('[', '').replaceAll(']', '').split(', ');
      if (dateParts.length == 2) {
        String dayMonth = dateParts[0];
        String year = dateParts[1];

        // Split dayMonth into day and month
        List<String> dayMonthParts = dayMonth.split(' ');
        if (dayMonthParts.length == 2) {
          String day = dayMonthParts[0];
          String month = dayMonthParts[1];

          // Convert month name to month number
          int monthNumber = _getMonthNumber(month);

          if (monthNumber != -1) {
            return DateTime(int.parse(year), monthNumber, int.parse(day));
          }
        }
      }

      // Return a default date for invalid date format
      return DateTime(2000, 1, 1); // You can adjust this default date
    }).toList();

    parsedDates.removeWhere((date) => date == DateTime(2000, 1, 1));

    return Scaffold(
        backgroundColor: AppColors.white,
        endDrawer: const Drawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: Text(
            "Reschedule Session",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: AppColors.black),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const TopDetailSectionReschedule(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      const SectionHeading(
                        title: 'SPECIALITIES',
                      ),

                      /* GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: teacherSpecialtyList.length,

                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,

                            childAspectRatio: 3),
                        itemBuilder: (context, index) {
                          return SpecialityChip(
                              title: teacherSpecialtyList[index].specialty);
                        },
                      ),*/

                      Wrap(
                        spacing: 5.0,
                        children: List<Widget>.generate(
                          specialities.length,
                          (int index) {
                            return SpecialityChip(title: specialities[index]);
                          },
                        ).toList(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const SectionHeading(
                                  title: 'BOOK SESSION',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                //TODO:DATE PICKER TIMELINE
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: availableDates.isEmpty
                                      ? Container()
                                      : DatePicker(
                                    parsedDates[0],
                                    //availableDates[0],
                                    //DateTime.now(),
                                    height: Platform.isAndroid ? 110.h : 100.h,
                                    //100.h for ios,
                                    width: Platform.isAndroid ? 46.w : 44.w,
                                    //44.w for ios,
                                    initialSelectedDate: parsedDates[0],
                                    selectionColor:
                                    AppColors.primaryColor.withOpacity(0.7),
                                    selectedTextColor: Colors.white,
                                    activeDates: parsedDates,
                                    //availableDates.map((dateString) => DateTime.parse(dateString)).toList(),
                                    //availableDates,
                                    dateTextStyle: manropeHeadingTextStyle.copyWith(
                                        fontSize: 16.sp),
                                    onDateChange: (DateTime date) {
                                      ref
                                          .read(selectedDateProvider.notifier)
                                          .state = date;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                //TODO:MORNING SLOTS
                                Text(
                                  "Morning",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    morningList.length,
                                        (int index) {
                                      return ChoiceChip(
                                        backgroundColor: Colors.white,
                                        selectedColor:
                                        AppColors.primaryColor.withOpacity(0.7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: AppColors.primaryColor)),
                                        label: Text(
                                          // "${morningList[index]} AM",
                                          CommonFunctions.convertTo12HourFormat(
                                              morningList[index]),
                                          style: manropeHeadingTextStyle.copyWith(
                                            color: _morningValue == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        selected: _morningValue == index,
                                        onSelected: (bool selected) {
                                          if (selected) {
                                            // User selected a morning slot, so deselect any selected afternoon slot
                                            setState(() {
                                              _afterNoonValue= null;
                                              _eveningValue = null;
                                              _nightValue = null;
                                            });

                                          }
                                          setState(() {
                                            _morningValue = selected ? index : null;
                                            ref
                                                .read(selectedMorningProvider.notifier)
                                                .state = "${morningList[index]} AM";
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                //TODO:AFTERNOON SLOTS
                                Text(
                                  "Afternoon",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),

                                afternoonList.isNotEmpty
                                    ? Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    afternoonList.length,
                                        (int index) {
                                      return ChoiceChip(
                                        backgroundColor: Colors.white,
                                        selectedColor:
                                        AppColors.primaryColor.withOpacity(0.7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: AppColors.primaryColor)),
                                        label: Text(
                                          CommonFunctions.convertTo12HourFormat(
                                              afternoonList[index]),
                                          style: manropeHeadingTextStyle.copyWith(
                                            color: _afterNoonValue == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        selected: _afterNoonValue == index,
                                        onSelected: (bool selected) {
                                          if (selected) {
                                            // User selected a morning slot, so deselect any selected afternoon slot
                                            setState(() {
                                              _morningValue= null;
                                              _eveningValue = null;
                                              _nightValue = null;
                                            });

                                          }
                                          setState(() {
                                            _afterNoonValue =
                                            selected ? index : null;
                                            ref
                                                .read(selectedAfterNoonProvider
                                                .notifier)
                                                .state =
                                            "${afternoonList[index]} PM";
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                )
                                    : const Text("No time slots available"),
                                const SizedBox(
                                  height: 20,
                                ),

                                //TODO:EVENING SLOTS
                                Text(
                                  "Evening",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                eveningList.isNotEmpty
                                    ? Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    eveningList.length,
                                        (int index) {
                                      return ChoiceChip(
                                        backgroundColor: Colors.white,
                                        selectedColor:
                                        AppColors.primaryColor.withOpacity(0.7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: AppColors.primaryColor)),
                                        label: Text(
                                          CommonFunctions.convertTo12HourFormat(
                                              eveningList[index]),
                                          style: manropeHeadingTextStyle.copyWith(
                                            color: _eveningValue == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        selected: _eveningValue == index,
                                        onSelected: (bool selected) {
                                          if (selected) {
                                            // User selected a morning slot, so deselect any selected afternoon slot
                                            setState(() {
                                              _morningValue= null;
                                              _afterNoonValue = null;
                                              _nightValue = null;
                                            });

                                          }
                                          setState(() {
                                            _eveningValue = selected ? index : null;
                                            ref
                                                .read(selectedEveningProvider
                                                .notifier)
                                                .state = "${eveningList[index]} PM";
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                )
                                    : const Text("No time slots available"),
                                const SizedBox(
                                  height: 20,
                                ),

                                Text(
                                  "Night",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                nightList.isNotEmpty
                                    ? Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    nightList.length,
                                        (int index) {
                                      return ChoiceChip(
                                        backgroundColor: Colors.white,
                                        selectedColor:
                                        AppColors.primaryColor.withOpacity(0.7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: AppColors.primaryColor)),
                                        label: Text(
                                          CommonFunctions.convertTo12HourFormat(
                                              nightList[index]),
                                          style: manropeHeadingTextStyle.copyWith(
                                            color: _nightValue == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        selected: _nightValue == index,
                                        onSelected: (bool selected) {
                                          if (selected) {
                                            // User selected a morning slot, so deselect any selected afternoon slot
                                            setState(() {
                                              _morningValue= null;
                                              _afterNoonValue = null;
                                              _eveningValue = null;
                                            });

                                          }
                                          setState(() {
                                            _nightValue = selected ? index : null;
                                            ref
                                                .read(
                                                selectedNightProvider.notifier)
                                                .state = "${nightList[index]} PM";
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                )
                                    : const Text("No time slots available"),

                                const SizedBox(
                                  height: 20,
                                ),

                                Text(
                                  "Duration of session",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),

                                Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    durationSLotList.length,
                                        (int index) {
                                      return ChoiceChip(
                                        backgroundColor: Colors.white,
                                        selectedColor:
                                        AppColors.primaryColor.withOpacity(0.7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(
                                                color: AppColors.primaryColor)),
                                        label: Text(
                                          "${durationSLotList[index].slotTime} min",
                                          style: manropeHeadingTextStyle.copyWith(
                                            color: _durationValue == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        selected: _durationValue == index,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _durationValue = selected ? index : -1;
                                            ref
                                                .read(selectedDurationProvider.notifier)
                                                .state =
                                            "${durationSLotList[index].slotTime} min";
                                            ref
                                                .read(selectedDurationPriceProvider
                                                .notifier)
                                                .state = durationSLotList[index].price;
                                            ref
                                                .read(selectedDurationTeacherCodeProvider
                                                .notifier)
                                                .state = durationSLotList[
                                            index]
                                                .teacherSchedulingDetailCode;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                GestureDetector(
                                  onTap: () async {
                                    print(
                                        "MORNING TIME ========    ${ref.read(selectedMorningProvider)}");
                                    print(
                                        "AFTERNOON TIME ========    ${ref.read(selectedAfterNoonProvider)}");
                                    print(
                                        "EVENING TIME ========    ${ref.read(selectedEveningProvider)}");
                                    print(
                                        "NIGHT TIME ========    ${ref.read(selectedAfterNoonProvider)}");
                                    print(
                                        "DURATION ========    ${ref.read(selectedDurationProvider)}");
                                    print(
                                        "DURATION PRICE ========    ${ref.read(selectedDurationPriceProvider)}");
                                    print(
                                        "DURATION CODE ========    ${ref.read(selectedDurationTeacherCodeProvider)}");
                                    print(
                                        "DATE ========    ${ref.read(selectedDateProvider)}");

                                    if (_morningValue == -1 &&
                                        _afterNoonValue == -1 &&
                                        _eveningValue == -1 &&
                                        _nightValue == -1) {
                                      UIFeedback.showSnackBar(
                                          context, "Please select any time slot");
                                    } else if (_durationValue == -1) {
                                      UIFeedback.showSnackBar(
                                          context, "Please select duration of session");
                                    } else {
                                      // context.push(PagePath.PayemntMethod);

                                      /*await ref
                                .read(homeNotifierProvider.notifier)
                                .preBookSessionRequest(context);*/
                                      print(
                                          "MORNING TIME ========    ${ref.read(selectedMorningProvider)}");
                                      print(
                                          "AFTERNOON TIME ========    ${ref.read(selectedAfterNoonProvider)}");
                                      print(
                                          "EVENING TIME ========    ${ref.read(selectedEveningProvider)}");
                                      print(
                                          "NIGHT TIME ========    ${ref.read(selectedAfterNoonProvider)}");
                                      print(
                                          "DURATION ========    ${ref.read(selectedDurationProvider)}");
                                      print(
                                          "DURATION PRICE ========    ${ref.read(selectedDurationPriceProvider)}");
                                      print(
                                          "DURATION CODE ========    ${ref.read(selectedDurationTeacherCodeProvider)}");
                                      print(
                                          "DATE ========    ${ref.read(selectedDateProvider)}");

                                      if (_morningValue == -1 &&
                                          _afterNoonValue == -1 &&
                                          _eveningValue == -1 &&
                                          _nightValue == -1) {
                                        UIFeedback.showSnackBar(
                                            context, "Please select any time slot");
                                      } else if (_durationValue == -1) {
                                        UIFeedback.showSnackBar(
                                            context, "Please select duration of session");
                                      } else {
                                        ref
                                            .read(
                                            myClassesStudentNotifierProvider.notifier)
                                            .rescheduleBooking(
                                          bookingDate: ref.read(bookingDateProvider),
                                          bookingCode: ref.read(bookingCodeProvider),
                                          teacherSchedulingDetailCode: ref.read(
                                              teacherSchedulingDetailCodeProvider),
                                          paymentId: 0,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: CommonFunctions.deviceHeight(context) * 0.07,
                                    width: CommonFunctions.deviceWidth(context) * 0.8,
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.primaryColor,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: _durationValue
                                             == -1
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Reschedule Now",
                                            style: manropeHeadingTextStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          _durationValue == -1
                                              ? Container()
                                              : Text(
                                            // "${ref.read(selectedDurationPriceProvider)}",
                                            "\$" + slotPrice,
                                            style: manropeHeadingTextStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                              ]),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class AboutMe extends StatelessWidget {
  String text;

  AboutMe({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          kHintTextStyle.copyWith(fontSize: 14, color: AppColors.greyTextColor),
    );
  }
}

class SpecialityChip extends StatelessWidget {
  final String title;

  const SpecialityChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Colors.black12)),
      backgroundColor: Colors.white,
      label: Text(
        title,
        style: manropeHeadingTextStyle.copyWith(
          color: const Color(0XFF5B5B5B),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class BottomRowContainers extends StatelessWidget {
  const BottomRowContainers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kAppBarColor)),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 49,
            decoration: const BoxDecoration(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Image.asset("assets/images/watch.png"),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                "246",
                style: kHeading3TextStyle,
              )),
          Container(
            padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
            child: Text(
              "Hours",
              style: kHeading3TextStyle.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
