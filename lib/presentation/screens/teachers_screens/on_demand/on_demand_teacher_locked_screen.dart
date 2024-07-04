import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OnDemandTeacherScreenLocked extends ConsumerStatefulWidget {
  const OnDemandTeacherScreenLocked({Key? key}) : super(key: key);

  @override
  ConsumerState<OnDemandTeacherScreenLocked> createState() =>
      _OnDemandTeacherScreenState();
}

class _OnDemandTeacherScreenState
    extends ConsumerState<OnDemandTeacherScreenLocked> {
  final bool _request = true;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor:
    //   _request == false ? Color(0xFFF7F5FA) : AppColors.primaryColor,
    //   appBar: AppBar(
    //     actionsIconTheme: IconThemeData(color: Colors.black),
    //     elevation: 0,
    //     centerTitle: false,
    //     backgroundColor: Colors.white,
    //     title: Text(
    //       "Requests",
    //       style: manropeHeadingTextStyle,
    //     ),
    //   ),
    //   endDrawer: Drawer(
    //     backgroundColor: AppColors.neutral53,
    //     child: Theme(
    //       data: Theme.of(context).copyWith(
    //         iconTheme: IconThemeData(
    //             color: Colors.black), // Set the desired icon color
    //       ),
    //       child: Text('Test'),
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       Container(
    //         padding: EdgeInsets.symmetric(horizontal: 10.w),
    //         child: Text(
    //           "You have 90 secs to accept or decline request",
    //           style: manropeSubTitleTextStyle.copyWith(
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 10.h,
    //       ),
    //       Expanded(
    //         child: Container(
    //           width: 390.w,
    //           decoration: BoxDecoration(
    //               color: Color(0xFFF7F5FA),
    //               borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(20.r),
    //                 topRight: Radius.circular(20.r),
    //               )),
    //           child: Column(
    //             children: [
    //               Container(
    //                 margin: EdgeInsets.symmetric(vertical: 10.h),
    //                 height: 175.h,
    //                 width: 331.w,
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(20.r),
    //                 ),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     ReverseTimerProgressIndicator(
    //                       totalTime: 90,
    //                     ),
    //                     Card(
    //                       elevation: 0,
    //                       child: ListTile(
    //                         leading: ClipRRect(
    //                           borderRadius: BorderRadius.only(
    //                             topLeft: Radius.circular(20.r),
    //                             topRight: Radius.circular(20.r),
    //                           ),
    //                           child: Image.asset(
    //                             Drawables.teacherProfile,
    //                             height: 71.h,
    //                             width: 71.w,
    //                           ),
    //                         ),
    //                         title: Text(
    //                           "Liam Miller",
    //                           style: manropeHeadingTextStyle.copyWith(
    //                             fontSize: 14.sp,
    //                           ),
    //                         ),
    //                         subtitle: Text(
    //                           "Ankle sprains",
    //                           style: manropeSubTitleTextStyle.copyWith(
    //                             fontSize: 14.sp,
    //                             color: Color(0xFF828282),
    //                           ),
    //                         ),
    //                         trailing: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: [
    //                             Flexible(
    //                               child: Container(
    //                                 width: 43.w,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(10.r),
    //                                   color: AppColors.primaryColor
    //                                       .withOpacity(0.7),
    //                                 ),
    //                                 child: Center(
    //                                   child: Text(
    //                                     "Wed\n21",
    //                                     style:
    //                                     manropeSubTitleTextStyle.copyWith(
    //                                         fontSize: 12.sp,
    //                                         color: Colors.white,
    //                                         fontWeight: FontWeight.w600,
    //                                         height: 1.2),
    //                                     textAlign: TextAlign.center,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             SizedBox(height: 4.0),
    //                             // Time Text
    //                             Text(
    //                               "8:00 AM",
    //                               style: manropeSubTitleTextStyle.copyWith(
    //                                 fontSize: 12.sp,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //
    //                     Divider(),
    //
    //                     //ACCEPT/REJECT BUTTON
    //                     Row(
    //                       children: [
    //                         AcceptRejectButton(
    //                           onTap: () {},
    //                           text: "Reject",
    //                           color: Colors.red,
    //                           icon: Drawables.cancel,
    //                         ),
    //                         Container(
    //                           height: 39.h,
    //                           width: 1.14.w,
    //                           color: Color(0xFFE9ECF2),
    //                         ),
    //                         AcceptRejectButton(
    //                           onTap: () {},
    //                           text: "Accept",
    //                           color: Color(0xFF4A934A),
    //                           icon: Drawables.accept,
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Center(
      child: Container(
        child: const Text('Locked'),
      ),
    );
  }
}
