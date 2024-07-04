import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:moss_yoga/common/resources/text_styles.dart';

class OptionsWidget extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textcolor;

  final int? id;
  const OptionsWidget(
      {super.key,
      required this.image,
      required this.text,
      required this.onTap,
      this.color=
      const Color(0xFFF6F6F6),
      this.id,
        this.textcolor,
      });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: AbsorbPointer(
        child: Container(
          height: 122,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SvgPicture.asset(image),
              const SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: kHintTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: textcolor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
