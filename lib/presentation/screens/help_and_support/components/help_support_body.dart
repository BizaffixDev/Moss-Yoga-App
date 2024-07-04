import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import '../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';
import 'help_support_container.dart';


class HelpSupprtBody extends StatefulWidget {
  const HelpSupprtBody({Key? key}) : super(key: key);

  @override
  State<HelpSupprtBody> createState() => _HelpSupprtBodyState();
}

class _HelpSupprtBodyState extends State<HelpSupprtBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: 844.h,
          width: 390.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Drawables.authPlainBg,
                ),
                fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(

              height: 770.h,
              width: 390.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(37),
                  topRight: Radius.circular(37),
                ),
                image: DecorationImage(

                  image: AssetImage(
                    "assets/images/help_support_bg.png",
                  ),


                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [

                  SizedBox(height: 30.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Help & Support",
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 21,
                              ),
                            ),
                          ),




                        ],
                      ),

                      SizedBox(height: 30.h,),
                      HelpNSupportContainer(
                        onTap: (){
                          context.push(PagePath.learnAboutMossYoga);
                        },
                        title: "Learn about Moss Yoga",
                      ),
                      SizedBox(height: 20.h,),
                      HelpNSupportContainer(
                        onTap: (){
                          context.push(PagePath.feedback);
                        },
                        title: "Feedback",
                      ),
                      SizedBox(height: 20.h,),
                      HelpNSupportContainer(
                        onTap: (){
                          context.push(PagePath.faq);
                        },
                        title: "FAQ’s",
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );





    /*
      Scaffold(
      body: Container(
          height: 844.h,
          width: 390.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(37),
              topRight: Radius.circular(37),
            ),
            image: DecorationImage(
              image: AssetImage(Drawables.authPlainBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    height: 770.h,
                    width: 390.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(37),
                        topRight: Radius.circular(37),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HeroIcon(HeroIcons.arrowLeft, color: Colors.black,),
                           SizedBox(width: 20,),
                            Text(
                              'Help & Support',
                              style: TextStyle(
                                color: Color(0xFF202526),
                                fontSize: 21,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w700,
                               // height: 26.40,
                              ),
                            ),
                            Expanded(
                                child: Image.asset(
                                  Drawables.fotgotPassTop,
                                )),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 380,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF7C8364),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '  Learn about Moss Yoga',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w700,
                                      //height: 19.20,
                                    ),
                                  ),
                                  HeroIcon(HeroIcons.chevronRight),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 380,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF7C8364),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '  Feedback',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w700,
                                      //height: 19.20,
                                    ),
                                  ),
                                  HeroIcon(HeroIcons.chevronRight),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: 380,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF7C8364),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '  FAQs',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w700,
                                      //height: 19.20,
                                    ),
                                  ),
                                  HeroIcon(HeroIcons.chevronRight),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(Drawables.fotgotPassBottom))
                      ],
                    )
                  ),
                ),
              ]),
            ),
          )),
    );
    */


  }
}

