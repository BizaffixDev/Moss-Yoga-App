import 'package:flutter/material.dart';

import '../../../../../common/resources/text_styles.dart';


class SectionHeading extends StatelessWidget {
  final String title;
  const SectionHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,style: kHeading2TextStyle.copyWith(
      fontSize: 16,
    ),);
  }
}