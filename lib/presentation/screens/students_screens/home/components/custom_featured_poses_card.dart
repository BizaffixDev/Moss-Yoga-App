import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../../../../../common/resources/text_styles.dart';

class FeaturedPosesCard extends StatelessWidget {
  FeaturedPosesCard({super.key, required this.imagePath, required this.title});

  String imagePath;
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.white,
      padding: const EdgeInsets.only(left: 7, top: 5, bottom: 5, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: AppColors.neural60,
        ),
        color: AppColors.neural60,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: CommonFunctions.deviceWidth(context) * 0.54,
            height: 91,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
              color: Color(0x87e5e5e5),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 36, 0, 36),
              child: Text(
                title,
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 16.sp,
                  height: 1.2,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: CommonFunctions.isSmallDevice(context)
                  ? CommonFunctions.deviceWidth(context) * 0.2
                  : CommonFunctions.deviceWidth(context) * 0.31,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 91,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
