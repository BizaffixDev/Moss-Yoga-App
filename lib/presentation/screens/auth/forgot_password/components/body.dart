// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:go_router/go_router.dart';
// import 'package:moss_yoga/app/utils/common_functions.dart';
// import 'package:moss_yoga/common/resources/page_path.dart';
//
//
// import '../../../../../common/app_specific_widgets/custom_button.dart';
// import '../../../../../common/app_specific_widgets/custom_rich_text.dart';
// import '../../../../../common/app_specific_widgets/custom_text_field.dart';
// import '../../../../../common/app_specific_widgets/logo_green_image.dart';
// import 'appbar_widget.dart';
// import 'forgot_password_head.dart';
//
// class Body extends StatelessWidget {
//   const Body({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       backgroundColor:Colors.white,
//
//       appBar: ForgotpasswordAppbarWidget(appBar: AppBar(),onTap: ()=>context.pop(),),
//
//       body:  SingleChildScrollView(
//         child: Column(
//           children: [
//
//
//             const LogoGreenImage(),
//
//             const ForgotPasswordHead(),
//
//             const CustomTextField(
//               hintText: "jhondoe@gmail.com",
//               labelText: "Email",
//               prefixIcon: Icons.email_outlined,
//
//             ),
//
//             const SizedBox(height: 70),
//
//             CustomButton(
//               text: "Send Email",
//               onTap: (){},
//             ),
//
//
//
//             SizedBox(height: CommonFunctions.deviceHeight(context) * 0.02,),
//
//             CustomRichText(
//               text1: "Back to login account ",
//               text2:"",
//                 onTap: ()=>context.push(PagePath.verifyEmail),
//             )
//           ],
//         ),
//       ),
//
//     );
//   }
// }
