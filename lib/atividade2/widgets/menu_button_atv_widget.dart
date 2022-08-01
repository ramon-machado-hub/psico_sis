import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_text_styles.dart';

import '../../themes/app_colors.dart';

class MenuButtonAtvWidget extends StatefulWidget {
  final String label;
  final double height;
  final double width;
  final IconData icon;
  final VoidCallback onTap;

  const MenuButtonAtvWidget({Key? key, required this.label, required this.height, required this.width, required this.icon, required this.onTap}) : super(key: key);

  @override
  State<MenuButtonAtvWidget> createState() => _MenuButtonAtvWidgetState();
}

class _MenuButtonAtvWidgetState extends State<MenuButtonAtvWidget> {
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
              ),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(widget.icon)
                    // Image.asset(widget.image),
                  )),
            ),
          ),
          Text(widget.label, style: AppTextStyles.labelBlack16,)
        ],
      );
    }
  }
