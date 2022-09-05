import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../themes/app_text_styles.dart';

class MenuIconLabelButtonWidget extends StatefulWidget {
  final String label;
  final double height;
  final double width;
  final IconData iconData;
  final VoidCallback onTap;

  const MenuIconLabelButtonWidget({Key? key,
    required this.label,
    required this.height,
    required this.width,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MenuIconLabelButtonWidget> createState() => _MenuIconLabelButtonWidgetState();
}

class _MenuIconLabelButtonWidgetState extends State<MenuIconLabelButtonWidget> {
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
          SizedBox(
            height: widget.height*0.3,
            width: widget.width,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(widget.label, style: AppTextStyles.labelBold16,)),
          )
        ],
    );
  }
}
