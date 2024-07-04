import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class SplashScreenTest extends StatefulWidget {
  SplashScreenTest(this.text, {super.key});

  String text;

  @override
  _SplashScreenTestState createState() => _SplashScreenTestState();
}

class _SplashScreenTestState extends State<SplashScreenTest> {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    // Example: Fetch data, check authentication, etc.

    // Simulate a delay using Future.delayed
    Future.delayed(const Duration(seconds: 7), () {
      // Navigate to the desired route
      context.go(PagePath.onBoarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashColor,
      body: Container(
        width: 390.w,
        height: 844.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splsh_bg_upd.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Additional Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash_upd_layer.png',
                fit: BoxFit.cover,
              ),
            ),
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/images/splash_upd_layer.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Image.asset(
                  'assets/images/logo_upd_white.png',
                  width: 214,
                  height: 207,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 30,
                ),
                const LogoText(),
                Text('This is the text coming from noti ${widget.text}'),
                const SizedBox(
                  height: 20,
                ),
                const SubText(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.splashColor,
//       body: Container(
//         width: CommonFunctions.deviceWidth(context),
//         height: CommonFunctions.deviceHeight(context),
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage(
//                 "assets/images/splash_upd_layer.png",
//               ),
//               fit: BoxFit.cover),
//         ),
//
//         child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //LOGO
//             Image.asset(
//               'assets/images/logo_upd_white.png',
//              width: 214,
//                 height: 207,
//               fit: BoxFit.cover
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             const LogoText(),
//             const SizedBox(
//               height: 20,
//             ),
//             const SubText(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 70),
      child: SvgPicture.asset(
        "assets/images/moss_yoga_text.svg",
        // width: 274,
        // height: 31,
      ),
    );
  }
}

class SubText extends StatelessWidget {
  const SubText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'GOING BEYOND THE MATT',
      style: kButtonTextStyle.copyWith(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
    );
  }
}
