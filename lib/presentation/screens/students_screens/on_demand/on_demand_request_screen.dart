import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/models/teacher_book_session_request_student_model.dart';
import 'package:moss_yoga/presentation/providers/payment_providers/stripe_payment_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/students_screens/on_demand/on_demand_states/on_demand_states.dart';
import 'dart:math' as math;
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../data/models/teacher_specialty.dart';
import '../../../providers/on_demand_student_provider.dart';
import '../teacherDetail/components/body.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OnDemandRequestScreen extends ConsumerStatefulWidget {
  OnDemandRequestScreen({required this.teacherId, Key? key}) : super(key: key);

  String teacherId;

  @override
  ConsumerState<OnDemandRequestScreen> createState() =>
      _OnDemandRequestScreenState();
}

class _OnDemandRequestScreenState extends ConsumerState<OnDemandRequestScreen> {
  List<TeacherSpecialty> teacherSpecialtyList = [
    TeacherSpecialty(specialty: "Mediation"),
    TeacherSpecialty(specialty: "Ashtanga Yoga"),
    TeacherSpecialty(specialty: "Fitness"),
    TeacherSpecialty(specialty: "Restorative Yoga"),
    TeacherSpecialty(specialty: "Vinyasa Yoga"),
  ];

  static const int _totalSeconds = 3;
  int _elapsedSeconds = 0;
  Timer? _timer;
  String notAcceptedText = '';

  // bool isSuccessfulAccepted = false;
  bool teacherAcceptedRequest = false;
  String teacherPrice = '-1';
  bool isPaid = false;

