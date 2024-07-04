import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../providers/teachers_providers/my_classes_teache_provider.dart';
import '../../students_screens/my_classes/components/invoice_detail_container.dart';
import '../../students_screens/my_classes/components/view_detail_top_container.dart';


class ViewDetailsTeacher extends ConsumerStatefulWidget {
  /*final String studentName;
  final String slot;
  final String budget;
  final String date;
  final String day;
  final String time;*/

  const ViewDetailsTeacher({
    /*required this.studentName,
    required this.date,
    required this.slot,
    required this.budget,
    required this.day,
    required this.time,*/

    Key? key}) : super(key: key);

  @override
  ConsumerState<ViewDetailsTeacher> createState() => _ViewDetailsTeacherState();
}

class _ViewDetailsTeacherState extends  ConsumerState<ViewDetailsTeacher> {

  //TO CONVERT 24HR TIME FORMAT IN 12 HR
  String convertTo12HourFormat(String time24hr) {
    if (time24hr.isEmpty) {
      return '';
    }

    List<String> parts = time24hr.split(':');
    if (parts.length != 3) {
      return ''; // Invalid time format
    }

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;
    int second = int.tryParse(parts[2]) ?? 0;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
      return ''; // Invalid time format
    }

    String period = (hour >= 12) ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12; // Midnight
    } else if (hour > 12) {
      hour -= 12;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }


  @override
  Widget build(BuildContext context) {
    ref.read(studentNameProvider);
    ref.read(slotDurationProvider);
    ref.read(budgetProvider);
    ref.read(dateProvider);
    ref.read(dayProvider);
    ref.read(timeProvider);
    return  Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Classes',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.darkSecondaryGray),
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        // iconTheme: const IconThemeData(color: AppColors.greyColor),
      ),
      endDrawer: const DrawerScreen(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewDetailTopContainer(
            image:  Drawables.teacherProfile,
            teacherName: ref.read(studentNameProvider),
            yogaType: "Engineer",
            badgeIcon: "assets/svgs/my_teacher/badge-silver.svg",
          ),


          SizedBox(width: 20.w,),

          //invoice heading
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text("Invoice",style: manropeHeadingTextStyle.copyWith(
              fontSize: 16.sp,
            ),),
          ),

          SizedBox(width: 20.w,),

           InvoiceDetailContainer(
            title: "Date/Time",
            subtitle: "${ref.read(dayProvider)} ${ref.read(dateProvider)} ${convertTo12HourFormat(ref.read(timeProvider))}",
            icon:Drawables.calendarIcon,
          ),

           InvoiceDetailContainer(
            title: "Duration",
            subtitle: "${ref.read(slotDurationProvider)} mins",
            icon:Drawables.timeIcon,
          ),

           InvoiceDetailContainer(
            title: "Class Budget",
            subtitle: "\$ ${ref.read(budgetProvider)}",
            icon:Drawables.budgetIcon,
          ),

          const InvoiceDetailContainer(
            title: "Payment Method",
            subtitle: "1234 **** **** 1234",
            icon:Drawables.paymentCardIcon,
          ),






        ],
      ),
    );
  }
}




