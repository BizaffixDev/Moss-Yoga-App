import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/di/injector.dart';
import 'package:moss_yoga/presentation/providers/app_providers.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:moss_yoga/presentation/providers/teachers_providers/home_teacher_provider.dart';

import '../../app/utils/preference_manager.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/switch_screen_user_model.dart';
import '../resources/colors.dart';
import '../resources/text_styles.dart';

class DrawerTeacher extends ConsumerStatefulWidget {
  const DrawerTeacher({super.key});

  @override
  ConsumerState<DrawerTeacher> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends ConsumerState<DrawerTeacher> {
  late UserLocalDataSource userLocalDataSource;

  String userEmail = ''; //
  String userName = ''; //

  _loadUserData() async {
    // Load user data from preferences
    LoginResponseModel? user = await userLocalDataSource.getUser();
    if (user != null) {
      // User data exists, you can access it using the 'user' object
      // Now, 'user.email' will give you the user's email
      setState(() {
        userEmail = user.email; // Update the userEmail state variable
        userName = user.username; // Update the userEmail state variable
      });
    } else {
      // User data not found in preferences
      setState(() {
        userEmail =
            ''; // Update the userEmail state variable with an empty string
        userName =
            ''; // Update the userEmail state variable with an empty string
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLocalDataSource = UserLocalDataSourceImpl(
      preferencesManager: SecurePreferencesManager(),
    );
    _loadUserData();
  }

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(homeNotifierTeacherProvider.notifier).getTeacherData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int userId = ref.watch(teacherIdProvider.notifier).state;
    String name = ref.watch(nameProvider.notifier).state;
    String email = ref.watch(emailProvider.notifier).state;
    return Drawer(
      backgroundColor: Color(0xFF272727),
      child: ListView(
        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: 17.w,vertical: 30.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 94.h,
                  width: 94.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/student_avatar.png',),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Adjust the spacing between the profile picture and the name
                Text(
                  "${ref.watch(teacherObjectProvider).username == '' ? '' : '${ref.watch(teacherObjectProvider).username}'}",
                  style:manropeHeadingTextStyle.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),


          Padding(
            padding:  EdgeInsets.only(left: 40.w),
            child: Divider(color: Colors.white,),
          ),
          const SizedBox(height: 10),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading:
                  const Icon(Icons.person_outline_rounded, color: Colors.white),
              title:  Text(
                'My Profile',
                style: manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                // Handle drawer item tap
                // context.push(PagePath.studentProfileScreen);
                context.push(PagePath.teacherProfileScreen);
              },
            ),
          ),




          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading: const Icon(Icons.notifications_none_outlined,
                  color: Colors.white),
              title:  Text(
                'Notifications',
                style:  manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                context.push(PagePath.notificationTeacher);
              },
            ),
          ),



          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading: const HeroIcon(HeroIcons.clipboardDocumentList,
                  color: Colors.white),
              title:  Text(
                'Guide',
                style:  manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                context.push(PagePath.guide);
              },
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.schedule_outlined, color: Colors.white),
          //   title: const Text(
          //     'My Classes',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     context.push(PagePath.myClassesTeacher);
          //   },
          // ),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading:
                  const Icon(Icons.monetization_on_outlined, color: Colors.white),
              title:  Text(
                'Earning',
                style:  manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                print("EARNING FOR TEACHER ID = ${ref.read(teacherIdProvider)}");
                context.push("${PagePath.earnings}?teacherId=${ref.read(teacherIdProvider)}");
              },
            ),
          ),


          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading: const HeroIcon(HeroIcons.power, color: Colors.white),
              title:  Text(
                'Switch to Student',
                style:  manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () async {
                // final userType =
                //     ref.read(currentPlatformProvider).name.toString();
                final userDataSource = Injector.dependency<UserLocalDataSource>();
                final user = await userDataSource.getUser();
                if (user != null) {
                  debugPrint(
                      'This is the userType being sent!!! ${user.userType}');
                  // ignore: avoid_async_round_trip
                  GoRouter.of(context).go(
                      '${PagePath.switching}?userType=${user.userType}&userId=${user.userId}&userToken=${user.token}&userEmail=${user.email}&userName=${user.username}');
                } else {
                  UIFeedback.showSnackBar(context,
                      'User Is not logged in, please logout and login again.');
                }
              },
            ),
          ),



          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading: const HeroIcon(HeroIcons.cog8Tooth, color: Colors.white),
              title:  Text(
                'Settings',
                style: manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                context.push(PagePath.teacherSetting);
              },
            ),
          ),


          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
                leading: const HeroIcon(HeroIcons.questionMarkCircle,
                    color: Colors.white),
                title:  Text(
                  'Help & Support',
                  style: manropeSubTitleTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    height: 1.2,
                  ),
                ),
                onTap: () {
                  context.push(PagePath.helpandSupport);
                }),
          ),



          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading: const HeroIcon(HeroIcons.arrowLeftOnRectangle,
                  color: Colors.white),
              title:  Text(
                'Logout',
                style:  manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                ref.read(authNotifyProvider.notifier).logoutUser();
                context.go(PagePath.login);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          Padding(
            padding:  EdgeInsets.only(left: 40.w),
            child: Divider(color: Colors.white,),
          ),

          const SizedBox(
            height: 20,
          ),


          ListTile(
            leading: HeroIcon(HeroIcons.atSymbol, color: Colors.white),
            title: Text(
              "${ref.watch(teacherObjectProvider).email == '' ? '' : '${ref.watch(teacherObjectProvider).email},'}",
              style:  manropeSubTitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                height: 1.2,
              ),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
        ],
      ),
    );
  }
}
