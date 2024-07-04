import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';

class StyleContainer extends StatelessWidget {
  final String styleName;
  final VoidCallback onTap;
  const StyleContainer({
    required this.styleName,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 23, top: 17, right: 13),
      child: GestureDetector(
        onTap: onTap,
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),

            image: const DecorationImage(
              image: AssetImage(
                'assets/images/yoga_style_1.png',

              ),
              fit: BoxFit.contain,

            ),
          ),
         // width: 170.3.w,
          height: 204.h,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50.h,
              width: 170.3.w,
              decoration:  const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )

              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(styleName,style: manropeHeadingTextStyle.copyWith(
                      fontSize: 12.sp,

                    ),),
                    Text("See more",style: manropeSubTitleTextStyle.copyWith(
                        fontSize: 12.sp,
                        height: 1.2
                    ),),
                  ],
                ),
              ),
            ),
          ),



        ),
      ),
    );
  }
}