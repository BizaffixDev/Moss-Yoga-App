import 'package:flutter/material.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset("assets/images/logo_green.png",
        height: CommonFunctions.deviceHeight(context) * 0.31,
        width:  CommonFunctions.deviceWidth(context) * 0.7,),
    );
  }
}