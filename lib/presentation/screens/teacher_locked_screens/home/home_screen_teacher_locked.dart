import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/teachers_locked_providers/home_teacher_locked_provider.dart';
import 'package:moss_yoga/presentation/screens/teacher_locked_screens/states/home_teacher_locked_states.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/home/components/guide_container.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../data/models/yoga_poses_response_model.dart';
import '../../../../data/models/yoga_styles_response_model.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_providers/home_teacher_provider.dart';
import '../../students_screens/home/components/custom_featured_poses_card.dart';

class HomeScreenTeacherLocked extends ConsumerStatefulWidget {
  const HomeScreenTeacherLocked({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenTeacherLocked> createState() =>
      _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends ConsumerState<HomeScreenTeacherLocked> {
  final double _dragExtent = 0;
  final double _dragPosition = 0.0;

  bool _online = false;
  bool _apiCalled = false;

  String result = "Let's slide!";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(teacherHomeLockedNotifierProvider.notifier).getPoses();
        await ref
            .read(teacherHomeLockedNotifierProvider.notifier)
            .getYogaStyles();
        await ref
            .read(teacherHomeLockedNotifierProvider.notifier)
            .getYogaGuides();
        // await ref.read(homeNotifierTeacherProvider.notifier)
        //     .getTopRatedTeachers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TeacherLockedHomeStates>(teacherHomeLockedNotifierProvider,
        (previous, screenState) async {
      if (screenState is TeacherLockedHomeSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }
      if (screenState is TeacherLockedHomeErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString());
          // dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is TeacherLockedHomeLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });

    List<PosesResponseModel> posesList =
        ref.watch(teacherLockedAllPosesProvider);
    List<YogaStylesResponseModel> stylesList =
        ref.watch(teacherLockedAllYogaStylesProvider);
    List<String> youMayLikeList = ref.watch(youMayAlsoLikeProvider);
    var guidesListLength = ref
        .watch(teacherLockedAllYogaGuidesProvider.notifier)
        .getAllItems(ref.watch(teacherLockedAllYogaGuidesProvider));
    // var guidesList = ref.watch(teacherLockedAllYogaGuidesProvider.notifier).getAllItems(ref.watch(teacherLockedAllYogaGuidesProvider));
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        // padding: EdgeInsets.only(top: 20),
        child: Scaffold(
          appBar: AppBar(
            // iconTheme: IconThemeData(color: AppColors.darkGreenGray),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                Drawables.appBarLogo,
                height: 29.32.h,
                width: 87.77.w,
              ),
            ),
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            // iconTheme: const IconThemeData(color: AppColors.greyColor),
          ),
          endDrawer: Drawer(
            backgroundColor: AppColors.neutral53,
            child: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(
                    color: Colors.black), // Set the desired icon color
              ),
              child: const Text('Test'),
            ),
          ),
          body: Column(
            children: [
              // MAIN GREEN HEADER
              Container(
                height: 150.h,
                width: 390.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 36.w, right: 50.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome ${ref.watch(teacherObjectProvider).username == '' ?
                            '' : '${ref.watch(teacherObjectProvider).username},'}',
                            style: manropeHeadingTextStyle.copyWith(
                                color: Colors.white, fontSize:ref.watch(teacherObjectProvider).username.length <= 7 ?  24.sp : 20.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Stack(children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFF3EBE6),
                          radius: 40.r,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(Drawables.teacherProfile),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: SWIPPER

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 16, bottom: 0, right: 16),
                          // padding: const EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // image: Image.asset('assets/home/background_container.png');
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/home/background_container.png'),
                                fit: BoxFit.contain,
                              ),
                              // gradient: LinearGradient(
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   colors: [
                              //     Color(0xFFFFFFFF),
                              //     Colors.grey.withOpacity(0.1),
                              //     Color(0xFFFFFFFF),
                              //   ],
                              // ),
                            ),
                            child: HorizontalSlidableButton(
                              width: MediaQuery.of(context).size.width,
                              height: 76.h,
                              buttonWidth: 80.w,
                              // color: AppColors.primaryColor.withOpacity(0.2),
                              dismissible: false,
                              label: _online == true
                                  ? Container(
                                      // padding: EdgeInsets.only(left: 60),
                                      margin: EdgeInsets.only(top: 6.h),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/home/teacher/homescreen_locked.svg",
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      // padding: EdgeInsets.only(left: 6),
                                      // margin: EdgeInsets.only(top: 6.h),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/home/teacher/homescreen_locked.svg",
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "On Demand",
                                      style: manropeHeadingTextStyle.copyWith(
                                          fontSize: 16.sp,
                                      height: 1.2),

                                    ),
                                    Text(
                                      _online == false
                                          ? "Not Verified"
                                          : "Not Verified",
                                      style: manropeHeadingTextStyle.copyWith(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF828282),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onChanged: (position) {
                                setState(() {
                                  if (position == SlidableButtonPosition.end) {
                                    result = 'Button is on the right';
                                    _online = true;
                                  } else {
                                    result = 'Button is on the left';
                                    _online = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      ///Guides A-Z

                      /// Guides Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Guide A-Z',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),

                      /// Guides Heading
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 18,
                        ),
                        child: GridView.count(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: 10, vertical: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3,
                          children: List.generate(
                            guidesListLength.length,
                            (index) {
                              return Container(
                                // margin: EdgeInsets.only(top: 30, bottom: 30),
                                // padding: EdgeInsets.only(bottom: 30),
                                child: CustomGuideContainer(
                                  text: guidesListLength[index].name,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      ///Featured Poses Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Featured Poses',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),

                      /// Featured Poses Cards
                      posesList.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(
                                left: 23,
                                top: 1,
                              ),
                              child: Text(
                                'No Poses Avaialble right now',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.darkGreyHeading1),
                              ),
                            )
                          : Container(
                        padding: EdgeInsets.symmetric(horizontal: 23,),
                            child: SizedBox(
                                height: Platform.isAndroid
                                    ? CommonFunctions.deviceWidth(context) <= 360
                                        ? 370.h
                                        : CommonFunctions.deviceWidth(context) <=
                                                393
                                            ? 358.h
                                            : 410.h
                                    : CommonFunctions.deviceHeight(context) *
                                        0.45,

                                //CommonFunctions.deviceHeight(context) * 0.45,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: posesList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: FeaturedPosesCard(
                                        imagePath:
                                            'assets/images/user_profile_video_session.png',
                                        title: posesList[index].poseName,
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text('Explore Yoga Styles',
                                style: manropeHeadingTextStyle.copyWith(
                                    fontSize: 18.sp)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 26),
                              child: Text('View All',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      // stylesList
                      ///Explore Yoga Styles Image Cards
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 18,
                        ),
                        child: Container(
                          height: Platform.isAndroid ?
                          CommonFunctions.deviceWidth(context) <=360 ?
                          435.h :
                          CommonFunctions.deviceWidth(context) <=393 ?
                          470.h :
                          570.h :
                          410.h,
                          //500.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9),
                              bottomLeft: Radius.circular(9),
                              topRight: Radius.circular(9),
                              bottomRight: Radius.circular(9),
                            ),
                            color: Color(0x87e5e5e5),
                          ),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            children: List.generate(
                              stylesList.length,
                              (index) {
                                return Padding(
                                  padding:
                                      // const EdgeInsets.only(left: 23, top: 17, right: 13),
                                      const EdgeInsets.only(
                                          left: 8, top: 8, right: 8, bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    // width: 162,
                                    // height: 230,

                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/yoga_style_1.png',
                                          fit: BoxFit.fill,
                                          width: 162,
                                          height: 503,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 23,
                                              top: 170,
                                              right: 23,
                                              bottom: 16),
                                          child: ClipRect(
                                            child: Center(
                                              child: Text(
                                                stylesList[index].styleName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),



                      ///You May Also Like Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 23, top: 17),
                            child: Text(
                              'You may also like',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.darkGreenGray,
                                height: 1.2,
                              ),
                            ),
                          ),
                          youMayLikeList.isEmpty
                              ? const Text('')
                              : TextButton(
                            onPressed: () {},
                            child:  Padding(
                              padding: EdgeInsets.only(top: 15.0, right: 26),
                              child: Text(
                                'View All',
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Featured Poses Cards
                      youMayLikeList.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.only(
                          left: 23,
                          top: 1,
                        ),
                        child: Text(
                          'Nothing Available',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.darkGreyHeading1),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.symmetric(horizontal: 23),
                        height:Platform.isAndroid ?
                        CommonFunctions.deviceWidth(context) <=360 ?
                        372.h :
                        CommonFunctions.deviceWidth(context) <=393 ?
                        380.h :
                        420.h :
                        CommonFunctions.deviceHeight(context) * 0.47,

                        child: ListView.builder(
                          shrinkWrap: true,
                          // padding: EdgeInsets.only(bottom: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: youMayLikeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: FeaturedPosesCard(
                                imagePath: 'assets/home/also_like_yoga.png',
                                title: youMayLikeList[index],
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
