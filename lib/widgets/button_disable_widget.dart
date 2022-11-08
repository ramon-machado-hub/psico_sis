import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class ButtonDisableWidget extends StatefulWidget {
  final bool isButtonDisabled;
  final String label;
  final double width;
  final double height;
  final VoidCallback onTap;
  const ButtonDisableWidget({
    Key? key,
    required this.isButtonDisabled,
    required this.onTap,
    required this.label,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<ButtonDisableWidget> createState() => _ButtonDisableWidgetState();
}

class _ButtonDisableWidgetState extends State<ButtonDisableWidget> {
  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.primaryColor,
        onPrimary: Colors.white,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        minimumSize: Size(widget.width, widget.height), //////// HERE
      ),
      onPressed: widget.isButtonDisabled ? null : widget.onTap,
      child: Text( widget.label,
        style: AppTextStyles.labelBold16,),
    );
  }
}
