import 'package:flutter/material.dart';
class TermWidget extends StatelessWidget {
  final String number;
  final String termText;
  const TermWidget({
    super.key, required this.number, required this.termText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(number,
              style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF656565)
              ),),
            Expanded(
              child: Text(termText,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF656565)
                ),),
            ),
          ],
        ),

        const SizedBox(height: 5,),
      ],
    );
  }
}
