import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';

class CadastroProfissional3 extends StatefulWidget {
  const CadastroProfissional3({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional3> createState() => _CadastroProfissional3State();
}

class _CadastroProfissional3State extends State<CadastroProfissional3> {
  List<String> Servicos = [];
  String dropdownTpConsulta = 'CONSULTA AVALIATIVA';
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
                            backgroundColor: Colors.blue.withOpacity(0.5),
                            child:
                                Text("1", style: AppTextStyles.subTitleWhite14),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.5),
                              child: Text("2",
                                  style: AppTextStyles.subTitleWhite14)),
                        ),
                        Expanded(
                            child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text("3", style: AppTextStyles.subTitleWhite14,),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Adicione os serviços ofertados: "),

                    //Tipo Consulta / PREÇO / ADD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: size.width * 0.05,
                          width: size.width * 0.15,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.secondaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DropdownButton<String>(
                                    value: dropdownTpConsulta,
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
                                        dropdownTpConsulta = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'CONSULTA AVALIATIVA',
                                      'CONSULTA ÚNICA',
                                      'PACOTE 4 SESSÕES',
                                      'TERAPIA DE CASAL',
                                    ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: size.width * 0.05,
                          width: size.width * 0.2,
                          child: Center(
                            child: InputTextWidget(
                              label: "VALOR",
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
                              iconColor: AppColors.labelBlack,
                            ),
                          ),
                        ),
                        MaterialButton(
                          // height: 10,
                          onPressed: () {

                          },
                          color: AppColors.primaryColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(10),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add,
                            size: 22,
                          ),
                        )
                      ],
                    ),

                    Container(
                      width: size.width * 0.35,
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.blue
                      ),
                    )






                  ],
                ),
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "AVANÇAR",
                onTap: () {
                  // Dialogs.AlertDialogProfissional(context);
                  // Navigator.pushReplacementNamed(context, "/home_assistente");
                },
              ),
            ],
          ),
        ));
  }
}
