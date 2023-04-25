import 'package:card_settings/card_settings.dart';
import 'package:card_settings/helpers/platform_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:vim_mobile/ui/components/pageComponents/TextSizeChecker.dart'
    as SizeTest;

/// This is a header to distinguish sections of the form.
class VimCardSettingsHeader extends StatelessWidget
    implements CardSettingsWidget {
  VimCardSettingsHeader({
    this.label: 'Label',
    this.labelAlign: TextAlign.left,
    this.height: 44.0,
    this.color,
    this.showMaterialonIOS,
    this.visible = true,
    this.child,
    this.fieldPadding,
  });

  final String label;
  final TextAlign labelAlign;
  final double height;
  final Color color;
  @override
  final bool showMaterialonIOS;
  @override
  final bool visible;
  final Widget child;
  final EdgeInsetsGeometry fieldPadding;

  @override
  Widget build(BuildContext context) {
    if (!visible) return Container();
    if (child != null) return child;

    if (showCupertino(context, showMaterialonIOS))
      return _cupertinoHeader(context);
    else
      return _materialHeader(context);
  }

  Widget _cupertinoHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CSHeader(label),
        ),
      ],
    );
  }

  Widget _materialHeader(BuildContext context) {
    double upMargin = 8.0;
    double leftMargin = 14.0;
    double downMargin = 8.0;
    double rightMargin = 14.0;

    EdgeInsetsGeometry _fieldPadding = (fieldPadding ??
        CardSettings.of(context).fieldPadding ??
        EdgeInsets.only(
            left: leftMargin,
            top: upMargin,
            right: rightMargin,
            bottom: downMargin));

    /*Size _textSize(String text, TextStyle style, BuildContext context) {
      //checks the span of the text using given inputs
      final TextPainter heightPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width);
      //return height of text
      Size textsize = heightPainter.size;
      return textsize;
    }

    /*int _textLines(String text, TextStyle style, BuildContext context) {
      //checks the span of the text using given inputs
      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width);
      //get number of lines in text (linemetric)
      List<ui.LineMetrics> lines = textPainter.computeLineMetrics();
      //return number of lines
      int numLines = lines.length;
      return numLines;
    }*/

    //Size of Text;
    final Size textSize =
        _textSize(label, Theme.of(context).textTheme.headline6, context);

    //Number of Lines;
    final double textperline =
        //find characters per line by dividing screen size by text size
        MediaQuery.of(context).size.width / textSize.height;
    final double lines = label.length / textperline;
    //divide length of text by characters per line to estimate number of lines
    //_textLines(label, Theme.of(context).textTheme.headline6, context);

    //Temp Value used for math when calculating header height;
    final double boxHeight = textSize.height + 16;*/

    return Container(
      margin: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).secondaryHeaderColor,
      ),
      height: SizeTest.getTextSize(label, Theme.of(context).textTheme.headline6,
              context, upMargin, downMargin, leftMargin, rightMargin)
          .boxHeight,
      width: MediaQuery.of(context).size.width,
      padding: _fieldPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.headline6,
              textAlign: labelAlign,
              maxLines: null,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
