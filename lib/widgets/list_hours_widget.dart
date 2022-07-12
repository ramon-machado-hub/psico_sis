import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class ListHoursWidget extends StatefulWidget {
  final String hour;

  const ListHoursWidget({Key? key, required this.hour}) : super(key: key);

  @override
  State<ListHoursWidget> createState() => _ListHoursWidgetState();
}

class _ListHoursWidgetState extends State<ListHoursWidget> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        selected = !selected;
        setState(() {});
      },
      child: Container(
          decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  color: AppColors.line,
                  width: 1,
                ),
              ),
              borderRadius: BorderRadius.circular(5),
              color: selected ? AppColors.red : AppColors.green),
          child: Center(child: FittedBox(
              fit: BoxFit.contain,
              child: Text(widget.hour,style: AppTextStyles.labelClock22,)))),
    );
  }
}
