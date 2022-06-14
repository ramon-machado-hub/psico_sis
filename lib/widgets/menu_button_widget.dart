import 'package:flutter/cupertino.dart';
import 'package:psico_sis/themes/app_colors.dart';

class MenuButtonWidget extends StatefulWidget {

  final double height;
  final double width;
  const MenuButtonWidget({Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  State<MenuButtonWidget> createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
    );
  }
}
