import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../../../common/app_specific_widgets/custom_button.dart';
import '../../../providers/teachers_providers/home_teacher_provider.dart';
import 'components/select_text_row.dart';


class ScheduleDateScreen extends ConsumerStatefulWidget {
  const ScheduleDateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleDateScreen> createState() => _ScheduleDateScreenState();
}

class _ScheduleDateScreenState extends ConsumerState<ScheduleDateScreen> {

  final DateRangePickerController _dateRangePickerController = DateRangePickerController();

  List<DateTime> selectedDates = [];
  List<String> selectedDateStrings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title:  Text("Add Schedule",
        style: manropeHeadingTextStyle.copyWith(
          fontSize: 20.sp,
        ),),
      ),

      body: Column(
        children: [
         const SelectTextWIthStepCount(
            title: "Select the Date",
            step: "1",
          ),

          Container(
            height: 289.h,
            width: 350.w,
            color: AppColors.white,
            child: SfDateRangePicker(
              controller: _dateRangePickerController,
              selectionMode: DateRangePickerSelectionMode.multiple,
              onSelectionChanged: _onSelectionChanged,
                selectionColor:AppColors.primaryColor,
              todayHighlightColor: AppColors.primaryColor.withOpacity(0.2),

              startRangeSelectionColor:AppColors.primaryColor.withOpacity(0.8),
              endRangeSelectionColor: AppColors.primaryColor.withOpacity(0.8),
              rangeSelectionColor: AppColors.primaryColor.withOpacity(0.5),
              rangeTextStyle: const TextStyle(color: Colors.white,),

            ),
          ),
        ],
      ),

      bottomNavigationBar: SizedBox(

        height: 80.h,
        width: 390.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Next",
              onTap: () {

                if(_dateRangePickerController.selectedDates == null){
                  UIFeedback.showSnackBar(context, "Please Select your desired dates",height: 200);
                }else{
                  context.push(PagePath.scheduleTime);
                }

              },
              btnColor: AppColors.primaryColor,
              textColor: Colors.white,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {


    /*var dateList =  ref.read(scheduleDateTeacherListProvider.notifier).state;

    dateList = dateRangePickerSelectionChangedArgs.value;
    print(dateList);*/

    setState(() {
      selectedDates = args.value;
    });

    // Format the selected dates to DD/MM/YYYY format
    selectedDateStrings = selectedDates
        //.map((date) => DateFormat('dd/MM/yyyy').format(date))
        .map((date) => DateFormat('dd MMMM, yyyy').format(date))
        .toList();




    ref.read(scheduleDateTeacherListProvider.notifier).state = selectedDateStrings;



    print("DATE LIST ==== ${ref.read(scheduleDateTeacherListProvider.notifier).state}" ); // Display the formatted dates in the console


  }


}


