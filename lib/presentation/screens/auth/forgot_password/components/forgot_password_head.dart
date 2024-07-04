import 'package:flutter/material.dart';


class ForgotPasswordHead extends StatelessWidget {
  const ForgotPasswordHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Forgot Password?",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Color(0XFF3B3B3B)),
    );
  }
}

