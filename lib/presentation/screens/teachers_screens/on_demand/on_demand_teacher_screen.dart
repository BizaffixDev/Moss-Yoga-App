import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/common/app_specific_widgets/drawer_teacher.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_providers/home_teacher_provider.dart';
import '../../../providers/teachers_providers/on_demand_teacher_provider.dart';
import 'components/accept_reject_buttons.dart';
import 'components/reverse_progress_indicator.dart';
import 'on_demand_teacher_states.dart';

class OnDemandTeacherScreen extends ConsumerStatefulWidget {
  const OnDemandTeacherScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnDemandTeacherScreen> createState() =>
      _OnDemandTeacherScreenState();
}

class _OnDemandTeacherScreenState extends ConsumerState<OnDemandTeacherScreen> {
  final bool _request = true;

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(onDemandTeacherNotifierProvider.notifier)
            .getStudentRequests(teacherId: ref.read(teacherIdProvider).toString());
        //TODO: HAVE TO INSERT DYNAMIC TEACHER ID LATER ON
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var requestListProvider = ref.watch(onDemandStudentRequestProvider);

    ref.listen<OnDemandTeacherStates>(onDemandTeacherNotifierProvider,
        (previous, screenState) async {
      if (screenState is OnDemandTeacherSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      } else if (screenState is OnDemandTeacherAcceptSuccessfulState) {
        dismissLoading(context);
        UIFeedback.showSnackBar(context, "Request is successfully accepeted.",
            stateType: StateType.success,
            height: 140);
        setState(() {});
      } else if (screenState is OnDemandTeacherRejectSuccessfulState) {
        dismissLoading(context);
        UIFeedback.showSnackBar(context, "Request is rejected.", height: 140);
        setState(() {});
      } else if (screenState is OnDemandTeacherErrorState) {
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
      } else if (screenState is OnDemandTeacherAcceptErrorState) {
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
      } else if (screenState is OnDemandTeacherRejectErrorState) {
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
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      } else if (screenState is OnDemandTeacherLoadingState) {
        debugPrint('Loading inside OnDemandTeacherLoadingState');
        showLoading(context);
        setState(() {});
      } else if (screenState is OnDemandTeacherAcceptLoadingState) {
        debugPrint('Loading inside OnDemandTeacherLoadingState');
        showLoading(context);
        setState(() {});
      } else if (screenState is OnDemandTeacherRejectLoadingState) {
        debugPrint('Loading inside OnDemandTeacherLoadingState');
        showLoading(context);
        setState(() {});
      }
    });

    return Scaffold(
      backgroundColor:
          _request == false ? const Color(0xFFF7F5FA) : AppColors.primaryColor,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          "Requests",
          style: manropeHeadingTextStyle,
        ),
      ),
      endDrawer: DrawerTeacher(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              "You have 90 secs to accept or decline request",
              style: manropeSubTitleTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Container(
                width: 390.w,
                decoration: BoxDecoration(
                    color: const Color(0xFFF7F5FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    )),
                child: requestListProvider.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Requests to show",
                            style: manropeHeadingTextStyle.copyWith(
                                fontSize: 20.sp),
                          ),
                          Text(
                            "You haven’t receive any request yet.",
                            style: manropeHeadingTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: Color(0xFF7F9195),
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: requestListProvider.length,
                        itemBuilder: (context, index) {
                          final request = requestListProvider[index];
                          DateTime inputDateTime =
                              DateFormat('MM/dd/yyyy HH:mm:ss')
                                  .parse(request.createdDate);

                          String dayOfWeek = DateFormat('E').format(
                              inputDateTime); // Day of the week (e.g., "Wed")
                          String dayOfMonth = DateFormat('dd').format(
                              inputDateTime); // Day of the month (e.g., "11")
                          String time12Hour = DateFormat('hh:mm a').format(
                              inputDateTime); // Time in 12-hour format with AM/PM (e.g., "12:00 AM")at with AM/PM (e.g., "12:00 AM")
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 20.w),
                            height: 175.h,
                            width: 331.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ReverseTimerProgressIndicator(
                                  totalTime: 90,
                                  onTimerEnd: () {
                                    if (index >= 0 &&
                                        index < requestListProvider.length) {
                                      setState(() {
                                        // Remove the item from the list when the timer ends
                                        requestListProvider.removeAt(index);
                                      });
                                    } else {
                                      print("Invalid index: $index");
                                    }
                                    setState(() {
                                      // Remove the item from the list when the timer ends
                                      requestListProvider.removeAt(index);
                                    });
                                  },
                                ),
                                Card(
                                  elevation: 0,
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                      ),
                                      child: Image.asset(
                                        Drawables.teacherProfile,
                                        height: 71.h,
                                        width: 71.w,
                                      ),
                                    ),
                                    title: Text(
                                      request.studentName,
                                      style: manropeHeadingTextStyle.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Ankle sprains",
                                      style: manropeSubTitleTextStyle.copyWith(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF828282),
                                      ),
                                    ),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            width: 43.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.7),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "$dayOfWeek\n$dayOfMonth",
                                                style: manropeSubTitleTextStyle
                                                    .copyWith(
                                                        fontSize: 12.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.2),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        // Time Text
                                        Text(
                                          time12Hour,
                                          style:
                                              manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Divider(),

                                //ACCEPT/REJECT BUTTON
                                Row(
                                  children: [
                                    AcceptRejectButton(
                                      onTap: () {
                                        ref
                                            .read(
                                                onDemandTeacherNotifierProvider
                                                    .notifier)
                                            .rejectStudentRequest(
                                                bookingId: request.bookingCode);
                                        setState(() {
                                          requestListProvider.removeAt(index);
                                        });
                                      },
                                      text: "Reject",
                                      color: Colors.red,
                                      icon: Drawables.cancel,
                                    ),
                                    Container(
                                      height: 39.h,
                                      width: 1.14.w,
                                      color: const Color(0xFFE9ECF2),
                                    ),
                                    AcceptRejectButton(
                                      onTap: () {
                                        ref
                                            .read(
                                                onDemandTeacherNotifierProvider
                                                    .notifier)
                                            .acceptStudentRequest(
                                                bookingId: request.bookingCode);
                                        setState(() {
                                          requestListProvider.removeAt(index);
                                        });
                                      },
                                      text: "Accept",
                                      color: const Color(0xFF4A934A),
                                      icon: Drawables.accept,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })),
          ),
        ],
      ),
    );
  }
}
