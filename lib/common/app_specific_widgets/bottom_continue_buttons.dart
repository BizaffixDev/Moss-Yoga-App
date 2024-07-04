import 'package:flutter/material.dart';

import '../../app/utils/common_functions.dart';
import '../../presentation/screens/auth/stepper/components/not_now_text.dart';
import '../resources/colors.dart';
import 'custom_button.dart';

class BottomContinueButton extends StatelessWidget {
  final VoidCallback continueTap;
  final VoidCallback notNowTap;
  const BottomContinueButton({
    super.key, required this.continueTap, required this.notNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CommonFunctions.deviceHeight(context) * 0.16,
      width: CommonFunctions.deviceWidth(context),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(text: "Continue", onTap: continueTap,btnColor: AppColors.primaryColor,textColor: Colors.white,),
          NotNowText(onTap: notNowTap,)

        ],
      ),
    );
  }
}