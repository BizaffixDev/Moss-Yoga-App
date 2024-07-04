import 'package:flutter/material.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';



class OtherSignUpOptions extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  const OtherSignUpOptions({
    super.key, required this.image, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: CommonFunctions.deviceHeight(context) * 0.08,
        width: CommonFunctions.deviceWidth(context) * 0.23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:const  Color(0XFFE8E8E8),
        ),
        child: Image.asset(image,scale: 1.5,),
      ),
    );
  }
}

