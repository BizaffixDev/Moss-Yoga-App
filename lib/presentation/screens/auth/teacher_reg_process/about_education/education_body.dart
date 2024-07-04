import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/data/models/teacher_profile_status.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../app/utils/ui_snackbars.dart';
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

class TeacherRegProcessEducation extends ConsumerStatefulWidget {
  const TeacherRegProcessEducation({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherRegProcessEducation> createState() =>
      _TeacherRegProcessEducationState();
}

class _TeacherRegProcessEducationState
    extends ConsumerState<TeacherRegProcessEducation> {
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _instituteController = TextEditingController();
  final TextEditingController _docController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  //TEXT FOCUSNODES
  final FocusNode _specialityFocusNode = FocusNode();
  final FocusNode _instituteFocusNode = FocusNode();
  final FocusNode _docFocusNode = FocusNode();
  final FocusNode _experienceFocusNode = FocusNode();

  @override
  void dispose() {
    _specialityController.dispose();
    _instituteController.dispose();
    _docController.dispose();
    _experienceController.dispose();
    _specialityFocusNode.dispose();
    _instituteFocusNode.dispose();
    _docFocusNode.dispose();
    _experienceFocusNode.dispose();

    super.dispose();
  }

  File? _file;
  String? _fileName;

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     setState(() {
  //       _file = File(file.path!);
  //       _fileName = file.name;
  //     });
  //     print("FILENAME ======" + _fileName.toString());
  //   } else {
  //     print('No file selected.');
  //   }
  // }
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

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

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null) {
  //     PlatformFile platformFile = result.files.first;
  //
  //     final fileBytes = platformFile.bytes;
  //     if (fileBytes == null) {
  //       print("No file bytes available");
  //       return;
  //     }
  //
  //     final tempDir = await getTemporaryDirectory();
  //     final file = await File('${tempDir.path}/${platformFile.name}')
  //         .writeAsBytes(fileBytes);
  //
  //     setState(() {
  //       _file = file;
  //       _fileName = platformFile.name;
  //     });
  //
  //     print("FILENAME ======" + _fileName.toString());
  //   } else {
  //     print('No file selected.');
  //   }
  // }

  Future _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: AppColors.primaryColor, // Set the primary color of the theme
      onPrimary: Colors.white, // Set the text color on the primary color
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        _docController.text = DateFormat('yyyy/MM/dd').format(picked);

        ref.read(teacherDocFieldProvider.notifier).state =  _docController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStates>(authNotifyProvider, (previous, screenState) async {
      // if(screenState is LoginListState){
      //   list = screenState.val as List;
      // }
      if (screenState is ProfilingTeacherErrorState) {
        if (screenState.errorType == ErrorType.unauthorized) {
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 300);
          dismissLoading(context);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Bro')));
          // UIFeedback.logoutShowDialogue(context, ref);
        }
        if (screenState.errorType == ErrorType.other) {
          print("This is the error thats not shwoing: ${screenState.error}");
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error Bro')));
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 300);
          dismissLoading(context);
        } else {
          print("This is the error thats not shwoing: ${screenState.error}");
          UIFeedback.showSnackBar(context, screenState.error.toString(),
              height: 300);
          dismissLoading(context);
        }
      } else if (screenState is ProflingTeacherLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      } else if (screenState is ProflingTeacherSuccessfulState) {
        ref.read(teacherProfileStatusProvider.notifier).state =
            TeacherProfileStatus(status: ProfileCompletion.Complete);

        context.go(PagePath.teacherRegProcessSuccess);
        dismissLoading(context);
        ref.invalidate(teacherInstituteFieldProvider);
        ref.invalidate(teacherYearsOfExperienceFieldProvider);
        ref.invalidate(teacherDocFieldProvider);
        ref.invalidate(teacherCertificateFileNameProvider);

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
                      children: [
                        ArrowBackIcon(onTap: () => context.pop()),
                        SizedBox(
                          width: 80.w,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 14.h,
                          ),
                          child: Text(
                            'EDUCATION',
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
                              height: 25.h,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Add details about academic and\nprofessional background.',
                                style: manropeSubTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: const Color(0XFF414042),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 14.0),
                            CustomTextField(
                              hintText: "Select your specialty",
                              labelText: "Specialty*",
                              controller: _specialityController,
                              onChanged: (String? val) {
                                ref
                                    .read(
                                        teacherSpecialtyFieldProvider.notifier)
                                    .state = _specialityController.text.trim();
                              },
                              focusNode: _specialityFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_instituteFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              hintText: "Name of Institue",
                              labelText: "Institue*",
                              controller: _instituteController,
                              textInputType: TextInputType.text,
                              onChanged: (String? val) {
                                ref
                                    .read(
                                        teacherInstituteFieldProvider.notifier)
                                    .state = _instituteController.text.trim();
                              },
                              focusNode: _instituteFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_docFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              isReadONly: true,
                              hintText: "dd/mm/yy",
                              labelText: "Date of Completion*",
                              controller: _docController,
                              onTap: () async{
                                DateTime? selectedDate = await _selectDate(context);
                                if (selectedDate != null) {
                                  _docController.text = DateFormat('yyyy/MM/dd').format(selectedDate);
                                  ref
                                      .read(teacherDocFieldProvider.notifier)
                                      .state = _docController.text;

                                  print("DOC SELECTED =====   ${   ref
                                      .read(teacherDocFieldProvider)}");
                                }
                              },
                              onChanged: (String? val) {
                                ref
                                    .read(teacherDocFieldProvider.notifier)
                                    .state = _docController.text;

                                print("DOC SELECTED =====   ${   ref
                                    .read(teacherDocFieldProvider)}");
                              },
                              focusNode: _docFocusNode,
                              textInputAction: TextInputAction.next,
                              onSubmit: () {
                                FocusScope.of(context)
                                    .requestFocus(_experienceFocusNode);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              hintText: "Enter years of experience",
                              labelText: "Experience*",
                              controller: _experienceController,
                              onChanged: (String? val) {
                                ref
                                        .read(
                                            teacherYearsOfExperienceFieldProvider
                                                .notifier)
                                        .state =
                                    int.parse(
                                        _experienceController.text.trim());
                              },
                              focusNode: _experienceFocusNode,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              child: TextField(
                                readOnly: true,
                                onChanged: (_) {
                                  _docFocusNode.unfocus();
                                  setState(() {});
                                },
                                onTap: () {
                                  _docFocusNode.unfocus();
                                  setState(() {});
                                },
                                onSubmitted: (_) {
                                  _docFocusNode.unfocus();
                                  setState(() {});
                                },
                                // onChanged: (String? val) {
                                // onChanged: (String? val) {
                                //   if (_fileName != null) {
                                //     ref
                                //         .read(teacherCertificateFileNameProvider
                                //             .notifier)
                                //         .state = _fileName!;
                                //     ref
                                //         .read(teacherCertificateFilePathProvider
                                //             .notifier)
                                //         .state = _file!;
                                //   }
                                // },

                                //   ref
                                //       .read(teacherCertificateFileNameProvider
                                //           .notifier)
                                //       .state = _fileName!;
                                // },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText:
                                      _fileName ?? "Add Your Certificates",
                                  labelText: "Certificates*",
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
                            )
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
        height: 111.h,
        width: 390.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Complete Profile",
              onTap: () async {
                if (_specialityController.text.isEmpty ||
                    _instituteController.text.isEmpty ||
                    _docController.text.isEmpty ||
                    _experienceController.text.isEmpty) {
                  UIFeedback.showSnackBar(
                      context, "Please fill all the required fields",
                      height: 200);
                } else if (_file == null) {
                  UIFeedback.showSnackBar(
                      context, "Please add your certifications",
                      height: 200);
                } else {
                  _specialityFocusNode.unfocus();
                  _instituteFocusNode.unfocus();
                  _experienceFocusNode.unfocus();
                  _docFocusNode.unfocus();
                  print(
                      "DOC ============== ${ref.read(teacherDocFieldProvider.notifier).state}");
                  await ref
                      .read(authNotifyProvider.notifier)
                      .postTeacherDetailInfo(
                          isGoogle: ref
                              .read(teacherLoggedInWithGoogleProvider.notifier)
                              .state);
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
}
