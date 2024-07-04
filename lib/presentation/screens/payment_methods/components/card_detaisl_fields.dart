import 'package:flutter/material.dart';
import 'package:moss_yoga/presentation/screens/payment_methods/components/save_future_check_box.dart';

import '../../../../common/app_specific_widgets/custom_text_field.dart';

class CardDetailsFields extends StatelessWidget {
  const CardDetailsFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hintText: "Enter Account name here",
          labelText: "Account Name",
          m: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          hintText: "0000 XXXX XXXX XXXX",
          labelText: "Card Number",
          m: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: CustomTextField(
                hintText: "05/26",
                labelText: "Exp Date",
                m: 20,
              ),
            ),
            Expanded(
              child: CustomTextField(
                onChanged: (_) {},
                hintText: "123",
                labelText: "CVV",
                m: 20,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        const SaveForFuture(),
      ],
    );
  }
}
