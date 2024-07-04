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
import 'package:moss_yoga/data/models/on_demand_online_teachers_response_model.dart';
import 'package:moss_yoga/data/models/top_rated_teacher_response_model.dart';
import 'package:moss_yoga/presentation/screens/students_screens/my_classes/available_teachers_screen.dart';
import 'package:moss_yoga/presentation/screens/students_screens/on_demand/on_demand_states/on_demand_states.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../data/models/yoga_styles_response_model.dart';
import '../../../providers/on_demand_student_provider.dart';
import '../../../providers/screen_state.dart';
import 'components/custom_search_field.dart';
import 'components/custom_teacher_card_on_demand.dart';

class OnDemandScreen extends ConsumerStatefulWidget {
  const OnDemandScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnDemandScreen> createState() => _OnDemandScreenState();
}

class _OnDemandScreenState extends ConsumerState<OnDemandScreen> {
  late TextEditingController _searchController;

  bool isSearchValid = true;
  bool isSearchTapped = false;



  // String teacherId = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    ref.read(requestSentProvider.notifier).state;
    // ref.read(teacherBookingIdProvider.notifier).dispose();
    print(
        "REQUEST STATUS ======  ${ref.read(requestSentProvider.notifier).state}");
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
            .read(onDemandStudentNotifierProvider.notifier)
            .getTopRatedTeachers();
        await ref
            .read(onDemandStudentNotifierProvider.notifier)
            .getYogaStyles();
      });
    }
  }

  void handleSearch(String query) async {
    print('Search: $query');
    await ref
        .read(onDemandStudentNotifierProvider.notifier)
        .getTopRatedTeachersBySearch(
          gender: "",
          occupation: "",
          name: query,
          city: "",
          maxPrice: "",
          minPrice: "",
          badgeName: "",
          startTime: "",
        );

    // setState(() {
    //   isSearchValid = query.isNotEmpty;
    // });
    // FocusScope.of(context).unfocus();
    // if (isSearchValid) {
    //   // Perform search logic here
    //   // searchTeachers(query);
    //   print('Search: $query');
    //   await ref
    //       .read(onDemandStudentNotifierProvider.notifier)
    //       .getTopRatedTeachersBySearch(
    //         gender: "",
    //         occupation: "",
    //         name: query,
    //         city: "",
    //         maxPrice:"",
    //     minPrice: "",
    //     badgeName: "",
    //     startTime: "",
    //       );
    // }
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

  double lowerValue = 50;
  double upperValue = 180;
  double _sliderDifference = 0;

  int seletedYogaIndex =
      -1; // Index of the currently selected ChoiceChip (-1 means none selected)

  //CertificationLevel? selectedLevel;
  Gender? selectedGender;

  void _handleSliderChanged(double difference) {
    setState(() {
      _sliderDifference = difference;
      // You can use _lowerValue and _upperValue here as well if needed
    });
  }

  // Your other state variables
  //Gender? _selectedGender;

  // void _handleGenderSelected(Gender? selectedGender) {
  //   setState(() {
  //     _selectedGender = selectedGender;
  //   });
  // }

  List<YogaStylesResponseModel> selectedStyles = [];

  /*List<Gender> genders = [
    Gender('Male'),
    Gender('Female'),
    Gender('Neutral'),
  ];*/

  final List<String> locations = [
    'Las Vegas',
    'Boston',
    'San Jose',
    'New York',
    'Chicago'
  ];
  String selectedLocation = '';

  final List<String> availabilty = [
    '09 - 10 am',
    '10 - 11 am',
    '11 - 12 am',
    '03 - 04 pm',
    '05 - 06 pm'
  ];
  String selectedAvailability = '';

  final List<String> genders = ['Male', 'Female', 'Neutral'];
  String _selectedGender = '';

  final List<String> level = ['All', 'Bronze', 'Silver', 'Gold'];
  String selectedLevel = '';

  @override
  Widget build(BuildContext context) {
    ref.listen<OnDemandStudentStates>(onDemandStudentNotifierProvider,
        (previous, screenState) async {
      if (screenState is FilterStudentSuccessfulState) {
        dismissLoading(context);
        //context.pop();
      } else if (screenState is OnDemandStudentBookingSuccessfulState) {
        dismissLoading(context);
        // setState(() {});
        ref.read(requestSentProvider.notifier).state = true;
        print(
            "This is the damn shit inside state changeing ${ref.read(teacherBookingIdProvider)}");

        GoRouter.of(context).push(
            "${PagePath.onDemandStudentRequest}?teacherId=${ref.read(teacherBookingIdProvider)}");
      } else if (screenState is OnDemandStudentErrorState) {
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
        debugPrint('Loading inside OnDemandStudentLoadingState');
        showLoading(context);
        // setState(() {});
      }
    });
//OnDemandStudentBookingLoadingState
    var teacherCardListProvider = ref.watch(onDemandOnlineTeachersProvider);
    var yogaStylesListProvider = ref.watch(allYogaStylesFilterProvider);

    ref.watch(requestSentProvider);

    final savedTeachers = ref.watch(savedTeacherProvider);

    final savedTeacherIds =
        savedTeachers.map((teacher) => teacher.teacherId).toList();

    final savedTeacherCardList = teacherCardListProvider
        .where((teacher) => savedTeacherIds.contains(teacher.teacherId))
        .toList();


// Step 1: Create a Set to store unique teacher IDs
    Set<int> uniqueTeacherIds = Set();

// Step 2: Filter the teacherCardList to include only unique teachers
    List<OnDemandOnlineTeacherResponse> filteredTeachers = teacherCardListProvider.where((teacher) {
      if (!uniqueTeacherIds.contains(teacher.teacherId)) {
        uniqueTeacherIds.add(teacher.teacherId);
        return true;
      }
      return false;
    }).toList();



    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: AppColors.neutral53),
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'On Demand',
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
          endDrawer: DrawerScreen(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                ///Ready to Practice Plus SearchBar
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
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
                      //TODO: FILTERS BODY

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context,
                                  StateSetter setState) {
                            return Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 24.w),
                              width: MediaQuery.of(context).size.width,
                              height: 750.h,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 80.w),
                                      child: Divider(
                                        height: 5,
                                        color: AppColors.primaryColor,
                                        thickness: 4,
                                      ),
                                    ),
                                    Text(
                                      "Budget",
                                      style: manropeHeadingTextStyle
                                          .copyWith(
                                        fontSize: 18.sp,
                                      ),
                                    ),

                                    FlutterSlider(
                                      values: [lowerValue, upperValue],
                                      rangeSlider: true,
                                      max: 500,
                                      min: 0,
                                      trackBar: FlutterSliderTrackBar(
                                        activeTrackBarHeight: 5,
                                        inactiveTrackBar: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey
                                              .withOpacity(0.4),
                                        ),
                                        activeTrackBar: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      tooltip: FlutterSliderTooltip(
                                        boxStyle: FlutterSliderTooltipBox(
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8))),
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      onDragging: (handlerIndex,
                                          lowerValue, upperValue) {
                                        setState(() {
                                          this.lowerValue = lowerValue;
                                          this.upperValue = upperValue;
                                        });
                                      },
                                    ),

                                    Text(
                                      "Gender Preference",
                                      style: manropeHeadingTextStyle
                                          .copyWith(
                                        fontSize: 18.sp,
                                      ),
                                    ),

                                    //GENDER CHOICE CHIPS
                                    Container(
                                      margin: EdgeInsets.only(left: 13.w),
                                      child: Wrap(
                                        spacing: 4,
                                        children: List<Widget>.generate(
                                          genders.length,
                                          (int index) {
                                            final gender = genders[index];
                                            return SizedBox(
                                              child: Container(

                                                child: ChoiceChip(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w),

                                                  backgroundColor: Colors.white,
                                                  selectedColor:

                                                  AppColors
                                                      .selectedBoxColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    side: BorderSide(
                                                        color: AppColors
                                                            .primaryColor),
                                                  ),
                                                  label: Text(
                                                    gender,
                                                    style:
                                                        manropeSubTitleTextStyle
                                                            .copyWith(
                                                      color: _selectedGender ==
                                                              gender
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                  selected:
                                                      _selectedGender == gender,
                                                  onSelected: (bool selected) {
                                                    setState(() {
                                                      _selectedGender = gender;
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),

                                    Text(
                                      "Certification Level",
                                      style: manropeHeadingTextStyle
                                          .copyWith(
                                        fontSize: 18.sp,
                                      ),
                                    ),

                                    //CERTIFICATION CHOICE CHIPS
                                    Container(
                                      margin: EdgeInsets.only(left: 13.w),
                                      child: Wrap(
                                        alignment:
                                            WrapAlignment.spaceBetween,
                                        spacing: 4,
                                        children: List<Widget>.generate(
                                          level.length,
                                          (int index) {
                                            final clevel = level[index];
                                            return ChoiceChip(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15.w),
                                              backgroundColor:
                                                  Colors.white,
                                              selectedColor: AppColors
                                                  .selectedBoxColor,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        4),
                                                side: BorderSide(
                                                    color: AppColors
                                                        .primaryColor),
                                              ),
                                              label: Text(
                                                clevel,
                                                style:
                                                    manropeSubTitleTextStyle
                                                        .copyWith(
                                                  color: selectedLevel ==
                                                          clevel
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              selected:
                                                  selectedLevel == clevel,
                                              onSelected:
                                                  (bool selected) {
                                                setState(() {
                                                  selectedLevel = clevel;
                                                });
                                              },
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),

/*
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Yoga Styles",
                                        style: manropeHeadingTextStyle
                                            .copyWith(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder:
                                                  (BuildContext context) {
                                                return _buildModalContent();
                                              });
                                        },
                                        child: Text(
                                          "View All",
                                          style: manropeHeadingTextStyle
                                              .copyWith(
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
                                      spacing: 8,
                                      children: List<Widget>.generate(
                                        yogaStylesListProvider.length,
                                            (int index) {
                                          final style =
                                          yogaStylesListProvider[index];
                                          return ChoiceChip(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            backgroundColor: Colors.white,
                                            selectedColor: AppColors
                                                .primaryColor
                                                .withOpacity(0.7),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(4),
                                              side: BorderSide(
                                                  color: AppColors
                                                      .primaryColor),
                                            ),
                                            label: Text(
                                              style.styleName,
                                              style: manropeSubTitleTextStyle
                                                  .copyWith(
                                                color: seletedYogaIndex ==
                                                    index
                                                    ? Colors
                                                    .white // Set the text color to white when selected
                                                    : Colors.black,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            selected:
                                            seletedYogaIndex == index,
                                            onSelected: (bool selected) {
                                              if (selected) {
                                                setState(() {
                                                  seletedYogaIndex =
                                                      index; // Add the style to the selectedStyles list
                                                });
                                              } else {
                                                setState(() {
                                                  seletedYogaIndex =
                                                  -1; // Add the style to the selectedStyles list
                                                });
                                                // Remove the style from the selectedStyles list
                                              }
                                            },
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),*/

                                    Text(
                                      "Location",
                                      style: manropeHeadingTextStyle
                                          .copyWith(
                                        fontSize: 18.sp,
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 13.w),
                                      child: Wrap(
                                        // alignment: WrapAlignment.spaceBetween,
                                        spacing: 4,
                                        children: List<Widget>.generate(
                                          locations.length,
                                          (int index) {
                                            final location =
                                                locations[index];
                                            return ChoiceChip(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 15.w),
                                              backgroundColor:
                                                  Colors.white,
                                              selectedColor: AppColors
                                                  .selectedBoxColor,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        4),
                                                side: BorderSide(
                                                    color: AppColors
                                                        .primaryColor),
                                              ),
                                              label: Text(
                                                location,
                                                style:
                                                    manropeSubTitleTextStyle
                                                        .copyWith(
                                                  color:
                                                      selectedLocation ==
                                                              location
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              selected:
                                                  selectedLocation ==
                                                      location,
                                              onSelected:
                                                  (bool selected) {
                                                if (selected) {
                                                  setState(() {
                                                    selectedLocation =
                                                        location;
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),

                                    Text(
                                      "Availabilty",
                                      style: manropeHeadingTextStyle
                                          .copyWith(
                                        fontSize: 18.sp,
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 13.w),
                                      child: Wrap(
                                        // alignment: WrapAlignment.spaceBetween,
                                        spacing: 4,
                                        children: List<Widget>.generate(
                                          availabilty.length,
                                          (int index) {
                                            final time =
                                                availabilty[index];
                                            return ChoiceChip(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10.w),
                                              backgroundColor:
                                                  Colors.white,
                                              selectedColor: AppColors
                                                  .selectedBoxColor,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        4),
                                                side: BorderSide(
                                                    color: AppColors
                                                        .primaryColor),
                                              ),
                                              label: Text(
                                                time,
                                                style:
                                                    manropeSubTitleTextStyle
                                                        .copyWith(
                                                  color:
                                                      selectedAvailability ==
                                                              time
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              selected:
                                                  selectedAvailability ==
                                                      time,
                                              onSelected:
                                                  (bool selected) {
                                                if (selected) {
                                                  setState(() {
                                                    selectedAvailability =
                                                        time;
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            m: 10.w,
                                            text: "Cancel",
                                            onTap: () async {
                                              context.pop();
                                            },
                                            btnColor: Colors.white,
                                            textColor: Colors.red,
                                            border: Border.all(
                                                color: Colors.red),
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomButton(
                                            m: 10.w,
                                            text: "Apply",
                                            onTap: () async {
                                              FocusScope.of(context)
                                                  .unfocus();
                                              await ref
                                                  .read(
                                                      onDemandStudentNotifierProvider
                                                          .notifier)
                                                  .getTopRatedTeachersBySearch(
                                                    gender:
                                                        _selectedGender,
                                                    occupation: "",
                                                    name: "",
                                                    city:
                                                        selectedLocation,
                                                    startTime:
                                                        selectedAvailability,
                                                    badgeName:
                                                        selectedLevel,
                                                    //selectedLevel!.level.isEmpty? null : selectedLevel!.level,
                                                    minPrice:
                                                        //null,
                                                        lowerValue
                                                            .toString(),
                                                    maxPrice:
                                                        //null,
                                                        upperValue
                                                            .toString(),
                                                  );

                                            },
                                            btnColor:
                                                AppColors.primaryColor,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),

                                    // Add your content here
                                  ],
                                ),
                              ),
                            );

                            /*buildFilterBody(lowerValue, upperValue,
                            genders, _selectedGender, selectedLevel);*/
                          });
                        },
                      );
                    },
                  ),
                ),

                ///ON Demand Techers

                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  color: Colors.white,
                  height: CommonFunctions.deviceHeight(context) * 1.2,
                  //padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),

                  child:
                  filteredTeachers.isEmpty
                      ?  Container(
                    height: CommonFunctions.deviceHeight(context),
                    width: CommonFunctions.deviceWidth(context),
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 200.h),
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text('No Teachers available right now.',
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
                        filteredTeachers.length,
                            (index) {
                          //final teacher = teacherCardListProvider[index];
                         // final teacher = teacherCardListProvider[index];
                          final teacher = filteredTeachers[index];
                          final isTeacherSaved = savedTeachers.any((t) => t.teacherId == teacher.teacherId);
                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h,),
                            child: CustomTeacherCardOnDemand(

                              rating: teacher.avgRatingValue,
                              //rating: teacher.avgRatingValue.toStringAsFixed(1),
                              teacherOccupation: teacher.occupation,
                              price:"\$" +  teacher.getDatesResponse[0].price,
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

                               //context.push(PagePath.TeacherDetail);

                                  ///Sending request to book on backend Here
                                  print(
                                      "This is the code rn in click ${teacher.getDatesResponse[0].teacherSchedulingDetailCode}");
                                  ref
                                          .read(teacherBookingIdProvider.notifier)
                                          .state =
                                      teacher.getDatesResponse[0].teacherSchedulingDetailCode;
                                  print(
                                      "This is the code saved in provider ${ref.read(teacherBookingIdProvider)}");
                                  await ref
                                      .read(onDemandStudentNotifierProvider
                                          .notifier)
                                      .bookSession(
                                          bookingCode: teacher
                                              .getDatesResponse[0].teacherSchedulingDetailCode,
                                          date: '${teacher.getDatesResponse[0].availableDates}');

                                  ref.read(teacherNameProvider.notifier).state =
                                      teacher.teacherFirstName;
                                  ref
                                      .read(teacherRatingProvider.notifier)
                                      .state = teacher.avgRatingValue;
                                  ref
                                      .read(teacherPriceProvider.notifier)
                                      .state = teacher.getDatesResponse[0].price;

                                  ///This is the schedule id being passed to the next screen.
                                  // setState(() {
                                  //   teacherId =
                                  //       teacher.teacherSchedulingDetailCode;
                                  // });

                                  print(
                                      "TEACHER ID ON CLICK ===== ${teacher.teacherId}");

                                  print(
                                      "BOOKING CODE ON CLICK ===== ${teacher.getDatesResponse[0].teacherSchedulingDetailCode}");

                                  print(
                                      "REQUEST STATUS ===== ${ref.read(requestSentProvider.notifier).state}");
                              },
                            ),
                          );
                        }),
                  ),
                ),

  ],
            ),
          )),
    );
  }


}
