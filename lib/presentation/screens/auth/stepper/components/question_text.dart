import 'package:flutter/material.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class QuestionText extends StatelessWidget {
  final String text;
  const QuestionText({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      //"What's your Intention?",
      style:  manropeHeadingTextStyle.copyWith(
        fontSize: 20,
        height: 1.2,
      ),
    textAlign: TextAlign.center,);
  }
}