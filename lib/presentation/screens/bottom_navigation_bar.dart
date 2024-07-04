import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';

class StudentBottomNavBar extends ConsumerStatefulWidget {
  String location;

  StudentBottomNavBar({super.key, required this.child, required this.location});

  final Widget child;

  @override
  ConsumerState<StudentBottomNavBar> createState() =>
      _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<StudentBottomNavBar> {
  int _currentIndex = 0;
  static List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon:
      SvgPicture.asset(Drawables.homePngUnTapped),
      activeIcon:
      SvgPicture.asset(Drawables.homePngTapped),
      label: 'Home',
      initialLocation: PagePath.homeScreen,
    ),
    MyCustomBottomNavBarItem(
      icon:SvgPicture.asset(Drawables.onDemandPngUnTapped),
      activeIcon: SvgPicture.asset(Drawables.onDemandPngTapped),
      label: 'On Demand',
      initialLocation: PagePath.onDemandScreen,
    ),
    MyCustomBottomNavBarItem(
      icon:SvgPicture.asset(Drawables.myClassesPngStudentUnTapped),
      activeIcon: SvgPicture.asset(Drawables.myClassesPngStudentTapped),
      label: 'My Teachers',
      initialLocation: PagePath.myTeachers,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontFamily: 'Roboto');
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
            color: AppColors.white,
            // padding: const EdgeInsets.only(top: 20),
            child: widget.child),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        selectedItemColor: const Color(0xFF434343),
        selectedFontSize: 12,
        unselectedItemColor: const Color(0xFF838383),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _goOtherTab(context, index);
        },
        currentIndex: widget.location == PagePath.homeScreen
            ? 0
            : widget.location == PagePath.onDemandScreen
                ? 1
                : widget.location == PagePath.myTeachers
                    ? 2
                    : 0,
        items: tabs,
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    GoRouter router = GoRouter.of(context);
    String location = tabs[index].initialLocation;

    setState(() {
      _currentIndex = index;
    });
    if (index == 3) {
      // context.push('/login');
    } else {
      router.go(location);
    }
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem(
      {required this.initialLocation,
      required Widget icon,
      String? label,
      Widget? activeIcon})
      : super(icon: icon, label: label, activeIcon: activeIcon ?? icon);
}

// Widget bottomTabs(BuildContext context) {
//   return Container(
//     color: Colors.white70,
//     height: 60,
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: <Widget>[
//         MaterialButton(
//           minWidth: 5,
//           onPressed: () {
//             setState(() {
//               ref.read(bottomBarCurrentIndexProvider.notifier).state = 0;
//               // _selectedIndex = 2;
//             });
//             refreshProviders();
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image.asset(
//                 Drawables.homePng,
//                 width: 29,
//                 height: 29,
//                 color:
//                     _currentIndex == 0 ? AppColors.black : Color(0xFFc4c4c4),
//               ),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 'Home',
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: _currentIndex == 0
//                         ? AppColors.black
//                         : Color(0xFFc4c4c4),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500),
//               )
//             ],
//           ),
//         ),
//         MaterialButton(
//           minWidth: 5,
//           onPressed: () async {
//             setState(() {
//               ref.read(bottomBarCurrentIndexProvider.notifier).state = 1;
//             });
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image.asset(
//                 width: 29,
//                 height: 29,
//                 Drawables.onDemandVideoPng,
//                 color:
//                     _currentIndex == 1 ? AppColors.black : Color(0xFFc4c4c4),
//               ),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 'On Demand',
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: _currentIndex == 1
//                         ? AppColors.black
//                         : Color(0xFFc4c4c4),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500),
//               )
//             ],
//           ),
//         ),
//         MaterialButton(
//           minWidth: 5,
//           onPressed: () {
//             setState(() {
//               ref.read(bottomBarCurrentIndexProvider.notifier).state = 2;
//               //  _selectedIndex = 0;
//             });
//             refreshProviders();
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//                 Image.asset(
//                   Drawables.homePng,
//                   width: 29,
//                   height: 29,
//                   color:
//                   _currentIndex == 2 ? AppColors.black : Color(0xFFc4c4c4),
//                 ),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 'My Teachers',
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: _currentIndex == 2
//                         ? AppColors.black
//                         : Color(0xFFc4c4c4),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500),
//               )
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
