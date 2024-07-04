// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:moss_yoga/common/app_specific_widgets/drawer.dart';
// import 'package:moss_yoga/common/resources/colors.dart';
// import 'package:moss_yoga/common/resources/page_path.dart';
//
// class StudentNotificationScreen extends StatefulWidget {
//   StudentNotificationScreen({super.key, this.message});
//
//   RemoteMessage? message;
//
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<StudentNotificationScreen> {
//   ///List<String> notifications = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           leading: InkWell(
//             onTap: () {
//               context.go(PagePath.homeScreen);
//             },
//             child: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//           ),
//           elevation: 0,
//           iconTheme: const IconThemeData(
//             color: Colors.black,
//           ),
//           backgroundColor: Colors.white,
//           centerTitle: false,
//           title: const Text(
//             'Notifications',
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//         ),
//         endDrawer: const DrawerScreen(),
//         body: Padding(
//             padding: const EdgeInsets.all(90.0),
//             // child: notifications.isEmpty
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Image.asset(
//                 'assets/images/notify.png',
//                 height: 79,
//                 width: 79,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(widget.message?.notification?.title.toString() ??
//                   'No Title to show'),
//               Text(widget.message?.notification?.body.toString() ??
//                   'No Body to show'),
//               Text(
//                 'No notifications yet.',
//                 style: TextStyle(
//                     color: AppColors.primaryColor,
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Notifications about your activity will show up here.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: Colors.black.withOpacity(0.5),
//                     fontSize: 12.0,
//                     fontWeight: FontWeight.w500),
//               ),
//             ])
//             //     : ListView.builder(
//             //   itemCount: notifications.length,
//             //   itemBuilder: (BuildContext context, int index) {
//             //     return ListTile(
//             //       title: Text(notifications[index]),
//             //     );
//             //   },
//             // ),
//             ));
//   }
// }
