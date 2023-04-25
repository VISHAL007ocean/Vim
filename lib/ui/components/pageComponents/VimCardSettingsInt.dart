import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/interfaces/common_field_properties.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsText.dart';

/// This is a password field. It obscures the entered text.
class VimCardSettingsInt extends VimCardSettingsText
    implements ICommonFieldProperties {
  VimCardSettingsInt({
    bool contentOnNewLine = false,
    Key key,
    String label: 'Label',
    TextAlign labelAlign,
    double labelWidth,
    TextAlign contentAlign,
    String hintText,
    int initialValue: 0,
    Icon icon,
    Widget requiredIndicator,
    String unitLabel,
    int maxLength: 10,
    bool visible: true,
    bool enabled: true,
    bool autofocus: false,
    bool obscureText: false,
    bool autocorrect: false,
    // bool autovalidate: false,
    AutovalidateMode autovalidateMode: AutovalidateMode.onUserInteraction,
    FormFieldValidator<int> validator,
    FormFieldSetter<int> onSaved,
    ValueChanged<int> onChanged,
    TextEditingController controller,
    FocusNode focusNode,
    TextInputAction inputAction,
    FocusNode inputActionNode,
    TextInputType keyboardType,
    TextStyle style,
    bool maxLengthEnforced: true,
    ValueChanged<String> onFieldSubmitted,
    List<TextInputFormatter> inputFormatters,
    bool showMaterialonIOS,
    EdgeInsetsGeometry fieldPadding,
  }) : super(
          key: key,
          label: label,
          hintText: hintText,
          labelAlign: labelAlign,
          labelWidth: labelWidth,
          showMaterialonIOS: showMaterialonIOS,
          contentAlign: contentAlign,
          initialValue: initialValue?.toString(),
          unitLabel: unitLabel,
          icon: icon,
          requiredIndicator: requiredIndicator,
          maxLength: maxLength,
          visible: visible,
          contentOnNewLine: contentOnNewLine,
          enabled: enabled,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          // autovalidate: autovalidate,
          autovalidateMode: autovalidateMode,
          fieldPadding: fieldPadding,
          validator: (value) {
            if (validator == null) return null;
            return validator(intelligentCast<int>(value));
          },
          onSaved: (value) {
            if (onSaved == null) return;
            onSaved(intelligentCast<int>(value));
          },
          onChanged: (value) {
            if (onChanged == null) return;
            onChanged(intelligentCast<int>(value));
          },
          controller: controller,
          focusNode: focusNode,
          inputAction: inputAction,
          inputActionNode: inputActionNode,
          keyboardType:
              keyboardType ?? TextInputType.numberWithOptions(decimal: false),
          style: style,
          maxLengthEnforced: maxLengthEnforced,
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
            FilteringTextInputFormatter.allow(RegExp("[0-9]+")),
          ],
        );
}
