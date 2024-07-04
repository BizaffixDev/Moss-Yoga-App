import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/strings.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';
import 'package:moss_yoga/presentation/providers/screen_state.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UIFeedback {
  UIFeedback._();

  static void showSnackBar(
    BuildContext context,
    String message, {
    StateType stateType = StateType.error,
    Color? leftBarColor,
    VoidCallback? onPressed,
    void Function(FlushbarStatus?)? onStatusChanged,
    double percentageToMult = 0.79,
    int? height = 140,
  }) {
    if (stateType == StateType.error) {
      _showErrorBar(context, message, onPressed, height);
    } else if (stateType == StateType.success) {
      _showSuccessBar(context, message, onPressed, height);
    } else if (stateType == StateType.initial) {
      _showInfoBar(context, message, onPressed, height);
    } else {
      _showInfoBar(context, message, onPressed, height);
    }
  }

  static void _showInfoBar(BuildContext context, String? message,
      VoidCallback? onPressed, int? height) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.fixed,
        // Set behavior to fixed
        margin: EdgeInsets.only(bottom: 844.h - height!, right: 20, left: 20),
        backgroundColor: const Color(0xFF303535),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        action: SnackBarAction(
          label: 'x',
          textColor: Colors.white,
          onPressed: onPressed ??
              () {
                // Navigator.pop(context);
              },
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(Drawables.errorSnackbar),
                SizedBox(
                  width: 20.w,
                ),
                SizedBox(
                  width: 200.w,
                  child: Text(
                    message ??
                        "Something went wrong. Please check your credentials and try again",
                    style: manropeHeadingTextStyle.copyWith(
                        fontSize: 14.sp, color: Colors.white, height: 1.2),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            /*Text(
              "x",
              style: manropeHeadingTextStyle.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            )*/
          ],
        ),
      ),
    );

    // return showTopSnackBar(
    //   // Overlay.of(context),
    //   // OverlayState(),
    //   Overlay.of(context),
    //   CustomSnackBar.info(
    //     message: message,
    //   ),
    //   dismissType: DismissType.onSwipe,
    //   dismissDirection: [
    //     DismissDirection.down,
    //     DismissDirection.horizontal,
    //     DismissDirection.up
    //   ],
    // );
  }

  static void _showSuccessBar(
    BuildContext context,
    String? message,
    VoidCallback? onPressed,
    int? height,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.startToEnd,

      behavior: SnackBarBehavior.floating,
      // Set behavior to fixed
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(bottom: 844.h - height!, right: 20, left: 20),
      backgroundColor: const Color(0xFF507D2D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      action: SnackBarAction(
        label: 'x',
        textColor: Colors.white,
        onPressed: onPressed ??
            () {
              // Navigator.pop(context);
            },
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(Drawables.successSnackar),
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                width: 200.w,
                child: Text(
                  message ??
                      "Something went wrong. Please check your credentials and try again",
                  style: manropeHeadingTextStyle.copyWith(
                      fontSize: 14.sp, color: Colors.white, height: 1.2),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          // Text(
          //   "x",
          //   style: manropeHeadingTextStyle.copyWith(
          //     fontSize: 16.sp,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
    ));

/*    return showTopSnackBar(
      // Overlay.of(context),
      OverlayState(),
      CustomSnackBar.success(
        message: "Good job, your release is successful. Have a nice day",
      ),
      dismissType: DismissType.onSwipe,
      dismissDirection: [
        DismissDirection.down,
        DismissDirection.horizontal,
        DismissDirection.up
      ],
      onTap: onPressed,
    )*/
  }

  static void _showErrorBar(BuildContext context, String? message,
      VoidCallback? onPressed, int? height) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      // Set behavior to fixed
      margin: EdgeInsets.only(bottom: 820.h - height!, right: 20, left: 20),
      backgroundColor: const Color(0xFFC62828),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      action: SnackBarAction(
        label: 'x',
        textColor: Colors.white,
        onPressed: onPressed ??
            () {
              // Navigator.pop(context);
            },
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(Drawables.errorSnackbar),
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                width: 200.w,
                child: Text(
                  message ??
                      "Something went wrong. Please check your credentials and try again",
                  style: manropeHeadingTextStyle.copyWith(
                      fontSize: 14.sp, color: Colors.white, height: 1.2),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          // Text(
          //   "x",
          //   style: manropeHeadingTextStyle.copyWith(
          //     fontSize: 16.sp,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
    ));

    /*return  showTopSnackBar(
      // OverlayState(),
      Overlay.of(context),
      CustomSnackBar.error(
        backgroundColor: Color(0xFFC62828),
        borderRadius: BorderRadius.circular(8.r),
        textStyle: manropeHeadingTextStyle.copyWith(
          fontSize: 14.sp,
          color: Colors.white
        ),
        maxLines: 4,
        message:
        message ?? "Something went wrong. Please check your credentials and try again",
      ),
      dismissType: DismissType.onSwipe,
      dismissDirection: [
        DismissDirection.down,
        DismissDirection.horizontal,
        DismissDirection.up
      ],
    );*/
  }

  static Future<bool?> showAlertDialog(
    BuildContext context, {
    bool isMessageWiget = false,
    Widget? messageWidget,
    bool isTap = false,
    VoidCallback? tapOk,
    required String title,
    required String message,
    String imageName = '',
    String cancelBtnText = 'Cancel',
    String okBtnText = 'Ok',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          title: Column(
            children: [
              if (imageName.isNotEmpty) ...[
                SvgPicture.asset(imageName),
                const SizedBox(height: 5),
              ],
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ignore: prefer_if_elements_to_conditional_expressions
              isMessageWiget
                  ? messageWidget!
                  : Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed:
                          isTap ? tapOk : () => Navigator.pop(context, true),
                      child: Text(
                        okBtnText,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        cancelBtnText,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static Future<bool?> showMessageAlertDialog(
    BuildContext context, {
    bool isMessageWiget = false,
    Widget? messageWidget,
    bool isTap = false,
    VoidCallback? tapOk,
    required String title,
    required String message,
    String imageName = '',
    String cancelBtnText = 'Cancel',
    String okBtnText = 'Ok',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          title: Column(
            children: [
              if (imageName.isNotEmpty) ...[
                SvgPicture.asset(imageName),
                const SizedBox(height: 5),
              ],
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ignore: prefer_if_elements_to_conditional_expressions
              isMessageWiget
                  ? messageWidget!
                  : Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  // showPlatformDialog(
  // context: context,
  // builder: (context) => BasicDialogAlert(
  // title: Text("Current Location Not Available"),
  // content:
  // Text("Your current location cannot be determined at this time."),
  // actions: <Widget>[
  // BasicDialogAction(
  // title: Text("OK"),
  // onPressed: () {
  // Navigator.pop(context);
  // },
  // ),
  // ],
  // ),
  // );
  // Alert(
  // context: context,
  // type: AlertType.warning,
  // title: "RFLUTTER ALERT",
  // desc: "Flutter is more awesome with RFlutter Alert.",
  // buttons: [
  // DialogButton(
  // child: Text(
  // "FLAT",
  // style: TextStyle(color: Colors.white, fontSize: 20),
  // ),
  // onPressed: () => Navigator.pop(context),
  // color: Color.fromRGBO(0, 179, 134, 1.0),
  // ),
  // DialogButton(
  // child: Text(
  // "GRADIENT",
  // style: TextStyle(color: Colors.white, fontSize: 20),
  // ),
  // onPressed: () => Navigator.pop(context),
  // gradient: LinearGradient(colors: [
  // Color.fromRGBO(116, 116, 191, 1.0),
  // Color.fromRGBO(52, 138, 199, 1.0)
  // ]),
  // )
  // ],
  // ).show();

  //

  static Future<bool?> logoutShowDialogue(BuildContext context, WidgetRef ref) {
    debugPrint('Logout for Show Platform Dialog called');
    return Alert(
      onWillPopActive: true,
      closeIcon: Container(),
      style: AlertStyle(
        overlayColor: Colors.black,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        // alertPadding: EdgeInsets.all(10),
      ),
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              SizedBox(
                height: 100,
                width: 350,
                child: SvgPicture.asset(
                  'assets/',
                  color: Colors.black,
                  height: 18,
                  width: 18,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text(
                        'Ok',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      onPressed: () async {
                        // unawaited(
                        //     ref.read(userNotifyProvider.notifier).logout());
                        // await ref
                        //     .read(userNotifyProvider.notifier)
                        //     .clearAllProviders();
                        // ignore: use_build_context_synchronously
                        // Beamer.of(context).beamToNamed(PagePath.LoginScreen);
                      },
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: OutlinedButton(
                      child: Text(
                        'Logout',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.primaryColor),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      buttons: [],
    ).show();
  }

  // static Future<bool?> sessionOutDialog(BuildContext context, WidgetRef ref) {
  //   if (ref.read(sessionTimeoutProvider)) {
  //     ref.read(sessionTimeoutProvider.notifier).state = false;
  //     return Alert(
  //       onWillPopActive: true,
  //       buttons: [],
  //       closeIcon: Container(),
  //       style: AlertStyle(
  //         overlayColor: Colors.black,
  //         alertBorder: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         // alertPadding: EdgeInsets.all(10),
  //       ),
  //       context: navigatorKey.currentState!.context,
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Image.asset(
  //             'assets/close.png',
  //             height: 50,
  //             width: 50,
  //           ),
  //           Text(
  //             AppLocalizations.of(globalContext!).session_expired,
  //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 15),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: OutlinedButton(
  //                   style: OutlinedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     backgroundColor: AppColors.primaryColor,
  //                   ),
  //                   child: Text(
  //                     AppLocalizations.of(globalContext!).ok,
  //                     style: Theme.of(globalContext!)
  //                         .textTheme
  //                         .labelMedium
  //                         ?.copyWith(color: Colors.white),
  //                   ),
  //                   onPressed: () async {
  //                     await ref
  //                         .read(userNotifyProvider.notifier)
  //                         .clearAllProviders();
  //                     await ref
  //                         .read(authNotifyProvider.notifier)
  //                         .setRegularLogin();
  //                     // ignore: use_build_context_synchronously
  //                     ref.read(sessionTimeoutProvider.notifier).state = true;
  //                     navigatorKey.currentState?.context
  //                         .go(PagePath.password, extra: true);
  //                     // return true;
  //                     // Future.delayed(Duration.zero,(){
  //                     //   true;
  //                     // });
  //                   },
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ).show();
  //     // return showDialog<bool>(
  //     //   context: navigatorKey.currentState!.context,
  //     //   barrierDismissible: false,
  //     //   builder: (BuildContext context) {
  //     //     return AlertDialog(
  //     //       shape:
  //     //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  //     //       title: Image.asset(
  //     //         'assets/close.png',
  //     //         height: 50,
  //     //         width: 50,
  //     //       ),
  //     //       content:
  //     //       Column(
  //     //         mainAxisSize: MainAxisSize.min,
  //     //         children: [
  //     //           Text(
  //     //             AppLocalizations.of(globalContext!).session_expired,
  //     //             style: const TextStyle(
  //     //                 fontWeight: FontWeight.bold, fontSize: 14),
  //     //             textAlign: TextAlign.center,
  //     //           ),
  //     //           const SizedBox(height: 15),
  //     //           Row(
  //     //             children: [
  //     //               Expanded(
  //     //                 child: OutlinedButton(
  //     //                   style: OutlinedButton.styleFrom(
  //     //                     shape: RoundedRectangleBorder(
  //     //                       borderRadius: BorderRadius.circular(5),
  //     //                     ),
  //     //                     backgroundColor: AppColors.primaryColor,
  //     //                   ),
  //     //                   child: Text(
  //     //                     AppLocalizations.of(globalContext!).ok,
  //     //                     style: Theme.of(globalContext!)
  //     //                         .textTheme
  //     //                         .labelMedium
  //     //                         ?.copyWith(color: Colors.white),
  //     //                   ),
  //     //                   onPressed: () async {
  //     //                     await ref
  //     //                         .read(userNotifyProvider.notifier)
  //     //                         .clearAllProviders();
  //     //                     await ref
  //     //                         .read(authNotifyProvider.notifier)
  //     //                         .setRegularLogin();
  //     //                     // ignore: use_build_context_synchronously
  //     //                     ref.read(sessionTimeoutProvider.notifier).state =
  //     //                     true;
  //     //                     navigatorKey.currentState?.context
  //     //                         .go(PagePath.password, extra: true);
  //     //                   },
  //     //                 ),
  //     //               ),
  //     //             ],
  //     //           )
  //     //         ],
  //     //       ),
  //     //     );
  //     //   },
  //     // );
  //   } else {
  //     return Future.delayed(Duration.zero, () {
  //       return false;
  //     });
  //   }
  // }

  static Future<bool?> showAppUpdateRequiredDialod(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          // title: Image.asset(
          //   'assets/close.png',
          //   height: 50,
          //   width: 50,
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text(
                        'update',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      onPressed: () {
                        if (Platform.isAndroid || Platform.isIOS) {
                          final urlToLaunch = Platform.isAndroid
                              ? Strings.googlePlayURL
                              : Strings.appStoreShareURL;
                          final url = Uri.parse(urlToLaunch);
                          launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static Future<bool?> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String imageName = '',
    String okBtnText = 'Ok',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          title: Column(
            children: [
              if (imageName.isNotEmpty) ...[
                SvgPicture.asset(imageName),
                const SizedBox(height: 5),
              ],
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text(
                  okBtnText,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
      },
    );
  }
}
