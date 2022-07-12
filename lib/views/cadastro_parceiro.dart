import 'package:flutter/material.dart';
import 'package:psico_sis/widgets/drop_down_widget.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';

class CadastroParceiro extends StatefulWidget {
  const CadastroParceiro({Key? key}) : super(key: key);

  @override
  State<CadastroParceiro> createState() => _CadastroParceiroState();
}

class _CadastroParceiroState extends State<CadastroParceiro> {
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Text(
                            "CADASTRO PARCEIRO",
                            style: AppTextStyles.labelBold16,
                          ),
                        ),
                        InputTextWidget(
                          label: "RAZÃO SOCIAL",
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
                          label: "CNPJ",
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

                        Column(
                          children: const [
                            Text("Desconto"),
                            DropDownWidget(list: ["10%","20%","30%","40%"]),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "Cadastrar",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/home_assistente");
                },
              ),
            ],
          ),
        ));
  }
}
