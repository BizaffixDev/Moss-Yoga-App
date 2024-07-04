import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';

class ProgressBarWidget extends StatelessWidget {
  final int step;
  const ProgressBarWidget({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10),
      child: Row(

        children: [

         IconButton(onPressed: (){
           context.pop();
           print("popped");
           }, icon: const Icon(Icons.arrow_back,color: Colors.white,),),



          SingleStepBar(color: step == 1 ? AppColors.primaryColor : AppColors.greyColor),
          SingleStepBar(color: step == 2 ? AppColors.primaryColor : AppColors.greyColor),
          SingleStepBar(color: step == 3 ? AppColors.primaryColor : AppColors.greyColor),
          SingleStepBar(color: step == 4 ? AppColors.primaryColor : AppColors.greyColor),
          SingleStepBar(color: step == 5 ? AppColors.primaryColor : AppColors.greyColor),

         SizedBox(width: 5.w,),

         Text("$step/5",style: manropeSubTitleTextStyle.copyWith(
           color: Colors.white,
           fontSize: 12.sp
         ),)





         /* Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              height: 5,
              decoration: const BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child:  FAProgressBar(
                borderRadius:const  BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                currentValue:  currentValue,
                //int.parse("${snapshot.data}"),
                //int.parse("${SPHelper.sp.get("mechanic_wallet")}"),
                maxValue: 4,
                displayTextStyle: GoogleFonts.roboto(
                    color:Colors.transparent, fontSize: 12),
                changeProgressColor: AppColors.primaryColor,
                progressColor: AppColors.primaryColor,
                displayText: ' ',
              ),
            ),
          ),*/

        ],
      ),
    );
  }
}

class SingleStepBar extends StatelessWidget {
  const SingleStepBar({
    super.key,

    required this.color,
  });


  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        width: 60,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
