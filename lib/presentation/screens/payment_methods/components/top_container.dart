import 'package:flutter/material.dart';

import '../../../../app/utils/common_functions.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/text_styles.dart';

class TopContainer extends StatelessWidget {
  const TopContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CommonFunctions.deviceHeight(context) * 0.15,
      width: CommonFunctions.deviceWidth(context),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.kAppBarColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/teacher.png",
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jenny Luke",
                style: kHeading3TextStyle,
              ),
              Text(
                "Power Yoga",
                style: kHeading3TextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: const Color(0XFF3B3B3B),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "\$ 150",
            style: kHeading2TextStyle,
          )
        ],
      ),
    );
  }
}