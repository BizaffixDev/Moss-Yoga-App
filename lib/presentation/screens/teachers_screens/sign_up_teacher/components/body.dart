import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/app_specific_widgets/social_login.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';

import '../../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../../common/app_specific_widgets/custom_rich_text.dart';
import '../../../../../common/app_specific_widgets/custom_text_field.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/strings.dart';

import '../../../auth/choose_role/components/arrow_back_icon.dart';
import '../../../auth/login/components/or_login_with_text.dart';
import 'sign_up_text.dart';

class Body extends ConsumerStatefulWidget {
  const Body({
    super.key,
  });

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool isObscure = true;
  bool isChecked = false;

  @override
  void initState() {
    print(
        "user Role ===   ${ref.read(userRoleProvider.notifier).state.userRole.name}");
    print('The Current Screen is SIGN UP TEACHER');
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      if (screenState is GoogleSignUpErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          print('going inside unauthorized block in UI');
          UIFeedback.showSnackBar(context, 'Invalid credentials', height: 140);
          dismissLoading(context);
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
      } else if (screenState is AuthErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          print('going inside unauthorized block in UI');
          UIFeedback.showSnackBar(context, 'Invalid credentials', height: 140);
          dismissLoading(context);
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
      } else if (screenState is GoogleSignUpLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is SignUpTeacherLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      } else if (screenState is SignupSuccessfulTeacherState) {
        // UIFeedback.showSnackBar(context, "Thankyou for signing up! We have emailed you a verification link to confirm your email address.",
        //  stateType: StateType.initial,height: 280);
        final email = _emailController.text.trim();
        GoRouter.of(context)
            .push('${PagePath.verifyEmailTeacher}?email=$email');
        // GoRouter.of(context).go(PagePath.verifyEmail);
        dismissLoading(context);
      } else if (screenState is AuthSuccessfulGoogleSignUpState) {
        ref.read(teacherLoggedInWithGoogleProvider.notifier).state = true;
        print(
            'now the Teacher google logged in provider is set to ${ref.watch(teacherLoggedInWithGoogleProvider.notifier).state}');
        GoRouter.of(context).push(PagePath.teacherRegProcess);
        dismissLoading(context);
      }
    });

    /*   ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      // if(screenState is LoginListState){
      //   list = screenState.val as List;
      // }
      if (screenState is AuthErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is SignUpTeacherLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is SignupSuccessfulTeacherState) {
        final email = _emailController.text.trim();
        GoRouter.of(context).push('${PagePath.verifyEmailTeacher}?email=$email');
        dismissLoading(context);

        // setState(() {});
      } else if (screenState is AuthSuccessfulGoogleSignUpState) {
        GoRouter.of(context).go(PagePath.teacherRegProcess);
        dismissLoading(context);
      }
    });*/
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
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
                children: [
                  //Leaf textures
                  Image.asset("assets/images/login_bg_texture.png"),

                  Align(
                    alignment: Alignment.topLeft,
                    child: ArrowBackIcon(
                      onTap: () {
                        print("clicked");
                        context.pop();
                      },
                    ),
                  ),

                  //Welcome Text
                  const SignUpText(),

                  // white COntainer having all textfields and buttons
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 567.h,
                      //   height: CommonFunctions.deviceHeight(context) * 0.7,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.r),
                            topRight: Radius.circular(35.r),
                          )),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),

                            //Username TextField
                            //Username TextField
                            CustomTextField(
                              focusNode: _usernameFocusNode,
                              obscure: false,
                              controller: _usernameController,
                              hintText: "Enter User Name Here",
                              labelText: "User Name",
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            //Email TextField
                            CustomTextField(
                              focusNode: _emailFocusNode,
                              obscure: false,
                              controller: _emailController,
                              hintText: "Enter Email Here",
                              labelText: "Email",
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),

                            //Password TextField
                            CustomTextField(
                              focusNode: _passwordFocusNode,
                              controller: _passwordController,
                              hintText: "Enter Password Here",
                              labelText: "Password",
                              obscure: isObscure,
                              textInputAction: TextInputAction.done,
                              suffixIcon: isObscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              obscureIconLogic: () {
                                print(isObscure);
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            ),

                            SizedBox(
                              height:
                                  CommonFunctions.deviceHeight(context) * 0.05,
                              width: 268,
                              child: Center(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppColors.primaryColor,
                                      checkColor: Colors.white,
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    CustomRichText(
                                        text1: "I agree to the ",
                                        text2: "Terms & Conditions",
                                        onTap: () =>
                                            context.push(PagePath.terms))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            //Login Button
                            CustomButton(
                              btnColor: AppColors.primaryColor,
                              textColor: Colors.white,
                              text: "Create Account",
                              onTap: () async {
                                if (_usernameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  _usernameFocusNode.unfocus();
                                  _passwordFocusNode.unfocus();
                                  _emailFocusNode.unfocus();
                                  UIFeedback.showSnackBar(
                                      context, "All fields are required",
                                      stateType: StateType.error, height: 140);
                                } else if (isChecked == false) {
                                  _usernameFocusNode.unfocus();
                                  _passwordFocusNode.unfocus();
                                  _emailFocusNode.unfocus();
                                  UIFeedback.showSnackBar(context,
                                      "Please agree to the terms and conditions",
                                      stateType: StateType.error, height: 140);
                                } else if (!Strings.emailRegex
                                    .hasMatch(_emailController.text)) {
                                  _usernameFocusNode.unfocus();
                                  _passwordFocusNode.unfocus();
                                  _emailFocusNode.unfocus();
                                  UIFeedback.showSnackBar(context,
                                      "Please enter valid email address",
                                      stateType: StateType.error, height: 140);
                                } else {
                                  _usernameFocusNode.unfocus();
                                  _passwordFocusNode.unfocus();
                                  _emailFocusNode.unfocus();
                                  var signup = await ref
                                      .read(authNotifyProvider.notifier)
                                      .signupTeacher(
                                        context,
                                        username: _usernameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                  debugPrint("This is the response$signup");
                                }
                                //context.pushNamed(PagePath.verifyEmail);
                              },
                            ),

                            SizedBox(
                              height: 10.h,
                            ),

                            ORLoginWithText(
                              isLogin: false,
                            ),

                            SizedBox(
                              height: 10.h,
                            ),

                            // const SocialLoginButtons(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocialLogin(
                                  icon: Drawables.appleIcon,
                                  onTap: () {},
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                SocialLogin(
                                  icon: Drawables.googleIcon,
                                  onTap: () async {
                                    print("Tapped Google SignIn");
                                    ref
                                        .read(authNotifyProvider.notifier)
                                        .signUpWithGoogle(
                                          context,
                                          userRole: ref
                                              .read(userRoleProvider.notifier)
                                              .state
                                              .userRole
                                              .name,
                                        );
                                  },
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 30.h,
                            ),

                            CustomRichText(
                              text1: "Already have an account? ",
                              text2: "Login here",
                              onTap: () => context.push(PagePath.login),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class OtherSignUpOptions extends StatelessWidget {
//   const OtherSignUpOptions({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 81,
//       width: 101,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Color(0XFFE8E8E8),
//       ),
//       child: Image.asset("assets/images/apple.png"),
//     );
//   }
// }
//
