import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/earnings/earning_states.dart';

import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/app_specific_widgets/teacherdrawer.dart';
import '../../../../data/models/earnings_teacher_response_model.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_providers/earnings_teacher_provider.dart';
import '../../../providers/teachers_providers/home_teacher_provider.dart';

class EarningScreen extends ConsumerStatefulWidget {
  final String teacherId;
  const EarningScreen({required this.teacherId,Key? key}) : super(key: key);

  @override
  ConsumerState<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends ConsumerState<EarningScreen> {


  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(earningsTeacherNotifierProvider.notifier)
            .getEarningTeacher(
            teacherId: widget.teacherId);
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    ref.listen<EarningsTeacherStates>(earningsTeacherNotifierProvider,
            (previous, screenState) async {
          if (screenState is EarningsTeacherSuccessfulState) {
            dismissLoading(context);
            setState(() {});
          }  else if (screenState is EarningsTeacherErrorState) {
            if (screenState.errorType == ErrorType.unauthorized) {
              UIFeedback.showSnackBar(context, screenState.error.toString(),
                  height: 140);
              dismissLoading(context);
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
              // UIFeedback.logoutShowDialogue(context, ref);
            } else if (screenState.errorType == ErrorType.other) {
              debugPrint(
                  "This is the error thats not shwoing: ${screenState.error}");
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
              UIFeedback.showSnackBar(context, screenState.error.toString(),
                  height: 140);
              // dismissLoading(context);
            } else {
              print("This is the error thats not shwoing: ${screenState.error}");
              UIFeedback.showSnackBar(context, screenState.error.toString(),
                  height: 140);
              dismissLoading(context);
            }
          }
           else if (screenState is EarningsTeacherLoadingState) {
            debugPrint('Loading');
            showLoading(context);
            // setState(() {});
          }
        });

     String totalEarning = ref.watch(totalEarningProvider).toString();
     String studentName = ref.watch(teacherObjectProvider).username;
    List<Detail> student = ref.watch(studentDetailListProvider);


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Earnings',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      endDrawer: TeacherDrawer(),

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [

            SizedBox(height: 10.h,),

            Container(

              width: 390.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),


              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [

                        SizedBox(width: 20.w,),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                              "assets/images/teacher.png"
                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Text(studentName, style: manropeHeadingTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          height: 1.2,
                        ),)
                      ],
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.only(left: 20.w,top: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            HeroIcon(HeroIcons.currencyDollar,size: 35.h),
                            Text("Earnings",style: manropeHeadingTextStyle.copyWith(
                              color: Color(0xFF828282),
                              fontSize: 18.sp

                            ),)
                          ],
                        ),

                        SizedBox(width: 10.w,),

                        Text("\$$totalEarning",style: manropeHeadingTextStyle.copyWith(
                          fontSize: 40.sp,
                          color: Color(0xFF5B5B5B),
                          height: 1.2,
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
            ),


            SizedBox(height: 10.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("This Week",style: manropeHeadingTextStyle.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),),

                GestureDetector(
                  onTap:(){} ,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      Icon(Icons.arrow_drop_down_outlined,)
                    ],
                  ),
                ),

              ],
            ),


            SizedBox(height: 10.h,),


          student.isEmpty ? Center(
            child: Text("No Earning Yet", style: manropeSubTitleTextStyle),
          ) :

            ListView.builder(
              itemCount: student.length,
              shrinkWrap: true,
                itemBuilder: (context,index){
              return  Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //set border radius more than 50% of height and width to make circle
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                        "assets/images/teacher.png"
                    ),
                  ),
                  title: Text(student[index].studentName,style: manropeHeadingTextStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),),
                  subtitle: Text(student[index].paymentDate,style: manropeHeadingTextStyle.copyWith(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),),

                  trailing:Text("\$${student[index].amount}",style: manropeHeadingTextStyle.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 20.sp,
                  ),),
                ),
              );
            }),



          ],
        ),
      ),
    );
  }
}
