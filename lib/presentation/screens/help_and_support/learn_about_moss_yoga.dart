import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/presentation/providers/help_support_provider.dart';

import '../../../app/utils/ui_snackbars.dart';
import '../../../common/app_specific_widgets/loader.dart';
import '../../../common/resources/colors.dart';
import '../../../common/resources/drawables.dart';
import '../../../common/resources/text_styles.dart';
import '../../providers/screen_state.dart';
import 'help_support_states.dart';

class LearnAboutMossYoga extends ConsumerStatefulWidget {
  const LearnAboutMossYoga({super.key});

  @override
  ConsumerState<LearnAboutMossYoga> createState() => _LearnAboutMossYogaState();
}

class _LearnAboutMossYogaState extends ConsumerState<LearnAboutMossYoga> {

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
            .getLearnMossYoga();
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    ref.listen<HelpSupportStates>(helpSupportNotifierProvider, (previous, screenState) async {

      if (screenState is LearnMossYogaSuccessfulState) {
        dismissLoading(context);
        setState(() {});

      }


      else if (screenState is LearnMossYogaErrorState) {
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


      else if (screenState is  LearnMossYogaLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }


    });


    final learnMossYogaList = ref.watch(learnMossYogaProvider.notifier).state;

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
                  alignment: Alignment.bottomLeft
                ,
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
                      height: 500.h,
                      width: 390.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var item in learnMossYogaList)
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
                                      Text(
                                        item.title,
                                        style: manropeHeadingTextStyle.copyWith(
                                          fontSize: 18.sp,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 28.w, right: 10.w),
                                    child: Text(
                                      item.description,
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
