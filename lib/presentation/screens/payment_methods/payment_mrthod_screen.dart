import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/presentation/providers/payment_providers/stripe_payment_provider.dart';
import 'package:moss_yoga/presentation/screens/payment_methods/states/payment_states.dart';
import '../../../common/app_specific_widgets/loader.dart';
import '../../../common/resources/colors.dart';
import '../../providers/home_provider.dart';
import '../../providers/screen_state.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  int teacherId;

  PaymentMethodScreen({required this.teacherId, Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  bool isCardAdd = false;
  bool isPaid = false;
  int selectedRadio = 0;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    super.initState();
    print('This is the teacherID ${widget.teacherId}');
    isPaid = false;
  }

  @override
  Widget build(BuildContext context) {
    // final methods = ref.watch(paymentMethodProvider);
    String name = ref.read(teacherNameProvider);
    String occupation = ref.read(teacherOccupationProvider);
    String amount = ref.read(teacherPriceProvider);

    ref.listen<StripeStates>(paymentNotifierProvider,
        (previous, screenState) async {
      if (screenState is StripeErrorState) {
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
        } else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
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
          // Future.delayed(Duration(milliseconds: 10));
          // UIFeedback.showSnackBar(context, screenState.error.toString(),
          //     height: 140);
          // dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
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
          // dismissLoading(context);
        }
      } else if (screenState is StripeLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is StripeSuccessfulState) {
        // chrlist =  screenState.chronicResponseList;
        //print("chrListt ${chrlist[0].chronicConditionName}");
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
                      style: kHeading2TextStyle.copyWith(fontSize: 18.5),
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

    return Scaffold(
      endDrawer: const Drawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //YOUR TEACHER TEXT

              Text(
                "Your Teacher",
                style: kHeading3TextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: CommonFunctions.deviceHeight(context) * 0.15,
                width: CommonFunctions.deviceWidth(context),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.kAppBarColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/teacher.png",
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: kHeading3TextStyle,
                        ),
                        Text(
                          occupation,
                          style: kHeading3TextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: const Color(0XFF3B3B3B),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      amount,
                      style: kHeading2TextStyle,
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              // Text(
              //   "Select your payment method",
              //   style: kHeading3TextStyle,
              // ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: CommonFunctions.deviceHeight(context) * 0.23,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
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
                    "TOTAL",
                    style: manropeHeadingTextStyle,
                  ),
                  Text(
                    amount,
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
                      text: "Pay Now",
                      onTap: () async {
                        PaymentIntentModelRequest paymentIntentModelRequest =
                            PaymentIntentModelRequest(
                                amount: amount.replaceAll('\$', ''),
                                currency: "USD",
                                description: name);
                        print('This is the teacherID ${widget.teacherId}');
                        await ref
                            .read(paymentNotifierProvider.notifier)
                            .createPaymentIntent(
                                teacherId: widget.teacherId,
                                paymentIntentModelRequest:
                                    paymentIntentModelRequest);
                      },
                      btnColor: AppColors.primaryColor,
                      textColor: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
