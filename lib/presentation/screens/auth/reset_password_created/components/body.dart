import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/presentation/screens/auth/reset_password_created/components/reset_password_created_bottom_sheet.dart';

import '../../../../../common/app_specific_widgets/logo_green_image.dart';
import '../../reset_password/components/reset_password_head.dart';
import 'appbar_widget.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:Colors.white,

      appBar: ResetPasswordCreatedAppbarWidget(appBar: AppBar(),onTap: ()=>context.pop(),),

      body:  const SingleChildScrollView(
        child: Column(
          children: [

            LogoGreenImage(),

            ResetPasswordHead(),

            ResetPasswordCreatedBottomSheet(),
          ],
        ),
      ),

    );
  }
}