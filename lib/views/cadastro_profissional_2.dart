import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';

class CadastroProfissional2 extends StatefulWidget {
  const CadastroProfissional2({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional2> createState() => _CadastroProfissional2State();
}

class _CadastroProfissional2State extends State<CadastroProfissional2> {
  String dropdownEspecialidade = 'NUTRIÇÃO';
  List<bool> listDias = [false,false,false,false,false,false,];

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
                              backgroundColor: Colors.blue,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

//Drop Especialidade
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Tipo Consulta
                        Text(
                          "Especialidade",
                          style: AppTextStyles.subTitleBlack14,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.secondaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton<String>(
                              value: dropdownEspecialidade,
                              icon: const Icon(Icons.arrow_drop_down_sharp),
                              elevation: 16,
                              style: TextStyle(color: AppColors.labelBlack),
                              underline: Container(
                                height: 2,
                                color: AppColors.line,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownEspecialidade = newValue!;
                                });
                              },
                              items: <String>[
                                'NUTRIÇÃO',
                                'PSICOLOGIA',
                                'PSICO PEDAGOGIA',
                                'FONO AUDIOLOGOGIA',
                              ].map<DropdownMenuItem<String>>((String value) {
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

                    InputTextWidget(
                      label: "CÓDIGO CRM",
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
                      textStyle: AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,
                    ),


                    //Dias trabalhados
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: (){
                            listDias[0]=true;
                            Dialogs.AlertHorasTrabalhadas(context, "Segunda");
                            setState(() { });

                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: listDias[0] ?  AppColors.line : AppColors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Segunda")),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            listDias[1]=true;
                            Dialogs.AlertHorasTrabalhadas(context, "Terça");
                            setState(() { });
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: listDias[1] ?  AppColors.line : AppColors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Terça")),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            listDias[2]=true;
                            Dialogs.AlertHorasTrabalhadas(context, "Quarta");
                            setState(() { });
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: listDias[2] ?  AppColors.line : AppColors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Quarta")),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            listDias[3]=true;
                            Dialogs.AlertHorasTrabalhadas(context, "Quinta");
                            setState(() { });
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: listDias[3] ?  AppColors.line : AppColors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Quinta")),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            listDias[4]=true;
                            Dialogs.AlertHorasTrabalhadas(context, "Sexta");
                            setState(() { });
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: listDias[4] ?  AppColors.line : AppColors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Sexta")),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            listDias[5]=true;
                            Dialogs.AlertHorasTrabalhadas(context, "Sábado");
                            setState(() { });
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: listDias[5] ?  AppColors.line : AppColors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Sábado")),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "AVANÇAR",
                onTap: () {
                  // Dialogs.AlertDialogProfissional(context);
                  Navigator.pushReplacementNamed(context, "/cadastro_profissional3");
                },
              ),
            ],
          ),
        ));
  }
}
