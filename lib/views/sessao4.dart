import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/arguments/sessao4_arguments.dart';
import '../model/sessao.dart';
import '../model/servico.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';

class Sessao4 extends StatefulWidget {
  final Sessao4Arguments arguments;
  const  Sessao4({Key? key, required this.arguments}) : super(key: key);

  @override
  State< Sessao4> createState() => _Sessao4State();
}

class _Sessao4State extends State<Sessao4> {


  late List<Sessao> _lSessoes = [];
  late List<Servico> _lServicos = [];

  Future<void> ReadJsonDataServico() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/servicos_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lServicos = list.map((e) => Servico.fromJson(e)).toList();
      _lServicos.forEach((element) {
        if (element.id==widget.arguments.servicoProfissional.idServico){
        }
      });
    });
  }

  Future<void> ReadJsonDataSessoes() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/consultas_json.json');

    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lSessoes = list.map((e) => Sessao.fromJson(e)).toList();
      print("_lSessoes ${_lSessoes.length}");
    });
  }




  String getDescServicoById(int? id) {
    String value = "ID Serviço não encontrado";
    print("${_lServicos.length} getDescServicoById");
    _lServicos.forEach((element) {
      if (element.id == id) {
        value = element.descricao.toString();
      }
    });
    return value;
  }

  @override
  void initState() {
    super.initState();
    ReadJsonDataSessoes();
    ReadJsonDataServico();
  }

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
                          padding: const EdgeInsets.only(left: 6.0, right: 6.0),
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
                          padding:  const EdgeInsets.only(left: 6.0, right: 6.0),
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
                          padding: const EdgeInsets.only(left: 6.0, right: 6.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.32,
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
                    //Informações da consulta
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //Serviço
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tipo de Serviço: "),
                                  // Text(getDescServicoById(
                                  //     widget.arguments.servicoProfissional.idServico),
                                  //   style: AppTextStyles.labelBold16,),
                                ],
                              ),
                            )
                          ],
                        ),

                        //profissional
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Profissional:"),
                                  Text("${widget.arguments.profissional.nome}", style: AppTextStyles.labelBold16,),
                                ],
                              ),
                            )
                          ],
                        ),

                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text("Pacientes:"),
                            ),
                          ],
                        ),
                        // Pacientes
                        for (int i =0;i<widget.arguments.pacientes.length; i++)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${i+1} - ${widget.arguments.pacientes[i].nome}", style: AppTextStyles.labelBold16,),
                                  ],
                                ),
                              )
                            ],
                          ),

                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text("Sessões:"),
                            ),
                          ],
                        ),
                        //Sessões
                        for (int i =0; i<widget.arguments.sessoes.length; i++)
                          Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: size.height*0.03,
                                        width: size.width * 0.12,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(widget.arguments.sessoes[i], style: AppTextStyles.labelBlack16Lex,)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height*0.04,
                                        width: size.width * 0.06,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(widget.arguments.HorariosSessoes[i], style: AppTextStyles.labelBlack12Lex,)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height*0.04,
                                        width: size.width * 0.06,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(widget.arguments.datasSessoes[i], style: AppTextStyles.labelBlack12Lex,textAlign: TextAlign.right,)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height*0.04,
                                        width: size.width * 0.05,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text("${widget.arguments.valorSessoes[i].toString()},00", style: AppTextStyles.labelBlack12Lex,textAlign: TextAlign.right,)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        //total
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("VALOR TOTAL:"),
                                  Text("RS ${widget.arguments.servicoProfissional.valor},00", style: AppTextStyles.labelBold16,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Forma de Pagamento: "),
                                  Text("${widget.arguments.tipoPagamento}", style: AppTextStyles.labelBold16,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //tipo de pagamento
                        Row(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Desconto Parceiro:"),
                                  if (widget.arguments.parceiro!=null)
                                    Text("${widget.arguments.parceiro?.razaoSocial}", style: AppTextStyles.labelBold16,)
                                  else
                                    Text("NÃO POSSUI", style: AppTextStyles.labelBold16,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tipo Sessão: "),
                                  Text("SESSÃO PRESENCIAL", style: AppTextStyles.labelBold16,),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Row(
                        //   children: [
                        //
                        //   ],
                        // ),







                      ],
                    ),
                  ),
                  SizedBox(width: size.width * 0.06,),
                  Container(
                    width: size.width * 0.22,
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
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "CONFIRMAR",
                onTap: () async {
                  // print(_localPath);
                  // await SalvarSessaoJson(widget.arguments.datasSessoes[0],
                  //     widget.arguments.HorariosSessoes[0],
                  //     widget.arguments.valorSessoes[0].toInt(),
                  //     "PRESENCIAL", widget.arguments.sessoes[0],
                  //     widget.arguments.profissional.id!, "SALA 1", "PENDENTE");
                  print("salvouUUUU");
                  // showAlertDialog(context);
                  Navigator.pushReplacementNamed(context, "/sessao");
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