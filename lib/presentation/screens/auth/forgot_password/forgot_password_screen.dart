import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_text_field.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';

import '../../../../common/resources/page_path.dart';
import '../../../../common/resources/text_styles.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    String email = _emailController.text.trim();
    bool isValid =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);
    if (_isMounted) {
      setState(() {
        print(isValid);
        _isEmailValid = isValid;
      });
    }
  }

  void _sendEmail() {
    _validateEmail();
    if (_isMounted && _isEmailValid) {
      FocusScope.of(context).unfocus();
      ref
          .read(authNotifyProvider.notifier)
          .forgotPassword(context, email: _emailController.text.trim());
      // Perform the logic to send the email here
      // This function will be called only if the email is valid
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      if (!_isMounted) return;
      if (screenState is ForgotPasswordErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats weird: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is ForgotPasswordLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      } else if (screenState is ForgotPasswordSuccessfulState) {
        dismissLoading(context);
        print('This is the current stte $ForgotPasswordSuccessfulState');
        // Future.delayed(Duration(seconds: 3), () {
        final email = _emailController.text.trim();
        // if (mounted) {
        GoRouter.of(context)
            .push('${PagePath.forgotOtpVerification}?email=$email');
        //   setState(() {});
        // }
        // });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: 844.h,
          width: 390.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Drawables.authPlainBg,
                ),
                fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 760.h,
              width: 390.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(37),
                  topRight: Radius.circular(37),
                ),
                image: DecorationImage(

                  image: AssetImage(
                  "assets/images/background_leaves.png",
                ),


                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.go(PagePath.login),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 21,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "To recover your account, enter your\nregistered email address with Moss Yoga.",
                          style: manropeSubTitleTextStyle.copyWith(
                            height: 1.2,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150.h,
                  ),
                  Column(
                    children: [
                      CustomTextField(
                        ///Add error text and isEmailValid
                        isFieldValid: _isEmailValid,
                        errorText:
                            _isEmailValid ? null : 'Please Enter a valid Email',
                        obscure: false,
                        hintText: "Enter Email Here",
                        labelText: "Email",
                        controller: _emailController,
                        onChanged: (_) {
                          setState(() {
                            _isEmailValid = true;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        text: "Send Email",
                        onTap: _sendEmail,
                        btnColor: Colors.white,
                        textColor: AppColors.primaryColor,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
