import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../widgets/app_bar_widget.dart';

class Caixa extends StatefulWidget {
  const Caixa({Key? key}) : super(key: key);

  @override
  State<Caixa> createState() => _CaixaState();
}

class _CaixaState extends State<Caixa> {
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
                radius: 2.0,
                colors: [
                  AppColors.shape,
                  AppColors.primaryColor,
                ],
              )),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    width: size.width * 0.45,
                    height: size.height * 0.7,
                    decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.line,
                            width: 1,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.shape),

                  ),
                ),
              ),

            ],
          ),
        ));
  }
}
