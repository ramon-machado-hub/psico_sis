import 'package:flutter/material.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';

import '../themes/app_colors.dart';
import '../widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarWidget(),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 2.5,
              colors: [
                AppColors.shape,
                AppColors.primaryColor,
              ],
            )),
        child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.labelWhite,
                borderRadius: BorderRadius.circular(25),
              ),
              width: size.width*0.8,
              height: size.height*0.7,
              child: Wrap(
                runAlignment: WrapAlignment.center,
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceEvenly,
                spacing: size.width*0.03,
                runSpacing: 30,
                children: [
                   MenuButtonWidget(height: size.width*0.1, width: size.width*0.1),
                   MenuButtonWidget(height: size.width*0.1, width: size.width*0.1)
                ],
              ),
            )), // child: Container(
      ),
    );
  }
}
