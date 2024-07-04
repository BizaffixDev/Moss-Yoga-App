import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moss_yoga/presentation/providers/guide_provider.dart';
import 'package:moss_yoga/presentation/screens/guide/guide_states.dart';

import '../../../../../app/utils/ui_snackbars.dart';
import '../../../../../common/app_specific_widgets/loader.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/text_styles.dart';


import '../../../providers/screen_state.dart';



class PosesSingleDetailScreen extends ConsumerStatefulWidget {
  const PosesSingleDetailScreen({required this.id, Key? key}) : super(key: key);

  final int id;

  @override
  ConsumerState<PosesSingleDetailScreen> createState() => _PosesSingleDetailStudentsScreenState();
}

class _PosesSingleDetailStudentsScreenState extends ConsumerState<PosesSingleDetailScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(guideNotifierProvider.notifier)
          .getPoseDetailsGuide(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {

    String poseName = ref.watch(poseNameProvider);
    String poseShortDescription= ref.watch(poseShortDescriptionProvider);
    final poseDetail = ref.watch(poseDetailProvider.notifier).state;

    ref.listen<GuideStates>(guideNotifierProvider, (previous, screenState) async {
      if (screenState is GuidePoseErrorState) {
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
      } else if (screenState is GuidePoseLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is GuidePoseSuccessfulState) {

        setState(() {

        });

        dismissLoading(context);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(

            expandedHeight: 425.h,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/images/pose1.png',
                fit: BoxFit.cover,),

              title: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(poseName,style: manropeHeadingTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                        height: 1.2,

                      ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
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
              height: 28.h,
              width: 75.w,
              margin: EdgeInsets.only(left: 20.w,top: 20.h,right: 300.w),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Colors.black12
                  )
              ),
              child: Center(
                child: Text("Meaning",
                  style: manropeSubTitleTextStyle.copyWith(
                    fontSize: 14.sp,
                    height: 1.2,
                    color: Color(0xFF828282),
                  ),),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(poseName,
                style: manropeHeadingTextStyle.copyWith(
                  fontSize: 18.sp,
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
                  for (var item in poseDetail)
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
