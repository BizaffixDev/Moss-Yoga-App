import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:go_router/go_router.dart';

import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import '../providers/app_providers.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

class TeacherBottomNavBar extends ConsumerStatefulWidget {
  String location;

  TeacherBottomNavBar({super.key, required this.child, required this.location});

  final Widget child;

  @override
  ConsumerState<TeacherBottomNavBar> createState() =>
      _TeacherBottomNavBarState();
}

class _TeacherBottomNavBarState extends ConsumerState<TeacherBottomNavBar> {
  int _currentIndex = 0;

  static List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon:
      SvgPicture.asset(Drawables.homePngUnTapped),
      activeIcon:
      SvgPicture.asset(Drawables.homePngTapped),
      label: 'Home',
      initialLocation: PagePath.homeScreenTeacher,
    ),
    MyCustomBottomNavBarItem(
      icon:SvgPicture.asset(Drawables.onDemandPngUnTapped),
      activeIcon: SvgPicture.asset(Drawables.onDemandPngTapped),
      label: 'On Demand',
      initialLocation: PagePath.onDemandTeacher,
    ),
    MyCustomBottomNavBarItem(
      icon:SvgPicture.asset(Drawables.myClassesPngTeacherUnTapped),
      activeIcon: SvgPicture.asset(Drawables.myClassesPngTeacherTapped),
      label: 'My Classes',
      initialLocation: PagePath.myClassesTeacher,
    ),
  ];
  static List<MyCustomBottomNavBarItem> lockedTabs = [
    MyCustomBottomNavBarItem(
      icon: SvgPicture.asset(
        Drawables.homePngUnTapped,
        width: 23,
        height: 26,
      ),
      // SvgPicture.asset('assets/home/teacher/home_bottomTab_colored.svg'),
      activeIcon: SvgPicture.asset(
        Drawables.homePngTapped,
        width: 23,
        height: 26,
      ),
      label: 'Home',
      initialLocation: PagePath.homeScreenTeacherLocked,
    ),
    MyCustomBottomNavBarItem(
      icon: Image.asset(
        Drawables.onDemandTeacherPnnLocked,
        width: 29,
        height: 32,
      ),
      activeIcon: Image.asset(
        Drawables.onDemandTeacherPnnLocked,
        width: 29,
        height: 29,
      ),
      label: 'On Demand',
      initialLocation: PagePath.homeScreenTeacherLocked,
    ),
    MyCustomBottomNavBarItem(
      icon: Image.asset(
        Drawables.myClassesPngUnTappedLocked,
        width: 29,
        height: 29,
      ),
      activeIcon: Image.asset(
        Drawables.myClassesPngUnTappedLocked,
        width: 29,
        height: 29,
      ),
      label: 'My Classes',
      initialLocation: PagePath.homeScreenTeacherLocked,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    var isVerified = ref.watch(isLockedTeacherProvider);

    const labelStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w500);
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: labelStyle,
          unselectedLabelStyle: labelStyle,
          selectedItemColor: const Color(0xff828282),
          selectedFontSize: 11,
          unselectedItemColor: const Color(0xFF838383),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            // _goOtherTab(context, index, isVerified);
            // print(
            //     'this is the current list ${isVerified ? tabs[1].activeIcon : lockedTabs[1].activeIcon}');

            ///-------------///
            // Always update _currentIndex, regardless of whether it changes
            // setState(() {
            //   _currentIndex = index;
            // });
            if (isVerified == false && (index == 1 || index == 2)) {
              // Show the snackbar
              debugPrint('inside show the snackbar of isLocked');
              // _scaffoldMessengerKey.currentState?.UIFeedback.showSnackBar(context, 'This feature is locked');
              _scaffoldMessengerKey.currentState?.showSnackBar(
                // const SnackBar(®
                //   content: Text('This feature is locked'),
                //   duration: Duration(seconds: 2),
                // ),
                SnackBar(
                  dismissDirection: DismissDirection.startToEnd,
                  behavior: SnackBarBehavior.floating,
                  // Set behavior to fixed
                  margin: EdgeInsets.only(bottom: 650.h, right: 20, left: 20),
                  backgroundColor: const Color(0xFF303535),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  action: SnackBarAction(
                    label: 'x',
                    textColor: Colors.white,
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(Drawables.errorSnackbar),
                          SizedBox(
                            width: 20.w,
                          ),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              "This feature is locked",
                              style: manropeHeadingTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  height: 1.2),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      /*Text(
              "x",
              style: manropeHeadingTextStyle.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            )*/
                    ],
                  ),
                ),
              );
              // );
            } else {
              // Navigate only if the feature isn't locked
              _goOtherTab(context, index);
            }
            print(
                'this is the current list ${isVerified
                    ? tabs[1].activeIcon
                    : lockedTabs[1].activeIcon}');
          },
          currentIndex: isVerified
              ? widget.location == PagePath.homeScreenTeacher
              ? 0
              : widget.location == PagePath.onDemandTeacher
              ? 1
              : widget.location == PagePath.myClassesTeacher
              ? 2
              : 0
              : widget.location == PagePath.homeScreenTeacherLocked
              ? 0
              : widget.location == PagePath.onDemandTeacherLocked
              ? 1
              : widget.location == PagePath.myClassesTeacherLocked
              ? 2
              : 0,
          items: isVerified ? tabs : lockedTabs,
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: AppColors.primaryColor,
        //   child:
        //       SvgPicture.asset('assets/home/chat-bubble-bottom-center-text.svg'),
        // ),
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    GoRouter router = GoRouter.of(context);
    print('inside _goOtherTab');

    // bool isLocked = ref.watch(isLockedTeacherProvider);
    String location = ref.watch(isLockedTeacherProvider)
        ? tabs[index].initialLocation
        : lockedTabs[index].initialLocation;

    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      // context.push('/login');
    } else {
      router.go(location);
    }
    // Show snackbar when On Demand or My Classes is selected in locked state
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem({required this.initialLocation,
    required Widget icon,
    String? label,
    Widget? activeIcon})
      : super(icon: icon, label: label, activeIcon: activeIcon ?? icon);
}
