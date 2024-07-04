import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/components/arrow_container.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/components/toggle_container.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../providers/teachers_providers/teacher_account_provider.dart';

class TeacherSettings extends ConsumerStatefulWidget {
  const TeacherSettings({super.key});

  @override
  ConsumerState<TeacherSettings> createState() => _StudentSettingsState();
}

class _StudentSettingsState extends ConsumerState<TeacherSettings> {
  late double height, width;

  final bool _locationSwitch = false;
  final bool _notificationSwitch = false;

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(teacherAccountNotifierProvider.notifier)
            .getTeacherData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(teacherObjectProvider.notifier).state;
    String email = ref.watch(teacherEmail.notifier).state;
    String name = ref.watch(teacherFullName.notifier).state;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        endDrawer: const DrawerScreen(),
        body: Container(
          height: 844.h,
          width: 390.w,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            image: DecorationImage(
              image: AssetImage(Drawables.authPlainBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 700.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:Platform.isIOS ?  70 : 150.h,
                        ),
                        Text(
                          ref.watch(teacherObjectProvider).username,
                          style: const TextStyle(
                            color: Color(0xFF202526),
                            fontSize: 25,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            // height: 30,
                          ),
                        ),
                        Text(
                          ref.watch(teacherObjectProvider).email,
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 14,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            //height: 16.80,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 43.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30.h,),
                              const Text(
                                'General',
                                style: TextStyle(
                                  color: Color(0xFF202526),
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  //height: 21.60,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ToggleContainer(
                                title: "Location",
                                icon: HeroIcons.mapPin,
                                isSwitched: _locationSwitch,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // ArrowContainer(
                              //     title: "Payment Method",
                              //     icon: HeroIcons.currencyDollar,
                              //     onTap: () {}),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              const Text(
                                'Security',
                                style: TextStyle(
                                  color: Color(0xFF202526),
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  //height: 21.60,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ToggleContainer(
                                title: "Notification",
                                icon: HeroIcons.bell,
                                isSwitched: _notificationSwitch,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ArrowContainer(
                                  title: "My Account",
                                  icon: HeroIcons.user,
                                  onTap: () {
                                    context.push(PagePath.teacherMyAccount);
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Column(
              children: [
                SizedBox(height: 20.h,),
                Center(
                  child: Container(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          const AssetImage('assets/images/student_avatar.png'),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primaryColor, width: 5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}
