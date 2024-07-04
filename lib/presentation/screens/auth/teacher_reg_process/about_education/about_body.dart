import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:moss_yoga/app/utils/ui_snackbars.dart';
import 'package:moss_yoga/data/models/user_gender_model.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';

import '../../../../../common/app_specific_widgets/custom_button.dart';
import '../../../../../common/app_specific_widgets/custom_text_field.dart';
import '../../../../../common/app_specific_widgets/loader.dart';
import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/drawables.dart';
import '../../../../../common/resources/page_path.dart';
import '../../../../../common/resources/text_styles.dart';
import '../../../../providers/screen_state.dart';
import '../../choose_role/components/arrow_back_icon.dart';
import '../../login/states/login_states.dart';

class TeacherRegProcessAbout extends ConsumerStatefulWidget {
  const TeacherRegProcessAbout({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherRegProcessAbout> createState() =>
      _TeacherRegProcessAboutState();
}

class _TeacherRegProcessAboutState
    extends ConsumerState<TeacherRegProcessAbout> {
  //TEXT CONTROLLERS
  final TextEditingController _fullmameController = TextEditingController(text: "");
  final TextEditingController _contactnumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController(text: "");

  //final TextEditingController _locationController= TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();

  //TEXT FOCUSNODES
  final FocusNode _fullmameFocusNode = FocusNode();
  final FocusNode _contactnumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _headlineFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = ref.read(teacherSignUpEmailProvider);
  }


  @override
  void dispose() {
    _fullmameController.dispose();
    _contactnumberController.dispose();
    _emailController.dispose();
    //_locationController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _headlineController.dispose();
    _fullmameFocusNode.dispose();
    _contactnumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _countryFocusNode.dispose();
    _cityFocusNode.dispose();
    _ageFocusNode.dispose();
    _headlineFocusNode.dispose();
    super.dispose();
  }

  PickedFile? _image;




  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    try {
      final pickedImage = await picker.getImage(source: source);

      if (pickedImage != null) {
        final filePath = pickedImage.path;
        final fileName = filePath.split('/').last;

        ref.read(teacherProfileImagePathProvider.notifier).state = filePath;
        ref.read(teacherProfileImageNameProvider.notifier).state = fileName;

        setState(() {
          _image = PickedFile(filePath);
        });
        UIFeedback.showSnackBar(
          context,
          'Image Selected Successfully',
          height: 200,
          stateType: StateType.success,
          onPressed: () {},
        );
      } else {
        UIFeedback.showSnackBar(context, 'No Image Selected. Please try again.',
            height: 200);
      }
    } catch (e) {
      print(e.toString());
      UIFeedback.showSnackBar(context, 'Error selecting image: ${e.toString()}',
          height: 200);
    }
  }


