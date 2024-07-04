import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_text_field.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';

import '../../../../app/utils/common_functions.dart';
import '../../../../common/resources/text_styles.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  String email;

  ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _currentPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool arePasswordsValid = false; // New variable to track password validity

  bool isObscure1 = true;
  bool isObscure2 = true;

  @override
  void dispose() {
    _currentPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  _checkBothPasswords() {
    if (_confirmPassController.text.trim() ==
            _currentPassController.text.trim() &&
        _confirmPassController.text.trim().length >= 8 &&
        _currentPassController.text.trim().length >= 8) {
      return true;
    }
    return false;
  }

  _confirmPasswordChange() {
    if (_checkBothPasswords()) {
      ref.read(authNotifyProvider.notifier).resetPassword(
          context: context,
          email: widget.email.trim().toString(),
          password: _confirmPassController.text.trim());
    } else if (_confirmPassController.text.trim().length < 8 &&
        _currentPassController.text.trim().length < 8) {
      UIFeedback.showSnackBar(context, 'Must be 8 characters long.');
    } else {
      UIFeedback.showSnackBar(context, 'The passwords do not match.');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      if (screenState is ResetPasswordErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          print("For Some Reason it came here: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not showing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is ResetPasswordLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      } else if (screenState is ResetPasswordSuccessfulState) {
        dismissLoading(context);
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(35),
                topLeft: Radius.circular(35),
              ),
            ),
            context: context,
            builder: (context) {
              return SizedBox(
                height: CommonFunctions.deviceHeight(context) * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 5,
                          width: 80,
                          decoration:
                          const BoxDecoration(color: Color(0xFFDADAD1)),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(Drawables.pencil),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "PASSWORD CREATED",
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          "New Password Has Been Created!",
                          style: manropeHeadingTextStyle.copyWith(
                              fontSize: 24,
                              color: const Color(0xFF27364E),
                              height: 1.2),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "You can now login with your newly created account password.",
                          style: manropeHeadingTextStyle.copyWith(
                              fontSize: 16,
                              color: const Color(0xFF5B5B5B),
                              fontWeight: FontWeight.w400,
                              height: 1.2),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(),
                        CustomButton(
                            btnColor: AppColors.primaryColor,
                            textColor: AppColors.white,
                            text: "Confirm",
                            onTap: () {
                              Navigator.of(context).pop();
                              GoRouter.of(context).go(PagePath.login);
                              // Timer.periodic(Duration(seconds: 1),
                              //     (timer) {
                              //   GoRouter.of(context)
                              //       .go(PagePath.login);
                              // });
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    });

    return Scaffold(

      backgroundColor: AppColors.primaryColor,
      body: Container(
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
            height: 750.h,
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
                  onPressed: () => context.pop(),
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
                        "Reset Password?",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 21,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Reset your password to recover & login\nto your account.",
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
                  height: 130.h,
                ),
                CustomTextField(
                  onChanged: (_) {
                    setState(() {});
                  },
                  controller: _currentPassController,
                  hintText: "Create New Password",
                  labelText: "Create New Password",
                  obscure: isObscure1,
                  suffixIcon: isObscure1
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  obscureIconLogic: () {
                    print(isObscure1);
                    setState(() {
                      isObscure1 = !isObscure1;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onChanged: (_) {
                    setState(() {});
                  },
                  controller: _confirmPassController,
                  hintText: "Re-enter New Password",
                  labelText: "Re-enter New Password",
                  obscure: isObscure2,
                  suffixIcon: isObscure2
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  obscureIconLogic: () {
                    print(isObscure2);
                    setState(() {
                      isObscure2 = !isObscure2;
                    });
                  },
                ),
                _checkBothPasswords()
                    ? Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Your passwords Match!",
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 4.0),
                            //   child: Icon(
                            //     Icons.incorre,
                            //     color: Colors.red,
                            //     size: 12,
                            //   ),
                            // ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "*Must be 8 charcters long",
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  text: "Confirm",
                  onTap: () {
                    _confirmPasswordChange();
                  },
                  btnColor: _currentPassController.text.length < 7 ||
                          _confirmPassController.text.length < 7
                      ? const Color(0xFFF7F5FA)
                      : AppColors.primaryColor,
                  textColor: _currentPassController.text.length < 7 ||
                          _confirmPassController.text.length < 7
                      ? const Color(0xFFC4C4BC)
                      : AppColors.white,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
