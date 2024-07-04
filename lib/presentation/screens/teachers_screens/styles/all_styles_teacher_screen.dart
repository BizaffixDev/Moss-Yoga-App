import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/page_path.dart';
import '../../../../data/models/yoga_styles_response_model.dart';

import '../../../providers/teachers_providers/home_teacher_provider.dart';
import '../../students_screens/on_demand/components/custom_search_field.dart';


class StylesAllTeacherScreen extends ConsumerStatefulWidget {
  const StylesAllTeacherScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StylesAllTeacherScreen> createState() => _StylesAllScreenState();
}

class _StylesAllScreenState extends ConsumerState<StylesAllTeacherScreen> {
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
    List<YogaStylesResponseModel> stylesList = ref.watch(teacherAllYogaStylesProvider);

    List<YogaStylesResponseModel> filteredStyles;
    if (searchQuery.isEmpty) {
      filteredStyles = stylesList;
    } else {
      filteredStyles = stylesList.where((style) {
        return style.styleName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }


    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Yoga Styles',
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

      body:     SingleChildScrollView(
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


            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                ),
                color: Color(0x87e5e5e5),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: List.generate(
                  filteredStyles.length,
                      (index) {
                    final style = filteredStyles[index];
                    return Padding(
                      padding:
                      // const EdgeInsets.only(left: 23, top: 17, right: 13),
                      const EdgeInsets.only(
                          left: 8, top: 8, right: 8, bottom: 8),
                      child: GestureDetector(
                        onTap: (){
                          GoRouter.of(context).push(
                              '${PagePath.styleDetailGuide}?id=${style.styleId}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.transparent,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/yoga_style_1.png',),
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
                                style.styleName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: AppColors.white),
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
          ],
        ),
      ),      /// Featured Poses Cards


    );
  }
}
