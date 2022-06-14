import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

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
      padding: const EdgeInsets.only(bottom: 16, left: 60,right: 60),
      child: Column(
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.shape,
          ),
          TextFormField(
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
                contentPadding: EdgeInsets.zero,
                labelText: widget.label,
                labelStyle: widget.textStyle,
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: AppColors.shape,
                    )
                  ],
                ),
                border: InputBorder.none),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.shape,
          )
        ],
      ),

    );
  }
}
