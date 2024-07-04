import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/presentation/providers/my_teachers_provider.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_teacher/my_teachers_states.dart';

import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/page_path.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/screen_state.dart';
import '../on_demand/components/custom_search_field.dart';
import '../on_demand/components/custom_teacher_card_on_demand.dart';
import '../top_rated_teachers/components/custom_teacher_card_top_rated.dart';
import 'components/my_classes_btn.dart';

class MyTeachersScreen extends ConsumerStatefulWidget {
  const MyTeachersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyTeachersScreen> createState() => _MyTeachersScreenState();
}

class _MyTeachersScreenState extends  ConsumerState<MyTeachersScreen>
    with TickerProviderStateMixin {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  late int _startingTabCount;
  List<Tab> _tabs = <Tab>[];
  late TabController _tabController;
  late TextEditingController _searchController;


  List<String> displayedTeachersForPrevious = [];
  List<String> displayedTeachersForSaved = [];

  bool isSearchValid = true;
  bool isSearchTapped = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();

    // displayedTeachersForPrevious.addAll(previousTeachers);
    // displayedTeachersForSaved.addAll(savedTeachers);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(myTeachersNotifierProvider.notifier)
            .getPreviousTeachers(studentId: ref.read(studentIdProvider).toString());

        print("STUDENT ID ON PREVIOUS TEACHERS API ${ref.read(studentIdProvider)}");

      });
    }
  }



  void searchTeachers(String query) {
    setState(() {
      displayedTeachersForPrevious.clear();
      displayedTeachersForSaved.clear();

      if (_tabController.index == 0) {
        // Previous Teacher Tab
        //displayedTeachersForPrevious.addAll(
          // previousTeachers.where(
          //   (teacher) => teacher.toLowerCase().contains(
          //         query.toLowerCase(),
          //       ),
          // ),
        //);
      //  displayedTeachersForSaved.addAll(savedTeachers);
      } else {
        // Saved Teacher Tab
        //displayedTeachersForPrevious.addAll(previousTeachers);
        // displayedTeachersForSaved.addAll(
        //   savedTeachers.where(
        //     (teacher) => teacher.toLowerCase().contains(
        //           query.toLowerCase(),
        //         ),
        //   ),
        // );
      }
    });
  }

  void handleSearch(String query) {
    setState(() {
      isSearchValid = query.isNotEmpty;
    });
    if (isSearchValid) {
      // Perform search logic here
      searchTeachers(query);
      print('Search: $query');
    }
  }

  void handleSearchTap() {
    setState(() {
      isSearchTapped = true;
    });
  }

  void handleSearchFocusChange() {
    setState(() {
      isSearchTapped = false;
    });
  }

  // Function to format the date
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM, yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    var teacherCardListProvider = ref.watch(previousTeachersProvider);
    final savedTeachers = ref.watch(savedPreviousTeacherProvider);


    final savedTeacherIds = savedTeachers.map((teacher) => teacher.teacherId).toList();

    final savedTeacherCardList = teacherCardListProvider
        .where((teacher) => savedTeacherIds.contains(teacher.teacherId))
        .toList();

    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date
    String formattedDate = formatDate(now);


    ref.listen<MyTeachersStates>(myTeachersNotifierProvider, (previous, screenState) async {
      if (screenState is MyTeachersLoadingState) {
        showLoading(context);
        setState(() {});
      }

      else if (screenState is MyTeachersSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }

      else if (screenState is MyTeachersErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
           dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 140);
          dismissLoading(context);
        }
      }

      else if (screenState is MyTeachersLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }

      else {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });


    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: DrawerScreen(),

      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
           SliverAppBar(
            iconTheme: const IconThemeData(color: AppColors.neutral53),
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Teachers',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.darkSecondaryGray),
              ),
            ),
            elevation: 0,
            backgroundColor: AppColors.white,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: manropeHeadingTextStyle.copyWith(
                  fontSize: 16.sp,
                  color: Colors.grey
              ),

              labelColor: AppColors.primaryColor,
              labelStyle:  manropeSubTitleTextStyle.copyWith(
                fontSize: 16.sp,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color:  Colors.black,
              ),
              labelPadding: EdgeInsets.symmetric(vertical: 10),
              tabs: const [
                // Tab(text: 'Previous Teacher',),
                Text(
                  'Previous Teacher',

                ),
                Text(
                  'Saved Teacher',
                ),
              ],
            ),
          ),
        ];
      }, body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: [
            ///Ready to Practice Plus SearchBar
            Container(
              padding:  EdgeInsets.only(
                top: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SearchPage(
                    searchController: _searchController,
                    isMyTeachersTab: true,
                    // Set to true if it's My Teachers tab
                    onSearch: handleSearch,
                    onSearchTap: handleSearchTap,
                    onSearchFocusChange: handleSearchFocusChange,
                    isSearchValid: isSearchValid,
                    isSearchTapped: isSearchTapped,
                  ),


                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [

                        SizedBox(height: 10.h,),

                        MyClassesBtn(
                          onTap: (){
                            //context.push(PagePath.myClassesStudent);
                            GoRouter.of(context).push(
                                '${PagePath.myClassesStudent}');
                          },
                        ),

                        SizedBox(height: 10.h,),




                        Container(
                          color: Colors.white,
                          child: SizedBox(
                            height: CommonFunctions.deviceHeight(context) * 1.5,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Previous Teacher Tab Content

                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  color: Colors.white,

                                  //padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),

                                  child:
                                  teacherCardListProvider.isEmpty
                                      ?  Container(
                                    margin: EdgeInsets.only(top: 200.h),
                                        padding:  EdgeInsets.symmetric(horizontal: 20.w),
                                        child: Text('Your teachers will appear here once you book a class',
                                  style: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 16.sp,
                                    color: Color(0XFF828282),
                                    height: 1.2,
                                  ),
                                    textAlign: TextAlign.center,
                                  ),
                                      )
                                      :

                                  GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    children: List.generate(
                                        teacherCardListProvider.length,
                                            (index) {
                                          //final teacher = teacherCardListProvider[index];
                                          final teacher = teacherCardListProvider[index];
                                          final isTeacherSaved = savedTeachers.any((t) => t.teacherId == teacher.teacherId);
                                          return Container(
                                            margin: EdgeInsets.only(bottom: 10.h,),
                                            child: CustomTeacherCardOnDemand(
                                              rating: teacher.avgRatingValue,
                                              //rating: teacher.avgRatingValue.toStringAsFixed(1),
                                              teacherOccupation: teacherCardListProvider[index].occupation,
                                              price:  teacherCardListProvider[index].price,
                                              saveTeacher: (){
                                                if (isTeacherSaved) {
                                                  ref.read(savedTeacherProvider.notifier).deleteTeacher(teacher.teacherId);
                                                } else {
                                                  ref.read(savedPreviousTeacherProvider.notifier).addTeacher(teacher);
                                                }
                                              },
                                              saveIcon: isTeacherSaved ? Icons.bookmark : Icons.bookmark_border,
                                              imagePath:
                                              'assets/images/teacher_card_dummy_2.png',
                                              teacherName:
                                              '${teacherCardListProvider[index].teacherFirstName}',
                                              //   imagePath: teacherCardList[index].profilePicture
                                              onTap: () async{

                                                print(
                                                    "TEACHER ID ON CLICK ===== ${teacher.teacherId}");
                                                GoRouter.of(context).push(
                                                  //'${PagePath.TeacherDetail}?userid=2');
                                                    '${PagePath.TeacherDetail}?userid=${teacher.teacherId}');

                                                //'${PagePath.TeacherDetail}?userid=${teacherCardListProvider[index].teacherId}');
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                ),




                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  color: Colors.white,

                                  //padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),

                                  child:
                                  teacherCardListProvider.isEmpty
                                      ?

                                  Container(
                                    margin: EdgeInsets.only(top: 200.h),
                                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Text('Saved Sessions listed here',
                                      style: manropeSubTitleTextStyle.copyWith(
                                        fontSize: 16.sp,
                                        color: Color(0XFF828282),
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                      :

                                  GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    children: List.generate(
                                        savedTeacherCardList.length,
                                            (index) {
                                          //final teacher = teacherCardListProvider[index];
                                              final teacher = savedTeacherCardList[index];
                                              final isTeacherSaved = savedTeachers.any((t) => t.teacherId == teacher.teacherId);
                                          return Container(
                                            margin: EdgeInsets.only(bottom: 10.h,),
                                            child: CustomTeacherCardOnDemand(
                                              rating: teacher.avgRatingValue,
                                              //rating: teacher.avgRatingValue.toStringAsFixed(1),
                                              teacherOccupation: teacherCardListProvider[index].occupation,
                                              price:  teacherCardListProvider[index].price,
                                              saveTeacher: (){
                                                  if (isTeacherSaved) {
                                                    ref.read(savedTeacherProvider.notifier).deleteTeacher(teacher.teacherId);
                                                  } else {
                                                    ref.read(savedPreviousTeacherProvider.notifier).addTeacher(teacher);
                                                  }
                                              },
                                              saveIcon: isTeacherSaved ? Icons.bookmark : Icons.bookmark_border,
                                              imagePath:
                                              'assets/images/teacher_card_dummy_2.png',
                                              teacherName:
                                              '${teacherCardListProvider[index].teacherFirstName}',
                                              //   imagePath: teacherCardList[index].profilePicture
                                              onTap: () async{

                                                    print(
                                                        "TEACHER ID ON CLICK ===== ${teacher.teacherId}");
                                                    GoRouter.of(context).push(
                                                      //'${PagePath.TeacherDetail}?userid=2');
                                                        '${PagePath.TeacherDetail}?userid=${teacher.teacherId}');

                                                //'${PagePath.TeacherDetail}?userid=${teacherCardListProvider[index].teacherId}');
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                ),







                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),

            /*///Top Rated Teachers
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///Top Rated Teachers Heading & View All
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 23, top: 17),
                      child: Text(
                        'Top Rated Teachers',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.neutral53),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            ///Top Rated Teachers Card
            SizedBox(
              height: CommonFunctions.deviceHeight(context) * 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.5,
                  crossAxisCount: 2,
                ),
                physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return CustomTeacherCardOnDemand(
                    imagePath: 'assets/images/yoga_pose_1.png',
                    teacherName: "jenny",
                    onTap: () {},
                  );
                  // );
                },
              ),
            ),*/
          ],
        ),
      ),

      ),









    );
  }
}


