import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:moss_yoga/common/resources/colors.dart';

class ReverseTimerProgressIndicator extends StatefulWidget {
  final int totalTime;
  final VoidCallback onTimerEnd;

  const ReverseTimerProgressIndicator({super.key, required this.totalTime, required this.onTimerEnd});

  @override
  _ReverseTimerProgressIndicatorState createState() => _ReverseTimerProgressIndicatorState();
}

class _ReverseTimerProgressIndicatorState extends State<ReverseTimerProgressIndicator> {
  late Timer _timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        elapsedSeconds++;
      });

      if (elapsedSeconds >= widget.totalTime) {
        timer.cancel();
        // Call the callback function when the timer ends
        widget.onTimerEnd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int remainingSeconds = widget.totalTime - elapsedSeconds;
    double progress = remainingSeconds / widget.totalTime;
    return Container(
      height: 17.h,
      width: 330.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: LinearProgressIndicator(
          backgroundColor: const Color(0xFFDADAD1),
          color: AppColors.primaryColor.withOpacity(0.2),
          value: progress,
          semanticsLabel: 'Reverse Timer Progress Indicator',
        ),
      ),
    );
  }
}
