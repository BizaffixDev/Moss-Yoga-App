import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';

class MyClassesBtn extends StatelessWidget {
  final VoidCallback onTap;
  const MyClassesBtn({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 312.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svgs/my_teacher/my_class_icon.svg"),
              SizedBox(width: 10.w,),
              Text("My Classes",style: manropeHeadingTextStyle.copyWith(
                  fontSize: 16.sp
              ),)
            ],
          ),
        ),
      ),
    );
  }
}