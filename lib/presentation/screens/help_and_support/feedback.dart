import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/help_support_provider.dart';

import '../../../app/utils/preference_manager.dart';
import '../../../app/utils/ui_snackbars.dart';
import '../../../common/app_specific_widgets/loader.dart';
import '../../../common/resources/colors.dart';
import '../../../common/resources/drawables.dart';
import '../../../data/data_sources/user_local_data_source.dart';
import '../../../data/models/login_response_model.dart';
import '../../providers/screen_state.dart';
import 'help_support_states.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final feedbackTextController = TextEditingController();

  late UserLocalDataSource userLocalDataSource;
  String userEmail = ''; // Initialize with an empty string
  int userId = -1; // Initialize with an empty string

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLocalDataSource = UserLocalDataSourceImpl(
      preferencesManager: SecurePreferencesManager(),
    );
    _loadUserData();
  }

  _loadUserData() async {
    // Load user data from preferences
    LoginResponseModel? user = await userLocalDataSource.getUser();
    if (user != null) {
      // User data exists, you can access it using the 'user' object
      // Now, 'user.email' will give you the user's email
      setState(() {
        userEmail = user.email; // Update the userEmail state variable
        userId = user.userId; // Update the userEmail state variable
      });
    } else {
      // User data not found in preferences
      setState(() {
        userEmail =
            ''; // Update the userEmail state variable with an empty string
        userId = -1; // Update the userEmail state variable with an empty string
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HelpSupportStates>(helpSupportNotifierProvider,
        (previous, screenState) async {
      if (screenState is FeedbackSuccessfulState) {
        dismissLoading(context);
        setState(() {});

        showModalBottomSheet(
            context: context,
            isDismissible: false,
            isScrollControlled: false,
            shape: const RoundedRectangleBorder(
              // <-- SEE HERE
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 388.h,
                width: 391.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                            feedbackTextController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            "x",
                            style: manropeSubTitleTextStyle.copyWith(
                                color: Colors.grey, fontSize: 18.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        height: 119.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                        child: Container(
                          height: 90.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB5BF8F),
                          ),
                          child: Center(
                            child: SvgPicture.asset(Drawables.tickWhite),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Text(
                        "Thankyou for your feedback",
                        style: manropeHeadingTextStyle,
                      ),
                      Text(
                        "Your complain has been forwarded successfully. We’ll get back to you shortly",
                        style: manropeSubTitleTextStyle.copyWith(
                            color: const Color(0xFF7F9195),
                            fontSize: 16.sp,
                            height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            });
      } else if (screenState is FeedbackErrorState) {
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
      } else if (screenState is FeedbackLoadingState) {
        debugPrint('Loading');
        showLoading(context);
        // setState(() {});
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        height: 844.h,
        width: 390.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                Drawables.authPlainBg,
              ),
              fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 770.h,
            width: 390.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(37),
                topRight: Radius.circular(37),
              ),
              image: DecorationImage(
                alignment: Alignment.bottomLeft,
                image: AssetImage(
                  "assets/images/help_support_bg.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Image.asset(
                      'assets/home/moss_yoga_logo_2.png',
                      width: 140.w,
                      fit: BoxFit.cover,
                      // height: CommonFunctions.deviceHeight(context) * 0.2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text(
                      "Feedback",
                      style: manropeHeadingTextStyle.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text(
                      "We are here to help you!",
                      style: manropeSubTitleTextStyle.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    height: 150.h,
                    width: 280.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    child: TextField(
                      controller: feedbackTextController,
                      maxLines: 15,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "Enter your text here",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: CustomButton(
                        m: 0,
                        btnColor: AppColors.primaryColor,
                        textColor: Colors.white,
                        text: "Send",
                        onTap: () {
                          if (feedbackTextController.text.isEmpty) {
                            UIFeedback.showSnackBar(
                                context, "Please provide us your feedback");
                          } else {
                            ref
                                .read(helpSupportNotifierProvider.notifier)
                                .sendFeedback(
                                    email: userEmail,
                                    feedback:
                                        feedbackTextController.text.trim());
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
