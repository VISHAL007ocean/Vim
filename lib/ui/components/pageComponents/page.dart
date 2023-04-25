import 'package:flutter/material.dart';

class MultiPage extends StatelessWidget {
  final Color bgColor;
  final Widget widget;
  final Widget content;

  const MultiPage({Key key, this.widget, @required this.content, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isVertical = orientation == Orientation.portrait;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: widget ?? Container(), flex: isVertical ? 5 : 4),
              ],
            ),
          );
        },
      ),
    );
  }
}
