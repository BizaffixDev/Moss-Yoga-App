import 'package:flutter/material.dart';

import 'components/body.dart';

class TeacherRegProcess extends StatefulWidget {
  const TeacherRegProcess({Key? key}) : super(key: key);

  @override
  State<TeacherRegProcess> createState() => _TeacherRegProcessState();
}

class _TeacherRegProcessState extends State<TeacherRegProcess>
    with WidgetsBindingObserver {
  void showAlertBox() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hello"),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
