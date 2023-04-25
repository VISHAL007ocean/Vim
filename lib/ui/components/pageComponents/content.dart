
import 'package:flutter/material.dart';

class PagesContent extends StatelessWidget {
  final String title;
  final String body;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  const PagesContent(
      {Key key,
      @required this.title,
      this.body,
      this.titleStyle,
      this.bodyStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 50.0),
        ),
        Text(title, style: titleStyle, textAlign: TextAlign.center),
        Container(
          padding: const EdgeInsets.only(bottom: 24.0),
        ),
        Text(body, style: bodyStyle, textAlign: TextAlign.center)
      ],
    );
  }
}