import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/data/models/dual_login_user.dart';
import 'package:moss_yoga/presentation/providers/dual_login_provider.dart';
import 'package:moss_yoga/presentation/screens/auth/both_roles_exist/states/dual_login_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/screens/auth/choose_role/components/role_buttons.dart';
import '../../../../../data/models/user_role.dart';

class BothRolesExistScreen extends ConsumerStatefulWidget {
  BothRolesExistScreen({Key? key, required this.dualLoginUser})
      : super(key: key);
  DualLoginUser dualLoginUser;

  @override
  ConsumerState<BothRolesExistScreen> createState() =>
      _BothRolesExistScreenState();
}

class _BothRolesExistScreenState extends ConsumerState<BothRolesExistScreen> {
  bool isTapped1 = false;
  bool isTapped2 = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
        "This is the data gotten From LoginScreen: ${widget.dualLoginUser}");
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DualLoginStates>(dualLoginNotifierProvider,
        (previous, screenState) async {
      if (screenState is DualLoginSuccessfulStateStudent) {
        dismissLoading(context);
        setState(() {
          Future.delayed(const Duration(milliseconds: 500),
              () => GoRouter.of(context).go(PagePath.homeScreen));
        });
      } else if (screenState is DualLoginSuccessfulStateTeacher) {
        dismissLoading(context);
        setState(() {
          Future.delayed(const Duration(milliseconds: 500),
              () => GoRouter.of(context).go(PagePath.homeScreenTeacher));
        });
      } else if (screenState is DualLoginSuccessfulStateTeacherNotVerified) {
        dismissLoading(context);
        setState(() {
          Future.delayed(const Duration(milliseconds: 500),
              () => GoRouter.of(context).go(PagePath.homeScreenTeacherLocked));
        });
      } else if (screenState is DualLoginErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          // dismissLoading(context);
        } else {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      } else if (screenState is DualLoginLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 844.h,
        width: 390.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Drawables.selectRoleBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SvgPicture.asset(
                Drawables.appName,
              ),
            ),
            Container(
              height: 430.h,
              width: 390.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 34.h,
                  ),
                  //TODO: select your role tet
                  Text(
                    "Your Registered With Both Roles",
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    " Please Select One",
                    textAlign: TextAlign.center,
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  //Choose Role Container

                  RoleButtons(
                    id: 1,
                    icon: isTapped1
                        ? Drawables.teacherChooseRoleIconWhite
                        : Drawables.teacherChooseRoleIconBlack,
                    text: "Teacher",
                    border: Border.all(
                      color:
                          isTapped1 ? AppColors.white : AppColors.primaryColor,
                      width: 1,
                    ),
                    onTap: () async {
                      setState(() {
                        isTapped1 = !isTapped1;
                        isTapped2 = false;
                      });

                      ///Change the provider value to Teacher(Since user clicked on Teacher)
                      ref.read(userRoleProvider.notifier).state =
                          UserRoleModel(userRole: UserRole.Teacher);

                      ///Update the dual Login Variable with selected value(In this case Teacher)

                      widget.dualLoginUser.userType = ref
                          .read(userRoleProvider.notifier)
                          .state
                          .userRole
                          .name;

                      ///Call the api with passing in the latest values

                      await ref
                          .read(dualLoginNotifierProvider.notifier)
                          .loginWithOneRole(
                              dualLoginUser: widget.dualLoginUser);
                      debugPrint(ref
                          .read(userRoleProvider.notifier)
                          .state
                          .userRole
                          .name);
                      // GoRouter.of(context).push(PagePath.DualLoginScreenTeacher);
                      // GoRouter.of(context).go(PagePath.DualLoginScreenTeacher);
                    },
                    bgColor:
                        isTapped1 ? AppColors.primaryColor : AppColors.white,
                    txtColor:
                        isTapped1 ? AppColors.white : AppColors.primaryColor,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  RoleButtons(
                    id: 1,
                    icon: isTapped2
                        ? Drawables.studentChooseRoleIconWhite
                        : Drawables.studentChooseRoleIconBlack,
                    text: "Student",
                    border: Border.all(
                      color:
                          isTapped1 ? AppColors.white : AppColors.primaryColor,
                      width: 1,
                    ),
                    onTap: () async {
                      // setState(() {
                      setState(() {
                        isTapped2 = !isTapped2;
                        isTapped1 = false;
                      });

                      ///Change the provider value to student(Since user clicked on Student)
                      ref.read(userRoleProvider.notifier).state =
                          UserRoleModel(userRole: UserRole.Student);

                      ///Update the dual Login Variable with selected value(In this case Student)
                      widget.dualLoginUser.userType = ref
                          .read(userRoleProvider.notifier)
                          .state
                          .userRole
                          .name;

                      debugPrint(
                          "This is the user he selected ${ref.read(userRoleProvider.notifier).state.userRole.name}");

                      ///Call the api with passing in the latest values
                      await ref
                          .read(dualLoginNotifierProvider.notifier)
                          .loginWithOneRole(
                              dualLoginUser: widget.dualLoginUser);

                      // });
                      //
                      // Future.delayed(const Duration(milliseconds: 500),
                      //     () => GoRouter.of(context).go(PagePath.homeScreen));
                    },
                    bgColor:
                        isTapped2 ? AppColors.primaryColor : AppColors.white,
                    txtColor:
                        isTapped2 ? AppColors.white : AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
