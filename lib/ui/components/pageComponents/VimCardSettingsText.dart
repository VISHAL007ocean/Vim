// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.

import 'package:card_settings/card_settings.dart';
import 'package:card_settings/helpers/platform_functions.dart';
import 'package:card_settings/interfaces/common_field_properties.dart';
import 'package:card_settings/interfaces/text_field_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

/// This is a standard one line text entry  It's based on the [TextFormField] widget.
class VimCardSettingsText extends FormField<String>
    implements ICommonFieldProperties, ITextFieldProperties {
  VimCardSettingsText({
    Key key,
    String initialValue,
    bool autovalidate: false,
    AutovalidateMode autovalidateMode: AutovalidateMode.onUserInteraction,
    this.enabled = true,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.maxLengthEnforced = true,
    this.inputMask,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.style,
    this.focusNode,
    this.inputAction,
    this.inputActionNode,
    this.label = 'Label',
    this.contentOnNewLine = true,
    this.maxLength = 20,
    this.numberOfLines = 1,
    this.showCounter = false,
    this.visible = true,
    this.autocorrect = true,
    this.obscureText = false,
    this.autofocus = false,
    this.contentAlign,
    this.hintText,
    this.icon,
    this.labelAlign,
    this.labelWidth,
    this.prefixText,
    this.requiredIndicator,
    this.unitLabel,
    this.showMaterialonIOS,
    this.showClearButtonIOS = OverlayVisibilityMode.never,
    this.fieldPadding,
  })  : //assert(initialValue == null || controller == null),
        assert(keyboardType != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(autovalidateMode != null),
        assert(textCapitalization != null),
        assert(maxLengthEnforced != null),
        assert(maxLength == null || maxLength > 0),
        assert(controller == null || inputMask == null),
        super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          //autovalidate: autovalidate,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<String> field) =>
              (field as _VimCardSettingsTextState)._build(field.context),
        );

  @override
  final ValueChanged<String> onChanged;

  final TextEditingController controller;

  final String inputMask;

  final FocusNode focusNode;

  final TextInputAction inputAction;

  final FocusNode inputActionNode;

  final TextInputType keyboardType;

  final TextCapitalization textCapitalization;

  final TextStyle style;

  @override
  final bool enabled;

  final bool maxLengthEnforced;

  final ValueChanged<String> onFieldSubmitted;

  final List<TextInputFormatter> inputFormatters;

  @override
  final String label;

  @override
  final TextAlign labelAlign;

  @override
  final double labelWidth;

  @override
  final TextAlign contentAlign;

  final String unitLabel;

  final String prefixText;

  @override
  final String hintText;

  @override
  final Icon icon;

  @override
  final Widget requiredIndicator;

  final bool contentOnNewLine;

  final int maxLength;

  final int numberOfLines;

  final bool showCounter;

  @override
  final bool visible;

  final bool autofocus;

  final bool obscureText;

  final bool autocorrect;

  @override
  final bool showMaterialonIOS;

  @override
  final EdgeInsetsGeometry fieldPadding;

  ///Since the CupertinoTextField does not support onSaved, please use [onChanged] or [onFieldSubmitted] instead
  @override
  final FormFieldSetter<String> onSaved;

  ///In material mode this shows the validation text under the field
  ///In cupertino mode, it shows a [red] [Border] around the [CupertinoTextField]
  @override
  final FormFieldValidator<String> validator;

  final OverlayVisibilityMode showClearButtonIOS;

  @override
  _VimCardSettingsTextState createState() => _VimCardSettingsTextState();
}

class _VimCardSettingsTextState extends FormFieldState<String> {
  TextEditingController _controller;

  @override
  VimCardSettingsText get widget => super.widget as VimCardSettingsText;

  @override
  void initState() {
    super.initState();
    _initController(widget.initialValue);
  }

