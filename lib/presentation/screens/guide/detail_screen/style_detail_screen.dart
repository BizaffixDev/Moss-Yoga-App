import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/guide_provider.dart';
import 'package:moss_yoga/presentation/screens/guide/guide_states.dart';

import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/loader.dart';
import '../../../../../common/resources/colors.dart';


import '../../../providers/screen_state.dart';



class StyleSingleDetailScreen extends ConsumerStatefulWidget {
  const StyleSingleDetailScreen({required this.id,Key? key}) : super(key: key);

  final int id;

  @override
  ConsumerState<StyleSingleDetailScreen> createState() => _StyleSingleDetailStudentScreenState();
}

class _StyleSingleDetailStudentScreenState extends ConsumerState<StyleSingleDetailScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(guideNotifierProvider.notifier)
          .getYogaStyleDetailsGuide(id: widget.id);
    });
  }


  @override
  Widget build(BuildContext context) {

    String styleName = ref.watch(styleNameProvider);
    String styleShortDescription= ref.watch(styleShortDescriptionProvider);
    // String styleHeading1= ref.watch(styleHeading1Provider);
    // String styleHeading2= ref.watch(styleHeading2Provider);
    // String styleHeading3= ref.watch(styleHeading3Provider);
    // String styleDetail1= ref.watch(styleDetail1Provider);
    // String styleDetail2= ref.watch(styleDetail2Provider);
    // String styleDetail3= ref.watch(styleDetail3Provider);

    final styleDetail = ref.watch(styleDetailProvider.notifier).state;

    ref.listen<GuideStates>(guideNotifierProvider, (previous, screenState) async {
      if (screenState is GuideStyleErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is GuideStyleLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is GuideStyleSuccessfulState) {
        // chrlist =  screenState.chronicResponseList;
        //print("chrListt ${chrlist[0].chronicConditionName}");
        print(ref.read(styleShortDescriptionProvider));
        setState(() {});
        // GoRouter.of(context).go(PagePath.homeScreen);
        dismissLoading(context);
      }
    });


    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(

            expandedHeight: 425.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/images/yoga_style_1.png',
                fit: BoxFit.cover,),

              title: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(styleName,style: manropeHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 20.sp
                    ),),
                    Row(
                      children: [
                        SvgPicture.asset(Drawables.shareIcon),
                        SvgPicture.asset(Drawables.saveIcon),
                      ],
                    ),
                  ],
                ),
              ),
              centerTitle: true,

            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
              child: Text(styleShortDescription ?? "hello",
                style: manropeSubTitleTextStyle.copyWith(
                  fontSize: 14.sp,
                  height: 1.2,
                  color: Color(0xFF828282),
                ),),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text("Lessons",
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 16.sp,
                  color: Color(0xFF536063),
                ),),
            ),
          ),


          //HOW TO PRACTICE
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                  children: [
                    for (var item in styleDetail)
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
                                  item.header,
                                  style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h,),
                          Padding(
                            padding: EdgeInsets.only(left: 28.w, right: 10.w),
                            child: Text(
                              item.detail,
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                height: 1.2,
                                color: Color(0xFF828282),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h,),
                        ],
                      ),
                  ]


                /* [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        margin: EdgeInsets.only(right: 30.w),
                        height: 17.h,
                        width: 17.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.withOpacity(0.7),
                        ),
                      ),
                      Text(poseHeading1,
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor,
                        ),),
                    ],
                  ),
                ],*/
              ),
            ),
          ),




        ],
      ),
    );
  }
}
