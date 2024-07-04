import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/presentation/screens/teachers_screens/teacher_profile_setting/teacher_account_states.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../app/utils/common_functions.dart';
import '../../../../app/utils/ui_snackbars.dart';
import '../../../../common/app_specific_widgets/drawer.dart';
import '../../../../common/app_specific_widgets/loader.dart';
import '../../../../common/app_specific_widgets/teacherdrawer.dart';
import '../../../../common/resources/colors.dart';
import '../../../../common/resources/drawables.dart';
import '../../../../common/resources/text_styles.dart';
import '../../../../data/models/user_gender_model.dart';
import '../../../providers/screen_state.dart';
import '../../../providers/teachers_providers/teacher_account_provider.dart';


class TeacherProfileScreen extends ConsumerStatefulWidget {
  TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<TeacherProfileScreen>  with TickerProviderStateMixin {

  String selectedGender = UserGender.female;

  TextEditingController fullNameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController contactNumberController = TextEditingController(text: "");
  TextEditingController dobController = TextEditingController(text: "");
  TextEditingController locationController = TextEditingController(text: "");
  TextEditingController educationController = TextEditingController(text: "");
  TextEditingController docController = TextEditingController(text: "");
  TextEditingController yocController = TextEditingController(text: "");
  TextEditingController certificationController = TextEditingController(text: "");

  late TabController _tabController;

  PickedFile? _image;
  File? _file;
  String? _fileName;

  Future<void> _selectDob(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: AppColors.primaryColor, // Set the primary color of the theme
      onPrimary: Colors.white, // Set the text color on the primary color
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(colorScheme: colorScheme),
          // Apply the custom color scheme
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }


  Future<void> _selectDoc(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: AppColors.primaryColor, // Set the primary color of the theme
      onPrimary: Colors.white, // Set the text color on the primary color
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(colorScheme: colorScheme),
          // Apply the custom color scheme
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        docController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    FocusScope.of(context).unfocus();
    final picker = ImagePicker();

    try {
      final pickedImage = await picker.getImage(source: source);

      if (pickedImage != null) {
        final filePath = pickedImage.path;
        final fileName = filePath.split('/').last;
        // ref.read(teacherProfileImagePathProvider.notifier).state =
        //     pickedImage.path;
        // ref.read(teacherProfileImageNameProvider.notifier).state =
        //     pickedImage.toString();
        //
        // setState(() {
        //   _image = PickedFile(pickedImage.path);
        // });
        ref.read(teacherProfileImagePathProvider.notifier).state = filePath;
        ref.read(teacherProfileImageNameProvider.notifier).state = fileName;

        setState(() {
          _image = PickedFile(filePath);
        });
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


  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    FocusScope.of(context).unfocus();
    if (result != null) {
      PlatformFile file = result.files.first;
      final tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/${file.name}');

      if (file.bytes != null) {
        await tempFile.writeAsBytes(file.bytes!);
      } else {
        tempFile.createSync(recursive: true);
        tempFile.writeAsBytesSync(await File(file.path!).readAsBytes());
      }

      setState(() {
        _file = tempFile;
        _fileName = file.name;
        ref.read(teacherCertificateFilePathProvider.notifier).state = tempFile;
        ref.read(teacherCertificateFileNameProvider.notifier).state = file.name;
        // ref.read(teacherCertificateFileNameProvider.notifier).state =
        //     _fileName!;
        // ref.read(teacherCertificateFilePathProvider.notifier).state = _file!;
      });
      print("FILENAME ======$_fileName");
    } else {
      print('No file selected.');
    }
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called once $_apiCalled");
    if (!_apiCalled) {
      _apiCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {



        await ref.read(teacherAccountNotifierProvider.notifier).getProfileDetails().whenComplete(() {

          // setState(() {
          //   fullNameController.text = ref.read(teacherFullName);
          //   emailController.text = ref.read(teacherEmail);
          //   contactNumberController.text = ref.read(teacherContactNumber);
          //   docController.text = ref.read(teacherDoc);
          //   dobController.text = ref.read(teacherDob);
          //   locationController.text = ref.read(teacherCity);
          //   educationController.text = ref.read(teacherEducation);
          //   yocController.text = ref.read(teacherYoc).toString();
          //   selectedGender = ref.read(teacherGender);
          //
          // });

        });

      });
    }
  }


  @override
  Widget build(BuildContext context) {

    String description =  ref.watch(teacherDescription);


    ref.listen<TeacherAccountStates>(teacherAccountNotifierProvider, (previous, screenState) async {

      if (screenState is TeacherProfileDetailsSuccessfulState) {
        dismissLoading(context);
        setState(() {
          fullNameController.text = ref.read(teacherFullName);
          emailController.text = ref.read(teacherEmail);
          contactNumberController.text = ref.read(teacherContactNumber);
          docController.text = ref.read(teacherDoc);
          dobController.text = ref.read(teacherDob);
          locationController.text = ref.read(teacherCity);
          educationController.text = ref.read(teacherEducation);
          yocController.text = ref.read(teacherYoc).toString();
          selectedGender =ref.read(teacherGender) ?? UserGender.female.toString();

        });
      }


      else if (screenState is UpdateTeacherProfileDetailsSuccessfulState) {
        dismissLoading(context);
        context.pop();
        context.pop();
        UIFeedback.showSnackBar(context, "Your Profile updated successfully.",
            stateType: StateType.success,
            height: 500);

        setState(() {
          fullNameController.text = ref.read(teacherFullName);
          emailController.text = ref.read(teacherEmail);
          contactNumberController.text = ref.read(teacherContactNumber);
          docController.text = ref.read(teacherDoc);
          dobController.text = ref.read(teacherDob);
          locationController.text = ref.read(teacherCity);
          educationController.text = ref.read(teacherEducation);
          yocController.text = ref.read(teacherYoc).toString();
          selectedGender =ref.read(teacherGender) ?? UserGender.female.toString();

        });


      }

      else if (screenState is TeacherProfileDetailsErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          // dismissLoading(context);
        }
        else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      }

      else if (screenState is UpdateTeacherProfileDetailsErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        else if (screenState.errorType == ErrorType.other) {
          debugPrint(
              "This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
           dismissLoading(context);
        }
        else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 250);
          dismissLoading(context);
        }
      }

      else if (screenState is  UpdateTeacherProfileDetailsLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }

      else if (screenState is  TeacherProfileDetailsLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }else{
        debugPrint('Loading');
        showLoading(context);
      }


    });


    return SafeArea(
      top: false,
      child: Scaffold(

        endDrawer: TeacherDrawer(),
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
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white,),
                              onPressed: () {
                                context.pop();
                              },
                            ),
                            //SizedBox(width: 285.w,),
                            IconButton(
                              icon: Icon(Icons.menu, color:Colors.white,),
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
                              backgroundColor: const Color(0xFFF3EBE6),
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
                                  //(ImageSource.gallery);
                                  _pickImage(ImageSource.gallery);
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
                        SizedBox(height: 10),
                        Text(
                          ref.read(teacherFullName),
                          //ref.watch(teacherObjectProvider).username,
                          style: manropeSubTitleTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          ref.read(teacherEmail),
                         // ref.watch(teacherObjectProvider).email,
                          style:manropeSubTitleTextStyle.copyWith(
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
                            height: 70.h,
                            width: 390.w,
                            decoration:  const BoxDecoration(
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
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Image.asset(Drawables.badgeTeacher, height: 20),
                                          SizedBox(width: 10.w,),
                                          Text(
                                            'Silver',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w700,
                                              // height: 21.60,
                                            ),
                                          ),
                                          SizedBox(width: 10.w,),
                                          HeroIcon(HeroIcons.questionMarkCircle, color: Colors.white),
                                        ],
                                      ),

                                      Row(
                                        children: [

                                          Icon(Icons.star, color: Colors.white),
                                          SizedBox(width: 10.w,),
                                          Text(
                                            '4.5 Rating ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w700,
                                              //height: 21.60,
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(

                  padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 20.h),
                  
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


                        Text(description.isEmpty ? "\"Nurturing souls through mindful movements and compassionate guidance.\"" : description,
                      style: manropeSubTitleTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1.2
                      ),
                      textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h,),


                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                        decoration: BoxDecoration(
                            color: Colors.white70,

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: Offset(1,3),
                              ),
                            ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                         /*   Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: AppColors.primaryColor,
                                unselectedLabelColor: const Color(0xFFC4C4BC),
                                tabs:  [
                                  // Tab(text: 'Previous Teacher',),
                                  Text(
                                    'Personal Information',
                                    style: manropeSubTitleTextStyle.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        height: 1.2,
                                        color: AppColors.neutral53,),
                                  ),
                                  Text(
                                    'Bank details',
                                    style: manropeSubTitleTextStyle.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        color: AppColors.neutral53),
                                  ),

                                ],
                              ),
                            ),*/

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Full Name',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: fullNameController,
                                    readOnly: true,
                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },
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

                                SizedBox(height: 12,),
                                Text(
                                  'Email Address',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: emailController,
                                    readOnly: true,
                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },
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

                                SizedBox(height: 12,),

                                Text(
                                  'Contact Number',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: contactNumberController,
                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: "+125486548",
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



                                SizedBox(height: 12,),



                                Text(
                                  'Date of Birth',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),

                                SizedBox(height: 12,),

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
                                            keyboardType: TextInputType.datetime,
                                            //controller: _ageController,
                                            onChanged: (String? val) {

                                            },
                                            onEditingComplete: () {
                                              // FocusScope.of(context)
                                              //     .requestFocus(_headlineFocusNode);
                                            },
                                            onTap: () {
                                              _selectDob(context);
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(
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
                                                suffixIcon: HeroIcon(HeroIcons.calendarDays,color: Colors.black,)
                                            ),
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
                                                  .read(teacherGender.notifier)
                                                  .state = selectedGender;
                                              //newValue = studentGender;
                                              print(selectedGender);
                                              print(
                                                  "selectedGender ${ref.read(teacherGender)}");
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
                                ),

                                SizedBox(height: 12.h,),

                                Text(
                                  'Location',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: locationController,
                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: "New York",
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

                                SizedBox(height: 15,),


                                Text("Experience",style: manropeHeadingTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.primaryColor,
                                ),),

                                SizedBox(height: 15,),

                                Text(
                                  'Education',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: educationController,
                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: "Education",
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

                                SizedBox(height: 12,),

                                Text(
                                  'Date of completion',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: docController,
                                    readOnly:true,
                                    onChanged: (String? value) {


                                    },
                                    onTap: () {
                                      _selectDoc(context);
                                    },
                                    onSubmitted: (_) {

                                    },

                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: "Date of completeion",
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

                                SizedBox(height: 12,),

                                Text(
                                  'Years of experience',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: yocController,

                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: "Years of experience",
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

                                SizedBox(height: 12,),


                                Text(
                                  'Certificate',
                                  style: manropeSubTitleTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color:const Color(0xFF5B5B5B)
                                  ),
                                ),
                                SizedBox(height: 12,),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: TextField(
                                    controller: certificationController,
                                    readOnly: true,
                                    onChanged: (_) {

                                      setState(() {});
                                    },
                                    onTap: () {

                                      setState(() {});
                                    },
                                    onSubmitted: (_) {

                                      setState(() {});
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      hintText: _fileName ?? "Add Your Certificates",
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
                                      suffixIcon: GestureDetector(
                                        onTap: () => _pickFile(),
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.primaryColor,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.centerRight,
                                          child: Center(
                                            child: Text(
                                              "Upload",
                                              style:
                                              manropeHeadingTextStyle.copyWith(
                                                fontSize: 12,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),
                                  ),
                                ),

                                SizedBox(height: 20,),





                                CustomButton(
                                    m: 0,
                                    text: "Save",
                                    onTap: () async{

                                      if(_image == null){
                                        UIFeedback.showSnackBar(
                                          context, "Please set your profile image.",);
                                      }else if (_file == null) {
                                        UIFeedback.showSnackBar(
                                            context, "Please add your certifications",
                                            height: 200);
                                      }else{
                                        FocusScope.of(context).unfocus();
                                        await ref.read(teacherAccountNotifierProvider.notifier).updateTeacherprofile(
                                          contactNumber: contactNumberController.text.trim(),
                                          location: locationController.text.trim(),
                                          education: educationController.text.trim(),
                                          dob: dobController.text,
                                          doc: docController.text,
                                          yoc: int.parse(yocController.text),
                                          gender: selectedGender,
                                        );
                                      }
                                    },
                                    btnColor: AppColors.primaryColor,
                                    textColor: Colors.white),
                              ],
                            ),

                           

                            /*SizedBox(
                              height:CommonFunctions.deviceHeight(context) * 1.5,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  //PERSONAL INFO TAB

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Full Name',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: fullNameController,
                                          readOnly: true,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },
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

                                      SizedBox(height: 12,),
                                      Text(
                                        'Email Address',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: emailController,
                                          readOnly: true,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },
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

                                      SizedBox(height: 12,),

                                      Text(
                                        'Contact Number',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: contactNumberController,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "+125486548",
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



                                      SizedBox(height: 12,),



                                      Text(
                                        'Date of Birth',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),

                                      SizedBox(height: 12,),

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
                                                  keyboardType: TextInputType.datetime,
                                                  //controller: _ageController,
                                                  onChanged: (String? val) {

                                                  },
                                                  onEditingComplete: () {
                                                    // FocusScope.of(context)
                                                    //     .requestFocus(_headlineFocusNode);
                                                  },
                                                  onTap: () {
                                                    _selectDob(context);
                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(
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
                                                      suffixIcon: HeroIcon(HeroIcons.calendarDays,color: Colors.black,)
                                                  ),
                                                ),
                                              )),

                                          SizedBox(
                                            width: 15,
                                          ),

                                          Expanded(
                                            child: Container(

                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 10),
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
                                                    print(selectedGender);
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
                                      ),

                                      SizedBox(height: 12.h,),

                                      Text(
                                        'Location',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: locationController,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },

                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "New York",
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

                                      SizedBox(height: 15,),


                                      Text("Experience",style: manropeHeadingTextStyle.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.primaryColor,
                                      ),),

                                      SizedBox(height: 15,),

                                      Text(
                                        'Education',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: educationController,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },

                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "Education",
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

                                      SizedBox(height: 12,),

                                      Text(
                                        'Date of completion',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: docController,
                                          readOnly:true,
                                          onChanged: (String? value) {


                                          },
                                          onTap: () {
                                            _selectDoc(context);
                                          },
                                          onSubmitted: (_) {

                                          },

                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "Date of completeion",
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

                                      SizedBox(height: 12,),

                                      Text(
                                        'Years of experience',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: yocController,

                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },

                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "Years of experience",
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

                                      SizedBox(height: 12,),


                                      Text(
                                        'Certificate',
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          controller: certificationController,
                                          readOnly: true,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },

                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: _fileName ?? "Add Your Certificates",
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
                                            suffixIcon: GestureDetector(
                                              onTap: () => _pickFile(),
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                height: 30,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColors.primaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                alignment: Alignment.centerRight,
                                                child: Center(
                                                  child: Text(
                                                    "Upload",
                                                    style:
                                                    manropeHeadingTextStyle.copyWith(
                                                      fontSize: 12,
                                                      color: AppColors.primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20,),





                                      CustomButton(
                                          m: 0,
                                          text: "Save",
                                          onTap: () async{

                                            if(_image == null){
                                              UIFeedback.showSnackBar(
                                                  context, "Please set your profile image.",);
                                            }else if (_file == null) {
                                              UIFeedback.showSnackBar(
                                                  context, "Please add your certifications",
                                                  height: 200);
                                            }else{
                                              FocusScope.of(context).unfocus();
                                              await ref.read(teacherAccountNotifierProvider.notifier).updateTeacherprofile(
                                                  contactNumber: contactNumberController.text.trim(),
                                                  location: locationController.text.trim(),
                                                  education: educationController.text.trim(),
                                                  dob: dobController.text,
                                                  doc: docController.text,
                                                  yoc: int.parse(yocController.text),
                                                  gender: selectedGender,
                                              );
                                            }
                                      },
                                          btnColor: AppColors.primaryColor,
                                          textColor: Colors.white),
                                    ],
                                  ),



                                  //BANK DETAIL TAB


                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Card Number",
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          readOnly: true,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "1234*********",
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

                                      SizedBox(height: 12,),
                                      Text(
                                        "Card Holder Name",
                                        style: manropeSubTitleTextStyle.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:const Color(0xFF5B5B5B)
                                        ),
                                      ),
                                      SizedBox(height: 12,),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        // margin: EdgeInsets.symmetric(horizontal: 20.w),
                                        child: TextField(
                                          readOnly: true,
                                          onChanged: (_) {

                                            setState(() {});
                                          },
                                          onTap: () {

                                            setState(() {});
                                          },
                                          onSubmitted: (_) {

                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            hintText: "James",
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
                                    ],
                                  ),





                                ],
                              ),
                            ),*/







                          ],
                        ),
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