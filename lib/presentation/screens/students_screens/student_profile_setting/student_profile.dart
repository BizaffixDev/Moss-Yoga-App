import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/data/models/student_level.dart';
import 'package:moss_yoga/data/models/user_level.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/student_account_states.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../../data/models/user_gender_model.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/student_profiling_provider/student_account_provider.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  String selectedGender = UserGender.female;
  String selectedLevel = StudentLevel.Beginner.name;

  TextEditingController fullNameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController dobController = TextEditingController(text: "");
  TextEditingController traumaController = TextEditingController(text: "");
  TextEditingController otherChronicController =
      TextEditingController(text: "");

  bool otherSelect = false;

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(colorScheme: colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);

      setState(() {
        dobController.text = formattedDate;
      });

      // Update the state if needed
      //ref.read(dobProvider.notifier).updateDob(formattedDate);
    }
  }

  bool _apiCalled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('This is the selectedLevel value $selectedLevel');
      await ref
          .read(studentAccountNotifierProvider.notifier)
          .getProfileDetails()
          .whenComplete(() {
        setState(() {
          // fullNameController.text = ref.read(nameProvider);
          // emailController.text = ref.read(emailProvider);
          // dobController.text = ref.read(dobProvider);
          // traumaController.text = ref.read(traumaProvider);
          // otherChronicController.text = ref.read(otherChronicProvider);
          //
          // selectedGender =
          //     ref.read(genderProvider) ?? UserGender.female.toString();
          // selectedLevel = ref.read(levelProvider) ?? StudentLevel.Beginner.name;
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    traumaController.dispose();
    otherChronicController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    List<String> chronicConditions =
        ref.watch(chronicConditionProvider.notifier).state;
    String studentLevel = ref.watch(levelProvider.notifier).state;
    //  fullNameController.text = studentName; // Initialize the fullNameController with userName
    //  emailController.text = studentEmail;
    //  traumaController.text = studentTrauma;
    // // selectedGender = studentGender;
    //  dobController.text = studentDob;
    ref.listen<StudentAccountStates>(studentAccountNotifierProvider,
        (previous, screenState) async {
      if (screenState is StudentProfileDetailsSuccessfulState) {
        setState(() {
          fullNameController.text = ref.read(nameProvider);
          emailController.text = ref.read(emailProvider);
          dobController.text = ref.read(dobProvider);
          traumaController.text = ref.read(traumaProvider);
          otherChronicController.text = ref.read(otherChronicProvider);

          selectedGender =
              ref.read(genderProvider) ?? UserGender.female.toString();
          selectedLevel = ref.read(levelProvider) ?? StudentLevel.Beginner.name;
        });
        dismissLoading(context);
      } else if (screenState is UpdateStudentProfileDetailsSuccessfulState) {
        dismissLoading(context);
        context.pop();
        context.pop();
        UIFeedback.showSnackBar(context, "Your Profile updated successfully.",
            stateType: StateType.success, height: 250);

        setState(() {
          fullNameController.text = ref.read(nameProvider);
          emailController.text = ref.read(emailProvider);
          dobController.text = ref.read(dobProvider);
          traumaController.text = ref.read(traumaProvider);
          otherChronicController.text = ref.read(otherChronicProvider);
          selectedGender = ref.read(genderProvider);
          selectedLevel = ref.read(levelProvider);
        });
      } else if (screenState is StudentProfileDetailsErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      } else if (screenState is UpdateStudentProfileDetailsErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        } else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
           dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      } else if (screenState is UpdateStudentProfileDetailsLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is StudentProfileDetailsLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else {
        debugPrint('Loading');
        showLoading(context);
      }
    });

    return SafeArea(
      top: false,
      child: Scaffold(
        endDrawer: DrawerScreen(),
        body: Container(
          height: 844.h,
          width: 390.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Drawables.authPlainBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 400.h,
                  width: 390.w,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/stdcover.png'),
                    fit: BoxFit.cover,
                  )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                context.pop();
                              },
                            ),
                            //SizedBox(width: 285.w,),
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                                // Add your menu button functionality here
                              },
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: Platform.isAndroid ? 60 : 80,
                             // 80 for ios,
                              backgroundImage: AssetImage(
                                  'assets/images/student_avatar.png'),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primaryColor, width: 5),
                                ),
                                child: CircularProgressIndicator(
                                  value: 0.6,
                                  // Adjust this value to indicate the profile completion
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 5.5,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  (ImageSource.gallery);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Drawables.cameraIcon,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          ref.read(nameProvider),
                          style: manropeSubTitleTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          ref.read(emailProvider),
                          style: manropeSubTitleTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            height: 1.2,
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: Platform.isAndroid ? 80.h : 70.h,
                            margin: EdgeInsets.only(top: 10.h),
                            //70.h for ios,
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              image: DecorationImage(
                                image: AssetImage(Drawables.authPlainBg),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(left: 30.w),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            HeroIcon(HeroIcons.sparkles,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              '20 points',
                                              style: manropeSubTitleTextStyle.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            HeroIcon(
                                                HeroIcons.questionMarkCircle,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              dropdownColor: AppColors
                                                  .primaryColor
                                                  .withOpacity(0.6),
                                              style: manropeSubTitleTextStyle
                                                  .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                              value:
                                              selectedLevel,
                                              onChanged: (String? newValue) {

                                                setState(() {
                                                  if (newValue ==
                                                      StudentLevel.Beginner.name
                                                          .toString()) {
                                                    selectedLevel =
                                                        StudentLevel.Beginner.name;
                                                  } else if (newValue ==
                                                      StudentLevel.Advanced.name
                                                          .toString()) {
                                                    selectedLevel =
                                                        StudentLevel.Advanced.name;
                                                  } else if (newValue ==
                                                      StudentLevel.Intermediate.name
                                                          .toString()) {
                                                    selectedLevel = StudentLevel
                                                        .Intermediate.name;
                                                  } else {
                                                    // Handle the case where the newValue doesn't match any enum value.
                                                    // You might want to set a default value or handle it as needed.
                                                    selectedLevel = StudentLevel
                                                        .Beginner.name; // Set a default value here.
                                                  }
                                                });
                                                ref
                                                    .read(
                                                        levelProvider.notifier)
                                                    .state = selectedLevel;
                                                //newValue = studentGender;
                                                print(selectedLevel);
                                                print(
                                                    "selecteLevel ${ref.read(levelProvider)}");
                                              },
                                              iconEnabledColor: Colors.white,
                                              items: getAllLevels().map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(
                                                      value,
                                                      style: manropeSubTitleTextStyle.copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18.sp,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  width: 390.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        decoration:
                            BoxDecoration(color: Colors.white70, boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(1, 3),
                          ),
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Full Name',
                              style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5B5B5B)),
                            ),
                            SizedBox(
                              height: 12,
                            ),

                            //FULLNAME TEXTFIELD
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: TextField(
                                readOnly: true,
                                controller: fullNameController,
                                onChanged: (newName) {},
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: "Full Name",
                                  labelStyle: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyTextColor,
                                  ),
                                  hintStyle: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.greyTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Email Address',
                              style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5B5B5B)),
                            ),
                            SizedBox(
                              height: 12,
                            ),

                            //EMAIL TEXTFIELD
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: TextField(
                                readOnly: true,
                                controller: emailController,
                                onChanged: (newEmail) {},
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: "Johndoe@gmail.com",
                                  labelStyle: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyTextColor,
                                  ),
                                  hintStyle: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.greyTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Date of Birth',
                              style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5B5B5B)),
                            ),

                            SizedBox(
                              height: 12,
                            ),

                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: dobController,
                                    onChanged: (newDob) {},
                                    readOnly: true,
                                    keyboardType: TextInputType.phone,
                                    //controller: _ageController,

                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 11.5),
                                        hintText: "",
                                        labelStyle:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.greyTextColor,
                                        ),
                                        hintStyle:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.greyTextColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: AppColors.greyTextColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: AppColors.greyTextColor,
                                          ),
                                        ),
                                        suffixIcon: HeroIcon(
                                          HeroIcons.calendarDays,
                                          color: Colors.black,
                                        )),
                                  ),
                                )),

                                SizedBox(
                                  width: 15,
                                ),

                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: AppColors.greyTextColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        style:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.greyTextColor,
                                        ),
                                        value: selectedGender,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedGender = newValue!;
                                          });
                                          ref
                                              .read(genderProvider.notifier)
                                              .state = selectedGender!;
                                          //newValue = studentGender;
                                          print(selectedGender);
                                          print(
                                              "selectedGender ${ref.read(genderProvider)}");
                                        },
                                        items: UserGender.getAllGenders()
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(

                                // ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Health Information',
                        style: manropeHeadingTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        decoration:
                            BoxDecoration(color: Colors.white70, boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(1, 3),
                          ),
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Traumas',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: TextField(
                                //controller: traumaController,
                                controller: traumaController,
                                maxLines: 4,
                                // onChanged: (newTrauma) {
                                //
                                //   ref.read(traumaProvider.notifier).updateTrauma(newTrauma);
                                // },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: "Write Your expireince",
                                  labelStyle: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyTextColor,
                                  ),
                                  hintStyle: manropeSubTitleTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.greyTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Chronic Condition',
                              style: manropeHeadingTextStyle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Wrap(
                              spacing: 5.0,
                              children: List<Widget>.generate(
                                chronicConditions.length,
                                (int index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 5.h),
                                    height: 50.h,
                                    width: 353.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        title: Text(
                                          chronicConditions[index],
                                          style: manropeSubTitleTextStyle.copyWith(
                                            height: 1,
                                          ),
                                        ),
                                        // trailing: GestureDetector(
                                        //   onTap: (){
                                        //     // Call the function to delete the chronic condition at the specified index
                                        //     ref.read(chronicConditionProvider.notifier).deleteChronicAtIndex(index);
                                        //   },
                                        //   child: Container(
                                        //     decoration: BoxDecoration(
                                        //       color: Color(0xFFC4C4BC).withOpacity(0.2),
                                        //     ),
                                        //     height: 25.h,
                                        //     width: 25.h,
                                        //
                                        //     child: Center(
                                        //       child: Icon(Icons.remove,color: AppColors.primaryColor,),
                                        //     ),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  otherSelect = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text("Add another one ")
                                ],
                              ),
                            ),
                            otherSelect
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: otherChronicController,
                                      keyboardType: TextInputType.text,
                                      //controller: _ageController,
                                      onChanged: (String? val) {},
                                      onEditingComplete: () {
                                        // FocusScope.of(context)
                                        //     .requestFocus(_headlineFocusNode);
                                      },

                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 11.5),
                                        hintText: "",
                                        labelStyle:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.greyTextColor,
                                              height: 1.2,
                                        ),
                                        hintStyle:
                                            manropeSubTitleTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.greyTextColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: AppColors.greyTextColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: AppColors.greyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: CustomButton(
                            m: 0,
                            text: "Save",
                            onTap: () async {
                              await ref
                                  .read(studentAccountNotifierProvider.notifier)
                                  .updateStudentProfile(
                                    trauma: traumaController.text,
                                    dob: dobController.text,
                                    gender: selectedGender ?? UserGender.female,
                                  );
                            },
                            btnColor: AppColors.primaryColor,
                            textColor: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
