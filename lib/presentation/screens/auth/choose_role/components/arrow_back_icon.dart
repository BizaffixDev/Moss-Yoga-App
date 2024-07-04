import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowBackIcon extends StatelessWidget {
  final VoidCallback onTap;
  const ArrowBackIcon({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 34.h,left: 15.w),
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(

          Icons.arrow_back,
          color: Colors.white,

        ),
      ),
    );
  }
}
