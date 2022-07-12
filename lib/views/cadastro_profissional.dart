import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';

class CadastroProfissional extends StatefulWidget {
  const CadastroProfissional({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional> createState() => _CadastroProfissionalState();
}

class _CadastroProfissionalState extends State<CadastroProfissional> {
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "CADASTRO PROFISSIONAL",
                style: AppTextStyles.labelBold16,
              ),
              //contagem passos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: size.width * 0.45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.shape),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text("1", style: AppTextStyles.subTitleWhite14),
                          ),
                        ),
                        Expanded(child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding:  EdgeInsets.only(left: 6.0, right: 6.0),
                          child:  CircleAvatar(
                            backgroundColor: AppColors.line,
                            child: Text("2"),
                          ),
                        ),
                        Expanded(child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.line,
                            child: Text("3"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              //container informações cadastro
              Container(
                width: size.width * 0.45,
                height: size.height * 0.6,
                decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: AppColors.line,
                        width: 1,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.shape),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8,),
                    InputTextWidget(
                      label: "NOME",
                      icon: Icons.perm_contact_cal_sharp,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                    InputTextWidget(
                      label: "CPF",
                      icon: Icons.badge_outlined,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                    InputTextWidget(
                      label: "ENDEREÇO",
                      icon: Icons.location_on_outlined ,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                    InputTextWidget(
                      label: "TELEFONE",
                      icon: Icons.local_phone,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                    InputTextWidget(
                      label: "DATA DE NASCIMENTO",
                      icon: Icons.date_range_rounded ,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira um texto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle:  AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,),
                  ],

                ),
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "AVANÇAR",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/cadastro_profissional2");
                },
              ),
            ],
          ),
        ));
  }
}
