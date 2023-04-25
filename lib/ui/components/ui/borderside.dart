
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

class VimBorderSide extends BorderSide {
  VimBorderSide({Color color})
      : super(
          color: color != null ? color : Colors.white,
          style: BorderStyle.solid,
          width: 1.0,
        );
}

class VimStyle extends TextStyle {
  const VimStyle.raleway(double size, FontWeight weight, Color color)
      : super(inherit: false, color: color, fontFamily: 'Raleway', fontSize: size, fontWeight: weight, textBaseline: TextBaseline.alphabetic);
}

TextStyle ralewayThin(double fontSize, [Color color]) => new VimStyle.raleway(fontSize, FontWeight.w100, color ?? vimScaffoldColor);
TextStyle ralewayLight(double fontSize, [Color color]) => new VimStyle.raleway(fontSize, FontWeight.w300, color ?? vimScaffoldColor);
TextStyle ralewayRegular(double fontSize, [Color color]) => new VimStyle.raleway(fontSize, FontWeight.w400, color ?? vimScaffoldColor);
TextStyle ralewayMedium(double fontSize, [Color color]) => new VimStyle.raleway(fontSize, FontWeight.w500, color ?? vimScaffoldColor);
TextStyle ralewayBold(double fontSize, [Color color]) => new VimStyle.raleway(fontSize, FontWeight.w700, color ?? vimScaffoldColor);

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the TM app.
class VimTheme extends InheritedWidget {
  VimTheme({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  Color get accentColor => vimAccent;
  Color get primaryColor => vimPrimary;
  Color get borderSideColor => vimButtonColor;
  Color get appBarBackgroundColor => scaffoldColor;

  final Color scaffoldColor = vimScaffoldColor;
  final Color appBarColor = vimPrimary;
  final Color textColor = Colors.black;
  final Color textMutedColor = vimScaffoldColor;

  TextStyle get appBarStyle => ralewayBold(20.0, appBarColor);
  TextStyle get titleStyle => ralewayMedium(18.0, vimPrimary);
  TextStyle get smallTextStyle => ralewayRegular(12.0, textColor);
  TextStyle get mediumTextStyle => ralewayRegular(16.0, textColor);

  @override
  bool updateShouldNotify(VimTheme oldWidget) => false;
}
