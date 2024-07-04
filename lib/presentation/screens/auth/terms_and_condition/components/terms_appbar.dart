import 'package:flutter/material.dart';
import 'package:moss_yoga/common/resources/text_styles.dart';

class TermsAppbarWidget extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appBar;
  final VoidCallback? onTap;
  const TermsAppbarWidget({
    super.key, required this.appBar, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.all(10),
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: const Color(0XFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset("assets/images/back_arrow.png"),
            )),
      ),
      title:  Text(
        "Terms and Condition",
        style: kButtonTextStyle,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(appBar.preferredSize.height);
}