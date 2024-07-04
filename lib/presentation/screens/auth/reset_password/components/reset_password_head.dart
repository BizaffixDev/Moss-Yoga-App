import 'package:flutter/material.dart';


class ResetPasswordHead extends StatelessWidget {
  const ResetPasswordHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Reset Your Password",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Color(0XFF3B3B3B)),
    );
  }
}

