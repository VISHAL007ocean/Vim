import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:flutter/material.dart';

class CardSettingsGenericWidget extends StatelessWidget
    implements CardSettingsWidget {
  static const TextStyle style = const TextStyle(fontWeight: FontWeight.w700);

  final List<Widget> children;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  CardSettingsGenericWidget({@required this.children});

  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}
