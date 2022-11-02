import '../widgets/counter_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TileWidget extends StatelessWidget {
  final String text;
  final int count;
  const TileWidget(this.text, this.count, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final deviceHeight = deviceSize.height;
    return CircularPercentIndicator(
      radius: deviceHeight * 0.08,
      animation: true,
      animationDuration: 1000,
      lineWidth: deviceHeight * 0.0127,
      percent: 1,
      header: Text(
        text,
        style: TextStyle(fontSize: deviceHeight * 0.0255),
      ),
      center: CounterAnimationWidget(
        begin: 0,
        end: count,
        duration: 1,
        curve: Curves.easeOut,
        textStyle: TextStyle(
          fontSize: deviceHeight * 0.0447,
          fontWeight: FontWeight.w600,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Theme.of(context).primaryColor,
    );
  }
}
