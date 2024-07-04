import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/page_path.dart';
import '../../../../data/models/yoga_poses_response_model.dart';
import '../../../providers/teachers_providers/home_teacher_provider.dart';
import '../../students_screens/home/components/custom_featured_poses_card.dart';
import '../../students_screens/on_demand/components/custom_search_field.dart';



class PosesAllTeacherScreen extends ConsumerStatefulWidget {
  const PosesAllTeacherScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PosesAllTeacherScreen> createState() => _PosesAllScreenState();
}

class _PosesAllScreenState extends ConsumerState<PosesAllTeacherScreen> {
  late TextEditingController _searchController;

  bool isSearchValid = true;
  bool isSearchTapped = false;

  String searchQuery = '';

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
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    List<PosesResponseModel> posesList = ref.watch(teacherAllPosesProvider);

    List<PosesResponseModel> filteredPoses;
    if (searchQuery.isEmpty) {
      filteredPoses = posesList;
    } else {
      filteredPoses = posesList.where((pose) {
        return pose.poseName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Featured Poses',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.darkSecondaryGray),
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        // iconTheme: const IconThemeData(color: AppColors.greyColor),
      ),
      endDrawer: const DrawerScreen(),

      body:

      SingleChildScrollView(
        child: Wrap(
          children: [

            Column(
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
              ],
            ),


            posesList.isEmpty
                ? const Center(

              child: Text(
                'No Poses Avaialble right now',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.darkGreyHeading1),
              ),
            )
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredPoses.length,
                itemBuilder: (BuildContext context, int index) {
                  final poses = filteredPoses[index];
                  return GestureDetector(
                    onTap: (){
                      print(
                          "POSE ID ON CLICK ===== ${poses.poseId}");
                      GoRouter.of(context).push(
                        //'${PagePath.TeacherDetail}?userid=2');
                          '${PagePath.posesDetailGuide}?id=${poses.poseId}');
                    },
                    child: FeaturedPosesCard(
                      imagePath:
                      'assets/images/user_profile_video_session.png',
                      title: poses.poseName,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),      /// Featured Poses Cards


    );
  }
}
