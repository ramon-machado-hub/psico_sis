import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';

import '../widgets/button_widget.dart';

class Parceiro extends StatefulWidget {
  const Parceiro({Key? key}) : super(key: key);

  @override
  State<Parceiro> createState() => _ParceiroState();
}

class _ParceiroState extends State<Parceiro> {
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
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "Cadastrar Parceiro",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/cadastro_parceiro");
                },
              ),
            ],
          ),
        ));
  }
}
