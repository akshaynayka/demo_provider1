import 'package:flutter/material.dart';

class CounterAnimationWidget extends StatefulWidget {
  const CounterAnimationWidget({
    required this.begin,
    required this.end,
    required this.curve,
    required this.duration,
    required this.textStyle,
    Key? key,
  }) : super(key: key);
  final int begin; // The beginning of the int animation.
  final int end; // The the end of the int animation (result).
  final int duration; // The duration of the animation.
  final Curve curve; // The curve of the animation (recommended: easeOut).
  final TextStyle textStyle; // The TextStyle.

  @override
  CounterAnimationWidgetState createState() => CounterAnimationWidgetState();
}

class CounterAnimationWidgetState extends State<CounterAnimationWidget>
    with SingleTickerProviderStateMixin {
  Animation? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(seconds: widget.duration), vsync: this);
    _animation = IntTween(begin: widget.begin, end: widget.end).animate(
        CurvedAnimation(parent: _animationController!, curve: widget.curve));

    _animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController!,
        builder: (_, __) {
          return Text(_animation!.value.toString(), style: widget.textStyle);
        });
  }
}
