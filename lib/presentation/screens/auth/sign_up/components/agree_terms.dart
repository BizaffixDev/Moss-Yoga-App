import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_rich_text.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';

class AgreeTerms extends ConsumerStatefulWidget {

  const AgreeTerms({
    super.key,
  });

  @override
  ConsumerState<AgreeTerms> createState() => _AgreeTermsState();
}

class _AgreeTermsState extends ConsumerState<AgreeTerms> {
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
              activeColor: AppColors.primaryColor,
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;

                });



              },
            ),


            CustomRichText(text1: "I agree to the ", text2: "Terms & Conditions", onTap: ()=>context.push(PagePath.terms))

          ],
        ),
      ),
    );
  }
}
