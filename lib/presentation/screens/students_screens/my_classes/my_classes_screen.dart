import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/cancel_reasons_model.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/components/upcoming.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../data/models/my_classes_student_response_model.dart';
import '../../../providers/my_classes_student_provider.dart';
import '../../../providers/screen_state.dart';
import 'components/cancelled.dart';
import 'components/completed.dart';
import 'components/no_classes_text.dart';
import 'my_classes_states.dart';

class MyClassesStudentScreen extends ConsumerStatefulWidget {
  const MyClassesStudentScreen({
    Key? key,
    // required this.id,
    //required this.date,
  }) : super(key: key);

  // int id;
  // String date;

  @override
  ConsumerState<MyClassesStudentScreen> createState() =>
      _MyClassesStudentScreenState();
}

class _MyClassesStudentScreenState extends ConsumerState<MyClassesStudentScreen>
    with TickerProviderStateMixin {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  double width = 0.0;
  double height = 0.0;

  // late int _startingTabCount;
  // final List<Tab> _tabs = <Tab>[];
  late TabController _tabController;

  // late TextEditingController _searchController;

  bool isSearchValid = true;
  bool isSearchTapped = false;

  final TextEditingController _reasonTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(myClassesStudentNotifierProvider.notifier)
          .getMyClassesData(
            date: DateFormat('dd MMMM, yyyy').format(
              DateTime.now(),
            ),
          );
    });
  }

