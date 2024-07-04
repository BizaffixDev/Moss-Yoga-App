import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/text_styles.dart';

class SelectTextWIthStepCount extends StatelessWidget {
  final String title;
  final String step;
  const SelectTextWIthStepCount({
    super.key, required this.title, required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: manropeHeadingTextStyle.copyWith(
            fontSize: 16.sp,
          ),),
          //SELECT DATE TEXT
          Container(
            padding: const EdgeInsets.all(8),
            decoration:const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF3F3F3),
            ),
            child: Center(
              child: Text("$step/2",
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 12.sp,
                ),),
            ),

          ),

          //DATE PICKER


        ],
      ),
    );
  }
}