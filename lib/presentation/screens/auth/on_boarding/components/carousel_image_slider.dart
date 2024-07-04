import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/presentation/screens/auth/on_boarding/components/sub_heading.dart';

class CarouselImageSlider extends StatelessWidget {
  const CarouselImageSlider({
    super.key,
    required CarouselSliderController sliderController,
    required this.images,
  }) : _sliderController = sliderController;

  final CarouselSliderController _sliderController;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: CommonFunctions.deviceHeight(context) * 0.7,
      height: 620.h,
      child: CarouselSlider.builder(
        unlimitedMode: true,

        controller: _sliderController,
        slideBuilder: (index) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    images[index],
                  ),
                  fit: BoxFit.cover

              ),
            ),

            child: const SubHeading(),

          );
        },
        // slideTransform: CubeTransform(),
        slideIndicator: CircularSlideIndicator(
          indicatorRadius: 4,
          itemSpacing: 10,
          padding: const EdgeInsets.only(bottom: 32),
          indicatorBorderColor: AppColors.greyTextColor,
          currentIndicatorColor: AppColors.primaryColor,
          indicatorBackgroundColor: AppColors.white,

        ),

        itemCount: images.length,
        initialPage: 0,
        enableAutoSlider: false,
      ),
    );
  }
}
