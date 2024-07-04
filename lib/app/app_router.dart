import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/data/models/dual_login_user.dart';
import 'package:moss_yoga/data/models/switch_screen_user_model.dart';
import 'package:moss_yoga/presentation/screens/auth/both_roles_exist/both_role_exists_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/choose_role/choose_role_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/forgot_password/otp_verfication/forgot_otp_verification.dart';
import 'package:moss_yoga/presentation/screens/auth/login/login_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/on_boarding/on_boarding_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/reset_password/reset_password_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/stepper/steps/chroinic_list.dart';
import 'package:moss_yoga/presentation/screens/auth/stepper/steps/step3.dart';
import 'package:moss_yoga/presentation/screens/auth/stepper/steps/step2.dart';
import 'package:moss_yoga/presentation/screens/auth/stepper/steps/step4.dart';
import 'package:moss_yoga/presentation/screens/auth/stepper/steps/step5.dart';
import 'package:moss_yoga/presentation/screens/auth/stepper/steps/trauma.dart';
import 'package:moss_yoga/presentation/screens/auth/teacher_reg_process/about_education/about_body.dart';
import 'package:moss_yoga/presentation/screens/auth/teacher_reg_process/about_education/education_body.dart';
import 'package:moss_yoga/presentation/screens/auth/teacher_reg_process/about_education/success.dart';
import 'package:moss_yoga/presentation/screens/auth/teacher_reg_process/teacher_reg_process.dart';
import 'package:moss_yoga/presentation/screens/auth/terms_and_condition/terms_and_condition_screen.dart';
import 'package:moss_yoga/presentation/screens/auth/splash_screen.dart';
import 'package:moss_yoga/presentation/screens/bottom_navigation_bar.dart';
import 'package:moss_yoga/presentation/screens/help_and_support/faqs.dart';
import 'package:moss_yoga/presentation/screens/help_and_support/feedback.dart';
import 'package:moss_yoga/presentation/screens/help_and_support/learn_about_moss_yoga.dart';
import 'package:moss_yoga/presentation/screens/payment_methods/payment_mrthod_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/lobby_student/lobby_student_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/available_teachers_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/my_classes_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/view_details_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/on_demand/on_demand_request_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/on_demand/on_demand_states/on_demand_request_accept_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/poses/all_poses_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/styles/all_styles_screen.dart';

import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/student_delete_account.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/student_my_account.dart';
import 'package:moss_yoga/presentation/screens/switch_screens/switching_screens.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/earnings/earnings_screen.dart';

import 'package:moss_yoga/presentation/screens/teachers_screens/home/home_screen_teacher.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/lobby_teacher/lobby_teacher_screen.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/my_classes/my_classes_screen.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/my_classes/my_classes_screen_locked.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/on_demand/on_demand_teacher_locked_screen.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/on_demand/on_demand_teacher_screen.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/schedule/select_time.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/session_details/session_detail_screen.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_delete_account.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_my_account.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_profile.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_settings.dart';

