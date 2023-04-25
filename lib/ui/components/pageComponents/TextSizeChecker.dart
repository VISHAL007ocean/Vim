import 'package:flutter/material.dart';

//Function with Parameters
getTextSize(String text, TextStyle style, BuildContext context, double upMargin,
    double downMargin, double leftMargin, double rightMargin) {
  Size _textSize(String text, TextStyle style, BuildContext context) {
    //checks the span of the text using given inputs
    final TextPainter heightPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width);
    //return height of text
    Size textsize = heightPainter.size;
    return textsize;
  }

  Size textSize = _textSize(text, style, context); //size of text

  double verticalMargin = upMargin + downMargin;

  double horizontalMargin = leftMargin + rightMargin;

  double charsPerLine = MediaQuery.of(context).size.width /
      textSize.height; //number of characters per line

  double lineheight = textSize.height + verticalMargin;

  int numLines = (text.length / charsPerLine).ceil();

  double boxHeight = lineheight * numLines;

  return new TextSize(textSize.height, verticalMargin, horizontalMargin,
      charsPerLine, lineheight, numLines, boxHeight);
}

class TextSize {
  double textSize; // Size of given Text
  double verticalMargin; // Top+Bottom Margin of Text
  double horizontalMargin; // Top+Bottom Margin of Text
  double characters; // Number of Characters per Line
  double lineHeight; // Height of Each TextLine
  int numLines; // number of lines in box
  double boxHeight; // height of box

  TextSize(
    this.textSize,
    this.verticalMargin,
    this.horizontalMargin,
    this.characters,
    this.lineHeight,
    this.numLines,
    this.boxHeight,
  );
}
