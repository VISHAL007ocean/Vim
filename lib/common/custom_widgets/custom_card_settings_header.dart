import 'package:card_settings/helpers/platform_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:flutter/material.dart';

/// This is a header to distinguish sections of the form.
class CustomCardSettingsHeader extends StatelessWidget {
  CustomCardSettingsHeader({
    this.label: 'Label',
    this.labelAlign: TextAlign.left,
    this.height: 44.0,
    this.color,
    this.showMaterialonIOS,
  });

  final String label;
  final TextAlign labelAlign;
  final double height;
  final Color color;
  final bool showMaterialonIOS;

  @override
  Widget build(BuildContext context) {
    if (showCupertino(context, showMaterialonIOS))
      return cupertinoHeader(context);
    else
      return materialHeader(context);
  }

  Widget cupertinoHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CSHeader(label),
        ),
      ],
    );
  }

  Widget materialHeader(BuildContext context) {
    return Wrap(children: [
      Container(
        margin: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).secondaryHeaderColor,
        ),
        height: height,
        padding:
            EdgeInsets.only(left: 14.0, top: 8.0, right: 14.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headline6,
                textAlign: labelAlign,
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
