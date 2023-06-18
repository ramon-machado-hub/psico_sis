import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextWidget3 extends StatefulWidget {

  final bool obscureText;
  final String label;
  final Color backgroundColor;
  final double height;
  final Color borderColor;
  final Color iconColor;
  final String? initalValue;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final TextStyle textStyle;

  const InputTextWidget3({
    Key? key,
    required this.label,
    required this.height,
    // required this.maxLines,
    required this.keyboardType,
    required this.obscureText,
    required this.backgroundColor,
    required this.borderColor,
    required this.textStyle,
    required this.iconColor,
    this.onChanged,
    this.initalValue,
    this.validator,
    this.controller}) : super(key: key);

  @override
  State<InputTextWidget3> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget3> {
  @override
  Widget build(BuildContext context) {

    return
      Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 30, left: 30,right: 30),
        child:
        TextFormField(
          // maxLines: (widget.maxLines==1)?1:widget.height ~/ widget.maxLines ,
          enableSuggestions: false,
          autocorrect: false,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          initialValue: widget.initalValue,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              fillColor: widget.backgroundColor,
              filled: true,
              labelText: widget.label,
              labelStyle: widget.textStyle,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              border: InputBorder.none),
        ),

    );
  }
}
