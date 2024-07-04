import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/notification_response_model.dart';
import 'package:moss_yoga/presentation/providers/notification_providers/notification_student_provider.dart';

import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../providers/screen_state.dart';
import 'notification_student_states.dart';

class NotificationStudentScreen extends ConsumerStatefulWidget {
  const NotificationStudentScreen({super.key});

  @override
  ConsumerState<NotificationStudentScreen> createState() => _NotifyScreenFillState();
}

class _NotifyScreenFillState extends ConsumerState<NotificationStudentScreen> {
  List<Map<String, String>> notificationsToday = [{
    "title":"usman",
  }];
  List<Map<String, String>> notificationsYesterday = [];
  List<Map<String, String>> notificationsThisWeek = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(notificationStudentNotifierProvider.notifier)
          .getNotifications();

    });
  }

  @override
  Widget build(BuildContext context) {


    ref.listen<NotifictionStudentsStates>(notificationStudentNotifierProvider, (previous, screenState) async {

      if (screenState is NotifictionStudentSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }



      else if (screenState is NotifictionStudentErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          // dismissLoading(context);
        }
        else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      }


      else if (screenState is NotifictionStudentLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }

      else {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });

    List<NotificationData> todayList = ref.watch(todayProvider);
    List<NotificationData> yesterdayList = ref.watch(yesteradyProvider);
    List<NotificationData> olderList = ref.watch(olderProvider);
    int count = ref.watch(notificationCount);


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        endDrawer: const DrawerScreen(),
        body: Container(
          height:  844.h,
          width: 390.w,
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(37),
              topRight: Radius.circular(37),
            ),
            image: DecorationImage(
              image: AssetImage(notificationsToday.isNotEmpty ?  Drawables.authPlainBg : Drawables.authPlainGreyBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                  children: [
                const SizedBox(width: 60),
                Container(
                  margin: EdgeInsets.only(top: 20.h,left: 30.w),
                  child: Text(
                    'You have ${todayList.length} new notifications today.',
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                    // if (notificationsToday.isEmpty &&
                    //     notificationsYesterday.isEmpty && notificationsThisWeek.isEmpty)
                    // NotificationEmptyScreen()
                    //  else

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                    height: 711.h,
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
                      children: [

                       // notificationsToday.isNotEmpty ?
                        todayList.isNotEmpty ?  Text("Today",style: manropeHeadingTextStyle.copyWith(
                          color: const Color(0xFF5B5B5B),
                          fontSize: 16.sp,
                        ),) : Container() ,
                        //    : Container(),


                       // notificationsToday.isNotEmpty ?

                        Flexible(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: todayList.length,
                            itemBuilder: (context, index) {
                              final today = todayList[index];
                              return ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.fiber_manual_record,
                                        color: AppColors.primaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Image.asset('assets/images/notifyfill.png'),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(today.notificationName),
                                        ),
                                         Text(
                                          today.notificationTime, // Replace this with the real-time value of the notification
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(today.notificationMessage),
                              );
                            },
                          ),
                        ) ,

                            //: Container(),

                        yesterdayList.isNotEmpty ?     Text("Yesterday",style: manropeHeadingTextStyle.copyWith(
                          color: const Color(0xFF5B5B5B),
                          fontSize: 16.sp,
                        ),)  : Container(),
                        yesterdayList.isNotEmpty ?
                        Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: yesterdayList.length,
                            itemBuilder: (context, index) {
                              final yesterday = yesterdayList[index];
                              return ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.fiber_manual_record,
                                        color: AppColors.primaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Image.asset('assets/images/notifyfill.png'),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(yesterday.notificationName),
                                        ),
                                         Text(
                                           yesterday.notificationTime, // Replace this with the real-time value of the notification
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(yesterday.notificationMessage),
                              );
                            },
                          ),
                        ) :
                        Container(),

                        olderList.isNotEmpty ? Text("This Week",style: manropeHeadingTextStyle.copyWith(
                          color: const Color(0xFF5B5B5B),
                          fontSize: 16.sp,
                        ),) : Container(),
                        olderList.isNotEmpty ?  Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: olderList.length,
                            itemBuilder: (context, index) {
                              final older = olderList[index];
                              return ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.fiber_manual_record,
                                        color: AppColors.primaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Image.asset('assets/images/notifyfill.png'),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(older.notificationName),
                                        ),
                                         Text(
                                          older.notificationTime, // Replace this with the real-time value of the notification
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(older.notificationMessage),
                              );
                            },
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }

  Widget NotificationEmptyScreen(){
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(90.0),
            // child: notifications.isEmpty
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/images/notify.png',
                height: 79,
                width: 79,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'No notifications yet.',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Notifications about your activity will show up here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
              ),
            ])
          //     : ListView.builder(
          //   itemCount: notifications.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return ListTile(
          //       title: Text(notifications[index]),
          //     );
          //   },
          // ),
        )
    );
  }

}