import '../presentation/screens/auth/forgot_password/forgot_password_screen.dart';
import '../presentation/screens/auth/stepper/steps/physical_list.dart';
import '../presentation/screens/auth/stepper/steps/step1.dart';
import '../presentation/screens/auth/verify_email/verify_email_screen.dart';
import '../presentation/screens/guide/detail_screen/guide_detail_screen.dart';
import '../presentation/screens/guide/detail_screen/pose_detail_screen.dart';
import '../presentation/screens/guide/detail_screen/style_detail_screen.dart';
import '../presentation/screens/guide/guide_screen.dart';
import '../presentation/screens/help_and_support/help_and_support.dart';
import '../presentation/screens/students_screens/home/home_screen.dart';
import '../presentation/screens/students_screens/lobby_student/agora_video_screen_student.dart';
import '../presentation/screens/students_screens/my_classes/components/reschedule_class_screen.dart';
import '../presentation/screens/students_screens/my_teacher/my_teachers_tab.dart';
import '../presentation/screens/students_screens/notification_screen/notification_student_screen.dart';
import '../presentation/screens/students_screens/on_demand/on_demand.dart';
import '../presentation/screens/students_screens/student_profile_setting/student_change_passwd.dart';
import '../presentation/screens/students_screens/student_profile_setting/student_profile.dart';
import '../presentation/screens/students_screens/student_profile_setting/student_settings.dart';
import '../presentation/screens/students_screens/teacherDetail/teacher_detail_screen.dart';
import '../presentation/screens/students_screens/top_rated_teachers/top_rated_teachers_screen.dart';
import '../presentation/screens/teacher_locked_screens/home/home_screen_teacher_locked.dart';
import '../presentation/screens/teacher_navigation_bar.dart';
import '../presentation/screens/teachers_screens/my_classes/view_details_screen.dart';
import '../presentation/screens/teachers_screens/notifications/notification_teacher_screen.dart';
import '../presentation/screens/teachers_screens/poses/all_poses_teacher_Screen.dart';
import '../presentation/screens/teachers_screens/schedule/select_date.dart';
import '../presentation/screens/teachers_screens/sign_up_teacher/sign_up_teacher_screen.dart';
import '../presentation/screens/teachers_screens/styles/all_styles_teacher_screen.dart';
import '../presentation/screens/teachers_screens/teacher_profile_setting/teacher_change_password.dart';
import '../presentation/screens/teachers_screens/verify_email_teacher/verify_email_teacher.dart';

///Global Key for the navigation
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
// final globalContext = _rootNavigatorKey.currentContext;
final _shellStudentNavigatorKey = GlobalKey<NavigatorState>();
final _shellTeacherNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<OverlayState> overlayState = GlobalKey<OverlayState>();

class AppRouter {
  AppRouter._();

