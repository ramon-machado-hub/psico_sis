import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';

class ConfirmarConsulta extends StatefulWidget {
  const  ConfirmarConsulta({Key? key}) : super(key: key);

  @override
  State< ConfirmarConsulta> createState() => _ConfirmarConsultaState();
}

class _ConfirmarConsultaState extends State<ConfirmarConsulta> {
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
              const SizedBox(
                height: 20,
              ),
              //container com indicadores dos passos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.shape),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.5),
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
                            backgroundColor: Colors.blue.withOpacity(0.5),
                            child: Text("2", style: AppTextStyles.subTitleWhite14),
                          ),
                        ),
                        Expanded(child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text("3",style: AppTextStyles.subTitleWhite14),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.2,
                height: size.height * 0.55,
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
                    //Informações da consulta
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tipo de consulta: "),
                              Text("CONSULTA AVALIATIVA", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Data:"),
                              Text("18/07/2022 - segunda feira", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Profissional:"),
                              Text("ANNE VASCONCELOS", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Paciente:"),
                              Text("ANDRÉ SILVA NASCIMENTO", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Desconto Parceiro:"),
                              Text("NÃO POSSUI", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Forma de Pagamento:"),
                              Text("A VISTA (DINHEIRO)", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),



                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("VALOR TOTAL:"),
                              Text("RS 150,00", style: AppTextStyles.labelBold16,),
                            ],
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "CONFIRMAR",
                onTap: () {
                  showAlertDialog(context);
                  // Navigator.pushReplacementNamed(context, "/confirmar_consulta");
                },
              ),
            ],
          ),
        ));
  }
}

showAlertDialog(BuildContext context,){
  showDialog(
      context: context,
      builder:(BuildContext context) {
        return  AlertDialog(
          title:  Text("Deseja Confirmar o agendamento?"),
          actions: [
            ElevatedButton(
              child: Text("SIM"),
              onPressed: (){
                showAlertDialog2(context);
              },
            ),
            ElevatedButton(
              child: Text("NÃO"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },);
}

showAlertDialog2(BuildContext context,){
  showDialog(
    context: context,
    builder:(BuildContext context) {
      return  AlertDialog(
        title:  Text("Agendamento confirmado com sucesso!"),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/home_assistente");
            },
          ),

        ],
      );
    },);
}