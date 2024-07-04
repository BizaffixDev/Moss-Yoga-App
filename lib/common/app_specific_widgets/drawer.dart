import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/di/injector.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import '../../presentation/providers/home_provider.dart';
import '../resources/colors.dart';

class DrawerScreen extends ConsumerStatefulWidget {
  const DrawerScreen({super.key});

  @override
  ConsumerState<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends ConsumerState<DrawerScreen> {
  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(homeNotifierProvider.notifier).getStudentData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int userId = ref.watch(studentIdProvider.notifier).state;
    String name = ref.watch(nameProvider.notifier).state;
    String email = ref.watch(emailProvider.notifier).state;
    return Drawer(
      backgroundColor: Color(0xFF272727),
      child: ListView(
        children: [

          const SizedBox(height: 20),
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
                  name,
                  style: manropeHeadingTextStyle.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                context.push(PagePath.studentProfileScreen);
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
                style: manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                context.push(PagePath.notificationStudent);
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
                style: manropeSubTitleTextStyle.copyWith(
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
          //     'My Teachers',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     // Handle drawer item tap
          //     context.push(PagePath.myTeachers);
          //   },
          // ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: ListTile(
              leading: const HeroIcon(HeroIcons.power, color: Colors.white),
              title:  Text(
                'Switch to Teacher',
                style: manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () async {
                ///I'm not using the currentPlatform rn, since that would need adding and updating
                ///this everywhere i.e. login,signins(T+S), Switching.
                // final userType = ref.read(currentPlatformProvider).name.toString();
                final userDataSource = Injector.dependency<UserLocalDataSource>();
                final user = await userDataSource.getUser();
                print('This is the user type ${user?.userType}');
                if (user != null) {
                  // debugPrint('This is the userType being sent!!! $userType');
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
                context.push(PagePath.studentSetting);
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
                style: manropeSubTitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
              onTap: () {
                // Handle drawer item tap
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

          Padding(
            padding:  EdgeInsets.only(left: 55.w,right: 0),

            child: Row(
              children: [
                HeroIcon(HeroIcons.atSymbol, color: Colors.white),

            SizedBox(width: 30.w,),

            Text(
              email,
              style: manropeSubTitleTextStyle.copyWith(
                color: Colors.white54,
                fontSize: 14.sp,
                //height: 1.2,
              ),
            ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
