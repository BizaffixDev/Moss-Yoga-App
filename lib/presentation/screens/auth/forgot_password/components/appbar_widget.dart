import 'package:flutter/material.dart';

class ForgotpasswordAppbarWidget extends StatelessWidget implements PreferredSizeWidget{

  final AppBar appBar;
  final VoidCallback? onTap;
  const ForgotpasswordAppbarWidget({
    super.key,  required this.appBar,this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,

      title: GestureDetector(
        onTap: onTap,
        child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color:const Color(0XFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset("assets/images/back_arrow.png"),
            )
        ),
      ),

    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(appBar.preferredSize.height);
}