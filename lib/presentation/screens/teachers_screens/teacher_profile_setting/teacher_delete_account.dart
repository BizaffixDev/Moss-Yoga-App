import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/teachers_providers/teacher_account_provider.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/student_account_states.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_account_states.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../providers/screen_state.dart';

class TeacherDeleteAccount extends ConsumerStatefulWidget {
  const TeacherDeleteAccount({super.key});

  @override
  ConsumerState<TeacherDeleteAccount> createState() => _StudentDeleteAccountState();
}

class _StudentDeleteAccountState extends ConsumerState<TeacherDeleteAccount> {



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

      if (screenState is TeacherDeleteAccountSuccessfulState) {
        dismissLoading(context);
        setState(() {});

        context.go(PagePath.login);
      }


      else if (screenState is TeacherDeleteAccountErrorState) {
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
      else if (screenState is  TeacherDeleteAccountLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }


    });
    int userId =  ref.watch(teacherId.notifier).state;

    return Scaffold(
      body: Container(
        height: 844.h,
        width: 390.w,
        decoration: BoxDecoration(
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 20.h),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:(){
                              context.pop();
                            },
                            child: HeroIcon(
                              HeroIcons.arrowLeft,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Color(0xFF202526),
                              fontSize: 21,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              // height: 26.40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        width: 319,
                        child: Text(
                          'Please remember that this action is irreversible. Once your account is deleted, all your data including your workout history, progress, and any premium membership benefits will be permanently removed from Moss Yoga App.',
                          style: TextStyle(
                            color: Color(0xFF232323),
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            //  height: 22.40,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        width: 319,
                        child: Text(
                          'Incase youre experiencing any issues with our app or have any suggestions for improvements, we would love to hear from you. Contact our Support Team before you decide to leave us.',
                          style: TextStyle(
                            color: Color(0xFF232323),
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            // height: 22.40,
                          ),
                        ),
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'Delete Account',
                        onTap: (){
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
                                          HeroIcon(HeroIcons.trash, color: Color(0xff51563F),size: 70,),
                                          SizedBox(height: 20,),
                                          Text(
                                            'Are you sure you want to delete\nyour account?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF202526),
                                              fontSize: 20,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w700,
                                              // height: 24,
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          CustomButton(
                                            text: 'Cancel',
                                            onTap: (){},
                                            btnColor: Color(0xff51563F),
                                            textColor: Colors.white,
                                          ),
                                          SizedBox(height: 20,),
                                          InkWell(
                                            child: Text(
                                              'Yes, delete my account',
                                              style: TextStyle(
                                                color: Color(0xFF202526),
                                                fontSize: 16,
                                                fontFamily: 'Manrope',
                                                fontWeight: FontWeight.w700,
                                                // height: 19.20,
                                              ),
                                            ),
                                            onTap: (){
                                              ref.read(teacherAccountNotifierProvider.notifier).deleteAccount(userId: userId);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        btnColor: const Color(0xffC62828),
                        textColor: const Color(0xffFFFFFF),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
