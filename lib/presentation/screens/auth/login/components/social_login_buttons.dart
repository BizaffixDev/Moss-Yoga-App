import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/app_specific_widgets/social_login.dart';
import '../../../../../common/resources/drawables.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SocialLogin(icon: Drawables.appleIcon, onTap: () {},),
          SizedBox(width: 16.w,),
          SocialLogin(icon: Drawables.googleIcon, onTap: () {},),
        ],
      );
  }
}