import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/login/components/welcome_text.dart';
import 'package:moss_yoga/presentation/screens/auth/login/states/login_states.dart';
import '../../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../../common/app_specific_widgets/custom_rich_text.dart';
import '../../../../../common/app_specific_widgets/custom_text_field.dart';
import '../../../../../common/app_specific_widgets/social_login.dart';
import 'forgot_password_text.dart';
import 'or_login_with_text.dart';

class Body extends ConsumerStatefulWidget {
  const Body({
    super.key,
  });

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    ref.read(userRoleProvider.notifier).state.userRole.name;
    print(
        "user Role ===   ${ref.read(userRoleProvider.notifier).state.userRole.name}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      if (screenState is GoogleLoginErrorState) {
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
      } else if (screenState is LoginErrorState) {
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
      } else if (screenState is GoogleLoginLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is LoginLoadingState) {
        debugPrint('Loading');
        showLoading(context);
      } else if (screenState is LoginSuccessfulState) {
        dismissLoading(context);
        GoRouter.of(context).go(PagePath.homeScreen);
      } else if (screenState is LoginSuccessfulBothUserTypesState) {
        var user = screenState.loginResponseModel;
        var userType = screenState.loginResponseModel.userType;
        // var userName = screenState.loginResponseModel.username;
        // var userToken = screenState.loginResponseModel.token;
        // var userEmail = screenState.loginResponseModel.email;
        print(
            'This user is of both types sending them to the selection type role screen');
        dismissLoading(context);
        GoRouter.of(context).go(
            '${PagePath.loginBothUserExists}?userType=$userType&userId=${user.userId}&userToken=${user.token}&userEmail=${user.email}');
        // GoRouter.of(context).go(PagePath.loginBothUserExists);
      } else if (screenState is AuthSuccessfulGoogleLoginBothUserExistInState) {
        var user = screenState.loginResponseModel;
        var userType = screenState.loginResponseModel.userType;
        // var userName = screenState.loginResponseModel.username;
        // var userToken = screenState.loginResponseModel.token;
        // var userEmail = screenState.loginResponseModel.email;
        print(
            'This user is of both types sending them to the selection type role screen');
        dismissLoading(context);
        GoRouter.of(context).go(
            '${PagePath.loginBothUserExists}?userType=$userType&userId=${user.userId}&userToken=${user.token}&userEmail=${user.email}');
        // GoRouter.of(context).go(PagePath.loginBothUserExists);
      } else if (screenState is LoginSuccessfulTeacherState) {
        dismissLoading(context);

        ///Put Condition here to check if verified or not then send it to their respective screens.
        if (screenState.isVerified == true) {
          print('isVerified is TRUE so sending to teacher locked screens');
          GoRouter.of(context).go(PagePath.homeScreenTeacher);
        } else {
          print('isVerified is FALSE so sending to teacher locked screens');
          GoRouter.of(context).go(PagePath.homeScreenTeacherLocked);
        }
      }

      ///From Google Login to Teacher Screen (Conditions below)
      else if (screenState is AuthSuccessfulGoogleTeacherLoginInState) {
        dismissLoading(context);

        ///Put Condition here to check if verified or not then send it to their respective screens.
        if (screenState.isVerified == true) {
          print('isVerified is TRUE so sending to teacher Verified screen');
          GoRouter.of(context).go(PagePath.homeScreenTeacher);
        } else {
          print('isVerified is FALSE so sending to teacher locked screen');
          GoRouter.of(context).go(PagePath.homeScreenTeacherLocked);
        }
      }

      ///From Google Login to Student Screen
      else if (screenState is AuthSuccessfulGoogleStudentLoginInState) {
        print('Inside AuthSuccessfulGoogleStudentLoginInState yay');
        dismissLoading(context);
        GoRouter.of(context).go(PagePath.homeScreen);
      }
    });

    return Scaffold(
      // backgroundColor: Colors.white,
      //This is the main container having the image as background
      body: SingleChildScrollView(
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
              Image.asset(
                "assets/images/login_bg_texture.png",
                fit: BoxFit.cover,
              ),
              //Arrow back Icon Button

              //Welcome Text

              const WelcomeText(),

              /*  const Positioned(
                    top: 100,
                    left: 32,
                    child: WelcomeText()),*/

              // white COntainer having all textfields and buttons
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    //height: CommonFunctions.deviceHeight(context) * 0.65,
                    height: 563.h,
                    width: 390.w,
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

                          //Email TextField
                          CustomTextField(
                            focusNode: _emailFocusNode,
                            controller: _emailController,
                            hintText: "Enter Email Here",
                            labelText: "Email",
                            textInputAction: TextInputAction.next,
                            obscure: false,
                            onSubmit: () {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          SizedBox(
                            height: 20.h,
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

                          const ForgotPasswordText(),

                          SizedBox(
                            height: 30.h,
                          ),

                          //Login Button
                          CustomButton(
                            btnColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            text: "Login",
                            onTap: () async {
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                UIFeedback.showSnackBar(
                                    context, "Email and Password is required",
                                    stateType: StateType.error);
                              } else {
                                _passwordFocusNode.unfocus();
                                _emailFocusNode.unfocus();
                                var loggingIn = await ref
                                    .read(authNotifyProvider.notifier)
                                    .login(context,
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim());

                                debugPrint("This is the response$loggingIn");
                              }
                            },
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          ORLoginWithText(
                            isLogin: true,
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialLogin(
                                icon: Drawables.appleIcon,
                                onTap: () {},
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              SocialLogin(
                                  icon: Drawables.googleIcon,
                                  onTap: () async {
                                    _passwordFocusNode.unfocus();
                                    _emailFocusNode.unfocus();
                                    // if (_emailController.text.isEmpty ||
                                    //     _passwordController.text.isEmpty) {
                                    //   UIFeedback.showSnackBar(
                                    //       context, "Email and Password is required");
                                    // } else {
                                    var loggingIn = await ref
                                        .read(authNotifyProvider.notifier)
                                        .loginWithGoogle(context);
                                    debugPrint(
                                        "This is the response$loggingIn");
                                  }
                                  // },
                                  ),
                            ],
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          CustomRichText(
                            text1: "Don't have an account? ",
                            text2: "Sign up here",
                            onTap: () {
                              // ref.read(userRoleProvider.notifier).state.userRole.name == "Student"?
                              // context.push(PagePath.signUp) :
                              // context.push(PagePath.signUpTeacher);

                              context.push(PagePath.chooseRole);
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
