
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/choose_role/components/arrow_back_icon.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';
import 'package:moss_yoga/presentation/screens/auth/verify_email/components/otp_verification_text.dart';
import 'package:pinput/pinput.dart';

class ForgotOtpVerfication extends ConsumerStatefulWidget {
  String email;

  ForgotOtpVerfication({Key? key, required this.email}) : super(key: key);

  @override
  ConsumerState<ForgotOtpVerfication> createState() =>
      _ForgotOtpVerficationState();
}

class _ForgotOtpVerficationState extends ConsumerState<ForgotOtpVerfication> {
  int start = 120;
  bool wait = false;
  final otpController = TextEditingController();
  bool isVerificationFailed = false;
  late FocusNode _focusNode; // Add a FocusNode variable
  Timer? _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void resendCode() {
    if (wait) {
      // Show a snackbar indicating that the timer is still running
      UIFeedback.showSnackBar(
          context,
          "Please wait "
          " ${start ~/ 60}:${(start % 60).toString().padLeft(2, '0')}"
          " for the timer to finish");
    } else {
      otpController.clear(); // Clear the otpController text field
      startTimer();
      setState(() {
        wait = true;
        start = 120;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode = FocusNode(); // Initialize the FocusNode
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();

    _focusNode.dispose(); // Dispose the FocusNode when the screen is disposed
    super.dispose();
  }

  _sendOtp() {
    final code = otpController.text.trim();
    final email = widget.email;
    ref.read(authNotifyProvider.notifier).otpVerificationForgotPassowrd(context,
        email: email.toString(), code: code);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      if (screenState is OTPVerificationErrorState) {
        setState(() {
          isVerificationFailed = true;
          otpController.clear(); // Clear the otpController text field
        });
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not showing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 280);
          dismissLoading(context);
        } else {
          print("This is the else: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 280);
          dismissLoading(context);
        }
      } else if (screenState is OTPVerificationLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      } else if (screenState is OTPVerificationSuccessfulState) {
        print(
            'Inside the success state of OTPVerificationStudentSuccessfulState');
        otpController.clear(); //// Clear the otpController text field
        final email = widget.email.trim().toString();
        GoRouter.of(context).push('${PagePath.resetPassword}?email=$email');

        // context.push(PagePath.resetPassword);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            // When tapped outside, remove the focus from the text field
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: 844.h,
              width: 390.w,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Drawables.authBg,
                      ),
                      fit: BoxFit.cover)),
              child: Stack(
                  //Leaf textures
                  children: [
                    Image.asset("assets/images/login_bg_texture.png"),
                    //Arrow back Icon Button
                    Align(
                      alignment: Alignment.topLeft,
                      child: ArrowBackIcon(
                        onTap: () {
                          print("clicked");
                          context.pop();
                        },
                      ),
                    ),
                    //Leaf textures

                    //Welcome Text
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 120.h),
                        child: const OtpVerificationText(),
                      ),
                    ),

                    // white COntainer having all textfields and buttons
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 560.h,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            Text(
                              "Enter the OTP sent to ${widget.email}",
                              textAlign: TextAlign.center,
                              style: manropeSubTitleTextStyle.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Pinput(
                              onChanged: (_) {
                                setState(() {});
                              },
                              controller: otpController,
                              length: 4,
                              keyboardType: TextInputType.number,
                              toolbarEnabled: false,
                              listenForMultipleSmsOnAndroid: true,
                              defaultPinTheme: isVerificationFailed
                                  ? errorPinTheme // Change border color to red
                                  : defaultPinTheme,
                              focusedPinTheme:
                                  defaultPinTheme.copyDecorationWith(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              submittedPinTheme:
                                  defaultPinTheme.copyDecorationWith(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your code will expire in ",
                                  style: kHintTextStyle,
                                ),
                                Text(
                                  "${start ~/ 60}:${(start % 60).toString().padLeft(2, '0')}", // Updated line
                                  style: kHintTextStyle.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: resendCode,
                              child: Text(
                                "Resend Code",
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: start == 0
                                      ? AppColors.primaryColor
                                      : AppColors.greyTextColor,
                                ),
                              ),
                            ),
                            CustomButton(
                              btnColor: otpController.text.length > 3
                                  ? AppColors.primaryColor
                                  : const Color(0xFFF7F5FA),
                              textColor: otpController.text.length > 3
                                  ? AppColors.white
                                  : const Color(0xFFC4C4BC),
                              onTap: () {
                                if (otpController.text.length > 3
                                    // && !isVerificationFailed
                                    ) {
                                  _sendOtp();
                                }
                              },
                              text: "Verify",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
