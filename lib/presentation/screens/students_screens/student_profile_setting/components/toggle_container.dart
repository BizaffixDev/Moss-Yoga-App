import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../../common/resources/colors.dart';


class ToggleContainer extends StatefulWidget {
  final String title;

  final HeroIcons icon;
  bool isSwitched;
   ToggleContainer({required this.title, required this.icon,  this.isSwitched = false ,Key? key}) : super(key: key);

  @override
  State<ToggleContainer> createState() => _ToggleContainerState();
}

class _ToggleContainerState extends State<ToggleContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      width: 313.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeroIcon(
            widget.icon,
            color: const Color(0xFF7C8364),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
           widget.title,
            style: const TextStyle(
              color: Color(0xFF202526),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              // height: 14.40,
            ),
          ),
          const Spacer(),
          CupertinoSwitch(
            activeColor: AppColors.primaryColor,
            value: widget.isSwitched,
            onChanged: (value) {
              setState(() {
                widget.isSwitched = value;
              });
            },
          )
        ],
      ),
    );
  }
}