  // var amount = '100';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendTeacherRequestMethod();
    });
    isPaid = false;
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///Going insid to make teacher response yes
    print('Going insid to make teacher response yes');
    print('teacher Response was $teacherAcceptedRequest');

    print('teacher Response is $teacherAcceptedRequest');
  }

  Future<void> sendTeacherRequestMethod() async {
    print(
        'this is the Teacher code inside ondemand_request_screen code: ${widget.teacherId}');
    var responseOfTeacher = await ref
        .read(onDemandStudentNotifierProvider.notifier)
        .teacherResponseToBookSession(
          teacherBookSessionRequestStudentModel:
              TeacherBookSessionRequestStudentModel(
                  bookingCode: widget.teacherId),
        );
    print(responseOfTeacher);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsedSeconds < _totalSeconds) {
        setState(() {
          _elapsedSeconds++;
        });
      } else {
        handleTeacherRequestAccepted(context, teacherAcceptedRequest);
      }
      //   _timer?.cancel();
      //
      //   ///Cancel this if state becomes successful.(use a var and change its val at success_
      //
      //   teacherAcceptedRequest
      //       ? const SizedBox.shrink()
      //       : UIFeedback.showSnackBar(
      //       context, "Sorry! your request was not accepted by teacher",
      //       height: 300);
      //   teacherAcceptedRequest
      //       ? notAcceptedText = "Teacher has accepted your request"
      //       : notAcceptedText = "Oops! Request not accepted";
      //
      //   teacherAcceptedRequest
      //       ? ref
      //       .read(requestSentProvider.notifier)
      //       .state = true
      //       : ref
      //       .read(requestSentProvider.notifier)
      //       .state = false;
      // }
    });
  }

  // void _stopTimer() {
  //   _timer?.cancel();
  // }
  void handleTeacherRequestAccepted(
      BuildContext context, bool teacherAcceptedRequest) {
    _timer?.cancel();

    if (teacherAcceptedRequest) {
      return;
    }

    UIFeedback.showSnackBar(
      context,
      "Sorry! your request was not accepted by the teacher",
      height: 180,
    );

    notAcceptedText = "Oops! Request not accepted";
    ref.read(requestSentProvider.notifier).state = false;
  }

  void _resetTimer() {
    setState(() {
      _elapsedSeconds = 0;
    });
    _startTimer(); // Restart the timer when reset
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OnDemandStudentStates>(onDemandStudentNotifierProvider,
        (previous, screenState) async {
      if (screenState is OnDemandStudentTeacherLoadingState) {
        // setState(() {
        debugPrint('Loading');
        showLoading(context);
        // });
      }
      if (screenState is OnDemandStudentBookingErrorState) {
        print('error comes here');
        dismissLoading(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.startToEnd,
            // behavior: SnackBarBehavior.floating,
            // Set behavior to fixed
            margin: EdgeInsets.only(bottom: 500.h),

            backgroundColor: const Color(0xFFC62828),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            action: SnackBarAction(
              label: 'x',
              textColor: Colors.white,
              onPressed: () {
                // Navigator.pop(context);
              },
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Drawables.errorSnackbar),
                    SizedBox(
                      width: 20.w,
                    ),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        screenState.error.toString(),
                        style: manropeHeadingTextStyle.copyWith(
                            fontSize: 14.sp, color: Colors.white, height: 1.2),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   "x",
                //   style: manropeHeadingTextStyle.copyWith(
                //     fontSize: 16.sp,
                //     color: Colors.white,
                //   ),
                // )
              ],
            ),
          ),
        );
      }

      ///The Api that checks if teacher accepted request
      ///if they did then make 2 green
      ///And change screen to now Pay.
      else if (screenState is OnDemandStudentTeacherAcceptedRequestState) {
        dismissLoading(context);
        setState(() {
          teacherAcceptedRequest = true;
          teacherPrice = screenState.price;
        });
      } else if (screenState is OnDemandStripeErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          dismissLoading(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.startToEnd,
              behavior: SnackBarBehavior.floating,
              // Set behavior to fixed
              margin: EdgeInsets.only(bottom: 500.h),

              backgroundColor: const Color(0xFFC62828),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              action: SnackBarAction(
                label: 'x',
                textColor: Colors.white,
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(Drawables.errorSnackbar),
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          screenState.error.toString(),
                          style: manropeHeadingTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: Colors.white,
                              height: 1.2),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "x",
                  //   style: manropeHeadingTextStyle.copyWith(
                  //     fontSize: 16.sp,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            ),
          );
          // UIFeedback.showSnackBar(context, screenState.error.toString(),
          //     height: 140);
        } else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.startToEnd,
              behavior: SnackBarBehavior.floating,
              // Set behavior to fixed
              margin: EdgeInsets.only(bottom: 500.h),

              backgroundColor: const Color(0xFFC62828),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              action: SnackBarAction(
                label: 'x',
                textColor: Colors.white,
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(Drawables.errorSnackbar),
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          screenState.error.toString(),
                          style: manropeHeadingTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: Colors.white,
                              height: 1.2),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "x",
                  //   style: manropeHeadingTextStyle.copyWith(
                  //     fontSize: 16.sp,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            ),
          );

          // UIFeedback.showSnackBar(context, screenState.error.toString(),
          //     height: 140);
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.startToEnd,
              behavior: SnackBarBehavior.floating,
              // Set behavior to fixed
              margin: EdgeInsets.only(bottom: 500.h),

              backgroundColor: const Color(0xFFC62828),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              action: SnackBarAction(
                label: 'x',
                textColor: Colors.white,
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(Drawables.errorSnackbar),
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          screenState.error.toString(),
                          style: manropeHeadingTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: Colors.white,
                              height: 1.2),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "x",
                  //   style: manropeHeadingTextStyle.copyWith(
                  //     fontSize: 16.sp,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            ),
          );
          // UIFeedback.showSnackBar(context, screenState.error.toString(),
          //     height: 140);
          dismissLoading(context);
        }
      } else if (screenState is OnDemandStripeSuccessfulState) {
        dismissLoading(context);
        await Future.delayed(Duration(microseconds: 10));
        setState(() {
          isPaid = true;
        });
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
                      screenState.paymentStatus,
                      style: kHeading2TextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Your session has been successful booked",
                      style: kHintTextStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Total Amount",
                      style: kHintTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("\$ ${screenState.amount}", style: kHeading3TextStyle),
                    // Text("${screenState.amount}", style: kHeading3TextStyle),
                    const SizedBox(
                      height: 15,
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

    String name = ref.read(teacherNameProvider);
    String rating = ref.read(teacherRatingProvider);
    String price = ref.read(teacherPriceProvider);
    double progress = _elapsedSeconds / _totalSeconds;

    double parsedValue = double.parse(rating);
    String formatRating = parsedValue.toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'On Demand',
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
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Use CrossAxisAlignment.start
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 20.sp,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 10.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  teacherAcceptedRequest
                      ? Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "2",
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 20.sp,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: Text(
                              "2",
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 20.sp,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                  teacherAcceptedRequest
                      ? Container(
                          height: 10.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : Container(
                          height: 10.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                  isPaid
                      ? Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "3",
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 20.sp,
                                color: Colors.white,
                                height: 1.2
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: Text(
                              "3",
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 20.sp,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      "Requested",
                      style: manropeHeadingTextStyle.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                    width: 5.w,
                  ),
                  Center(
                    child: Text(
                      "Pay",
                      style: manropeHeadingTextStyle.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                    width: 10.w,
                  ),
                  Center(
                    child: Text(
                      "Join Now",
                      style: manropeHeadingTextStyle.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 80.h),
                    width: 390.w,
                    height: 200.h,
                    decoration:  BoxDecoration(
                        //color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        gradient: LinearGradient(

                            //end: Alignment.center,
                            colors: [
                              Color(0xFF334525),
                              Color(0xFF334525).withOpacity(0.7),
                              Color(0xFFD7DEBD),

                            ])),
                    child: Center(
                      child: teacherAcceptedRequest
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Request Accepted",
                                  style: manropeHeadingTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 60.w, right: 60.w),
                                  child: Text(
                                    "Your Video Session with ${name}",
                                    style: manropeSubTitleTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 85.w, right: 77.w),
                                  child: Text(
                                    "will start after payment",
                                    style: manropeSubTitleTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _elapsedSeconds < _totalSeconds
                                      ? "Request Sent"
                                      : "Oops! Request not accepted",
                                  style: manropeHeadingTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                                Text(
                                  _elapsedSeconds < _totalSeconds
                                      ? "Expect your teacher's timely response."
                                      : "",
                                  style: manropeSubTitleTextStyle.copyWith(
                                      color: Colors.white),
                                )
                              ],
                            ),
                    ),
                  ),
                ),


                teacherAcceptedRequest
                    ? Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/home/complete_booking_tick.png',
                              height: 132.h,
                              width: 132.h,
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CustomPaint(
                                painter: CircleProgressPainter(
                                  progressColor: AppColors.primaryColor,
                                  backgroundColor: Colors.white,
                                  strokeWidth: 8,
                                  progress:
                                      progress, // Update the progress value here
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: const Color(0xFFE9ECF2),
                                    child: Text(
                                      formatTime(_totalSeconds - _elapsedSeconds),
                                      style: manropeHeadingTextStyle.copyWith(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 250.h, bottom: 10.h),
                    width: 390.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: teacherAcceptedRequest
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TEACHER INFO
                              Container(
                                padding: EdgeInsets.only(left: 20.w),
                                width: 375.w,
                                height: 137.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: const Color(0xfff9f9f9)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //image
                                    Container(
                                      height: 96.h,
                                      width: 101.43.w,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/teacher.png"),
                                            fit: BoxFit.cover,
                                          )),
                                    ),

                                    const SizedBox(
                                      width: 20,
                                    ),

                                    //INFO
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //name
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                name,
                                                //"Jane Cyrus",
                                                style: manropeHeadingTextStyle
                                                    .copyWith(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30.w,
                                              ),
                                              Text(
                                                price,
                                                style: manropeSubTitleTextStyle
                                                    .copyWith(
                                                  fontSize: 16.sp,
                                                  color:
                                                      const Color(0xFF535353),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Text(
                                            "Ashtanga Yoga",
                                            style: manropeHeadingTextStyle
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              /*Row(
                                          children: List.generate(4, (index) => const Icon(Icons.star,color: Colors.yellow,),
                                          ),
                                        ),*/
                                              RatingBarIndicator(
                                                rating: parsedValue,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                unratedColor: Colors.grey,
                                                // Color for unrated stars
                                                direction: Axis.horizontal,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                formatRating,
                                                style: manropeSubTitleTextStyle
                                                    .copyWith(
                                                  fontSize: 18.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Text(
                                  "About",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Text(
                                  "Nurturing souls through mindful movements and compassionate guidance.",
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2D3536),
                                    height: 1.2,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Text(
                                  "Specialities",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Wrap(
                                  spacing: 5.0,
                                  children: List<Widget>.generate(
                                    teacherSpecialtyList.length,
                                    (int index) {
                                      return SpecialityChip(
                                          title: teacherSpecialtyList[index]
                                              .specialty);
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: teacherAcceptedRequest
          ? Container(
              height: CommonFunctions.deviceHeight(context) * 0.23,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(3, 10)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Budget",
                          style: manropeHeadingTextStyle,
                        ),
                        Text(
                          "\$" + teacherPrice,
                          style: manropeHeadingTextStyle,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10.h),
                      height: 73,
                      width: CommonFunctions.deviceWidth(context),
                      child: isPaid
                          ? CustomButton(
                              text: "Go Back",
                              onTap: () {
                                context.go(PagePath.homeScreen);
                              },
                              btnColor: AppColors.primaryColor,
                              textColor: Colors.white,
                            )
                          : CustomButton(
                              text: "Click & Pay Now",
                              onTap: () async {
                                PaymentIntentModelRequest
                                    paymentIntentModelRequest =
                                    PaymentIntentModelRequest(
                                        amount:
                                            teacherPrice.replaceAll('\$', ''),
                                        currency: "USD",
                                        description: name);
                                await ref
                                    .read(onDemandStudentNotifierProvider
                                        .notifier)
                                    .onDemandCreatePaymentIntent(
                                        teacherId: ref.watch(
                                            acceptedOnDemandbookingTeacherIdProvider),
                                        paymentIntentModelRequest:
                                            paymentIntentModelRequest);
                              },
                              btnColor: AppColors.primaryColor,
                              textColor: Colors.white,
                            )),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double progress;

  CircleProgressPainter({
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.strokeWidth = 8,
    this.progress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    double sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
