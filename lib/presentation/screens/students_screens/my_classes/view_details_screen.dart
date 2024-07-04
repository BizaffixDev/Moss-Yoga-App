import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../providers/my_classes_student_provider.dart';
import 'components/invoice_detail_container.dart';
import 'components/view_detail_top_container.dart';

class ViewDetailsStudent extends ConsumerStatefulWidget {
  const ViewDetailsStudent({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewDetailsStudent> createState() => _ViewDetailsStudentState();
}

class _ViewDetailsStudentState extends ConsumerState<ViewDetailsStudent> {
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
    ref.read(teacherNameMyClassProvider);
    ref.read(teacherOccupationMyClassProvider);
    ref.read(slotDurationMyClassProvider);
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
            teacherName: ref.read(teacherNameMyClassProvider),
            yogaType: ref.read(teacherOccupationMyClassProvider),
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
            subtitle:  "${ref.read(dayProvider)} ${ref.read(dateProvider)} ${convertTo12HourFormat(ref.read(timeProvider))}",
            icon:Drawables.calendarIcon,
          ),

           InvoiceDetailContainer(
            title: "Duration",
            subtitle: "${ref.read(slotDurationMyClassProvider)} mins",
            icon:Drawables.timeIcon,
          ),

           InvoiceDetailContainer(
            title: "Class Budget",
            subtitle:"\$ ${ref.read(budgetProvider)}",
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




