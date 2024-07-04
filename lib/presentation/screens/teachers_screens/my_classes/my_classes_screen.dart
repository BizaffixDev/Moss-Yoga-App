import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer_teacher.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/my_classes/components/cancelled_teacher.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../data/models/my_classes_teacher_response_model.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_providers/my_classes_teache_provider.dart';
import '../../students_screens/my_classes/components/no_classes_text.dart';
import 'components/completed_teacher.dart';
import 'components/upcoming_teacher.dart';
import 'my_classes_teacher_states.dart';

class MyClassesTeacherScreen extends ConsumerStatefulWidget {
  const MyClassesTeacherScreen({Key? key}) : super(key: key);

  /*int id;
   String date;*/

  @override
  ConsumerState<MyClassesTeacherScreen> createState() =>
      _MyClassesTeacherScreenState();
}

class _MyClassesTeacherScreenState extends ConsumerState<MyClassesTeacherScreen>
    with TickerProviderStateMixin {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  double width = 0.0;
  double height = 0.0;
  late int _startingTabCount;
  final List<Tab> _tabs = <Tab>[];
  late TabController _tabController;
  late TextEditingController _searchController;

  bool isSearchValid = true;
  bool isSearchTapped = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(myClassesTeacherNotifierProvider.notifier)
            .getMyClassesData(
                date: DateFormat('dd MMMM, yyyy').format(DateTime.now()));
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: AppColors.primaryColor, // Set the primary color of the theme
      onPrimary: Colors.white, // Set the text color on the primary color
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select a date',
      // Optional, provide a help text
      cancelText: 'Cancel',
      // Optional, customize the cancel button text
      confirmText: 'OK',
      // Optional, customize the confirm button text
      errorFormatText: 'Invalid date format',
      // Optional, customize the error message for invalid date format
      errorInvalidText: 'Invalid date',
      // Optional, customize the error message for invalid date
      fieldLabelText: 'Date',
      // Optional, customize the label text for the date input field
      fieldHintText: 'Month/Date/Year',
      // Optional, customize the hint text for the date input field
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(colorScheme: colorScheme),
          // Apply the custom color scheme
          child: child!,
        );
      },
    );

    if (picked != null
        //  && picked != selectedDate
        ) {
      setState(() {
        selectedDate = picked;
      });
      String formatedDate = DateFormat('dd MMMM, yyyy').format(picked);
      print("SELECTED FORMATED DATE: $formatedDate");
      await ref
          .read(myClassesTeacherNotifierProvider.notifier)
          .getMyClassesData(date: formatedDate);
    }
  }

  String getMonthName() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM');
    final String monthName = formatter.format(now);
    return monthName;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MyClassesTeacherStates>(myClassesTeacherNotifierProvider,
        (previous, screenState) async {
      if (screenState is MyClassesTeacherSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      } else if (screenState is CancelBookingTeacherSuccessfulState) {
        await ref
            .watch(myClassesTeacherNotifierProvider.notifier)
            .getMyClassesData(
                date: DateFormat('dd MMMM, yyyy').format(DateTime.now()));
        dismissLoading(context);
        setState(() {});
      } else if (screenState is MyClassesTeacherErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          // dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      } else if (screenState is CancelBookingTeacherErrorState) {
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
      } else if (screenState is CancelBookingTeacherLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });
    List<ClassesData> upComingList = ref.watch(upcomingClassesProvider);
    List<ClassesData> cancelledList = ref.watch(cancelledClassesProvider);
    List<ClassesData> completedList = ref.watch(completedClassesProvider);
    print("UPCOMING CLASSESLIST $upComingList");
    final String monthName = getMonthName();
    return Material(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Classes',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.darkSecondaryGray),
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        // iconTheme: const IconThemeData(color: AppColors.greyColor),
      ),
      endDrawer: DrawerTeacher(),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              ///Date Section
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$monthName ${DateTime.now().year}",
                            style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 14.sp),
                          ),
                          Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryColor,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(PagePath.scheduleDate);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Add Schedule",
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.selectedBoxColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///Top Rated Teachers
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: DatePicker(
                      DateTime.now(),
                      height: Platform.isAndroid ? 140.h : 100.h,
                      //100.h for ios,
                      width: Platform.isAndroid ? 46.w : 44.w,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: AppColors.primaryColor.withOpacity(0.7),
                      selectedTextColor: Colors.white,
                      dateTextStyle:
                          manropeHeadingTextStyle.copyWith(fontSize: 16.sp),
                      onDateChange: (DateTime date) async {
                        String formatedDate =
                            DateFormat('dd MMMM, yyyy').format(date);
                        print("SELECTED FORMATED DATE: $formatedDate");
                        await ref
                            .read(myClassesTeacherNotifierProvider.notifier)
                            .getMyClassesData(date: formatedDate);
                      },
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryColor,
                      unselectedLabelColor: const Color(0xFFC4C4BC),
                      labelStyle:  manropeSubTitleTextStyle.copyWith(
                        fontSize: 16.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color:  Colors.black,
                      ),
                      labelPadding: EdgeInsets.symmetric(vertical: 10),
                      tabs: const [
                        // Tab(text: 'Previous Teacher',),
                        Text(
                          'Upcoming',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.neutral53),
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.neutral53),
                        ),
                        Text(
                          'Cancelled',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.neutral53),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height:Platform.isAndroid ?  CommonFunctions.deviceHeight(context) * 0.6:  CommonFunctions.deviceHeight(context) * 0.8,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        //UPCOMING TAB

                        upComingList.isEmpty
                            ? const NoClassesText()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: upComingList.length,
                                itemBuilder: (context, index) {
                                  return UpcomingTeacherWidget(
                                      studentName:
                                          upComingList[index].studentName,
                                      occupation: "Reporter",
                                      day: upComingList[index]
                                          .bookingDay
                                          .substring(0, 3),
                                      date: upComingList[index]
                                          .bookingDate
                                          .substring(0, 2),
                                      time: upComingList[index].startTime,
                                      budget: "\$ ${upComingList[index].price}",
                                      cancelSession: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return SizedBox(
                                              height:
                                                  CommonFunctions.deviceHeight(
                                                          context) *
                                                      0.5,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Image.asset(
                                                        "assets/images/cashback.png"),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Text(
                                                      "Are you sure?",
                                                      style:
                                                          manropeHeadingTextStyle
                                                              .copyWith(
                                                        fontSize: 20.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w),
                                                      child: Text(
                                                        "Cancellations before 2 hours of the class\nare eligible to refund",
                                                        style:
                                                            manropeSubTitleTextStyle
                                                                .copyWith(
                                                          fontSize: 14.sp,
                                                          color: const Color(
                                                              0xFF606060),
                                                          height: 1.2,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w),
                                                      child: Text(
                                                        "We will add your credit in your account\nwithin 48 hours.",
                                                        style:
                                                            manropeSubTitleTextStyle
                                                                .copyWith(
                                                          fontSize: 14.sp,
                                                          color: const Color(
                                                              0xFF606060),
                                                          height: 1.2,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                await ref
                                                                    .read(myClassesTeacherNotifierProvider
                                                                        .notifier)
                                                                    .cancelBooking(
                                                                        bookingCode:
                                                                            upComingList[index]
                                                                                .bookingCode)
                                                                    .whenComplete(
                                                                        () {
                                                                  context.pop();
                                                                });
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .transparent,
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "yes",
                                                                    style: manropeHeadingTextStyle.copyWith(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                context.pop();
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: const Color(
                                                                      0xFFF1F1F1),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "No",
                                                                    style: manropeHeadingTextStyle.copyWith(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      startSession: () {
                                        // '${PagePath.switching}?userType=${user.userType}&userId=${user.userId}&userToken=${user.token}&userEmail=${user.email}&userName=${user.username}');
                                        final studentName =
                                            upComingList[index].studentName;
                                        final chronicConditions =
                                            upComingList[index]
                                                .teacherSpeciality;
                                        final trauma =
                                            upComingList[index].tGender;
                                        final channelName = upComingList[index]
                                            .teacherSchedulingDetailCode;
                                        print(
                                            'channel Name is ${upComingList[index].teacherSchedulingDetailCode}');
                                        context.push(
                                            '${PagePath.lobbyWaitTeacher}?studentName=$studentName&chronicConditions=$chronicConditions&trauma=$trauma&channelName=$channelName');
                                      });
                                },
                              ),

                        //COMPLETED TAB

                        completedList.isEmpty
                            ? const NoClassesText()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: completedList.length,
                                itemBuilder: (context, index) {
                                  return CompletedTeacherWIdget(
                                    studentName:
                                        completedList[index].studentName,
                                    occupation: 'Engineer',
                                    day: completedList[index]
                                        .bookingDay
                                        .substring(0, 3),
                                    date: completedList[index]
                                        .bookingDate
                                        .substring(0, 2),
                                    time: completedList[index].startTime,
                                    budget: "\$ ${completedList[index].price}",
                                    viewSession: () {
                                      ref
                                          .read(studentNameProvider.notifier)
                                          .state = cancelledList[
                                              index]
                                          .studentName;
                                      ref
                                          .read(slotDurationProvider.notifier)
                                          .state = cancelledList[
                                              index]
                                          .slotTime;
                                      ref.read(budgetProvider.notifier).state =
                                          cancelledList[index].price;
                                      ref.read(dateProvider.notifier).state =
                                          cancelledList[index].bookingDate;
                                      ref.read(dayProvider.notifier).state =
                                          cancelledList[index].bookingDay;
                                      ref.read(timeProvider.notifier).state =
                                          cancelledList[index].startTime;

                                      print(
                                          "STUDENT NAME ========  ${ref.read(studentNameProvider.notifier).state} ");
                                      print(
                                          "SLOT  ========  ${ref.read(slotDurationProvider.notifier).state} ");
                                      print(
                                          "DATE ========  ${ref.read(dateProvider.notifier).state} ");
                                      print(
                                          "DAY ========  ${ref.read(dayProvider.notifier).state} ");
                                      print(
                                          "TIME ========  ${ref.read(timeProvider.notifier).state} ");
                                      print(
                                          "BUDGET ========  ${ref.read(budgetProvider.notifier).state} ");
                                      context.push(PagePath.viewDetailsTeacher);
                                    },
                                  );
                                }),

                        //THIRD TAB
                        cancelledList.isEmpty
                            ? const NoClassesText()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: cancelledList.length,
                                itemBuilder: (context, index) {
                                  return CancelledTeacherWIdget(
                                    studentName:
                                        cancelledList[index].studentName,
                                    occupation: 'Engineer',
                                    day: cancelledList[index]
                                        .bookingDay
                                        .substring(0, 3),
                                    date: cancelledList[index]
                                        .bookingDate
                                        .substring(0, 2),
                                    time: cancelledList[index].startTime,
                                    budget: "\$ ${cancelledList[index].price}",
                                    viewSession: () {
                                      ref
                                          .read(studentNameProvider.notifier)
                                          .state = cancelledList[
                                              index]
                                          .studentName;
                                      ref
                                          .read(slotDurationProvider.notifier)
                                          .state = cancelledList[
                                              index]
                                          .slotTime;
                                      ref.read(budgetProvider.notifier).state =
                                          cancelledList[index].price;
                                      ref.read(dateProvider.notifier).state =
                                          cancelledList[index].bookingDate;
                                      ref.read(dayProvider.notifier).state =
                                          cancelledList[index].bookingDay;
                                      ref.read(timeProvider.notifier).state =
                                          cancelledList[index].startTime;

                                      print(
                                          "STUDENT NAME ========  ${ref.read(studentNameProvider.notifier).state} ");
                                      print(
                                          "SLOT  ========  ${ref.read(slotDurationProvider.notifier).state} ");
                                      print(
                                          "DATE ========  ${ref.read(dateProvider.notifier).state} ");
                                      print(
                                          "DAY ========  ${ref.read(dayProvider.notifier).state} ");
                                      print(
                                          "TIME ========  ${ref.read(timeProvider.notifier).state} ");
                                      print(
                                          "BUDGET ========  ${ref.read(budgetProvider.notifier).state} ");
                                      context.push(PagePath.viewDetailsTeacher);
                                    },
                                  );
                                }),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
      // GridView.custom(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2, // Number of columns
      //     mainAxisSpacing: 10, // Spacing between rows
      //     crossAxisSpacing: 10, // Spacing between columns
      //     childAspectRatio: 0.8, // Width to height ratio of each item
      //   ),
      //   childrenDelegate: SliverChildBuilderDelegate(
      //         (BuildContext context, int index) {
      //       return Container(
      //         height: 1000,
      //         color: Colors.blue,
      //         child: Center(
      //           child: Text(
      //             items[index],
      //             style: TextStyle(fontSize: 20.0, color: Colors.white),
      //           ),
      //         ),
      //       );
      //     },
      //     childCount: items.length,
      //   ),
      // ),
    ));
  }
}
