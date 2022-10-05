import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextLowerWidget extends StatefulWidget {

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

  const InputTextLowerWidget({
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
  State<InputTextLowerWidget> createState() => _InputTextLowerWidgetState();
}

class _InputTextLowerWidgetState extends State<InputTextLowerWidget> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 30,right: 30),
      child: TextFormField(

        inputFormatters: [
          LowerCaseTextFormatter(),
        ],
        enableSuggestions: false,
        autocorrect: false,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        initialValue: widget.initalValue,
        validator: widget.validator,
        onChanged: widget.onChanged,
        // style: AppTextStyles.labelBlack12,

        decoration: InputDecoration(
            fillColor: widget.backgroundColor,
            filled: true,
            // contentPadding: EdgeInsets.zero,
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

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}