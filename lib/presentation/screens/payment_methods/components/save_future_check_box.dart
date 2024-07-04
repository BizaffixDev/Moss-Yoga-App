import 'package:flutter/material.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../../../../app/utils/common_functions.dart';
import '../../../../common/app_specific_widgets/custom_rich_text.dart';

class SaveForFuture extends StatefulWidget {

  const SaveForFuture({
    super.key,
  });

  @override
  State<SaveForFuture> createState() => _SaveForFutureState();
}

class _SaveForFutureState extends State<SaveForFuture> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CommonFunctions.deviceHeight(context) * 0.05,
      width: 268,

      child: Center(
        child: Row(

          children: [
            Checkbox(
              checkColor: Colors.white,
              activeColor: AppColors.primaryColor,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),


            const CustomRichText(text1: "Save this for future",)

          ],
        ),
      ),
    );
  }
}
