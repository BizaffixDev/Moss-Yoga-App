import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';

import '../../../../common/app_specific_widgets/custom_button.dart';
import 'components/carousel_image_slider.dart';
import 'components/main_heading.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {


  final List<String> images = [
    Drawables.onBoarding1,
    Drawables.onBoarding2,
    Drawables.onBoarding3,
  ];




  late CarouselSliderController _sliderController;

  @override
  void initState() {
    super.initState();
    _sliderController = CarouselSliderController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[


          //TODO: IMAGE SLIDER
          CarouselImageSlider(sliderController: _sliderController, images: images),

         // SizedBox(height: CommonFunctions.deviceHeight(context) * 0.02,),
          SizedBox(height: 28.h,),

          const MainHeading(),

          //const SubHeading(),

           SizedBox(height: 40.h,),
           //SizedBox(height: CommonFunctions.deviceHeight(context) * 0.03,),


          CustomButton(

            btnColor: AppColors.primaryColor,
            textColor: Colors.white,
            onTap: ()=>context.go(PagePath.login),
            text: "Continue",

          ),

         // SizedBox(height: 53.h,),



        ],
      ),
    );
  }
}





