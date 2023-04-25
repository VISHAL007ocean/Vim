
import 'package:flutter/material.dart';

class PagesButton extends StatelessWidget {
  static const TextStyle style = const TextStyle(fontWeight: FontWeight.w700);

  final VoidCallback onPressed;
  final String text;

  const PagesButton({Key key, this.onPressed, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}