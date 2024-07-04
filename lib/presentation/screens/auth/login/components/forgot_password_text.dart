import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          child: Text(
            "Forgot Password?",
            style: manropeSubTitleTextStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor,
            ),
          ),
          onPressed: () {
            GoRouter.of(context).push(PagePath.forgotPassword);
          },
        ),
      ),
    );
  }
}
