import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/data/models/poses_model.dart';
import 'package:moss_yoga/presentation/screens/students_screens/top_rated_teachers/components/custom_teacher_card_top_rated.dart';


import '../../../../app/utils/common_functions.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../../data/models/top_rated_teacher_response_model.dart';
import '../../../providers/home_provider.dart';
import '../home/components/custom_teacher_card.dart';
import '../on_demand/components/custom_search_field.dart';

class TopRatedTeachersScreen extends ConsumerStatefulWidget {
  const TopRatedTeachersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TopRatedTeachersScreen> createState() =>
      _TopRatedTeachersScreenState();
}

class _TopRatedTeachersScreenState
    extends ConsumerState<TopRatedTeachersScreen> {
  late TextEditingController _searchController;

  bool isSearchValid = true;
  bool isSearchTapped = false;

  String searchQuery = '';



  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void handleSearch(String query) {
    // setState(() {
    //   isSearchValid = query.isNotEmpty;
    // });
    // if (isSearchValid) {
    //   // Perform search logic here
    //   // searchTeachers(query);
    //   print('Search: $query');
    // }
    setState(() {
      searchQuery = query;
    });
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




  @override
  Widget build(BuildContext context) {



    var teacherCardListProvider = ref.watch(topRatedTeachersProvider);

// Step 1: Create a Set to store unique teacher IDs
    Set<int> uniqueTeacherIds = Set();

// Step 2: Filter the teacherCardList to include only unique teachers
    List<TopRatedTeacherResponseModel> filteredTeachers = teacherCardListProvider.where((teacher) {
      if (!uniqueTeacherIds.contains(teacher.teacherId)) {
        uniqueTeacherIds.add(teacher.teacherId);
        return true;
      }
      return false;
    }).toList();


    final savedTeachers = ref.watch(savedTeacherProvider);


    final savedTeacherIds = savedTeachers.map((teacher) => teacher.teacherId).toList();

    final savedTeacherCardList = teacherCardListProvider
        .where((teacher) => savedTeacherIds.contains(teacher.teacherId))
        .toList();






    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.black),
        elevation: 0,
        backgroundColor: AppColors.white,
        // iconTheme: const IconThemeData(color: AppColors.greyColor),
      ),
      endDrawer: DrawerScreen(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: [
            ///Ready to Practice Plus SearchBar
            SearchPage(
              searchController: _searchController,
              isMyTeachersTab: true,
              // Set to true if it's My Teachers tab
              onSearch: handleSearch,
              onSearchTap: handleSearchTap,
              onSearchFocusChange: handleSearchFocusChange,
              isSearchValid: isSearchValid,
              isSearchTapped: isSearchTapped,
              filterTap: (){},
            ),

            ///Top Rated Teachers
            Container(
              color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Top Rated Teachers Heading & View All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 23, top: 17,bottom: 10),
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
            ),



            ///Top Rated Teachers Card
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h,),
              color: Colors.white,

              //padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),

              child:
                   filteredTeachers.isEmpty
                  ? Container(
                     height: CommonFunctions.deviceHeight(context),
                     width: CommonFunctions.deviceWidth(context),
                     color: Colors.white,
                     margin: EdgeInsets.only(top: 200.h),
                     padding:  EdgeInsets.symmetric(horizontal: 20.w),
                     child: Text('No Teachers available right now',
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
                     childAspectRatio: 0.685,
                     children: List.generate(
                         filteredTeachers.length,
                             (index) {
                           //final teacher = teacherCardListProvider[index];
                           // final teacher = teacherCardListProvider[index];
                           final teacher = filteredTeachers[index];
                           final isTeacherSaved = savedTeachers.any((t) => t.teacherId == teacher.teacherId);
                           return Container(
                             margin: EdgeInsets.only(bottom: 10.h,),
                             child:



                             CustomTeacherCardTopRated(

                               rating: teacher.maxRatingValue,
                               //rating: teacher.avgRatingValue.toStringAsFixed(1),
                               teacherOccupation: teacher.occupation,
                               price:   "\$" + teacher.getDatesResponse[0].price,
                               saveTeacher: (){
                                 if (isTeacherSaved) {
                                   ref.read(savedTeacherProvider.notifier).deleteTeacher(teacher.teacherId);
                                 } else {
                                   ref.read(savedTeacherProvider.notifier).addTeacher(teacher);
                                 }
                               },
                               saveIcon: isTeacherSaved ? Icons.bookmark : Icons.bookmark_border,
                               imagePath:
                               'assets/images/teacher_card_dummy_2.png',
                               teacherName:
                               teacher.teacherFirstName,
                               //   imagePath: teacherCardList[index].profilePicture
                               onTap: () async{

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
                                 GoRouter.of(context).push(
                                   //'${PagePath.TeacherDetail}?userid=2');
                                     '${PagePath.TeacherDetail}?userid=${teacher.teacherId}');
                               }, teacherId: teacher.teacherId,
                             ),
                           );
                         }),
                   ),
            ),

            SizedBox(height: 10.h,),


          ],
        ),
      ),
    );
  }
}
