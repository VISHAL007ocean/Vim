import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedTitleText extends StatefulWidget {
  final String title;
  final double fontSize;
  final Color color;
  final int duration;
  final String fontFamily;

  const AnimatedTitleText({ Key key, this.title, this.fontSize, this.fontFamily, this.color, this.duration }) : super(key: key);

  @override
  _AnimatedTitleTextState createState() => _AnimatedTitleTextState(title: title, fontSize:fontSize, fontFamily: fontFamily, color: color, duration: duration);
}

class _AnimatedTitleTextState extends State<AnimatedTitleText> {
  final String title;
  final double fontSize;
  final Color color;
  final int duration;
  final String fontFamily;
  String _currentString = "";
  Timer _timer;

  _AnimatedTitleTextState({
      this.title,
      this.fontSize,
      this.fontFamily,
      this.color,
      this.duration,
  });

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(milliseconds: 512),
      _start
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentString,
      style: Theme.of(context).textTheme.subtitle1.copyWith(color: color, fontFamily: fontFamily, fontSize: fontSize),
    );
  }

  void _start(){
    _timer = Timer.periodic(Duration(milliseconds: duration), (Timer timer){
      final newLength = _currentString.length + 1;
      if ( newLength > title.length ) {
        _stop();
      } else {
        setState((){
          _currentString = title.substring(0, newLength);
        });
      }
    });
  }

  void _stop(){
    _timer.cancel();
  }
}