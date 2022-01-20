import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  String hint;
  String label;
  String initialValue;
  TextInputType type;
  TextEditingController textEditingController;
  List<TextInputFormatter> inputFormatter;
  bool readOnly;
  Function validator;
  ValueChanged onChanged;
  Icon icon;
  bool obscureText;
  Function onTap;
  var hintStyle;

  CustomTextField(
      {this.icon,
      this.hint,
      this.initialValue,
      this.inputFormatter,
      this.onChanged,
      this.readOnly,
      this.textEditingController,
      this.hintStyle,
      this.type,
      this.validator,
      this.label,
      this.onTap,
      this.obscureText});
  bool readOnlyDefault = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextFormField(
      onTap: onTap,
      obscureText: obscureText,
      validator: validator,
      readOnly: readOnly == null
          ? readOnlyDefault
          : readOnly
              ? readOnly
              : readOnlyDefault,
      initialValue: initialValue,
      inputFormatters: inputFormatter,
      onChanged: onChanged,
      controller: textEditingController,
      keyboardType: type,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        suffixIcon: icon,
        labelText: label,
        labelStyle: theme.textTheme.headline5,
        hintText: hint,
        hintStyle: hintStyle,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: theme.primaryColorDark),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: theme.primaryColorDark)),
      ),
    );
  }
}
