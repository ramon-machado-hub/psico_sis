import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_text_styles.dart';

class MenuButtonWidget extends StatefulWidget {
  final String label;
  final double height;
  final double width;
  final String image;
  final VoidCallback onTap;

  const MenuButtonWidget({Key? key,
    required this.label,
    required this.height,
    required this.width,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MenuButtonWidget> createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget> {
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
                    padding: const EdgeInsets.all(50.0),
                    child: Image.asset(widget.image),
                  )),
            ),
          ),
          FittedBox(
              fit: BoxFit.contain,
              child: Text(widget.label, style: AppTextStyles.labelBold16,)

          )
        ],
    );
  }
}