  @override
  void didUpdateWidget(VimCardSettingsText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _initController(oldWidget.controller.value.toString());
    }
  }

  void _initController(String initialValue) {
    if (widget.controller == null) {
      if (widget.inputMask == null) {
        _controller = TextEditingController(text: initialValue);
      } else {
        _controller =
            MaskedTextController(mask: widget.inputMask, text: initialValue);
      }
    } else {
      _controller = widget.controller;
    }

    _controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _controller.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    if (_controller.text != value) {
      didChange(_controller.text);
    }
  }

  void _handleOnChanged(String value) {
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  void _onFieldSubmitted(String value) {
    if (this.widget?.focusNode != null) this.widget.focusNode.unfocus();

    if (this.widget?.inputActionNode != null) {
      this.widget.inputActionNode.requestFocus();
      return;
    }

    if (this.widget?.onFieldSubmitted != null)
      this.widget.onFieldSubmitted(value);
  }

  Widget _build(BuildContext context) {
    if (showCupertino(context, widget.showMaterialonIOS))
      return _buildCupertinoTextbox(context);
    else
      return _buildMaterialTextbox(context);
    // return SizedBox();
  }

  Container _buildCupertinoTextbox(BuildContext context) {
    bool hasError = false;
    if (widget.validator != null) {
      String errorMessage = widget.validator(value);
      hasError = (errorMessage != null);
    }

    final ls = labelStyle(context, widget?.enabled ?? true);
    final _child = Container(
      child: CupertinoTextField(
        prefix: widget?.prefixText == null
            ? null
            : Text(
                widget.prefixText,
                style: ls,
              ),
        suffix: widget?.unitLabel == null
            ? null
            : Text(
                widget.unitLabel,
                style: ls,
              ),
        controller: _controller,
        focusNode: widget?.focusNode,
        textInputAction: widget?.inputAction,
        keyboardType: widget?.keyboardType,
        textCapitalization: widget?.textCapitalization,
        style: contentStyle(context, value, widget.enabled),
        decoration: hasError
            ? BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              )
            : BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF56122f), width: 1.0),
                  bottom: BorderSide(color: Color(0xFF56122f), width: 1.0),
                  left: BorderSide(color: Color(0xFF56122f), width: 1.0),
                  right: BorderSide(color: Color(0xFF56122f), width: 1.0),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
        clearButtonMode: widget?.showClearButtonIOS,
        placeholder: widget?.hintText,
        textAlign: widget?.contentAlign ?? TextAlign.end,
        autofocus: widget?.autofocus ?? false,
        obscureText: widget?.obscureText ?? false,
        autocorrect: widget?.autocorrect ?? true,
        //maxLengthEnforced: widget?.maxLengthEnforced ?? false,
        maxLines: widget?.numberOfLines,
        maxLength: (widget?.showCounter ?? false)
            ? widget?.maxLength
            : null, // if we want counter use default behavior
        onChanged: _handleOnChanged,
        onSubmitted: _onFieldSubmitted,
        inputFormatters: widget?.inputFormatters ??
            [
              // if we don't want the counter, use this maxLength instead
              LengthLimitingTextInputFormatter(widget?.maxLength)
            ],
        enabled: widget?.enabled,
      ),
    );
    return Container(
      child: widget?.visible == false
          ? null
          : widget?.contentOnNewLine == true
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CSControl(
                      nameWidget: widget?.requiredIndicator != null
                          ? Text(
                              (widget?.label ?? "") + ' *',
                              style: ls,
                            )
                          : Text(widget?.label, style: ls),
                      contentWidget: Container(),
                      style: CSWidgetStyle(icon: widget?.icon),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: _child,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? null
                          : CupertinoColors.white,
                    ),
                    Container(
                      padding: widget?.showCounter ?? false
                          ? EdgeInsets.all(5.0)
                          : null,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? null
                          : CupertinoColors.white,
                      child: widget?.showCounter ?? false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "${_controller?.text?.length ?? 0}/${widget?.maxLength}",
                                  style: TextStyle(
                                    color: CupertinoColors.inactiveGray,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CSControl(
                      nameWidget: Container(
                        width: widget?.labelWidth ??
                            CardSettings.of(context).labelWidth ??
                            120.0,
                        child: widget?.requiredIndicator != null
                            ? Text((widget?.label ?? "") + ' *', style: ls)
                            : Text(widget?.label, style: ls),
                      ),
                      contentWidget: Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: _child,
                        ),
                      ),
                      style: CSWidgetStyle(icon: widget?.icon),
                    ),
                    Container(
                      padding: widget?.showCounter ?? false
                          ? EdgeInsets.all(5.0)
                          : null,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? null
                          : CupertinoColors.white,
                      child: widget?.showCounter ?? false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "${_controller?.text?.length ?? 0}/${widget?.maxLength}",
                                  style: TextStyle(
                                    color: CupertinoColors.inactiveGray,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ],
                ),
    );
  }

  CardSettingsField _buildMaterialTextbox(BuildContext context) {
    return CardSettingsField(
      label: widget.label,
      labelAlign: widget?.labelAlign,
      labelWidth: widget?.labelWidth,
      visible: widget?.visible,
      unitLabel: widget?.unitLabel,

      //  sedfsf
      icon: widget?.icon,
      requiredIndicator: widget?.requiredIndicator,
      contentOnNewLine: widget?.contentOnNewLine ?? false,
      enabled: widget.enabled,
      fieldPadding: widget.fieldPadding,
      content: TextField(
        controller: _controller,
        focusNode: widget?.focusNode,
        keyboardType: widget?.keyboardType,
        textInputAction: widget?.inputAction,
        textCapitalization: widget?.textCapitalization,
        enabled: widget.enabled,
        readOnly: !widget.enabled,
        style: contentStyle(context, value, widget.enabled),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
          ),
          errorText: errorText,
          prefixText: widget?.prefixText,
          hintText: widget?.hintText,
          isDense: true,
        ),
        textAlign:
            widget?.contentAlign ?? CardSettings.of(context).contentAlign,
        autofocus: widget?.autofocus ?? false,
        obscureText: widget?.obscureText ?? false,
        autocorrect: widget?.autocorrect ?? true,
        //maxLengthEnforced: widget?.maxLengthEnforced ?? false,
        maxLines: widget?.numberOfLines,
        maxLength: (widget?.showCounter ?? false)
            ? widget?.maxLength
            : null, // if we want counter use default behavior
        onChanged: _handleOnChanged,
        onSubmitted: _onFieldSubmitted,
        inputFormatters: widget?.inputFormatters ??
            [
              // if we don't want the counter, use this maxLength instead
              LengthLimitingTextInputFormatter(widget?.maxLength)
            ],
      ),
    );
  }
}
