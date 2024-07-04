import 'package:flutter/material.dart';


class EmptyAppBarWidget extends StatelessWidget implements PreferredSizeWidget{

  final AppBar appBar;
  final VoidCallback? onTap;
  const EmptyAppBarWidget({
    super.key,  required this.appBar,this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading:       GestureDetector(
        onTap: onTap,
        child: const Icon(Icons.arrow_back,color: Colors.black,),
      ),


    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(appBar.preferredSize.height);
}