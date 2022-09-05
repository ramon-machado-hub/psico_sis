import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../themes/app_text_styles.dart';

class MenuIconButtonWidget extends StatefulWidget {
  final String label;
  final double height;
  final double width;
  final IconData iconData;
  final VoidCallback onTap;

  const MenuIconButtonWidget({Key? key,
    required this.label,
    required this.height,
    required this.width,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MenuIconButtonWidget> createState() => _MenuIconButtonWidgetState();
}

class _MenuIconButtonWidgetState extends State<MenuIconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [

          InkWell(
            onTap: widget.onTap,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
                boxShadow: kElevationToShadow[4],
              ),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                   child: Icon(widget.iconData),
                    // child: Image.asset(widget.image),
                  )),
            ),
          ),
          FittedBox(
              fit: BoxFit.contain,
              child: Text(widget.label, style: AppTextStyles.labelBold16,))
        ],
    );
  }
}
