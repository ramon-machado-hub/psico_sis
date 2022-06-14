import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.labelWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Olá"),
                    Text("Anne Vasconcelos"),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 60,
                height: 60,
                color: AppColors.labelWhite,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  height: 80,
                  width: 60,
                  alignment: Alignment.bottomRight,
                  child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "Sair",
                        textAlign: TextAlign.end,
                      ))),
            ),
          ],
        ));
  }
}
