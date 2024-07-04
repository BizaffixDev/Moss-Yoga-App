import 'package:flutter/material.dart';

import '../../../../../common/resources/text_styles.dart';

class OtpVerificationText extends StatelessWidget {
  const OtpVerificationText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OTP Verification",
          style: manropeHeadingTextStyle.copyWith(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Text(
          "A verification code has been sent to your\nregistered email",
          style: manropeSubTitleTextStyle.copyWith(
            height: 1.2,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}