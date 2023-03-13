import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class ButtonIconWidget extends StatefulWidget {
  final String label;
  final double width;
  final double height;
  final VoidCallback onTap;
  final Color colorButton;
  final TextStyle textStyle;
  final IconData iconData;


  const ButtonIconWidget({
    Key? key,
    required this.onTap,
    required this.label,
    required this.width,
    required this.height,
    required this.colorButton,
    required this.textStyle,
    required this.iconData,
  }) : super(key: key);

  @override
  State<ButtonIconWidget> createState() => _ButtonIconWidgetState();
}

class _ButtonIconWidgetState extends State<ButtonIconWidget> {
  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.primaryColor,
        onPrimary: widget.colorButton,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        minimumSize: Size(widget.width, widget.height), //////// HERE
      ),
      onPressed: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(widget.iconData),
            Text( widget.label,
              style: widget.textStyle,),
          ],
        ),
      ),
    );
  }
}
