import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/data/models/certfication_level_model.dart';
import 'package:moss_yoga/presentation/screens/students_screens/on_demand/on_demand_states/on_demand_states.dart';


import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/app_specific_widgets/loader.dart';

import '../../../providers/on_demand_student_provider.dart';
import '../../../providers/screen_state.dart';
import '../on_demand/components/custom_search_field.dart';
import '../on_demand/components/custom_teacher_card_on_demand.dart';


class Gender {
  final String name;

  Gender(this.name);
}

class AvailableTeachersScreen extends ConsumerStatefulWidget {
  const AvailableTeachersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AvailableTeachersScreen> createState() => _AvailableTeachersScreenState();
}

class _AvailableTeachersScreenState extends ConsumerState<AvailableTeachersScreen> {
  late TextEditingController _searchController;

  bool isSearchValid = true;
  bool isSearchTapped = false;

  @override
  void initState() {
    super.initState();
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
        await ref.read(onDemandStudentNotifierProvider.notifier)
            .getTopRatedTeachers();
      });
    }
  }


  void handleSearch(String query) {
    setState(() {
      isSearchValid = query.isNotEmpty;
    });
    if (isSearchValid) {
      // Perform search logic here
      // searchTeachers(query);
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

  @override
  Widget build(BuildContext context) {

    ref.listen<OnDemandStudentStates>(onDemandStudentNotifierProvider,
            (previous, screenState) async {
          if (screenState is OnDemandStudentSuccessfulState) {
            dismissLoading(context);
            setState(() {});
          } else if (screenState is FilterStudentSuccessfulState) {
            dismissLoading(context);
            setState(() {});
          }
          else if (screenState is OnDemandStudentBookingSuccessfulState) {
            dismissLoading(context);
            ref
                .read(requestSentProvider.notifier)
                .state = true;
            GoRouter.of(context).push(PagePath.onDemandStudentRequest);
            setState(() {});
          }
          else if (screenState is OnDemandStudentErrorState) {
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
              // dismissLoading(context);
            } else {
              print("This is the error thats not shwoing: ${screenState.error}");
              UIFeedback.showSnackBar(context, screenState.error.toString(),
                  height: 140);
              dismissLoading(context);
            }
          } else if (screenState is FilterStudentErrorState) {
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
              // dismissLoading(context);
            } else {
              print("This is the error thats not shwoing: ${screenState.error}");
              UIFeedback.showSnackBar(context, screenState.error.toString(),
                  height: 140);
              dismissLoading(context);
            }
          } else if (screenState is OnDemandStudentBookingErrorState) {
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
              // dismissLoading(context);
            } else {
              print("This is the error thats not shwoing: ${screenState.error}");
              UIFeedback.showSnackBar(context, screenState.error.toString(),
                  height: 140);
              dismissLoading(context);
            }
          } else if (screenState is OnDemandStudentBookingLoadingState) {
            debugPrint('Loading');
            showLoading(context);
            // setState(() {});
          } else {
            debugPrint('Loading');
            showLoading(context);
            // setState(() {});
          }
        });

    var teacherCardListProvider = ref.watch(onDemandOnlineTeachersProvider);
    final savedTeachers = ref.watch(savedTeacherProvider);


    final savedTeacherIds = savedTeachers.map((teacher) => teacher.teacherId).toList();

    final savedTeacherCardList = teacherCardListProvider
        .where((teacher) => savedTeacherIds.contains(teacher.teacherId))
        .toList();

    double lowerValue = 50;
    double upperValue = 180;

    List<Gender> genders = [
      Gender('Male'),
      Gender('Female'),
      Gender('Neutral'),
    ];

    Gender? selectedGender;
    CertificationLevel? selectedLevel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral53),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Available Teachers',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: [
            ///Ready to Practice Plus SearchBar
            Container(
              padding: const EdgeInsets.only(
                left: 23,
                right: 23,
                top: 21,
                bottom: 21,
              ),
              child: SearchPage(
                searchController: _searchController,
                isMyTeachersTab: false,
                // Set to true if it's My Teachers tab
                onSearch: handleSearch,
                onSearchTap: handleSearchTap,
                onSearchFocusChange: handleSearchFocusChange,
                isSearchValid: isSearchValid,
                isSearchTapped: isSearchTapped,
                filterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return buildFilterBody(lowerValue, upperValue,
                          genders, selectedGender, selectedLevel);
                    },
                  );
                },
              ),
            ),

            ///ON Demand Techers
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              color: Colors.white,

              //padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),
                ///Usman add this
                // requestText: ref
                // .read(requestSentProvider.notifier)
                //.state ==
                //false
                //? "Book Now"
                //: "Request Sent",
              child:
              teacherCardListProvider.isEmpty
                  ? const Text('No Teachers available right now')
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
                          teacherOccupation: teacher.occupation,
                          price: "\$" +  teacher.getDatesResponse[0].price,
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
                          '${teacherCardListProvider[index].teacherFirstName}',
                          //   imagePath: teacherCardList[index].profilePicture
                          onTap: () async{

                            await ref
                                .read(onDemandStudentNotifierProvider
                                .notifier)
                                .bookSession(
                                bookingCode:
                                teacher.getDatesResponse[0].teacherSchedulingDetailCode,
                                date:
                                '${teacher.getDatesResponse[0].availableDates}');


                            ref.read(teacherNameProvider.notifier).state = teacher.teacherFirstName;
                            ref.read(teacherRatingProvider.notifier).state = teacher.avgRatingValue;
                            ref.read(teacherPriceProvider.notifier).state = teacher.getDatesResponse[0].price;


                            print(
                                "TEACHER ID ON CLICK ===== ${teacher.teacherId}");

                            print(
                                "BOOKING CODE ON CLICK ===== ${teacher.getDatesResponse[0].teacherSchedulingDetailCode}");

                            print(
                                "REQUEST STATUS ===== ${ref.read(requestSentProvider.notifier).state}");

                            //'${PagePath.TeacherDetail}?userid=${teacherCardListProvider[index].teacherId}');
                          },
                        ),
                      );
                    }),
              ),
            ),


          ],
        ),
      )
    );
  }

  Widget buildFilterBody(
      double lowerValue,
      double upperValue,
      List<Gender> genders,
      Gender? selectedGender,
      CertificationLevel? selectedLevel) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            width: MediaQuery.of(context).size.width,
            height: 750.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [

                  SizedBox(
                    height: 20.h,
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 80.w),
                    child: Divider(
                      height: 5,
                      color: AppColors.primaryColor,
                      thickness: 4,
                    ),
                  ),
                  Text(
                    "Budget",
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),

                  FlutterSlider(
                    values: const [30, 420],
                    rangeSlider: true,
                    max: 500,
                    min: 0,
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarHeight: 5,
                      inactiveTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      activeTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primaryColor,
                      ),
                    ),
                    tooltip: FlutterSliderTooltip(
                      boxStyle: FlutterSliderTooltipBox(
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8))),
                      textStyle: const TextStyle(
                          fontSize: 17,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      lowerValue = lowerValue;
                      upperValue = upperValue;
                      setState(() {});
                    },
                  ),

                  Text(
                    "Gender Preference",
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List<Widget>.generate(
                      genders.length,
                          (int index) {
                        final gender = genders[index];
                        return ChoiceChip(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primaryColor.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: AppColors.primaryColor),
                          ),
                          label: Text(
                            gender.name,
                            style: manropeHeadingTextStyle.copyWith(
                              color: selectedGender == gender
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                          selected: selectedGender == gender,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedGender = selected ? gender : null;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),

                  Text(
                    "Certification Level",
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 13.w),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 15,
                      children: List<Widget>.generate(
                        selectedLevelsList.length,
                            (int index) {
                          final level = selectedLevelsList[index];
                          return ChoiceChip(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primaryColor.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: AppColors.primaryColor),
                            ),
                            label: Text(
                              level.level,
                              style: manropeHeadingTextStyle.copyWith(
                                color: selectedLevel == level
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                            selected: selectedLevel == level,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedLevel = selected ? level : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Yoga Styles",
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return _buildModalContent();
                              }
                          );
                        },
                        child: Text(
                          "View All",
                          style: manropeHeadingTextStyle.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 13.w),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 15,
                      children: List<Widget>.generate(
                        selectedLevelsList.length,
                            (int index) {
                          final level = selectedLevelsList[index];
                          return ChoiceChip(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primaryColor.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: AppColors.primaryColor),
                            ),
                            label: Text(
                              level.level,
                              style: manropeHeadingTextStyle.copyWith(
                                color: selectedLevel == level
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                            selected: selectedLevel == level,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedLevel = selected ? level : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  Text(
                    "Location",
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 13.w),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 15,
                      children: List<Widget>.generate(
                        selectedLevelsList.length,
                            (int index) {
                          final level = selectedLevelsList[index];
                          return ChoiceChip(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primaryColor.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: AppColors.primaryColor),
                            ),
                            label: Text(
                              level.level,
                              style: manropeHeadingTextStyle.copyWith(
                                color: selectedLevel == level
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                            selected: selectedLevel == level,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedLevel = selected ? level : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  Text(
                    "Availabilty",
                    style: manropeHeadingTextStyle.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 13.w),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 15,
                      children: List<Widget>.generate(
                        selectedLevelsList.length,
                            (int index) {
                          final level = selectedLevelsList[index];
                          return ChoiceChip(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primaryColor.withOpacity(
                                0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: AppColors.primaryColor),
                            ),
                            label: Text(
                              level.level,
                              style: manropeHeadingTextStyle.copyWith(
                                color: selectedLevel == level
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                            selected: selectedLevel == level,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedLevel = selected ? level : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  // Add your content here
                ],
              ),
            ),
          );
        });
  }

  Widget _buildModalContent() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Container(
            height: 750.h,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: 20.h,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Divider(
                    height: 5,
                    color: AppColors.primaryColor,
                    thickness: 4,
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  'Yoga Styles',
                  style: manropeHeadingTextStyle.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),

                Text(
                  'Pick one or more styles',
                  style: manropeSubTitleTextStyle.copyWith(
                    fontSize: 18.sp,
                    color: const Color(0xFF8F8F8F),
                  ),
                ),
                SizedBox(height: 12.h),

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final isSelected = _selectedItems.contains(item);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedItems.remove(item);
                          } else {
                            _selectedItems.add(item);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/yoga_style_1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(text: "Cancel", onTap: (){
                        context.pop();
                      },btnColor: Colors.white,textColor: Colors.red,
                        border: Border.all(color: Colors.red
                        ),),
                    ),

                    Expanded(
                      child: CustomButton(text: "Apply", onTap: (){
                        context.pop();
                      },
                        btnColor: AppColors.primaryColor,
                        textColor: Colors.white,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 12.h),

              ],
            ),
          );
        }
    );
  }


  final List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 12',
  ];

  final List<String> _selectedItems = [];

}

