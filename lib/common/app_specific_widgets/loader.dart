import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';

class Loader extends StatelessWidget {
  Loader({super.key, this.backgroundColor, this.height});

  final Color? backgroundColor;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height,
      color: AppColors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          height: 80,
          width: 80,
          // decoration: BoxDecoration(
          //   color: Colors.black.withOpacity(0.7),
          //   borderRadius: BorderRadius.circular(8),
          //   border: Border.all(
          //     color: Colors.black,
          //   ),
          // ),
         // child: const CircularProgressIndicator(),
          child: Image.asset("assets/loader/loader.gif",height: 80,width: 80,),
        ),
      ),
    );
  }
}

Future<void> showLoading(BuildContext context, {Color? backgroundColor}) {
  var isDebug = false;
  if (kDebugMode) {
    isDebug = true;
  } else {
    isDebug = false;
  }
  return showDialog(
    context: context,
    barrierDismissible: isDebug,
    barrierColor: AppColors.transparent,
    builder: (context) {
      return Loader(
        backgroundColor: backgroundColor,
      );
    },
  );
}

void dismissLoading(BuildContext context) {
  GoRouter.of(context).pop();
}
