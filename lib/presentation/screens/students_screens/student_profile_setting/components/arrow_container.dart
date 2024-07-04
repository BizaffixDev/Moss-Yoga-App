import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';



class ArrowContainer extends StatefulWidget {
  final String title;
  final HeroIcons icon;
  final VoidCallback onTap;
  const ArrowContainer({required this.title, required this.icon,  required this.onTap ,Key? key}) : super(key: key);

  @override
  State<ArrowContainer> createState() => _ArrowContainerState();
}

class _ArrowContainerState extends State<ArrowContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
            const HeroIcon(
              HeroIcons.chevronRight,
              color: Color(0xFF202526),
            ),

          ],
        ),
      ),
    );
  }
}
