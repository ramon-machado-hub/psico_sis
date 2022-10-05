import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class DropDownWidget extends StatefulWidget {
  final List<String> list;
  final String valueDrop1;
  final void Function(String? value)? onChanged;
  const DropDownWidget({Key? key, required this.list, required this.valueDrop1, this.onChanged}) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.secondaryColor),
      child: Center(
        child: DropdownButton<String>(
          value: widget.valueDrop1,
          icon: const Icon(
              Icons.arrow_drop_down_sharp),
          elevation: 16,
          style: TextStyle(
              color: AppColors.labelBlack),
          underline: Container(
            height: 2,
            color: AppColors.line,
          ),
          onChanged: widget.onChanged,
          // onChanged: (String? newValue) {
          //   setState(() {
          //     print(valueDrop);
          //     valueDrop = newValue!;
          //     print(valueDrop);
          //   });
          // },
          items: widget.list.map<DropdownMenuItem<String>>(
                  (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text("$value %"),
                );
              }).toList(),
        ),
      ),
    );
  }
}
