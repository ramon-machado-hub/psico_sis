import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class DropWidget extends StatefulWidget {
  final List<DropdownMenuItem<String>> list;

  const DropWidget({Key? key, required this.list}) : super(key: key);

  @override
  State<DropWidget> createState() => _DropWidgetState();
}

class _DropWidgetState extends State<DropWidget> {

  @override
  Widget build(BuildContext context) {
    String valueDrop = widget.list.first.value.toString();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.labelWhite),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButton<String>(
          value: valueDrop,
          icon: const Icon(
              Icons.arrow_drop_down_sharp),
          elevation: 16,
          style: TextStyle(
              color: AppColors.labelBlack),
          underline: Container(
            height: 2,
            color: AppColors.line,
          ),
          onChanged: (String? newValue) {

            setState(() {
              valueDrop = newValue!;
              print(newValue);
              print(valueDrop);
            });
          },
          items: widget.list,
        ),
      ),
    );
  }
}
