import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class ButtonColorIconDisableWidget extends StatefulWidget {
  final bool isButtonDisabled;
  final String label;
  final Color color;
  final IconData iconData;
  final double width;
  final double height;
  final VoidCallback onTap;
  const ButtonColorIconDisableWidget({
    Key? key,
    required this.isButtonDisabled,
    required this.onTap,
    required this.iconData,
    required this.color,
    required this.label,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<ButtonColorIconDisableWidget> createState() => _ButtonColorIconDisableWidgetState();
}

class _ButtonColorIconDisableWidgetState extends State<ButtonColorIconDisableWidget> {
  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: widget.color,
        onPrimary: Colors.white,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        minimumSize: Size(widget.width, widget.height), //////// HERE
      ),
      onPressed: widget.isButtonDisabled ? null : widget.onTap,
      child: Column(
                children: [
                  // Expanded(child:
                  Icon(widget.iconData,
                    color: AppColors.labelBlack,
                    size: widget.height*0.7,
                  ),
      // ,),
                  Text( widget.label,
                    style: AppTextStyles.labelBold16,),
                ],
      ),


    );
  }
}