  /// Background App is Live
  /// Background App is Dead(Notification late, but will open the app)
  /// Foreground notification.
  /// In App Messaging.
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: PagePath.splash,
    routes: [
      ///Student
      ShellRoute(
          navigatorKey: _shellStudentNavigatorKey,
          pageBuilder: (context, state, child) {
            // Here's where you can decide whether to show the bottom navigation bar
            bool showBottomNavBar = false;
            debugPrint("showBottomNavBar: $showBottomNavBar");
            String fullPath = state.fullPath ?? '';
            if (fullPath.startsWith(PagePath.homeScreen)) {
              debugPrint(
                  "HomeScreen: ${state.uri.toString()}, ${state.name}, $fullPath");
              showBottomNavBar = true;
            } else if (fullPath.startsWith(PagePath.onDemandScreen)) {
              debugPrint(
                  "OnDemandScreen: ${state.uri.toString()}, ${state.name}, $fullPath");
              showBottomNavBar = true;
            } else if (fullPath.startsWith(PagePath.myTeachers)) {
              debugPrint(
                  "MyTeachers: ${state.uri.toString()}, ${state.name}, $fullPath");
              showBottomNavBar = true;
            } else {
              debugPrint(
                  "Default: ${state.uri.toString()}, ${state.name}, ${fullPath}");
              showBottomNavBar = false;
            }

            // switch (state.fullPath) {
            //   case PagePath.homeScreen:
            //     debugPrint(
            //         "HomeScreen: ${state.uri.toString()}, ${state.name}, ${state.fullPath}");
            //     showBottomNavBar = true;
            //     break;
            //   case PagePath.onDemandScreen:
            //     debugPrint(
            //         "OnDemandScreen: ${state.uri.toString()}, ${state.name}, ${state.fullPath}");
            //     showBottomNavBar = true;
            //     break;
            //   case PagePath.myTeachers:
            //     debugPrint(
            //         "MyTeachers: ${state.uri.toString()}, ${state.name}, ${state.fullPath}");
            //     showBottomNavBar = false;
            //     break;
            //   default:
            //     debugPrint(
            //         "Default: ${state.uri.toString()}, ${state.name}, ${state.fullPath}");
            //     showBottomNavBar = false;
            // }

            debugPrint("This is the uri: ${state.uri.toString()}");
            debugPrint("This is the name: ${state.name.toString()}");
            debugPrint("This is the fullPAth: ${state.fullPath.toString()}");
            return NoTransitionPage(
              child: showBottomNavBar
                  ? StudentBottomNavBar(
                      location: state.uri.toString(),
                      child: child,
                    )
                  : child, // don't show StudentBottomNavBar for other pages
            );
          },
          routes: [
            GoRoute(
              path: PagePath.homeScreen,
              parentNavigatorKey: _shellStudentNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: HomeScreen(),
                );
              },
            ),
            GoRoute(
              path: PagePath.onDemandScreen,
              parentNavigatorKey: _shellStudentNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: OnDemandScreen(),
                );
              },
            ),
            GoRoute(
                parentNavigatorKey: _shellStudentNavigatorKey,
                path: PagePath.myTeachers,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: MyTeachersScreen(),
                  );
                }),
          ]),


      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: PagePath.topRatedTeachers,
        pageBuilder: (context, state) {
          debugPrint("This is topRatedTeachers ${state.fullPath}");
          return const NoTransitionPage(child: TopRatedTeachersScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),
      GoRoute(
          path: PagePath.myClassesStudent,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final queryParams = state.uri.queryParameters;
            //final date = queryParams['Date'];
            //final id = queryParams['teacherId'];
            return const NoTransitionPage(
              child: MyClassesStudentScreen(
                  //date: date!,
                  // id: int.parse(id!),
                  ),
            );
          }),

      GoRoute(
          path: PagePath.availableTeachers,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            // final queryParams = state.uri.queryParameters;
            //final date = queryParams['Date'];
            //final id = queryParams['teacherId'];
            return const NoTransitionPage(
              child: AvailableTeachersScreen(
                  //date: date!,
                  // id: int.parse(id!),
                  ),
            );
          }),

      GoRoute(
          path: PagePath.viewDetailsTeacher,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final queryParams = state.uri.queryParameters;
            // final date = queryParams['date'];
            // final studentName = queryParams['studentName'];
            // final time = queryParams['time'];
            // final budget = queryParams['price'];
            // final day = queryParams['day'];
            // final slot = queryParams['slot'];

            return const NoTransitionPage(
              child: ViewDetailsTeacher(
                  /* studentName: studentName ?? '',
                time: time ?? '',
                slot: slot ?? '',
                date: date ?? '',
                budget:budget ?? '',
                day: day ?? '',*/
                  //date: date!,
                  // id: int.parse(id!),
                  ),
            );
          }),

      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: PagePath.viewDetailsStudent,
          pageBuilder: (context, state) {
            // final queryParams = state.uri.queryParameters;
            //final date = queryParams['Date'];
            //final id = queryParams['teacherId'];
            return const NoTransitionPage(
              child: ViewDetailsStudent(
                  //date: date!,
                  // id: int.parse(id!),
                  ),
            );
          }),

      ///teacher
      ShellRoute(
          navigatorKey: _shellTeacherNavigatorKey,
          pageBuilder: (context, state, child) {
            debugPrint(state.uri.toString());
            return NoTransitionPage(
              child: TeacherBottomNavBar(
                location: state.uri.toString(),
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: PagePath.homeScreenTeacher,
              parentNavigatorKey: _shellTeacherNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: HomeScreenTeacher(),
                );
              },
            ),
            GoRoute(
              path: PagePath.onDemandTeacher,
              parentNavigatorKey: _shellTeacherNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: OnDemandTeacherScreen(),
                );
              },
            ),
            GoRoute(
              path: PagePath.homeScreenTeacherLocked,
              parentNavigatorKey: _shellTeacherNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: HomeScreenTeacherLocked(),
                );
              },
            ),
            GoRoute(
              path: PagePath.onDemandTeacherLocked,
              parentNavigatorKey: _shellTeacherNavigatorKey,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: OnDemandTeacherScreenLocked(),
                );
              },
            ),
            GoRoute(
                parentNavigatorKey: _shellTeacherNavigatorKey,
                path: PagePath.myClassesTeacherLocked,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: MyClassesScreenLocked(),
                  );
                }),
            GoRoute(
                parentNavigatorKey: _shellTeacherNavigatorKey,
                path: PagePath.myClassesTeacher,
                pageBuilder: (context, state) {
                  final queryParams = state.uri.queryParameters;
                  // final date = queryParams['Date'];
                  // final id = queryParams['teacherId'];

                  return const NoTransitionPage(
                    child: MyClassesTeacherScreen(),
                  );
                }),
          ]),

      // GoRoute(
      //   path: PagePath.notification,
      //   builder: (context, state) => NotificationsScreen(),
      // ),

      GoRoute(
        path: PagePath.lobbyWaitStudent,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final teacherName = queryParams['teacherName'];
          final yogaStyle = queryParams['yogaStyle'];
          final country = queryParams['country'];
          final channelName = queryParams['channelName'];
          return LobbyWaitStudent(
            teacherName: teacherName,
            yogaStyle: yogaStyle,
            country: country,
            channelName: channelName,
          );
        },
      ),

      GoRoute(
          path: PagePath.agoraVideoScreen,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final queryParams = state.uri.queryParameters;
            final channelName = queryParams['channelName']!;
            final userName = queryParams['userName']!;
            final uid = queryParams['uid']!;
            print(" This is the channel Name$channelName");
            print(" This is the user Name$userName");
            print(" This is the user id$uid");
            return AgoraVideoScreenStudent(
              channelName: channelName,
              userName: userName,
              uid: int.parse(uid),
            );
          }),

      GoRoute(
        path: PagePath.lobbyWaitTeacher,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final studentName = queryParams['studentName'];
          final chronicConditions = queryParams['chronicConditions'];
          final trauma = queryParams['trauma'];
          final channelName = queryParams['channelName'];
          return LobbyWaitTeacher(
            studentName: studentName,
            chronicConditions: chronicConditions,
            trauma: trauma,
            channelName: channelName,
          );
        },
      ),

      GoRoute(
        path: PagePath.earnings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final teacherId = queryParams['teacherId'] as String;
          return   EarningScreen(
            teacherId: teacherId,
          );
        }
      ),

      GoRoute(
        path: PagePath.notificationStudent,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationStudentScreen(),
      ),

      GoRoute(
        path: PagePath.notificationTeacher,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationTeacherScreen(),
      ),

      // GoRoute(
      //   path: PagePath.notifyScreenFill,
      //   parentNavigatorKey: rootNavigatorKey,
      //   builder: (context, state) => const NotifyScreenFill(),
      // ),

      GoRoute(
        path: PagePath.onBoarding,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: OnBoardingScreen());
        },
        // builder: (context, state) => OnBoardingScreen(),
      ),

      GoRoute(
        path: PagePath.login,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: SignInScreen());
        },
        //builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: PagePath.loginBothUserExists,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final userType = queryParams['userType']!;
          debugPrint("This is the userType in the router $userType");
          final userId = queryParams['userId']!;
          final userToken = queryParams['userToken']!;
          final userEmail = queryParams['userEmail']!;
          debugPrint('This is the user type received in router $userType');
          // Here I reconstruct the SwitchScreenUser object

          final dualLoginUser = DualLoginUser(
            userType: userType,
            id: int.parse(userId),
            token: userToken,
            email: userEmail,
          );
          return NoTransitionPage(
            child: BothRolesExistScreen(
              dualLoginUser: dualLoginUser,
            ),
          );
        },
        //builder: (context, state) => SignInScreen(),
      ),

      GoRoute(
        path: PagePath.signUp,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: SignUpSreen());
        },
        // builder: (context, state) => SignUpSreen(),
      ),

      GoRoute(
        path: PagePath.signUpTeacher,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: SignUpTeacherScreen());
        },
        // builder: (context, state) => SignUpSreen(),
      ),
      GoRoute(
        path: PagePath.terms,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TermsAndConditionScreen());
        },
        //builder: (context, state) => TermsAndConditionScreen(),
      ),
      GoRoute(
        path: PagePath.chooseRole,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ChooseRoleScreen());
        },
        //builder: (context, state) => ChooseRoleScreen(),
      ),

      GoRoute(
        path: PagePath.forgotPassword,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ForgotPasswordScreen());
        },
        //builder: (context, state) => ChooseRoleScreen(),
      ),
      GoRoute(
        path: PagePath.verifyEmailStudent,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final email = queryParams['email'] as String;
          return NoTransitionPage(
              child: VerifyEmailScreen(
            email: email,
          ));
        },
        //builder: (context, state) => VerifyEmailScreen(),
      ),

      GoRoute(
        path: PagePath.verifyEmailTeacher,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final email = queryParams['email'] as String;
          return NoTransitionPage(
              child: VerifyEmailTeacherScreen(
            email: email,
          ));
        },
        //builder: (context, state) => VerifyEmailScreen(),
      ),

      GoRoute(
        path: PagePath.resetPassword,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final email = queryParams['email'] as String;
          // final testEmail = '2pt2z7qp@icznn.com';
          return NoTransitionPage(child: ResetPasswordScreen(email: email));
        },
        //builder: (context, state) => ChooseRoleScreen(),
      ),

      GoRoute(
        path: PagePath.forgotOtpVerification,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final email = queryParams['email'] as String;
          return NoTransitionPage(
              child: ForgotOtpVerfication(
            email: email,
          ));
        },
        //builder: (context, state) => ChooseRoleScreen(),
      ),

      GoRoute(
        path: PagePath.intention,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: IntentionsStepView());
        },
        //builder: (context, state) => IntentionStepView(),
      ),
      GoRoute(
        path: PagePath.level,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: LevelsStepView());
        },
        //builder: (context, state) => LevelStepView(),
      ),

      GoRoute(
        path: PagePath.chronicQuestion,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ChronicConditionQuestionStep());
        },
        //builder: (context, state) => ChronicConditionQuestionStep(),
      ),

      GoRoute(
        path: PagePath.chronicList,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ChronicListStep());
        },
        // builder: (context, state) => ChronicListStep(),
      ),

      GoRoute(
        path: PagePath.injuryQuestion,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: InjuryQuestionStep());
        },
        //builder: (context, state) => PhysicalConditionQuestionStep(),
      ),

      GoRoute(
        path: PagePath.physicalList,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: PhysicalListStep());
        },
        //builder: (context, state) => PhysicalListStep(),
      ),

      GoRoute(
        path: PagePath.traumaQuestion,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TraumaConditionQuestionStep());
        },
        //builder: (context, state) => PhysicalListStep(),
      ),

      GoRoute(
        path: PagePath.trauma,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TraumatStep());
        },
        //builder: (context, state) => PhysicalListStep(),
      ),

      GoRoute(
        path: PagePath.verifyEmailStudent,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final email = queryParams['email'] as String;
          return NoTransitionPage(
              child: VerifyEmailScreen(
            email: email,
          ));
        },
        //builder: (context, state) => VerifyEmailScreen(),
      ),
      GoRoute(
          path: PagePath.TeacherDetail,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final queryParams = state.uri.queryParameters;
            final userId = queryParams['userid'] as String;
            return NoTransitionPage(
              child: TeacherDetailScreen(
                teacherId: int.parse(userId),
              ),
            );
          }
          //builder: (context, state) => TeacherDetailScreen(),
          ),

      GoRoute(
          path: PagePath.RescheduleTeacherDetail,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final queryParams = state.uri.queryParameters;
            final bookingId = queryParams['bookingId'] as String;
            return NoTransitionPage(
              child: RescheduleClassDetailScreen(
                bookingId: bookingId,
              ),
            );
          }
          //builder: (context, state) => TeacherDetailScreen(),
          ),

      GoRoute(
        path: PagePath.sessionDetailTeacher,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SessionDetailScreen(),
      ),

      GoRoute(
        path: PagePath.studentProfileScreen,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => StudentProfileScreen(),
      ),

      GoRoute(
        path: PagePath.teacherProfileScreen,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => TeacherProfileScreen(),
      ),

      GoRoute(
        path: PagePath.PayemntMethod,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          var teacherId = state.uri.queryParameters['teacherId'];
          print('this is the teacherId going into Payment Screen $teacherId');
          return NoTransitionPage(
            child: PaymentMethodScreen(
              teacherId: int.parse(teacherId!),
            ),
          );
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherRegProcess,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherRegProcess());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherRegProcessSuccess,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherRegProcessSuccess());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherRegProcessAbout,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherRegProcessAbout());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherRegProcessEducation,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherRegProcessEducation());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.scheduleDate,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ScheduleDateScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: PagePath.scheduleTime,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: ScheduleTimeScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.guide,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: GuideScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.styleDetailGuide,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final id = queryParams['id'] as String;
          return NoTransitionPage(
              child: StyleSingleDetailScreen(
            id: int.parse(id),
          ));
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.posesDetailGuide,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final id = queryParams['id'] as String;
          return NoTransitionPage(
              child: PosesSingleDetailScreen(
            id: int.parse(id),
          ));
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.guideDetail,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final id = queryParams['id'] as String;
          final type = queryParams['type'] as String;
          return NoTransitionPage(
              child: GuideSingleDetailScreen(
            id: int.parse(id),
            type: type,
          ));
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.onDemandStudentRequest,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final teacherId = queryParams['teacherId'];
          print('teacherId is inside app router $teacherId');
          return NoTransitionPage(
              child: OnDemandRequestScreen(teacherId: teacherId!));
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.onDemandStudentRequestAccept,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: OnDemandRequestAcceptScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.studentSetting,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: StudentSettings());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherSetting,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherSettings());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.studentChangePassword,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: StudentChangePassword());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherChangePassword,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherChangePassword());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.studentMyAccount,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: StudentMyAccount());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherMyAccount,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherMyAccount());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.studentDeleteAccount,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: StudentDeleteAccount());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.teacherDeleteAccount,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: TeacherDeleteAccount());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.helpandSupport,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: HelpAndSupportScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.learnAboutMossYoga,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: LearnAboutMossYoga());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.feedback,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: FeedbackScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.faq,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: FaqScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      // GoRoute(
      //   path: PagePath.splash,
      //   builder: (context, state) => const SplashScreen(),
      GoRoute(
        path: PagePath.splash,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        path: PagePath.posesViewAll,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: PosesAllScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.stylesViewAll,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: StylesAllScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.posesViewAllTeacher,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: PosesAllTeacherScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.stylesViewAllTeacher,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: StylesAllTeacherScreen());
        },
        //builder: (context, state) => PaymentMethodScreen(),
      ),

      GoRoute(
        path: PagePath.switching,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final queryParams = state.uri.queryParameters;
          final userType = queryParams['userType'];
          final userId = queryParams['userId'];
          final userToken = queryParams['userToken'];
          final userEmail = queryParams['userEmail'];
          final userName = queryParams['userName'];
          debugPrint('This is the user type received in router $userType');
          // Here I reconstruct the SwitchScreenUser object
          final currentUserType = SwitchScreenUser(
              userType!, int.parse(userId!), userToken!, userEmail!, userName!);
          return NoTransitionPage(
            child: SwitchingScreen(
              currentUserType: currentUserType,
            ),
          );
        },
        // builder: (context, state) => SwitchingScreen(),
      ),
    ],
  );
}
