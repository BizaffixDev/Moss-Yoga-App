import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/common/app_specific_widgets/loader.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/teacher_specialty.dart';
import 'package:moss_yoga/data/models/payment_request_model.dart';
import 'package:moss_yoga/data/models/top_rated_teacher_response_model.dart';
import 'package:moss_yoga/data/models/yoga_poses_response_model.dart';
import 'package:moss_yoga/data/models/yoga_styles_response_model.dart';
import 'package:moss_yoga/presentation/providers/payment_providers/stripe_payment_provider.dart';

import 'package:moss_yoga/presentation/providers/screen_state.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/page_path.dart';
import '../../../providers/home_provider.dart';
import 'components/custom_featured_poses_card.dart';
import 'components/custom_teacher_card.dart';
import 'home_states.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool bookNow = true;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // Call your API here
    //   await ref.read(homeNotifierProvider.notifier).getPoses();
    //   await ref.read(homeNotifierProvider.notifier).getYogaStyles();
    // });
  }

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ///Signup se ao then check if notifier bug comes
        ///check if mounted.
        await ref.read(homeNotifierProvider.notifier).getPoses();
        await ref.read(homeNotifierProvider.notifier).getYogaStyles();
        await ref.read(homeNotifierProvider.notifier).getTopRatedTeachers();
        await ref.read(homeNotifierProvider.notifier).getYouMayAlsoLike();
        await ref.read(homeNotifierProvider.notifier).getStudentData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeStates>(homeNotifierProvider, (previous, screenState) async {
      if (screenState is HomeSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }
      if (screenState is HomeErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          // dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      } else if (screenState is HomeLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });

    List<PosesResponseModel> posesList = ref.watch(allPosesProvider);
    List<YogaStylesResponseModel> stylesList = ref.watch(allYogaStylesProvider);
    List<String> youMayLikeList = ref.watch(youMayAlsoLikeProvider);
    var teacherCardList = ref.watch(topRatedTeachersProvider);
    final savedTeachers = ref.watch(savedTeacherProvider);

    final savedTeacherIds =
        savedTeachers.map((teacher) => teacher.teacherId).toList();

    final savedTeacherCardList = teacherCardList
        .where((teacher) => savedTeacherIds.contains(teacher.teacherId))
        .toList();

    // Create a Set to keep track of unique teacher IDs
    Set<int> uniqueTeacherIds = Set<int>();

    // Step 2: Filter the teacherCardList to include only unique teachers
    List<TopRatedTeacherResponseModel> filteredTeachers =
        teacherCardList.where((teacher) {
      if (!uniqueTeacherIds.contains(teacher.teacherId)) {
        uniqueTeacherIds.add(teacher.teacherId);
        return true;
      }
      return false;
    }).toList();

    // var teacherCardList = [
    //   PosesModel(
    //       imagePath: 'assets/images/user_profile_video_session.png',
    //       title: 'SIDE PLANK'),
    //   PosesModel(
    //       imagePath: 'assets/images/teacher_card_dummy_2.png',
    //       title: 'MOUNTAIN POSE'),
    // ];
    // var teacherCardList = ref.watch(topRatedTeachersProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        toolbarHeight: 70.h,
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        centerTitle: false,
        title: Container(
          width: 100.w,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Image.asset(
              'assets/home/moss_yoga_logo_2.png',
              width: 100.w,
              fit: BoxFit.cover,
              // height: CommonFunctions.deviceHeight(context) * 0.2,
            ),
          ),
        ),
        elevation: 0,
        // backgroundColor: AppColors.lightGreenSecondary,
        backgroundColor: AppColors.white,
        // iconTheme: const IconThemeData(color: AppColors.greyColor),
      ),
      endDrawer: const DrawerScreen(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Top Text Widgets
            bookNow == true
                ? Container(
                    padding:
                        const EdgeInsets.only(left: 23, top: 0, bottom: 16),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 20.sp,
                            color: Color(0xFF202526),
                          ),
                        )
                        ,
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Let’s Find you a Suitable Teacher",
                          style: manropeSubTitleTextStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                      left: 23,
                      top: 21,
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome John,',
                          style:  manropeHeadingTextStyle.copyWith(
                            fontSize: 20.sp,
                            color: Color(0xFF202526),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Let’s Find you a Suitable Teacher",
                          style: manropeSubTitleTextStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

            ///Book Now Card

            bookNow == true
                ? Stack(
                    children: [
                      Image.asset(
                        'assets/images/booknow_image.png',
                        width: 390.w,
                        height: 316.h,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(75,
                           Platform.isIOS ? 200 : 150,
                            75,
                            70),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                AppColors.primaryColor),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(
                                  CommonFunctions.deviceWidth(context) * 0.17,
                                  12,
                                  CommonFunctions.deviceWidth(context) * 0.17,
                                  12),
                            ),
                          ),
                          onPressed: () {
                          },
                          child: const Text(
                            'BOOK NOW',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                :
                // SvgPicture.asset(
                //   "assets/svgs/home/Vector.svg",
                //   // fit: BoxFit.cover,
                //   width: 425,
                //   height: 316,
                // ),

                ///Video session Card
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.fromLTRB(23, 17, 0, 17),
                    child: Container(
                      color: AppColors.lightGreenSecondary,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 16, 2, 0),
                                child: Text(
                                  "Your Video Session with Jessica",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: AppColors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 2, 0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Doe will start in',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.black),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Single tapped.
                                          },
                                      ),
                                      TextSpan(
                                          text: ' 04:12',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: AppColors.redColor),
                                          recognizer:
                                              DoubleTapGestureRecognizer()
                                                ..onDoubleTap = () {
                                                  DialogButton(
                                                    onPressed: () {},
                                                    child: const Text(
                                                        'Goto your meeting Room'),
                                                  );
                                                }),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 16, 71, 19),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.darkPrimaryGreen),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.fromLTRB(46, 13, 46, 12),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Join'),
                                ),
                              ),
                            ],
                          ),

                          ///Background + Picture
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Transform(
                                    transform:
                                        Matrix4.translationValues(12, 0, 0),
                                    // Adjust the X value as needed
                                    child: SizedBox(
                                      width: 126,
                                      height: 136,
                                      child: ClipRect(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: 0.85,
                                          child: Image.asset(
                                            "assets/images/background_dots_video_session.png",
                                            fit: BoxFit.contain,
                                            width: 116,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 100,),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 29, left: 13),
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/images/user_profile_video_session.png",
                                          // width: 180,
                                          //   height: 180,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

            ///Top Rated Teachers
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///Top Rated Teachers Heading & View All
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23, top: 17),
                      child: Text(
                        'Top Rated Teachers',
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.darkGreenGray,
                          height: 1.2,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(PagePath.topRatedTeachers);
                      },
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



                ///Top Rated Teachers Card
                Container(
                  height:CommonFunctions.isSmallDevice(context) ? 400.h : 280.h,
                  width: 390.w,
                  padding: EdgeInsets.only(left: 30.w, right: 30.w),
                  child: filteredTeachers.isEmpty
                      ? const Text('No Teachers available right now')
                      : ListView.builder(
                         physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredTeachers.length,
                          // Replace with your actual item count
                          itemBuilder: (context, index) {
                            final teacher = filteredTeachers[index];
                            //final teacher = teacherCardList[index];
                            final isTeacherSaved = savedTeachers
                                .any((t) => t.teacherId == teacher.teacherId);

                            return Padding(
                              padding:  EdgeInsets.only(right: 10.w),
                              child: CustomTeacherCard(
                                teacherId: teacher.teacherId,
                                rating: teacher.avgRatingValue,
                                //rating: teacher.avgRatingValue.toStringAsFixed(1),
                                saveTeacher: () {
                                  if (isTeacherSaved) {
                                    ref
                                        .read(savedTeacherProvider.notifier)
                                        .deleteTeacher(teacher.teacherId);
                                  } else {
                                    ref
                                        .read(savedTeacherProvider.notifier)
                                        .addTeacher(teacher);
                                  }
                                },
                                saveIcon: isTeacherSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                //rightMrgin: 25.w,
                                imagePath:
                                    'assets/images/teacher_card_dummy_2.png',
                                teacherName: '${teacher.teacherFirstName}',
                                //'${teacher.teacherFirstName} ${teacherCardList[index].teacherLastName}',
                                //   imagePath: teacherCardList[index].profilePicture
                                teacherOccupation: teacher.occupation,
                                price: "\$" + teacher.getDatesResponse[0].price,
                                onTap: () {
                                  ref.read(teacherNameProvider.notifier).state =
                                      teacher.teacherFirstName;
                                  ref
                                          .read(teacherRatingProvider.notifier)
                                          .state =
                                      teacher.maxRatingValue.toString();
                                  ref
                                      .read(teacherOccupationProvider.notifier)
                                      .state = teacher.occupation;
                                  ref
                                      .read(teacherAboutProvider.notifier)
                                      .state = teacher.teacherHeadline;
                                  ref.read(teacherCityProvider.notifier).state =
                                      teacher.city;
                                  // ref
                                  //     .read(teacherPriceProvider.notifier)
                                  //     .state = teacher.price;
                                  //ref.read(teacherSpecialtyList.notifier).state = teacher.sp;

                                  ref
                                      .read(homeNotifierProvider.notifier)
                                      .updateTeacherSpecialitiesList(
                                          teacher.teacherSpeciality);

                                  //ref.read(teacherPriceProvider.notifier).state = teacherCardList[index].;

                                  print(
                                      "TEACHER ID ON CLICK ===== ${teacher.teacherId}");
                                  GoRouter.of(context).push(
                                      //'${PagePath.TeacherDetail}?userid=2');
                                      '${PagePath.TeacherDetail}?userid=${teacher.teacherId}');
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

            ///Featured Poses

            ///Featured Poses Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 23, top: 17),
                  child: Text(
                    'Featured Poses',
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.darkGreenGray,
                      height: 1.2,
                    ),
                  ),
                ),
                posesList.isEmpty
                    ? const Text('')
                    : TextButton(
                        onPressed: () {
                          context.push(PagePath.posesViewAll);
                        },
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
                      height: Platform.isAndroid ?
                      CommonFunctions.deviceWidth(context) <=360 ?
                      370.h :
                      CommonFunctions.deviceWidth(context) <=393 ?
                      358.h :
                      410.h :
                      CommonFunctions.deviceHeight(context) * 0.45,
                      //height: Platform.isAndroid ? CommonFunctions.deviceWidth(context) <=360 ? 370.h : 410.h : CommonFunctions.deviceHeight(context) * 0.45,


                      //CommonFunctions.deviceHeight(context) * 0.45,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    "POSE ID ON CLICK ===== ${posesList[index].poseId}");
                                GoRouter.of(context).push(
                                    //'${PagePath.TeacherDetail}?userid=2');
                                    '${PagePath.posesDetailGuide}?id=${posesList[index].poseId}');
                              },
                              child: FeaturedPosesCard(
                                imagePath:
                                    'assets/images/user_profile_video_session.png',
                                title: posesList[index].poseName,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

            ///Explore Yoga Styles

            ///Explore Yoga Style Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 23, top: 17),
                  child: Text(
                    'Explore Yoga Styles',
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.darkGreenGray,
                      height: 1.2,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push(PagePath.stylesViewAll);
                  },
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
            // stylesList
            ///Explore Yoga Styles Image Cards
            Container(
              height:Platform.isAndroid ?
              CommonFunctions.deviceWidth(context) <=360 ?
              435.h :
              CommonFunctions.deviceWidth(context) <=393 ?
              470.h :
              570.h :
              400.h,
              //500.h,
              margin: EdgeInsets.symmetric(horizontal: 23,),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(9),
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
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(
                              //'${PagePath.TeacherDetail}?userid=2');
                              '${PagePath.styleDetailGuide}?id=${stylesList[index].styleId}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.transparent,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/yoga_style_1.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          // width: 162,
                          // height: 230,

                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                stylesList[index].styleName,
                                style:manropeSubTitleTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),


                        ),
                      ),
                    );
                  },
                ),
              ),
            ),



            ///You May Also Like

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
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15.0, right: 26),
                          child: Text(
                            'View All',
                            style: TextStyle(
                                color: AppColors.lightSecondaryGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
              ],
            ),

            /// Featured Poses Cards
            youMayLikeList.isEmpty
                ?  Padding(
                    padding: EdgeInsets.only(
                      left: 23,
                      top: 1,
                    ),
                    child: Text(
                      'Nothing Available',
                      style: manropeSubTitleTextStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 23,),
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
          ],
        ),
      ),
    );
  }
}
