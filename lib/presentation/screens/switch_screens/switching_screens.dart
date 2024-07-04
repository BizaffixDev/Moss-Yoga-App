import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/switch_screen_request_model.dart';
import 'package:moss_yoga/data/models/switch_screen_user_model.dart';
import 'package:moss_yoga/presentation/providers/app_providers.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';
import 'package:moss_yoga/presentation/providers/switch_screen_provider.dart';
import 'package:moss_yoga/presentation/screens/switch_screens/states/switch_states.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SwitchingScreen extends ConsumerStatefulWidget {
  SwitchScreenUser currentUserType;

  SwitchingScreen({Key? key, required this.currentUserType}) : super(key: key);

  @override
  ConsumerState<SwitchingScreen> createState() => _SwitchingScreenState();
}

class _SwitchingScreenState extends ConsumerState<SwitchingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    debugPrint(
        'This is the current userType Inside Switching Screens init ${widget.currentUserType.userType}');
    debugPrint('This is the current token ${widget.currentUserType.token}');
    debugPrint('This is the current id ${widget.currentUserType.id}');
    debugPrint('This is the current id ${widget.currentUserType.userName}');
    debugPrint(
        'This is the current userType ${widget.currentUserType.userType}');

    ///Make SwitchUser Object
    SwitchScreenRequestModel switchScreenRequestModel =
        SwitchScreenRequestModel(
            userId: widget.currentUserType.id,
            email: widget.currentUserType.userEmail,
            username: widget.currentUserType.userName,
            token: widget.currentUserType.token,
            userType: widget.currentUserType.userType);

    ///Check if its a Teacher or Student

    ///If Its a Teacher Call Send to Student Screen Api
    if (widget.currentUserType.userType == 'Teacher') {
      print(
          'Inside First API Call, Teacher user type, wants to turn into Student');

      ///Make the Api Call here
      Future.microtask(
        () async => await ref
            .read(swithcNotifierProvider.notifier)
            .switchToStudent(
                switchScreenRequestModel: switchScreenRequestModel),
      );
    }

    ///If Its a Student Call Send to Teacher Screen Api
    else if (widget.currentUserType.userType == 'Student') {
      print(
          'Inside First API Call, Student user type, wants to turn into Teacher');

      ///Make the Api Call here
      // Future.delayed(Duration(seconds: 1),{
      Future.microtask(
        () async => await ref
            .read(swithcNotifierProvider.notifier)
            .switchToTeacher(
                switchScreenRequestModel: switchScreenRequestModel),
      );
      // });
    }
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        // setState(() {});
      });
    controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(swithcNotifierProvider, (previous, screenState) {
      if (screenState is SwitchScreenSuccessfulSendToStudentState) {
        UIFeedback.showSnackBar(context, 'Switch Successful',
            height: 180, stateType: StateType.success);
        dismissLoading(context);
        setState(() {
          Future.delayed(const Duration(milliseconds: 500),
              () => GoRouter.of(context).go(PagePath.homeScreen));
        });
      } else if (screenState is SwitchScreenSuccessfulSendToTeacherState) {
        UIFeedback.showSnackBar(context, 'Switch Successful',
            height: 180, stateType: StateType.success);
        dismissLoading(context);
        setState(() {
          Future.delayed(const Duration(milliseconds: 500), () {
            GoRouter.of(context).go(PagePath.homeScreenTeacher);
          });
        });
      } else if (screenState is SwitchScreenErrorGoBackStudentState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);

          ///Pop back to the Home/Prev Screen
          Future.delayed(Duration(seconds: 2), () {
            context.go(PagePath.homeScreen);
          });
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);

          ///Pop back to the Home/Prev Screen
          Future.delayed(Duration(seconds: 2), () {
            context.go(PagePath.homeScreen);
          });
          // dismissLoading(context);
        } else {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);

          ///Pop back to the Home/Prev Screen
          Future.delayed(Duration(seconds: 2), () {
            context.go(PagePath.homeScreen);
          });
        }
      } else if (screenState is SwitchScreenErrorGoBackTeacherState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          print(
              'Inside unauthorized UI error SwitchScreenErrorGoBackTeacherState');
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);

          ///Pop back to the Home/Prev Screen
          Future.delayed(Duration(seconds: 2), () {
            context.go(PagePath.homeScreenTeacher);
          });
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);

          ///Pop back to the Home/Prev Screen
          Future.delayed(Duration(seconds: 2), () {
            context.go(PagePath.homeScreenTeacher);
          });
          // dismissLoading(context);
        } else {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);

          ///Pop back to the Home/Prev Screen
          debugPrint('Should go here context.go(PagePath.homeScreenTeacher);');
          Future.delayed(Duration(seconds: 2), () {
            context.go(PagePath.homeScreenTeacher);
          });
        }
      } else if (screenState is SwitchScreenLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });
    var currentUser = ref.read(currentPlatformProvider.notifier).state;
    String teacherSwitchText = 'Switching to Teacher';
    String studentSwitchText = 'Switching to Student';
    return Scaffold(
      backgroundColor: AppColors.splashColor,
      body: Container(
        width: 390.w,
        height: 844.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splsh_bg_upd.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Additional Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash_upd_layer.png',
                fit: BoxFit.cover,
              ),
            ),
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/images/splash_upd_layer.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Image.asset(
                  'assets/images/logo_upd_white.png',
                  width: 214,
                  height: 207,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 30,
                ),
                // const LogoText(),
                const SizedBox(
                  height: 28,
                ),
                Text(
                  currentUser == CurrentPlatform.Student
                      ? teacherSwitchText
                      : studentSwitchText,
                  style: kButtonTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  width: CommonFunctions.deviceHeight(context) * 0.35,
                  child: LinearProgressIndicator(
                    // minHeight: CommonFunctions.deviceHeight(context) * 0.6,
                    color: AppColors.progressBarColor,
                    backgroundColor: AppColors.progressBarColorBackground,
                    value: controller.value,
                    semanticsLabel: 'Moss Progress Bar',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 70),
      child: SvgPicture.asset(
        "assets/images/moss_yoga_text.svg",
        // width: 274,
        // height: 31,
      ),
    );
  }
}

// class SubText extends StatelessWidget {
//   const SubText({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Switching to Teacher',
//       style: kButtonTextStyle.copyWith(
//         color: Colors.white,
//         fontSize: 25,
//         fontWeight: FontWeight.w700,
//         fontFamily: GoogleFonts.manrope().fontFamily,
//       ),
//     );
//   }
// }