  void showImageSelectionErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Error selecting image. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(milliseconds: 300));
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a contact number";
    }

    // Regular expression to match USA phone numbers
    final usaPhoneRegex = RegExp(r'^\+1[2-9]\d{2}[2-9](?!11)\d{6}$');

    if (!usaPhoneRegex.hasMatch(value)) {
      return "Please enter a valid USA phone number";
    }

    return null; // Return null if validation passes
  }

  // String selectedGender = '';
  String selectedGender = UserGender.female.toString(); // Or any other default value

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      if (screenState is AuthErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString());
          dismissLoading(context);
        }
      } else if (screenState is AuthLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is LoginSuccessfulState) {
        dismissLoading(context);
        ref.invalidate(teacherFullNameFieldProvider);
        ref.invalidate(teacherContactFieldProvider);
        ref.invalidate(teacherEmailFieldProvider);
        ref.invalidate(teacherContactFieldProvider);
        ref.invalidate(teacherContactFieldProvider);
        ref.invalidate(teacherContactFieldProvider);

        // setState(() {});
      }
    });

    return Scaffold(
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: 844.h,
              width: 390.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Drawables.authPlainBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ArrowBackIcon(onTap: () => context.pop()),
                        SizedBox(
                          width: 100.w,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 14.h,
                          ),
                          child: Text(
                            'ABOUT',
                            style: manropeHeadingTextStyle.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 844.h,
                        width: 390.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(37),
                            topRight: Radius.circular(37),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Text(
                              'Add details about yourself ',
                              style: manropeSubTitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                color: const Color(0XFF414042),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 35.h),
                            imageProfile(),
                            SizedBox(height: 14.h),
                            CustomTextField(
                              hintText: "Jenny Luke",
                              labelText: "Full Name*",
                              controller: _fullmameController,
                              onChanged: (String? val) {
                                ref
                                    .read(teacherFullNameFieldProvider.notifier)
                                    .state = _fullmameController.text.trim();
                              },
                              focusNode: _fullmameFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_contactnumberFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            //PHONE FIELD
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              child: IntlPhoneField(
                                controller: _contactnumberController,
                                textInputAction: TextInputAction.next,
                                onSubmitted:(phone) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode);
                                },
                                decoration: InputDecoration(hintText: "Enter your contact number",
                                  labelText: 'Contact Number*',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: AppColors.greyTextColor),
                                  ),
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
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                    counterText: ""
                                ),

                                initialCountryCode: 'US',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                  ref.read(teacherContactFieldProvider.notifier)
                                      .state = phone.completeNumber;
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            /*CustomTextField(
                              textInputFormatterList: [
                                // LengthLimitingTextInputFormatter(10),
                                InternationalPhoneFormatter(),
                              ],

                              hintText: "Enter your contact number",
                              labelText: "Contact Number*",
                              controller: _contactnumberController,
                              textInputType: TextInputType.phone,
                              validator: _validatePhone,
                              onChanged: (String? val) {
                                ref
                                    .read(teacherContactFieldProvider.notifier)
                                    .state = _contactnumberController.text.trim();
                              },
                              focusNode: _contactnumberFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                            ),*/

                            CustomTextField(
                              hintText: "jennyluke@gmail.com",
                              labelText: "Email*",
                              controller: _emailController,
                              onChanged: (String? val) {
                                ref
                                    .read(teacherEmailFieldProvider.notifier)
                                    .state = _emailController.text.trim();
                              },
                              focusNode: _emailFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_countryFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              hintText: "Select Your Country",
                              labelText: "Country*",
                              controller: _countryController,
                              onChanged: (String? val) {
                                ref
                                    .read(teacherCountryFieldProvider.notifier)
                                    .state = _countryController.text.trim();
                              },
                              focusNode: _countryFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_cityFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              hintText: "Select Your City",
                              labelText: "City*",
                              controller: _cityController,
                              onChanged: (String? val) {
                                ref
                                    .read(teacherCityFieldProvider.notifier)
                                    .state = _cityController.text.trim();
                              },
                              focusNode: _cityFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_ageFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    keyboardType: TextInputType.phone,
                                    controller: _ageController,
                                    onChanged: (String? val) {
                                      ref
                                          .read(teacherAgeFieldProvider.notifier)
                                          .state = int.parse(_ageController.text);
                                    },
                                    focusNode: _ageFocusNode,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(_headlineFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: "Age",
                                      labelText: "Age*",
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
                                  )),

                                  const SizedBox(
                                    width: 15,
                                  ),

                                  Expanded(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
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
                                                    .read(
                                                        teacherGenderFieldProvider
                                                            .notifier)
                                                    .state =selectedGender;
                                                // UserGenderModel(
                                                //     userGender: selectedGender);
                                            print(selectedGender);
                                            print("selectedGender ${ref
                                                .read(
                                                teacherGenderFieldProvider
                                                    .notifier)
                                                .state}");
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

                                      // child: DropdownButtonHideUnderline(
                                      //   child: DropdownButton<String>(
                                      //     isExpanded: true,
                                      //     style:
                                      //         manropeSubTitleTextStyle.copyWith(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w400,
                                      //       color: AppColors.greyTextColor,
                                      //     ),
                                      //     value: selectedGender,
                                      //     onChanged: (UserGender? newValue) {
                                      //       setState(() {
                                      //         selectedGender = newValue!;
                                      //       });
                                      //       ref
                                      //               .read(
                                      //                   teacherGenderFieldProvider
                                      //                       .notifier)
                                      //               .state =
                                      //           UserGenderModel(
                                      //               userGender: selectedGender);
                                      //     },
                                      //     items: UserGender.map<
                                      //             DropdownMenuItem<UserGender>>(
                                      //         (UserGender value) {
                                      //       return DropdownMenuItem<UserGender>(
                                      //         value: value,
                                      //         child: Text(value
                                      //             .toString()
                                      //             .split('.')
                                      //             .last),
                                      //       );
                                      //     }).toList(),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                  // Expanded(

                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              hintText: "Describe your personality",
                              labelText: "Headline",
                              controller: _headlineController,
                              onChanged: (String? val) {
                                ref
                                    .read(teacherHeaderLineFieldProvider.notifier)
                                    .state = _headlineController.text.trim();
                              },
                              focusNode: _headlineFocusNode,
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 80.h,
        width: 390.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Next",
              onTap: () {
                if (_fullmameController.text.isEmpty ||
                    _contactnumberController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _countryController.text.isEmpty ||
                    _cityController.text.isEmpty ||
                    _ageController.text.isEmpty) {
                  UIFeedback.showSnackBar(
                      context, "Please fill all the required fields",
                      height: 200);
                } else if (_image == null) {
                  UIFeedback.showSnackBar(
                      context, "Please set your profile image.",
                      height: 200);
                }
                // else if(!Strings.phoneRegex.hasMatch(_contactnumberController.text.trim())){
                //   UIFeedback.showSnackBar(context, "Please provide coontact number in correct formatting",height: 200);
                // }
                else {
                  _headlineFocusNode.unfocus();
                  _ageFocusNode.unfocus();
                  context.push(PagePath.teacherRegProcessEducation);
                }
              },
              btnColor: AppColors.primaryColor,
              textColor: Colors.white,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFF3EBE6),
          radius: 40.r,
          child: Center(
            child: _image != null
                ? Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(File(_image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SvgPicture.asset(Drawables.profileIcon),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              _pickImage(ImageSource.gallery);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
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
      ]),
    );
  }
}
