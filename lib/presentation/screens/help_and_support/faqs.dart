import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/utils/ui_snackbars.dart';
import '../../../common/app_specific_widgets/loader.dart';
import '../../../common/resources/colors.dart';
import '../../../common/resources/drawables.dart';
import '../../../common/resources/text_styles.dart';
import '../../providers/help_support_provider.dart';
import '../../providers/screen_state.dart';
import 'help_support_states.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(helpSupportNotifierProvider.notifier)
            .getFAQs();
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    ref.listen<HelpSupportStates>(helpSupportNotifierProvider, (previous, screenState) async {

      if (screenState is FaqSuccessfulState) {
        dismissLoading(context);
        setState(() {});

      }


      else if (screenState is FaqErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          // dismissLoading(context);
        }
        else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      }


      else if (screenState is  FaqLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }


    });


    final faqList = ref.watch(faqsProvider.notifier).state;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
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
                alignment: Alignment.center,

                image: AssetImage(
                  "assets/images/help_support_bg.png",

                ),



                fit: BoxFit.fill,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 30.h,),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.only(left: 15.w),
                      child: Image.asset(
                        'assets/home/moss_yoga_logo_2.png',
                        width: 140.w,
                        fit: BoxFit.cover,
                        // height: CommonFunctions.deviceHeight(context) * 0.2,
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      height: 450.h,
                      width: 390.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var item in faqList)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 17.h,
                                        width: 17.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Flexible(
                                        child: Text(
                                          item.question,
                                          style: manropeHeadingTextStyle.copyWith(
                                            fontSize: 14.sp,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 28.w, right: 10.w),
                                    child: Text(
                                      item.answer,
                                      style: manropeSubTitleTextStyle.copyWith(
                                        fontSize: 14.sp,
                                        height: 1.5,
                                        color: Color(0xFF828282),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),


                   /* Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      height: 450.h,
                      width: 390.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 17.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text("What Is Yoga?",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 14.sp,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 28.w,right: 10.w),
                              child: Text("What Is Yoga? The word yoga, from the Sanskrit means “union”. Yoga postures, also called “asanas” are designed to purify the body and provide the physical strength and stamina required for long periods of meditation.",
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  color: Color(0xFF828282),
                                ),),
                            ),

                            SizedBox(height: 10.h,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 17.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text("How Many Times Per Week Should I Practice?",
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 14.sp,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 28.w,right: 10.w),
                              child: Text("Yoga is amazing—even if you only practice for one hour a week, you will experience the benefits of the practice. If you can do more than that, you will certainly experience more benefits. I suggest starting with two or three times a week, for an hour or an hour and a half each time. If you can only do 20 minutes per session, that’s fine too. Don’t let time constraints or unrealistic goals be an obstacle—do what you can and don’t worry about it. You will likely find that after a while your desire to practice expands naturally and you will find yourself doing more and more.",

                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  color: Color(0xFF828282),
                                ),),
                            ),

                            SizedBox(height: 10.h,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 17.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Flexible(
                                  child: Text("How Is Yoga Different From Stretching or Other Kinds of Fitness?",
                                    style: manropeHeadingTextStyle.copyWith(
                                      fontSize: 14.sp,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 28.w,right: 10.w),
                              child: Text("Unlike stretching or fitness, yoga is more than just physical postures. The physical practice is just one aspect of yoga. Even within the physical practice, yoga is unique because we connect the movement of the body and the fluctuations of the mind to the rhythm of our breath. Connecting the mind, body, and breath helps us to direct our attention inward. Through this process of inward attention, we learn to recognize our habitual thought patterns without labeling them, judging them, or trying to change them. We become more aware of our experiences from moment to moment. The awareness that we cultivate is what makes yoga a practice, rather than a task or a goal to be completed. Your body will most likely become much more flexible by doing yoga, and so will your mind.",
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  color: Color(0xFF828282),
                                ),),
                            ),


                            SizedBox(height: 10.h,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 17.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Flexible(
                                  child: Text("How to start practicing Yoga?",
                                    style: manropeHeadingTextStyle.copyWith(
                                      fontSize: 14.sp,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 28.w,right: 10.w),
                              child: Text("All you really need to begin practicing yoga is your body, your mind, and a bit of curiosity. But it is also helpful to have a pair of yoga leggings, or shorts, and a t-shirt that’s not too baggy. No special footgear is required because you will be barefoot. It’s nice to bring a towel to class with you. As your practice develops you might want to buy your own yoga mat, but most studios will have mats available for you.",
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  color: Color(0xFF828282),
                                ),),
                            ),
                          ],
                        ),
                      ),
                    ),*/





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
