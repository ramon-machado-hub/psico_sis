import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextWidget extends StatefulWidget {

  final bool obscureText;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final String? initalValue;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final TextStyle textStyle;

  const InputTextWidget({
    Key? key,
    required this.label,
    required this.icon,
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
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 30,right: 30),
      child: TextFormField(
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
            icon: Icon(
              widget.icon,
              color: widget.iconColor,
            ),
            border: InputBorder.none),
      ),

    );
  }
}
