import 'package:flutter/material.dart';

class ResetPasswordCreatedBottomSheet extends StatefulWidget {
  const ResetPasswordCreatedBottomSheet({Key? key}) : super(key: key);

  @override
  State<ResetPasswordCreatedBottomSheet> createState() =>
      _ResetPasswordCreatedBottomSheetState();
}

class _ResetPasswordCreatedBottomSheetState
    extends State<ResetPasswordCreatedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          child: const Text('Modal Bottom'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
