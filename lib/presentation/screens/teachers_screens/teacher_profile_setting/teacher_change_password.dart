import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/presentation/providers/teachers_providers/teacher_account_provider.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/student_account_states.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_account_states.dart';
import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../common/app_specific_widgets/custom_text_field.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../providers/screen_state.dart';

class TeacherChangePassword extends ConsumerStatefulWidget {
  // String email;

  const TeacherChangePassword({
    Key? key,
    // required this.email
  }) : super(key: key);

  @override
  ConsumerState<TeacherChangePassword> createState() =>
      _StudentChangePasswordState();
}

class _StudentChangePasswordState extends ConsumerState<TeacherChangePassword> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool arePasswordsValid = false;

  bool isObscure1 = true;
  bool isObscure2 = true;
  bool isObscure3 = true;


  final FocusNode _currentPassFocusNode = FocusNode();
  final FocusNode _newPassFocusNode = FocusNode();
  final FocusNode _confirmPassFocusNode = FocusNode();



  // Initialize with an empty string


  _checkBothPasswords() {
    if (_confirmPassController.text.trim() == _newPassController.text.trim() &&
        _confirmPassController.text.trim().length >= 8 &&
        _newPassController.text.trim().length >= 8) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    _currentPassFocusNode.dispose();
    _newPassFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  /*_confirmPasswordChange() {
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
*/





  bool _apiCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {

        await ref.read(teacherAccountNotifierProvider.notifier).getTeacherData();

      });


    }
  }


  @override
  Widget build(BuildContext context) {

    ref.listen<TeacherAccountStates>(teacherAccountNotifierProvider, (previous, screenState) async {

      if (screenState is TeacherChangePasswordSuccessfulState) {
        dismissLoading(context);
        setState(() {});

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
                      children: [
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
                          height: 20,
                        ),
                        //cross icon
                        //Image.asset(),
                        const HeroIcon(HeroIcons.checkCircle, color: Color(0xff51563F),size: 50,),
                        const SizedBox(height: 20,),
                        const Text(
                          'Password Changed\nSuccessfully!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF202526),
                            fontSize: 22,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            // height: 26.40,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const SizedBox(
                          width: 313,
                          child: Text(
                            'Your account password has been updated, you can already login with your new password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF5A6981),
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              // height: 16.80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),

                        CustomButton(text: "Go Back", onTap: (){
                          context.pop();
                          context.pop();
                        })

                      ],
                    ),
                  ),
                ),
              );
            }
        );

      }


      else if (screenState is TeacherChangePasswordErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          // dismissLoading(context);
        }
        else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      }
      else if (screenState is  TeacherChangePasswordLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }


    });
    String userEmail =  ref.watch(teacherEmail.notifier).state;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: 844.h,
            width: 390.w,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(37),
                topRight: Radius.circular(37),
              ),
              image: DecorationImage(
                image: AssetImage(Drawables.authPlainBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        height: 780.h,
                        width: 390.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(37),
                            topRight: Radius.circular(37),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () => context.pop(),
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Change Password",
                                    style: manropeHeadingTextStyle.copyWith(
                                      fontSize: 21,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20.w,bottom: 5.h),
                                  child: const Text(
                                    'Current Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                //CURRENT PASSWORD
                                CustomTextField(
                                  m: 20.w,
                                  onChanged: (_) {

                                    setState(() {});
                                  },
                                  focusNode: _currentPassFocusNode,
                                  controller: _currentPassController,
                                  hintText: "Current Password",
                                  labelText: "Current Password",
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
                                Container(
                                  margin: EdgeInsets.only(left: 20.w,bottom: 5.h),
                                  child: const Text(
                                    'New Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                //NEW PASSWORD
                                CustomTextField(
                                  m:20.w,
                                  onChanged: (_) {

                                    setState(() {});
                                  },
                                  focusNode: _newPassFocusNode,
                                  controller: _newPassController,
                                  hintText: "Enter new password",
                                  labelText: "Enter new password",
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w,bottom: 5.h),
                                  child: const Text(
                                    'Re-enter Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                //CONFIRM PASSWORD
                                CustomTextField(
                                  m: 20.w,
                                  onChanged: (_) {

                                    setState(() {});
                                  },
                                  focusNode: _confirmPassFocusNode,
                                  controller: _confirmPassController,
                                  hintText: "Re-enter Password",
                                  labelText: "Re-enter Password",
                                  obscure: isObscure3,
                                  suffixIcon: isObscure3
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  obscureIconLogic: () {
                                    print(isObscure3);
                                    setState(() {
                                      isObscure3 = !isObscure3;
                                    });
                                  },
                                ),
                              ],
                            ),
                            _checkBothPasswords()
                                ? Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                children: [
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
                              m: 20.w,
                              text: "Save",
                              onTap: () async {






                                if(_currentPassController.text.isEmpty || _newPassController.text.isEmpty || _confirmPassController.text.isEmpty){

                                  _currentPassFocusNode.unfocus();
                                  _newPassFocusNode.unfocus();
                                  _confirmPassFocusNode.unfocus();
                                  UIFeedback.showSnackBar(context, "Please provide all details",height: 150);
                                }else if(_newPassController.text != _confirmPassController.text){
                                  _currentPassFocusNode.unfocus();
                                  _newPassFocusNode.unfocus();
                                  _confirmPassFocusNode.unfocus();
                                  UIFeedback.showSnackBar(context, "Password does not match",height: 150);
                                }
                                else if(_newPassController.text.length <8){
                                  _currentPassFocusNode.unfocus();
                                  _newPassFocusNode.unfocus();
                                  _confirmPassFocusNode.unfocus();
                                  UIFeedback.showSnackBar(context, "Password must be at least 8 characters long",height: 150);
                                }
                                else{

                                  _currentPassFocusNode.unfocus();
                                  _newPassFocusNode.unfocus();
                                  _confirmPassFocusNode.unfocus();

                                  await ref
                                      .read(teacherAccountNotifierProvider
                                      .notifier)
                                      .changePassword(
                                    email: userEmail,
                                    currentpasswd: _currentPassController.text.trim(),
                                    changepasswd: _newPassController.text.trim(),
                                    reenterpasswd: _confirmPassController.text.trim(),
                                  );
                                }
                              },
                              btnColor: AppColors.primaryColor,
                              textColor: AppColors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
