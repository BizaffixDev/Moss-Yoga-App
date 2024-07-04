import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../../sign_up/components/agree_terms.dart';
import 'terms_appbar.dart';
import 'terms_list_view.dart';

class Body extends ConsumerStatefulWidget {
  const Body({
    super.key,
  });

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
        appBar: TermsAppbarWidget(
          appBar: AppBar(),
          onTap: ()=>context.pop(),
        ),
        body: const TermsListView(),


      bottomNavigationBar: SizedBox(
        height: CommonFunctions.deviceHeight(context) * 0.15,
        width: CommonFunctions.deviceWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const AgreeTerms(),
            CustomButton(text: "Confirm", onTap: (){
              context.pop();
            },
            btnColor: AppColors.primaryColor,
            textColor: Colors.white,
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),

    );
  }
}