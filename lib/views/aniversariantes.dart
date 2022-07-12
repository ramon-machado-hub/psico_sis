import 'package:flutter/material.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';

import '../themes/app_colors.dart';
import '../widgets/button_widget.dart';

class Aniversariantes extends StatefulWidget {
  const Aniversariantes({Key? key}) : super(key: key);

  @override
  State<Aniversariantes> createState() => _AniversariantesState();
}

class _AniversariantesState extends State<Aniversariantes> {
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width * 0.45,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.06,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.labelWhite,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.secondaryColor),
                        child: Center(child: Text("Do dia")),
                      ),
                      Container(
                        width: size.width * 0.06,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.labelWhite,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.line),
                        child: Center(child: Text("Da semana")),
                      ),
                      Container(
                        width: size.width * 0.06,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.labelWhite,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.line),
                        child: Center(child: Text("Do mês")),
                      ),
                    ],
                  ),
                ),
                Center(
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

              ],
            ),
          ));
    }
  }
