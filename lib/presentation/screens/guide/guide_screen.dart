import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/page_path.dart';


import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../../data/models/guideAZResponse.dart';
import '../../../../data/models/yoga_poses_response_model.dart';
import '../../../../data/models/yoga_styles_response_model.dart';
import '../../../common/app_specific_widgets/drawer.dart';
import '../../providers/guide_provider.dart';
import '../../providers/screen_state.dart';
import '../students_screens/on_demand/components/custom_search_field.dart';
import 'components/pose_container.dart';
import 'components/style_container.dart';
import 'guide_states.dart';


class GuideScreen extends ConsumerStatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends ConsumerState<GuideScreen> with TickerProviderStateMixin{

  late int _startingTabCount;
  final List<Tab> _tabs = <Tab>[];
  late TabController _tabController;
  late TextEditingController _searchController;




  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();

  }


  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(guideNotifierProvider.notifier).getPosesGuide();
        await ref.read(guideNotifierProvider.notifier).getYogaStylesGuide();
        await ref.read(guideNotifierProvider.notifier).getGuideData();
      });
    }
  }



  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }



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
  Widget build(BuildContext context) {

    ref.listen<GuideStates>(guideNotifierProvider, (previous, screenState) async {
      if (screenState is GuideSuccessfulState) {
        dismissLoading(context);
        setState(() {});
      }
      else if (screenState is GuideErrorState) {
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
      }

      else if (screenState is GuideLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });


    List<PosesResponseModel> posesList = ref.watch(allPosesGuideProvider);
    List<YogaStylesResponseModel> stylesList = ref.watch(allYogaStylesGuideProvider);


    final guideList = ref.watch(guideListProvider.notifier).state.guideMap;







    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Guide",
          style: manropeHeadingTextStyle.copyWith(
            fontSize: 20.sp,
          ),
        ),
      ),
      endDrawer: const DrawerScreen(),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            color: Colors.white,
            child: TabBar(
              padding: EdgeInsets.all(10),
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              unselectedLabelColor:const Color(0xFFC4C4BC),
              unselectedLabelStyle: manropeSubTitleTextStyle.copyWith(
                fontSize: 16.sp,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFC4C4BC),
              ),
              labelColor: Colors.black,
              labelStyle:  manropeSubTitleTextStyle.copyWith(
                fontSize: 16.sp,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color:  Colors.black,
              ),
              labelPadding: EdgeInsets.symmetric(vertical: 10),
              tabs:  const [
                // Tab(text: 'Previous Teacher',),
                 Text(
                  'Styles',

                ),
                Text(
                  'Poses',

                ),
                Text(
                  'Guide A-Z',

                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [


                //STYLES TAB
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: stylesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0, // Vertical spacing between containers
                    crossAxisSpacing: 8.0, // Horizontal spacing between containers
                  ),
                  itemBuilder: (context,index){
                    return   StyleContainer(
                      onTap: (){
                        print("STYLE ID ON CLICK======== ${stylesList[index].styleId}");
                        GoRouter.of(context).push(
                          //'${PagePath.TeacherDetail}?userid=2');
                            '${PagePath.styleDetailGuide}?id=${stylesList[index].styleId}');
                      },
                      styleName: stylesList[index].styleName,
                    );
                  },
                ),


                //POSES TAB

                ListView.builder(
                    shrinkWrap: true,
                    itemCount: posesList.length,
                    itemBuilder: (context,index){
                      return PosesContainer(
                        onTap: (){
                          print("POSE ID ON CLICK======== ${posesList[index].poseId}");
                          GoRouter.of(context).push(
                            //'${PagePath.TeacherDetail}?userid=2');
                              '${PagePath.posesDetailGuide}?id=${posesList[index].poseId}');
                        },
                        poseName: posesList[index].poseName,
                      );


                      //   Row(
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 20.w),
                      //       height: 15.h,
                      //       width: 15.h,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: AppColors.primaryColor,
                      //       ),
                      //     ),
                      //     PosesContainer(
                      //       onTap: (){
                      //         print("POSE ID ON CLICK======== ${posesList[index].poseId}");
                      //         GoRouter.of(context).push(
                      //           //'${PagePath.TeacherDetail}?userid=2');
                      //             '${PagePath.posesDetailGuide}?id=${posesList[index].poseId}');
                      //       },
                      //       poseName: posesList[index].poseName,
                      //     ),
                      //   ],
                      // );
                    }),



                //GUIDE TAB


                SingleChildScrollView(
                  child: Container(
                    height: CommonFunctions.deviceHeight(context) * 2.3,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
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
                          filterTap: (){},
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: guideList.length,
                                itemBuilder: (context, index){
                                  final letter = guideList.keys.elementAt(index);
                                  final guideResponses = guideList[letter]!;

                                  final filteredGuideResponses = guideResponses.where((guideResponse) {
                                    final name = guideResponse.name.toLowerCase();
                                    return name.contains(searchQuery.toLowerCase());
                                  }).toList();

                                  // Check if there are any filtered results
                                  bool isSearchValid = filteredGuideResponses.isNotEmpty;


                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Container(
                                          //   height: 15.h,
                                          //   width: 15.h,
                                          //   decoration: BoxDecoration(
                                          //     shape: BoxShape.circle,
                                          //     color: AppColors.primaryColor,
                                          //   ),
                                          // ),
                                          //
                                          // SizedBox(width: 20.w,),

                                          Text(letter,style: manropeHeadingTextStyle,),
                                        ],
                                      ),
                                      Visibility(
                                        visible: isSearchValid,
                                        child: GridView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: filteredGuideResponses.length,
                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                            shrinkWrap: true,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 6,
                                              mainAxisSpacing: 2,

                                            ),
                                            itemBuilder: (context,index){
                                             //final guideResponse = guideResponses[index];
                                              final guideResponse = filteredGuideResponses[index];
                                              return GestureDetector(
                                                onTap: (){
                                                  GoRouter.of(context).push(
                                                    //'${PagePath.TeacherDetail}?userid=2');
                                                     '${PagePath.guideDetail}?id=${guideResponse.keyId}&type=${guideResponse.type}');
                                                },
                                                child: Text(guideResponse.name,
                                                  style: manropeSubTitleTextStyle.copyWith(
                                                      fontSize: 16.sp,
                                                      color: const Color(0xFF5B5B5B)
                                                  ),),
                                              );
                                            }),
                                      ),
                                    ],
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
    );
  }
}




