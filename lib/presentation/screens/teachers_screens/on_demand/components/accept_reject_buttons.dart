import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/resources/text_styles.dart';

class AcceptRejectButton extends StatelessWidget {
  final String? text;
  final String? icon;
  final VoidCallback? onTap;
  final Color? color;
  const AcceptRejectButton({
    super.key,
     this.text,
     this.icon,
     this.onTap,
     this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SvgPicture.asset(
                icon!,
                height: 10.h,
                width: 10.h,
              ) ,
              SizedBox(
                width: 10.w,
              ),
              Text(
                text!,
                style: manropeHeadingTextStyle.copyWith(
                    color: color, fontSize: 12.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
