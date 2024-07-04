import 'package:flutter/cupertino.dart';

class SlideAction extends StatefulWidget {
  final double thumbWidth;
  final Widget Function(BuildContext, SlideActionState) trackBuilder;
  final Widget Function(BuildContext, SlideActionState) thumbBuilder;
  final VoidCallback action;

  const SlideAction({
    Key? key,
    required this.thumbWidth,
    required this.trackBuilder,
    required this.thumbBuilder,
    required this.action,
  }) : super(key: key);

  @override
  SlideActionState createState() => SlideActionState();
}

class SlideActionState extends State<SlideAction> with SingleTickerProviderStateMixin {
late AnimationController _animationController;
double _dragExtent = 0;
bool _dragUnderway = false;
bool _isMovingRight = false;

@override
void initState() {
  super.initState();
  _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
}

@override
void dispose() {
  _animationController.dispose();
  super.dispose();
}

double get thumbFractionalPosition => _dragExtent / widget.thumbWidth;

void _onDragStart(DragStartDetails details) {
  _dragUnderway = true;
  _isMovingRight = details.globalPosition.dx > context.size!.width / 2;
}

void _onDragUpdate(DragUpdateDetails details) {
  if (_dragUnderway) {
    setState(() {
      if (_isMovingRight) {
        _dragExtent += details.delta.dx;
        if (_dragExtent > widget.thumbWidth) {
          _dragExtent = widget.thumbWidth;
        }
      } else {
        _dragExtent -= details.delta.dx;
        if (_dragExtent < 0) {
          _dragExtent = 0;
        }
      }
    });
  }
}

void _onDragEnd(DragEndDetails details) {
  _dragUnderway = false;
  if (_dragExtent >= widget.thumbWidth / 2) {
    _animationController.forward();
    widget.action.call();
  } else {
    _animationController.reverse();
  }
}

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onHorizontalDragStart: _onDragStart,
    onHorizontalDragUpdate: _onDragUpdate,
    onHorizontalDragEnd: _onDragEnd,
    child: Stack(
      alignment: Alignment.centerRight,
      children: [
        widget.trackBuilder(context, this),
        Positioned(
          right: _isMovingRight ? _dragExtent : null,
          left: _isMovingRight ? null : _dragExtent,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: _isMovingRight ? const Offset(1, 0) : const Offset(-1, 0),
            ).animate(_animationController),
            child: widget.thumbBuilder(context, this),
          ),
        ),
      ],
    ),
  );
}
}
