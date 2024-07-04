import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  const SessionDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text("Details",style: manropeHeadingTextStyle.copyWith(
            fontSize: 20.sp
          ),
          ),
          centerTitle: false,

        ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 25.h,),

          //TOP CONTAINER
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            height: 96.h,
            width: 328.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFF7F5FA),
            ),
            child: Row(
              children: [
                Container(
                  height: 96.h,
                  width: 91.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),

                  ),
                  child: Image.asset(Drawables.teacherProfile,fit: BoxFit.cover,),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Liam Miller",style: manropeHeadingTextStyle.copyWith(
                        fontSize: 18.sp,
                      ),),
                      Text("Dentist",style: manropeSubTitleTextStyle.copyWith(
                        fontSize: 14.sp,
                      ),),

                    ],
                  ),
                ),

                const Spacer(),

                Container(
                  margin: EdgeInsets.only(right: 20.w),
                    child: SvgPicture.asset(Drawables.message)),


              ],
            ),
          ),

          SizedBox(height: 25.h,),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text("Invoice",style: manropeSubTitleTextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,

            ),),
          ),

          SizedBox(height: 25.h,),

          const InvoiceContainer(
            leading: Drawables.calendarIcon,
            title: "Date/Time",
            subtitle: "Mon 27 Oct, 2022   09:00 am",
          ),
          const InvoiceContainer(
            leading: Drawables.calendarIcon,
            title: "Duration",
            subtitle: "30 mins",
          ),
          const InvoiceContainer(
            leading: Drawables.budgetIcon,
            title: "Class Budget",
            subtitle: "\$ 20",
          ),
          const InvoiceContainer(
            leading: Drawables.paymentCardIcon,
            title: "Payment Method",
            subtitle: "Credit Card 1234 **** **** 1234",
          ),



        ],
      ),




    );
  }
}

class InvoiceContainer extends StatelessWidget {
  final String leading;
  final String title;
  final String subtitle;
  const InvoiceContainer({
    super.key, required this.leading, required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w,vertical: 4.h),
      height: 96.h,
      width: 328.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: const Color(0xFFF7F5FA),
      ),
      child: Center(
        child: ListTile(
          leading: SvgPicture.asset(leading),
          title: Text(title,style: manropeHeadingTextStyle.copyWith(
            fontSize: 16.sp,
            height: 1.2,
          ),),
          subtitle: Text(subtitle,style: manropeSubTitleTextStyle.copyWith(
            fontSize: 12.sp,

          ),),
        ),
      ),
    );
  }
}