/*  bool _apiCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(myClassesStudentNotifierProvider.notifier)
            .getMyClassesData(date: DateFormat('dd MMMM, yyyy').format(DateTime.now()));

      });
    }
  }*/

  @override
  void dispose() {
    _tabController.dispose();
    _reasonTextController.dispose();
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
        //&& picked != selectedDate
        ) {
      setState(() {
        selectedDate = picked;
      });
      String formatedDate = DateFormat('dd MMMM, yyyy').format(picked);
      print("SELECTED FORMATED DATE: $formatedDate");
      await ref
          .read(myClassesStudentNotifierProvider.notifier)
          .getMyClassesData(date: formatedDate);
    }
  }

  String getMonthName() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM');
    final String monthName = formatter.format(now);
    return monthName;
  }

  CancelReasonModel? cancelReason;

  @override
  Widget build(BuildContext context) {
    ref.listen<MyClassesStudentStates>(myClassesStudentNotifierProvider,
        (previous, screenState) async {
      if (screenState is MyClassesStudentSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      } else if (screenState is CancelBookingStudentSuccessfulState) {
        await ref
            .watch(myClassesStudentNotifierProvider.notifier)
            .getMyClassesData(
                date: DateFormat('dd MMMM, yyyy').format(DateTime.now()));
        dismissLoading(context);
        setState(() {});
      } else if (screenState is MyClassesStudentErrorState) {
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
      } else if (screenState is CancelBookingStudentErrorState) {
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
      } else if (screenState is CancelBookingStudentLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is MyClassesStudentLoadingState) {
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

    return SafeArea(
      top: false,
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
        endDrawer: const DrawerScreen(),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                ///Date Section
                Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  child: GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
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
                      ],
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.primaryColor,
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: manropeHeadingTextStyle.copyWith(
                            fontSize: 16.sp, color: Colors.grey),
                        labelStyle:  manropeSubTitleTextStyle.copyWith(
                          fontSize: 16.sp,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color:  Colors.black,
                        ),
                        labelPadding: EdgeInsets.symmetric(vertical: 10),
                        labelColor: AppColors.primaryColor,
                        tabs: const [
                          // Tab(text: 'Previous Teacher',),
                          Text(
                            'Upcoming',
                          ),
                          Text(
                            'Completed',
                          ),
                          Text(
                            'Cancelled',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: CommonFunctions.deviceHeight(context) * 0.8,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          //UPCOMING TAB
                          //const NoClassesText(),

                          upComingList.isEmpty
                              ? const NoClassesText()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: upComingList.length,
                                  itemBuilder: (context, index) {
                                    return UpComingWidget(
                                      channelName: upComingList[index]
                                          .teacherSchedulingDetailCode,
                                      teacherName:
                                          upComingList[index].teacherName,
                                      time: upComingList[index].startTime,
                                      day: upComingList[index]
                                          .bookingDay
                                          .substring(0, 3),
                                      country: upComingList[index].tGender,
                                      date: upComingList[index]
                                          .bookingDate
                                          .substring(0, 2),
                                      yogaType:
                                          upComingList[index].teacherSpeciality,
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
                                                                    .read(myClassesStudentNotifierProvider
                                                                        .notifier)
                                                                    .cancelBooking(
                                                                        bookingCode:
                                                                            upComingList[index]
                                                                                .bookingCode)
                                                                    .whenComplete(
                                                                        () async {
                                                                  await ref
                                                                      .watch(myClassesStudentNotifierProvider
                                                                          .notifier)
                                                                      .getMyClassesData(
                                                                          date:
                                                                              DateFormat('dd MMMM, yyyy').format(DateTime.now()));
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
                                                                    "Yes",
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
                                      reschedule: () {
                                        ref
                                            .read(teacherIdProvider.notifier)
                                            .state = upComingList[
                                                index]
                                            .teacherId;
                                        ref
                                            .read(bookingCodeProvider.notifier)
                                            .state = upComingList[
                                                index]
                                            .bookingCode;
                                        ref
                                            .read(bookingDateProvider.notifier)
                                            .state = upComingList[
                                                index]
                                            .bookingDate;
                                        ref
                                            .read(
                                                teacherSchedulingDetailCodeProvider
                                                    .notifier)
                                            .state = upComingList[
                                                index]
                                            .teacherSchedulingDetailCode;

                                        showModalBottomSheet(
                                          context: context,
                                          isDismissible: false,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return SizedBox(
                                                height: CommonFunctions
                                                        .deviceHeight(context) *
                                                    0.55,
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Image.asset(
                                                          "assets/images/warningIcon.png"),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w),
                                                        child: Text(
                                                          "Do you want to reschedule your class\nwith the same teacher?",
                                                          style:
                                                              manropeHeadingTextStyle
                                                                  .copyWith(
                                                            fontSize: 18.sp,
                                                            height: 1.2,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 50.h,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  ref
                                                                      .read(myClassesStudentNotifierProvider
                                                                          .notifier)
                                                                      .updateTeacherSpecialitiesListReshedule(
                                                                          upComingList[index]
                                                                              .teacherSpeciality);

                                                                  ref
                                                                      .read(teacherNameMyClassProvider
                                                                          .notifier)
                                                                      .state = upComingList[
                                                                          index]
                                                                      .teacherName;

                                                                  print(
                                                                      "TEACHER ID ON CLICK ===== ${ref.read(teacherIdProvider)}");
                                                                  GoRouter.of(
                                                                          context)
                                                                      .push(
                                                                          //'${PagePath.TeacherDetail}?userid=2');
                                                                          '${PagePath.RescheduleTeacherDetail}?bookingId=${upComingList[index].bookingCode}');
                                                                  // ref
                                                                  //     .read(homeNotifierProvider
                                                                  //         .notifier)
                                                                  //     .rescheduleBooking(
                                                                  //       bookingDate:
                                                                  //       upComingList[index].bookingDate,
                                                                  //       bookingCode:
                                                                  //       upComingList[index].bookingCode
                                                                  //       ,
                                                                  //       teacherSchedulingDetailCode:
                                                                  //       upComingList[index]
                                                                  //           .teacherSchedulingDetailCode,
                                                                  //       paymentId:
                                                                  //           0,
                                                                  //     );
                                                                  print(
                                                                      "TEACHER CODE =====    ${upComingList[index].teacherSchedulingDetailCode} ");
                                                                  print(
                                                                      "BOOKING CODE =====    ${upComingList[index].bookingCode}  ");
                                                                  print(
                                                                      "BOOKING DATE =====    ${upComingList[index].bookingDate}  ");
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .transparent,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Yes",
                                                                      style: manropeHeadingTextStyle.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black),
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
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: const Color(
                                                                        0xFFF1F1F1),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "No",
                                                                      style: manropeHeadingTextStyle.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        );
                                      },
                                      join: () {},
                                    );
                                  }),

                          //COMPLETED TAB
                          completedList.isEmpty
                              ? const NoClassesText()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: completedList.length,
                                  itemBuilder: (context, index) {
                                    return CompletedWidget(
                                      teacherName:
                                          completedList[index].teacherName,
                                      // badgeIcon: completedList[index].badgeName ==
                                      //         "Silver"
                                      //     ? "assets/svgs/my_teacher/badge-silver.svg"
                                      //     : "assets/svgs/my_teacher/badge-gold.svg",
                                      time: completedList[index].startTime,
                                      day: completedList[index]
                                          .bookingDay
                                          .substring(0, 3),
                                      date: completedList[index]
                                          .bookingDate
                                          .substring(0, 2),
                                      yogaType: "Power Yoga",
                                      // completedList[index].teacherSpeciality,
                                      bookAgain: () {},
                                      viewDetails: () {
                                        ref
                                                .read(teacherNameMyClassProvider
                                                    .notifier)
                                                .state =
                                            completedList[index].teacherName;
                                        ref
                                            .read(
                                                teacherOccupationMyClassProvider
                                                    .notifier)
                                            .state = completedList[
                                                index]
                                            .teacherSpeciality;
                                        ref
                                                .read(
                                                    slotDurationMyClassProvider
                                                        .notifier)
                                                .state =
                                            completedList[index].slotTime;
                                        ref
                                            .read(budgetProvider.notifier)
                                            .state = completedList[index].price;
                                        ref.read(dateProvider.notifier).state =
                                            completedList[index].bookingDate;
                                        ref.read(dayProvider.notifier).state =
                                            completedList[index].bookingDay;
                                        ref.read(timeProvider.notifier).state =
                                            completedList[index].startTime;

                                        print(
                                            "TEACHER NAME ========  ${ref.read(teacherNameMyClassProvider.notifier).state} ");
                                        print(
                                            "SLOT  ========  ${ref.read(slotDurationMyClassProvider.notifier).state} ");
                                        print(
                                            "DATE ========  ${ref.read(dateProvider.notifier).state} ");
                                        print(
                                            "DAY ========  ${ref.read(dayProvider.notifier).state} ");
                                        print(
                                            "TIME ========  ${ref.read(timeProvider.notifier).state} ");
                                        print(
                                            "BUDGET ========  ${ref.read(budgetProvider.notifier).state} ");
                                        context
                                            .push(PagePath.viewDetailsStudent);
                                      },
                                    );
                                  }),

                          //CANCELLED TAB

                          //const NoClassesText(),

                          cancelledList.isEmpty
                              ? const NoClassesText()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cancelledList.length,
                                  itemBuilder: (context, index) {
                                    return CancelledWidget(
                                      teacherName:
                                          cancelledList[index].teacherName,
                                      /* badgeIcon: cancelledList[index].badgeName ==
                                              "Silver"
                                          ? "assets/svgs/my_teacher/badge-silver.svg"
                                          : "assets/svgs/my_teacher/badge-gold.svg",*/
                                      time: cancelledList[index].startTime,
                                      day: cancelledList[index]
                                          .bookingDay
                                          .substring(0, 3),
                                      date: cancelledList[index]
                                          .bookingDate
                                          .substring(0, 2),
                                      yogaType: "Power Yoga",
                                      // cancelledList[index].teacherSpeciality[0],
                                      availableTeachersTap: () {
                                        context
                                            .push(PagePath.availableTeachers);
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
      ),
    );
  }
}
