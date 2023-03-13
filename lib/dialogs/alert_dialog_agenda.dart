import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_paciente.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/model/tipo_pagamento.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/servico_profissional_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/widgets/button_disable_widget.dart';
import 'package:psico_sis/widgets/button_widget.dart';

import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/comissao.dart';
import '../model/dias_profissional.dart';
import '../model/sessao.dart';
import '../provider/comissao_provider.dart';
import '../provider/dias_profissional_provider.dart';
import '../provider/servico_provider.dart';
import '../provider/tipo_pagamento_provider.dart';
import '../provider/transacao_provider.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/input_text_widget_mask.dart';

class DialogsAgendaAssistente {

  static int GetDiferenceDays(String data1, String data2){
    int dia1, dia2=0;
    int mes1, mes2=0;
    int ano1,ano2=0;
    dia1 = int.parse(data1.substring(0,2));
    dia2 = int.parse(data2.substring(0,2));
    mes1 = int.parse(data1.substring(3,5));
    mes2 = int.parse(data2.substring(3,5));
    ano1 = int.parse(data1.substring(6,10));
    ano2 = int.parse(data2.substring(6,10));
    final data = DateTime(ano2,mes2,dia2).difference(DateTime(ano1,mes1,dia1));
    print(data.inDays.toString()+" diferença");
    return data.inDays;
  }

  static Future<void> AlertDialogReagendamento2(
      parentContext, String uid, List<Sessao> sessao,Sessao sessaoReagendar,
      Sessao sessaoFinal,
      // List<Sessao> sessoesFinal,
      Paciente paciente, Profissional profissional,
      List<DiasProfissional> diasProfissional, List<DiasSalasProfissionais> diasSalasProfissional,
      List<String> datas, List<String> horarios, int diferenca )
  {

    int getDiferencaDias(String data1, String data2){
      // sessaoFinal.dataSessao
      int dia1, dia2=0;
      int mes1, mes2=0;
      int ano1,ano2=0;
      dia1 = int.parse(data1.substring(0,2));
      dia2 = int.parse(data2.substring(0,2));
      mes1 = int.parse(data1.substring(3,5));
      mes2 = int.parse(data2.substring(3,5));
      ano1 = int.parse(data1.substring(6,10));
      ano2 = int.parse(data2.substring(6,10));
      print("qqqq");
      print(dia1);
      print(dia2);
      print(mes1);
      print(mes2);
      print(ano1);
      print(ano2);
      final data = DateTime(ano2,mes2,dia2).difference(DateTime(ano1,mes1,dia1));
      print(data.inDays.toString()+" diferença");
      return data.inDays;
    }

    return showDialog(
        context: parentContext,
        useRootNavigator: false,
        builder: (BuildContext dialogContext){
          // int diferenca = getDiferencaDias(sessaoReagendar.dataSessao!, sessao[1].dataSessao!);
      return  AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {

              print(sessao.length);
              print(datas.length);
              print(horarios.length);

              return DetalhesReagendamento(
                datas: datas, horarios: horarios,sessoes: sessao,
                // sessaoFinal: sessaoReagendar, sessoesFinal: sessoesFinal,
                paciente: paciente, profissional: profissional, sessao: sessaoReagendar,diferenca: diferenca,);
            }),
      );}
    );
  }


  // Reagendamento
  static Future<void> AlertDialogReagendamento (
  parentContext, String uid, List<Sessao> sessao,Sessao
      sessaoReagendar, Paciente paciente,
      Profissional profissional,
      List<DiasProfissional> diasProfissional, List<DiasSalasProfissionais> diasSalasProfissional,) {

    List<String> dias = [
      "DOMINGO",
      "SEGUNDA",
      "TERÇA",
      "QUARTA",
      "QUINTA",
      "SEXTA",
      "SÁBADO"
    ];
    List<Sessao> sessoesProfissional = [];
    List<DiasSalasProfissionais> horariosDoDia = [];
    late DateTime _dataSelecionada = DateTime.now();
    late String novoHorario = "";
    late String novaData = "";
    late bool _selectData = false;
    late bool _selectReagendamento = false;
    late DateTime dataAtual = DateTime.now();
    late int mesAtual = DateTime
        .now()
        .month;
    late int anoAtual = DateTime
        .now()
        .year;

    Future<void> getSessoesProfissional(String data, String idProfissional)async{
      print("getSessoes");
      await Provider.of<SessaoProvider>(parentContext, listen:false).getListSessoesDoDiaByProfissional(
          data, idProfissional).then((value) {
        sessoesProfissional = value;
        print("sessoesProfissional ${sessoesProfissional.length}");
      });
    }

    String getMes(int mes){
      switch(mes){
        case 1:
          return "JANEIRO";
        case 2:
          return "FEVEREIRO";
        case 3:
          return "MARÇO";
        case 4:
          return "ABRIL";
        case 5:
          return "MAIO";
        case 6:
          return "JUNHO";
        case 7:
          return "JULHO";
        case 8:
          return "AGOSTO";
        case 9:
          return "SETEMBRO";
        case 10:
          return "OUTUBRO";
        case 11:
          return "NOVEMBRO";
        case 12:
          return "DEZEMBRO";
      }
      return "";
    }
    int getIndex(String dia){
      switch (dia) {
        case 'Segunda':
          {
            return 1;
          }
        case 'Terça':
          {
            return 2;
          }
        case 'Quarta':
          {
            return 3;
          }
        case 'Quinta':
          {
            return 4;
          }
        case 'Sexta':
          {
            return 5;
          }
        case 'Sábado':
          {
            return 6;
          }
        case 'Domingo':
          {
            return 0;
          }
      }
      return 7;
    }

    bool getDataValida(DateTime data){
      DateTime hoje = DateTime.now();
      if (data.year>hoje.year) {
        return true;
      } else{
        if (data.month>hoje.month) {
          return true;
        } else{
          if ((data.month==hoje.month)&&(data.day>=hoje.day)){
            return true;
          }
        }
      }
      print(data.month.toString()+" "+hoje.month.toString());
      print(data.day.toString()+" "+hoje.day.toString());
      print("---");
      return false;
    }

    String getDiaSemana(DateTime data) {
      String dia = DateFormat('EEEE').format(data);
      switch (dia) {
        case 'Monday':
          {
            return "Segunda";
          }
        case 'Tuesday':
          {
            return "Terça";
          }
        case 'Wednesday':
          {
            return "Quarta";
          }
        case 'Thursday':
          {
            return "Quinta";
          }
        case 'Friday':
          {
            return "Sexta";
          }
        case 'Saturday':
          {
            return "Sábado";
          }
        case 'Sunday':
          {
            return "Domingo";
          }
      }
      return "";
    }



    DateTime getDayIn(DateTime date){
      String diaSemana = getDiaSemana(date);
      int indexDia = getIndex(diaSemana);
      DateTime diaInicio = date.subtract(Duration(days: indexDia));
      return diaInicio;
    }

    bool contemAgendamento(String hora)  {
      print(_dataSelecionada);
      // getSessoesProfissional(UtilData.obterDataDDMMAAAA(_dataSelecionada),profissional.id1);
      print("Contém $hora");
      print(sessoesProfissional.length);
      bool result = false;

      if (sessoesProfissional.length==0){
        return false;
      } else{
        sessoesProfissional.forEach((element) {
          if (element.horarioSessao!.compareTo(hora)==0){
            result = true;
          }
        });
      }
      print(result);
      return result;
    }



    //Container com o calendário
    Widget selectDataSessao(contextData, Size size)  {
      late bool _select = false;
      List<String> dias = [
        "DOMINGO",
        "SEGUNDA",
        "TERÇA",
        "QUARTA",
        "QUINTA",
        "SEXTA",
        "SÁBADO"
      ];
      return StatefulBuilder(
          builder: (contextData, setState){
         //metodo que preenche os widgets do calendário
         List<Widget> listCalendario(double width,
                double heigth, DateTime dataAtual){
              List<String> diasProf = [];
              print("diasProfissional.length ${diasProfissional.length}");
              diasProfissional.forEach((element) {
                print(element.dia!);
                diasProf.add(element.dia!);
              });
              DateTime diaInicio = getDayIn(dataAtual);

          List<Widget> result = [];

          for (int j=0;j<6;j++) {
            for (int i = 0; i < 7; i++) {
              result.add(
                  (diasProf.contains(
                      getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)))
                          .toUpperCase())
                      && (getDataValida(diaInicio.add(Duration(days: (7 * j) + i))))
                  ) ?
                 InkWell(
                            onTap: () async{

                              print(_selectData);
                              print(horariosDoDia.length);
                              //adiciona horarios do dia do profissional
                              diasSalasProfissional.forEach((element) {
                                if (element.dia!.compareTo(getDiaSemana(
                                    diaInicio.add(Duration(days: (7 * j) + i))))==0){
                                  horariosDoDia.add(element);
                                }
                              });
                              print(horariosDoDia.length);

                              _dataSelecionada = diaInicio.add(Duration(days: (7 * j) + i));
                              novaData=UtilData.obterDataDDMMAAAA(_dataSelecionada);
                              await getSessoesProfissional(UtilData.obterDataDDMMAAAA(_dataSelecionada),profissional.id1);
                              _selectData=true;

                              setState((){
                              });
                              print(_selectData);
                              print(_dataSelecionada);
                              // await Provider.of<DiasSalasProfissionaisProvider>
                              //   (parentContext, listen: false).getHorariosDoDiaByProfissional
                              //   (profissional.id1,
                              //     getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)))
                              //         .toUpperCase())
                              //     .then((value) async {
                              // if (servicoSelecionado!.qtd_sessoes ==
                              //     _datasSelecionadas.length) {
                              //   showSnackBar("Sessões cadastradas.");
                              // } else {
                              //   diasSalasProfissional = value;
                              //   diasSalasProfissional.sort((a, b) =>
                              //       a.hora!.compareTo(b.hora!));
                              //   _dataSelecionada =
                              //       diaInicio.add(Duration(days: (7 * j) + i));
                              //   await Provider.of<SessaoProvider>(context, listen: false)
                              //       .getListSessoesDoDiaByProfissional(
                              //       UtilData.obterDataDDMMAAAA(_dataSelecionada),
                              //       profissionalSelecionado!.id1)
                              //       .then((value) {
                              //     sessoesProfissional = value;
                              //   });
                              //
                              // }
                              // });
                            },
                            child: Card(
                              child:
                              Container(
                                  height: heigth,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4.0)
                                  ),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: heigth/2,
                                        width: width,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(diaInicio
                                              .add(Duration(days: (7 * j) + i))
                                              .day
                                              .toString(),style: AppTextStyles.subTitleWhite16),
                                        ),
                                      ),
                                      SizedBox(
                                        height: heigth/2,
                                        width: width,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(getMes(diaInicio
                                              .add(Duration(days: (7 * j) + i))
                                              .month).substring(0, 3),style: AppTextStyles.subTitleWhite16),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          )
                      :
                  //card com o dia que o profissional não atua
                  Card(
                    child: Container(
                        height: heigth,
                        width: width,
                        decoration: BoxDecoration(
                            color: (getDataValida(
                                diaInicio.add(Duration(days: (7 * j) + i)))) ?
                            AppColors.labelWhite.withOpacity(0.6) : AppColors.line.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4.0)
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: heigth*0.4,
                                width: width*0.4,
                                child:
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(diaInicio
                                      .add(Duration(days: (7 * j) + i))
                                      .day
                                      .toString()),
                                )
                            ),
                            SizedBox(
                              height: heigth*0.4,
                              width: width*0.4,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(getMes(diaInicio
                                    .add(Duration(days: (7 * j) + i))
                                    .month).substring(0, 3)),
                              ),
                            )
                          ],
                        )
                    ),
                  )
              );
            }
          }
          return result;
        }

        //preenche widgets com os horarios...
        List<Widget> widgets = listCalendario(
            size.width * 0.035, size.height * 0.05, dataAtual);
        return  Container(
            height: size.height * 0.7,
            width: size.width * 0.3,
            color: AppColors.shape,
            child: Column(
              children: [
                Column(
                  children: [
                    //mes + icones 0.05
                    SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 4.0),
                              child: Text("${getMes(mesAtual)}/${anoAtual}"),

                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (anoAtual > DateTime.now().year) {
                                      if (mesAtual == 1) {
                                        mesAtual = 12;
                                        anoAtual--;
                                      } else {
                                        mesAtual--;
                                      }
                                    } else {
                                      if (mesAtual > DateTime.now().month) {
                                        mesAtual--;
                                      }
                                    }
                                    print(mesAtual);
                                    print(anoAtual);
                                    dataAtual = DateTime(anoAtual, mesAtual, 1);
                                    widgets = listCalendario(
                                        size.width * 0.035, size.height * 0.05,
                                        dataAtual);
                                    setState(() {});
                                  },
                                  child:Container(
                                    width: size.width*0.04,
                                    height: size.height*0.03,
                                    alignment: Alignment.center,
                                    // margin: EdgeInsets.all(100.0),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(
                                        size: size.height*0.03,
                                        Icons.arrow_left_outlined),
                                  ),),
                                InkWell(
                                  onTap: () {
                                    if (mesAtual == 12) {
                                      mesAtual = 1;
                                      anoAtual++;
                                    } else {
                                      mesAtual++;
                                    }
                                    print(mesAtual);
                                    print(anoAtual);
                                    dataAtual = DateTime(anoAtual, mesAtual, 1);
                                    widgets = listCalendario(
                                        size.width * 0.035, size.height * 0.05,
                                        dataAtual);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: size.width*0.04,
                                    height: size.height*0.03,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(
                                        size:  size.height*0.03,
                                        Icons.arrow_right_outlined),
                                  ),),

                              ],
                            )
                            // })
                          ],
                        )
                    ),
                    //Dias da semana 0.07
                    SizedBox(
                      height: size.height * 0.05,
                      width: size.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var items in dias)
                            Card(
                              elevation: 8,
                              color: AppColors.green,
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.035,
                                color: AppColors.secondaryColor,
                                child: Center(
                                  child: Text(items.substring(0, 3),
                                    style: AppTextStyles.labelBlack16Lex,),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    //calendário 0.4
                    SizedBox(
                        height: size.height * 0.4,
                        width: size.width * 0.3,
                        child: Column(
                            children: [
                              for (int j = 0; j < 6; j++)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    for (int i = 0; i < 7; i++)
                                      widgets[(j * 7) + i],
                                  ],)
                            ]
                        )
                    ),
                  ],
                ),


                //horários do dia selecionado
                (_selectData) ?
                SizedBox(
                    height: size.height * 0.2,
                    width: size.width * 0.3,
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 10),
                          child: Text("Data: ${UtilData.obterDataDDMMAAAA(
                              _dataSelecionada)}"),
                        ),
                        //horarios
                        Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            for(var itemsProf in diasSalasProfissional)
                              (contemAgendamento(itemsProf.hora!))?
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.045,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: AppColors.labelWhite,
                                      border: Border.all(color: AppColors.line)

                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: (size.height * 0.045)/2,
                                        width: size.width * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(itemsProf.hora!),
                                        ),
                                      ),
                                      SizedBox(
                                        height: (size.height * 0.045)/2,
                                        width: size.width * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text("OCUPADO",style: AppTextStyles.labelBold14,),
                                        ),
                                      ),
                                    ],
                                  )
                              )
                                  :
                               StatefulBuilder(
                                   builder: (contextData, StateSetter setState){
                                 return InkWell(
                                   onTap: () {
                                     _selectReagendamento = true;
                                     novoHorario = itemsProf.hora!;
                                     print(_selectData);
                                     print(_selectReagendamento);
                                     print(novoHorario);
                                     // sessao
                                     // sessaoReagendar.dataSessao= novaData;
                                     // sessaoReagendar.horarioSessao= novoHorario;
                                     setState((){});
                                     // _selectData = false;
                                     // bool result = false;
                                     // if (_datasSelecionadas.contains(
                                     //     UtilData.obterDataDDMMAAAA(
                                     //         _dataSelecionada))) {
                                     //   result = true;
                                     //   // showSnackBar(
                                     //   //     "Já existe uma sessão cadastrada nesta data.");
                                     // }
                                     // await Provider.of<SessaoProvider>(parentContext, listen: false)
                                     //     .existeSessaoByData(UtilData.obterDataDDMMAAAA(
                                     //     _dataSelecionada), paciente.id1).then((value) {
                                     //   print("provider value = $value");
                                     //   result= value;
                                     // });
                                     // if (result == true){
                                     //   showSnackBar(
                                     //       "Já existe uma sessão agendada para este paciente nesta data.");
                                     // } else if (servicoSelecionado!.qtd_sessoes! >
                                     //     _datasSelecionadas.length)
                                     // {
                                     // _horariosSelecionadas.add(items.hora!);
                                     // _salasSelecionadas.add(items.sala!);
                                     // _datasSelecionadas.add(
                                     //     UtilData.obterDataDDMMAAAA(
                                     //         _dataSelecionada));

                                     // }
                                     // if (_datasSelecionadas.length==servicoSelecionado!.qtd_sessoes){
                                     //   _botaoAvancar = true;
                                     // }
                                     // print('setstate');
                                     // setState(() {});
                                   },
                                   child: Container(
                                       height: size.height * 0.05,
                                       width: size.width * 0.045,
                                       decoration: BoxDecoration(
                                           color: AppColors.secondaryColor2,
                                           borderRadius: BorderRadius.circular(4.0),
                                           border: Border.all(color: AppColors.line)
                                       ),
                                       child: Column(
                                         children: [
                                           SizedBox(
                                               height:(size.height * 0.045)/2 ,
                                               width: size.width * 0.044,
                                               child: FittedBox(
                                                 fit: BoxFit.scaleDown,
                                                 child: Text(itemsProf.hora!),
                                               )
                                           ),
                                           SizedBox(
                                             height:(size.height * 0.045)/2 ,
                                             width: size.width * 0.044,
                                             child: FittedBox(
                                               fit: BoxFit.scaleDown,
                                               child: Text(itemsProf.sala!),
                                             ),
                                           )



                                         ],
                                       )
                                   ),
                                 );
                               }),

                          ],
                        ),
                      ],
                    )
                )
                    :
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.28,
                  child: Text("Selecione a data que deseja reagendar a sessão"),
                ),
              ],
            )
        );
      });
    }

    return showDialog(
        context: parentContext,
        builder: (BuildContext context){
           return  AlertDialog(
             content: StatefulBuilder(
                 builder: (BuildContext context, StateSetter setState) {
                    return SizedBox(
                        width: MediaQuery
                            .of(parentContext)
                            .size
                            .width * 0.8,
                        height: MediaQuery
                            .of(parentContext)
                            .size
                            .height * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //calendário com a agenda do profissional
                            selectDataSessao(context,MediaQuery.of(context).size),
                            //dados sessão a ser agendada
                            // Container(
                            //   width: MediaQuery
                            //       .of(parentContext)
                            //       .size
                            //       .width * 0.32,
                            //   height: MediaQuery
                            //       .of(parentContext)
                            //       .size
                            //       .height * 0.7,
                            //   color: AppColors.red,
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                            //         child: Text("Reagendamento da SESSÃO", style: AppTextStyles.labelBold16,),
                            //       ),
                            //       //cabeçalho com dados da sessão a ser alterada
                            //       Container(
                            //         color: AppColors.blue,
                            //         width: MediaQuery
                            //             .of(parentContext)
                            //             .size
                            //             .width * 0.35,
                            //         height: MediaQuery
                            //             .of(parentContext)
                            //             .size
                            //             .height * 0.15,
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //           children: [
                            //             Text("${sessaoReagendar.descSessao}", style: AppTextStyles.subTitleBlack14,),
                            //             Text("Situação: ${sessaoReagendar.situacaoSessao}", style: AppTextStyles.subTitleBlack14,),
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.start,
                            //               children: [
                            //                 Text("${sessaoReagendar.statusSessao}", style: AppTextStyles.labelBold16,),
                            //                 Text("  |  ${sessaoReagendar.dataSessao}  |  ", style: AppTextStyles.labelBold16,),
                            //                 Text("${sessaoReagendar.horarioSessao}  |", style: AppTextStyles.labelBold16,),
                            //               ],
                            //             ),
                            //             Divider(
                            //               thickness: 2,
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text("Nova data: ${_dataSelecionada}", style: AppTextStyles.subTitleBlack16,),
                            //           Text("_selectData: ${_selectData}", style: AppTextStyles.subTitleBlack16,),
                            //           Text("_selectReagendamento: ${_selectReagendamento}", style: AppTextStyles.subTitleBlack16,),
                            //           Text("novoHorario: ${novoHorario}", style: AppTextStyles.subTitleBlack16,),
                            //           (_selectData==false)?
                            //           Text("Selecione uma nova data para a sessão"):
                            //           (_selectReagendamento==false)?
                            //           Text("Selecione um horário",
                            //             style: AppTextStyles.subTitleBlack14,):
                            //           Text("Clique em finalizar para .")
                            //         ],),
                            //
                            //       (sessao.length<1)?
                            //       Center():
                            //       (sessao.length==1)?
                            //       Text("Próximas Sessões:"):
                            //       Text("Próxima Sessão:"),
                            //       for (var items in sessao)
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //           children: [
                            //             Text("${items.horarioSessao}"),
                            //             Text("${items.dataSessao}"),
                            //             Text("${items.situacaoSessao}"),
                            //             Text("${items.statusSessao}"),
                            //           ],
                            //         ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 16.0),
                            //         child: Divider(
                            //           thickness: 2,
                            //         ),
                            //       ),
                            //
                            //
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //         children: [
                            //           ButtonWidget(
                            //             onTap: (){
                            //             },
                            //             label: "REAGENDAR",
                            //             width: MediaQuery.of(context).size.width * 0.07,
                            //             height: MediaQuery.of(context).size.height * 0.065,),
                            //           ButtonWidget(
                            //             onTap: ()async{
                            //
                            //             },
                            //             label: "FINALIZAR",
                            //             width: MediaQuery.of(context).size.width * 0.07,
                            //             height: MediaQuery.of(context).size.height * 0.065,),
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // DetalhesReagendamento(novoHorario: novoHorario, novaData: "", sessao: sessaoReagendar)
                          ],
                        )
                    );
                 }
             ),
           );
        }
    );
  }


  //Opcoes Sessões
  static Future<void> AlertDialogOpcoes(
      parentContext, String uid, Sessao sessao, Sessao sessaoFinal,  Paciente paciente, Profissional profissional) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            width: MediaQuery
                .of(parentContext)
                .size
                .width * 0.6,
            height: MediaQuery
                .of(parentContext)
                .size
                .height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("DADOS DA SESSÃO", style: AppTextStyles.labelBlack16Lex,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),

                //PACIENTE
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.09,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child:
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("PACIENTE: ",style: AppTextStyles.subTitleBlack14,),
                          )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child:  Text("${paciente.nome}",
                              style: AppTextStyles.labelBlack16Lex,),
                          )
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        DialogsPaciente.AlterarDadosPaciente(parentContext, uid, paciente)
                            .then((value) => Navigator.pop(context));
                      },
                      child: SizedBox(
                        width: MediaQuery
                            .of(parentContext)
                            .size
                            .width * 0.06,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child:  Icon(Icons.edit),
                            )
                        ),
                      ),
                    )
                  ],
                ),
                //RESPONSÁVEL
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.09,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child:
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("RESPONSÁVEL: ",style: AppTextStyles.subTitleBlack14,),
                          )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child:  Text("${paciente.nome_responsavel}",
                              style: AppTextStyles.labelBlack16Lex,),
                          )
                      ),
                    ),

                  ],
                ),
                //PROFISSIONAL
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.09,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("PROFISSIONAL: ",style: AppTextStyles.subTitleBlack14,),
                          )

                      ),
                    ),

                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child:  Text("${profissional.nome}",
                              style: AppTextStyles.labelBlack16Lex,),
                          )

                      ),
                    ),

                  ],
                ),
                //Sessão
                Row(
                    children: [
                      SizedBox(
                        width: MediaQuery
                            .of(parentContext)
                            .size
                            .width * 0.09,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("SESSÃO: ",style: AppTextStyles.subTitleBlack14,),
                            )
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery
                              .of(parentContext)
                              .size
                              .width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${sessao.descSessao!.substring(0,11)}".toUpperCase(),
                          style: AppTextStyles.labelBlack16Lex,),
                      ),),
                ]),
                //desc
                Row(
                  children: [
                    SizedBox(width: MediaQuery
                        .of(parentContext)
                        .size
                        .width * 0.09,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("SERVIÇO: ",style: AppTextStyles.subTitleBlack14,),
                          )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.4,
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${sessao.descSessao!.substring(11,sessao.descSessao!.length)}",
                          style: AppTextStyles.labelBlack16Lex,),
                      ),
                    ),
                  ],
                ),
                //horário
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.08,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("HORÁRIO: ",style: AppTextStyles.subTitleBlack14,),
                        )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${sessao.horarioSessao}",
                            style: AppTextStyles.labelBlack16Lex,),
                        )
                      ),
                    ),
                  ],
                ),
                //SITUAÇÃO
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.08,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child:FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("SITUAÇÃO: ",style: AppTextStyles.subTitleBlack14,),
                        )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${sessao.situacaoSessao}",
                            style: AppTextStyles.labelBlack16Lex,),
                        )
                      ),
                    ),
                  ],
                ),
                //STATUS
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.08,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child:FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("STATUS: ",style: AppTextStyles.subTitleBlack14,),
                        )
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${sessao.statusSessao}",
                            style: AppTextStyles.labelBlack16Lex,),
                        )
                      ),
                    ),
                  ],
                ),
                //SALA
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.08,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("SALA: ",style: AppTextStyles.subTitleBlack14,),
                          ),
                        )
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(parentContext)
                          .size
                          .width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${sessao.salaSessao}",
                            style: AppTextStyles.labelBlack16Lex,),
                        )
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonWidget(
                      onTap: ()async{
                        print("ontap");
                        List<Sessao> listSessao = [];

                        List<DiasProfissional> diasProfissional = [];
                        List<DiasSalasProfissionais> diasSalasProfissional = [];
                        await Provider.of<DiasProfissionalProvider>
                          (context, listen: false)
                            .getDiasProfissionalByIdProfissional(profissional.id1)
                            .then((value) async{
                              diasProfissional = value;
                              await Provider.of<DiasSalasProfissionaisProvider>(context, listen:false)
                              .getListDiasSalasByProfissional(profissional.id1).then((value) {
                                diasSalasProfissional = value;
                                diasSalasProfissional.sort((a, b) =>
                                    a.hora!.compareTo(b.hora!));
                                int sessaoAtual = int.parse(sessao.descSessao!.substring(7,8));
                                int sessaoTotal = int.parse(sessao.descSessao!.substring(9,10));
                                List<String> datasSessoes = [];
                                List<String> horarioSessoes = [];

                                // existe mais de uma sessão para ser alterada
                                if (sessaoAtual!=sessaoTotal){
                                  print("!=");
                                  Provider.of<SessaoProvider>(context, listen: false)
                                      .getSessoesByTransacaoPacienteProfissional(sessao.idPaciente!, sessao.idProfissional!).then((value) {
                                    listSessao = value;
                                    print(listSessao.length);
                                    print("listSessao.length");
                                    listSessao.sort((a,b)=>a.descSessao!.compareTo(b.descSessao!));

                                    listSessao.forEach((element) {
                                      datasSessoes.add(element.dataSessao!);
                                      horarioSessoes.add(element.horarioSessao!);
                                    });
                                    print(datasSessoes.length);
                                    print("datasSessoes.length");

                                    int diference = GetDiferenceDays(datasSessoes[0], datasSessoes[1]);
                                    DialogsAgendaAssistente.AlertDialogReagendamento2(
                                        parentContext, uid, listSessao, sessao, sessaoFinal,
                                        paciente,
                                        profissional,diasProfissional,diasSalasProfissional,
                                        datasSessoes, horarioSessoes,
                                        diference
                                    ).then((value) => Navigator.pop(context));
                                  });
                                } else {
                                  print("==");
                                  listSessao.add(sessao);

                                  datasSessoes.add(sessao.dataSessao!);
                                  horarioSessoes.add(sessao.horarioSessao!);
                                  DialogsAgendaAssistente.AlertDialogReagendamento2(
                                      parentContext, uid, listSessao, sessao, sessaoFinal,
                                      paciente, profissional,diasProfissional,
                                      diasSalasProfissional, datasSessoes,
                                      horarioSessoes, 0
                                  ).then((value) => Navigator.pop(context));
                                }
                              });

                        });
                      },
                      label: "REAGENDAR",
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: MediaQuery.of(context).size.height * 0.065,),
                    ButtonWidget(
                      onTap: ()async{
                        if (sessao.situacaoSessao!.compareTo("PAGO")==0){

                          // DialogsAgendaAssistente.AlertDialogRegistrarPagamento(parentContext, uid, transacao, sessao, paciente, profissional);
                          DialogsAgendaAssistente.ConfirmFinalizarSessao(parentContext,sessao,uid);

                        } else {
                          List<TipoPagamento> tiposPagamento = [];
                          await Provider.of<TipoPagamentoProvider>(context, listen: false)
                              .getTiposPagamentos().then((value) {
                            tiposPagamento = value;
                            tiposPagamento.sort((a,b)=>a.descricao.toLowerCase().replaceAll("à", "a").compareTo(b.descricao.toLowerCase().replaceAll("à", "a")));
                          });
                          DialogsAgendaAssistente.AlertDialogRegistrarPagamento(parentContext,uid,sessao, paciente, profissional,tiposPagamento);
                        }
                        // await Provider.of<SessaoProvider>(context,listen: false)
                        //     .update(sessao.id1).then((value) => Navigator.pop(parentContext));
                        // await Provider.of<TransacaoProvider>(context,listen: false).
                        // DialogsAgendaAssistente.AlertDialogRegistrarPagamento(parentContext, uid, sessao, paciente, profissional);

                      },
                      label: "FINALIZAR",
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: MediaQuery.of(context).size.height * 0.065,),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            ButtonWidget(
              onTap: (){
                Navigator.pop(parentContext);
              },
              label: "<< VOLTAR",
              width: MediaQuery.of(context).size.width * 0.07,
              height: MediaQuery.of(context).size.height * 0.065,),
          ],
        );
      },
    );
  }

  static Future<void> ConfirmFinalizarSessao (parentContext,Sessao sessao,
      String uid,){
    return showDialog(context: parentContext, builder: (context){
      return AlertDialog(
        title: SizedBox(
          width: MediaQuery
              .of(parentContext)
              .size
              .width * 0.4,
          height: MediaQuery
              .of(parentContext)
              .size
              .height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("DESEJA REALMENTE FINALIZAR ESTA SESSÃO?"),
              Text(sessao.descSessao!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonWidget(
                    onTap: (){
                      //FINALIZAR PAGAMENTO
                      Provider.of<SessaoProvider>(context, listen:false)
                          .update(sessao.id1).then((value) =>
                          Navigator.pushReplacementNamed(
                              context, "/agenda_assistente")
                          // Navigator
                          // .pop(parentContext)
                      );
                    },
                    label: "FINALIZAR",
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.height * 0.065,),
                  ButtonWidget(
                    onTap: ()async{

                    },
                    label: "CANCELAR",
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.height * 0.065,),
                ],
              )

            ],
          ),
        ),
      );
    });
  }


  //Confirmar Pagamento
  static Future<void> AlertDialogRegistrarPagamento (
      parentContext, String uid, Sessao sessao, Paciente paciente, Profissional profissional,
      List<TipoPagamento> list
      ) {

    List<DropdownMenuItem<String>> getDropdownTiposPagamento(
        List<TipoPagamento> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].descricao.toString(),
          child: Text(list[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    String _dropdown = list.first.descricao;

    var txt1 = TextEditingController();
    var txt2 = TextEditingController();
    final _form = GlobalKey<FormState>();
    Size size = MediaQuery.of(parentContext).size;
    bool _checkSocial = false;
    String _valorSessao = "0,00";
    String _comissaoClinica = "0,00";
    String _comissaoProfissional = "0,00";
    String _comissaoFinalClinica = "0,00";
    String _comissaoFinalProfissional = "0,00";
    String _descontoClinica = "0,00";
    String _descontoProfissional = "0,00";
    Future<String> getValorServico(String desc)async{
       String result = "";
       await Provider.of<ServicoProvider>(parentContext, listen: false)
           .getServicoByDesc(desc).then((value) async{
         result = value.id1;
         await Provider.of<ServicoProfissionalProvider>(parentContext, listen: false)
             .getServByServicoProfissional(profissional.id1,result).then((value) {
               result = value.valor!;
               print(result);
         });
       });
       print(result);
       print("result");

       return result;
    }

    return showDialog(
        context: parentContext,
        builder: (context){
          return StatefulBuilder(builder: (context, setState){
            return AlertDialog(
              title: SizedBox(
                width: size
                    .width * 0.6,
                height: size
                    .height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("EFETUAR PAGAMENTO"),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.24,
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.6,
                            height: size.height * 0.06,
                            child: Row(
                              children: [
                                Text("Serviço: "),
                                Text(sessao.descSessao!.substring(11,sessao.descSessao!.length)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            height: size.height * 0.06,
                            child: Row(
                              children: [
                                Text("Valor Serviço: "),
                                FutureBuilder(
                                    future: getValorServico(sessao.descSessao!.substring(11,sessao.descSessao!.length)),
                                    builder: (parentContext, snapshot){
                                      if (snapshot.hasData){
                                        print("entrou sim");
                                        _valorSessao = snapshot.data as String;
                                        return Text(_valorSessao,  style: AppTextStyles.labelBlack16Lex,);
                                      } else {
                                        print("nao entrou nao");
                                        return Center(
                                            child: Text("")
                                        );
                                      }
                                    }),
                                // Text(sessao.!.substring(12,sessao.descSessao!.length)),
                              ],
                            ),

                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            height: size.height * 0.06,
                            child: Row(
                              children: [
                                Text("Desconto Social"),
                                Text("R\$ "+
                                    ((double.parse(_descontoClinica.replaceAll(',', '.')))+
                                        (double.parse(_descontoProfissional.replaceAll(',', '.')))).toStringAsFixed(2).replaceAll('.', ',')
                                ),
                              ],
                            ),

                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            height: size.height * 0.06,
                            child: Row(
                              children: [
                                Text("Valor Final "),
                                Text("R\$ "+
                                    (   (double.parse(_valorSessao.replaceAll(',', '.')))-
                                        ((double.parse(_descontoClinica.replaceAll(',', '.')))+
                                            (double.parse(_descontoProfissional.replaceAll(',', '.'))))
                                    ).toStringAsFixed(2).replaceAll('.', ',')
                                ),
                              ],
                            ),

                          ),
                        ],
                      ),
                    ),


                    Row(
                      children: [
                        Checkbox(
                            value: _checkSocial,
                            onChanged: (bool? value){
                              _checkSocial = value!;
                              if (_checkSocial){
                                print(_valorSessao);
                                _comissaoClinica = (double.parse(_valorSessao.replaceAll(',', '.'))*0.3).toStringAsFixed(2).toString();
                                _comissaoProfissional = (double.parse(_valorSessao.replaceAll(',', '.'))*0.7).toStringAsFixed(2).toString();
                                _comissaoFinalClinica = _comissaoClinica;
                                _comissaoFinalProfissional = _comissaoProfissional;
                                print(_comissaoClinica);
                                // _comissaoClinica = double.parse(_valorSessao)
                              }
                              setState((){});
                            }),
                        Text("Registrar desconto social.."),
                      ],
                    ),

                    (_checkSocial)?
                    SizedBox(
                      // color: AppColors.green,
                        height: size.height*0.3,
                        width: size.width*0.4,
                        child: Form(
                          key: _form,
                          child: Column(
                            children: [
                              //clínica
                              SizedBox(
                                // color: AppColors.blue,
                                  height: size.height*0.074,
                                  width: size.width*0.3,
                                  child:  Row(
                                    children: [
                                      //comissão clínica
                                      Container(
                                          height: size.height*0.06,
                                          width: size.width*0.074,
                                          decoration: BoxDecoration(
                                              color: AppColors.shape,
                                              borderRadius: BorderRadius.circular(6.0)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(" CLÍNICA ", style: AppTextStyles.labelBlack14Lex,),
                                                ),
                                                Text("R\$ "+_comissaoClinica, style: AppTextStyles.labelBlack14Lex,),

                                              ],
                                            ),
                                          )
                                      ),
                                      //desconto clínica
                                      Container(
                                        height: size.height*0.1,
                                        width: size.width*0.15,
                                        child: InputTextWidgetMask(
                                          label: "DESCONTO CLINICA",
                                          icon: Icons.business_outlined,
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          backgroundColor: AppColors.secondaryColor,
                                          borderColor: AppColors.line,
                                          textStyle: AppTextStyles.subTitleBlack12,
                                          iconColor: AppColors.labelBlack,
                                          input: CentavosInputFormatter(),
                                          controller: txt1,
                                          validator: (value) {
                                            if ((value!.isEmpty) || (value == null)) {
                                              return 'Insira um VALOR';
                                            }
                                            if (value.length<4){
                                              return 'VALOR inválido';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            if (value.length>_comissaoClinica.length){
                                              txt1.text = "0,00";
                                              _comissaoFinalClinica = _comissaoClinica;
                                              _descontoClinica = "0,00";
                                              setState;

                                            } else {
                                              if (value.length>0){
                                                String result = value;
                                                double valorInput = double.parse(result.replaceAll(',','.'));
                                                double comissaoClinica = double.parse(_comissaoClinica.replaceAll(',','.'));
                                                if (comissaoClinica < valorInput){
                                                  print("ultrapassou $comissaoClinica $valorInput");
                                                  txt1.text = "0,00";
                                                  _comissaoFinalClinica = _comissaoClinica;
                                                } else{
                                                  print("permitido $comissaoClinica $valorInput");
                                                  _descontoClinica = double.parse(result.replaceAll(',', '.')).toString();
                                                  _comissaoFinalClinica = (double.parse(_comissaoClinica.replaceAll(',', '.'))-double.parse(_descontoClinica)).toStringAsFixed(2).replaceAll('.', ',');
                                                }

                                              }
                                            }
                                            setState((){});


                                          },
                                        ),
                                      ),
                                      //comissao final Clínica
                                      Container(
                                          height: size.height*0.6,
                                          width: size.width*0.075,

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,

                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(" COMISSÃO FINAL ", style: AppTextStyles.labelBlack14Lex,),
                                              ),
                                              Text("R\$ "+_comissaoFinalClinica, style: AppTextStyles.labelBlack14Lex,),

                                            ],
                                          )
                                      ),
                                    ],
                                  )
                              ),
                              //profissional
                              SizedBox(
                                // color: AppColors.red,
                                  height: size.height*0.074,
                                  width: size.width*0.3,
                                  child:  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //comissão profissional
                                      Container(
                                          height: size.height*0.06,
                                          width: size.width*0.074,
                                          decoration: BoxDecoration(
                                              color: AppColors.shape,
                                              borderRadius: BorderRadius.circular(6.0)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                            child: Column(
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text("PROFISSIONAL", style: AppTextStyles.labelBlack14Lex,),
                                                  ),
                                                  Text("R\$ "+_comissaoProfissional, style: AppTextStyles.labelBlack14Lex,),
                                                ]
                                            ),
                                          )
                                      ),
                                      //desconto profissional
                                      SizedBox(
                                        height: size.height*0.1,
                                        width: size.width*0.15,
                                        child: InputTextWidgetMask(
                                          label: "DESCONTO PROFISSIONAL",
                                          icon: Icons.person_pin,
                                          keyboardType: TextInputType.number,
                                          obscureText: false,
                                          backgroundColor: AppColors.secondaryColor,
                                          borderColor: AppColors.line,
                                          textStyle: AppTextStyles.subTitleBlack12,
                                          iconColor: AppColors.labelBlack,
                                          controller: txt2,
                                          input: CentavosInputFormatter(),
                                          validator: (value) {
                                            if ((value!.isEmpty) || (value == null)) {
                                              return 'Insira um VALOR';
                                            }
                                            if (value.length<4){
                                              return 'VALOR inválido';

                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            if (value.length>_comissaoProfissional.length){
                                              txt2.text = "0,00";
                                              _comissaoFinalProfissional = _comissaoProfissional;
                                              _descontoProfissional="0,00";
                                            } else {
                                              if (value.length>0){
                                                String result = value;
                                                double valorInput = double.parse(result.replaceAll(',','.'));
                                                double comissaoProfissional = double.parse(_comissaoProfissional.replaceAll(',','.'));
                                                if (comissaoProfissional < valorInput){
                                                  print("ultrapassou $comissaoProfissional $valorInput");
                                                  txt2.text = "0,00";
                                                  _comissaoFinalProfissional = _comissaoProfissional;
                                                } else{
                                                  print("permitido $comissaoProfissional $valorInput");
                                                  _descontoProfissional = double.parse(result.replaceAll(',', '.')).toString();
                                                  _comissaoFinalProfissional = (double.parse(_comissaoProfissional.replaceAll(',', '.'))-double.parse(_descontoProfissional)).toStringAsFixed(2).replaceAll('.', ',');
                                                }

                                              }
                                            }
                                            setState((){});


                                          },
                                        ),
                                      ),
                                      //comissão final Profissional
                                      SizedBox(
                                          height: size.height*0.6,
                                          width: size.width*0.075,
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:[
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("COMISSÃO FINAL", style: AppTextStyles.labelBlack14Lex,),
                                                ),
                                                Text("R\$ "+_comissaoFinalProfissional, style: AppTextStyles.labelBlack14Lex,),

                                              ]
                                          )
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(
                                height: size.height*0.06,
                                width: size.width*0.3,
                                child: DropdownButton<String>(
                                  value: _dropdown,
                                  icon: const Icon(Icons.arrow_drop_down_sharp),
                                  elevation: 8,
                                  style: TextStyle(color: AppColors.labelBlack),
                                  underline: Container(
                                    height: 2,
                                    color: AppColors.line,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _dropdown = newValue!;
                                    });
                                  },
                                  items: getDropdownTiposPagamento(list),
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                        :
                    Center(),

                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonWidget(
                          onTap: () async{
                            // Navigator.pop(parentContext);
                            String valorTransacaoFinal=
                            (double.parse(_valorSessao.replaceAll(",", "."))-((double.parse(_descontoProfissional.replaceAll(",", ".")))+
                                (double.parse(_descontoClinica.replaceAll(",", "."))))).toStringAsFixed(2).replaceAll('.', ',');

                            await Provider.of<TransacaoProvider>(context, listen:false)
                                .put(
                                TransacaoCaixa(
                                  dataTransacao: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                  descricaoTransacao: sessao.descSessao!.substring(11,sessao.descSessao!.length),
                                  tpPagamento: _dropdown,
                                  tpTransacao: "PAGAMENTO EFETUADO",
                                  valorTransacao: valorTransacaoFinal,
                                  idPaciente: paciente.id1,
                                  idProfissional: profissional.id1,
                                  descontoProfissional: (double.parse(_descontoProfissional)).toStringAsFixed(2).replaceAll('.', ','),
                                  descontoClinica: (double.parse(_descontoClinica,)).toStringAsFixed(2).replaceAll('.', ','),
                                )).then((value) async{
                              String idTransacao = value;
                              print(value);
                              await Provider.of<ComissaoProvider>(context, listen: false)
                                  .put(Comissao(
                                  idProfissional: profissional.id1,
                                  idTransacao: idTransacao,
                                  idPagamento: "",
                                  dataGerada: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                  dataPagamento: "",
                                  valor: _comissaoFinalProfissional,
                                  situacao: "PENDENTE"));
                              await Provider.of<SessaoProvider>(context,listen: false).update(sessao.id1).then((value) {
                                Navigator.pushReplacementNamed(
                                    context, "/agenda_assistente");
                              });


                            });
                          },
                          label: "FINALIZAR",
                          width: MediaQuery.of(context).size.width * 0.07,
                          height: MediaQuery.of(context).size.height * 0.065,),
                        ButtonWidget(
                          onTap: ()async{
                            Navigator.pop(parentContext);
                          },
                          label: "CANCELAR",
                          width: MediaQuery.of(context).size.width * 0.07,
                          height: MediaQuery.of(context).size.height * 0.065,),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
       }
    );
  }
}

class DetalhesReagendamento extends StatefulWidget {
  // late BuildContext contextDialog;
  late String uid;
  // final String dataSessao;
  // final String horaSessao;
  // final String listDataSessoes;
  // final String listHoraSessoes;
  final int diferenca;
  final Sessao sessao;
  final List<Sessao> sessoes;
  // final Sessao sessaoFinal;
  // final List<Sessao> sessoesFinal;
  final List<String> horarios;
  final List<String> datas;
  final Paciente paciente;
  final Profissional profissional;
  DetalhesReagendamento({Key? key,
    // required this.sessaoFinal, required this.sessoesFinal,
    required this.sessoes,  required this.paciente, required this.profissional,
    required this.sessao, required this.diferenca, required this.horarios,
    required this.datas
  })
      : super(key: key);

  @override
  State<DetalhesReagendamento> createState() => _DetalhesReagendamentoState();
}

class _DetalhesReagendamentoState extends State<DetalhesReagendamento> {



  // late Sessao sessaoFinal = widget.sessao;

  List<String> dias = [
    "DOMINGO",
    "SEGUNDA",
    "TERÇA",
    "QUARTA",
    "QUINTA",
    "SEXTA",
    "SÁBADO"
  ];
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool messageErroData = false;
  String novoHorario ="";
  String novaData = "";
  List<String> novasDatas = [];
  List<String> novosHorarios = [];
  // List<Sessao> listSessoes = [];
  List<DiasProfissional> diasProfissional = [];
  List<DiasSalasProfissionais> diasSalasProfissional = [];
  List<Sessao> sessoesProfissional = [];
  late List<DiasSalasProfissionais> horariosDoDia = [];
  late DateTime _dataSelecionada = DateTime.now();
  late bool _changeSessao = false;
  late bool _selectData = false;
  late bool _selectReagendamento = false;
  late DateTime dataAtual = DateTime.now();
  late int mesAtual = DateTime.now().month;
  late int anoAtual = DateTime.now().year;
  // late int diferenca = 0;

  Future<void> getSessoesProfissional(String data, String idProfissional)async{
    print("getSessoes");
    await Provider.of<SessaoProvider>(context, listen:false).getListSessoesDoDiaByProfissional(
        data, idProfissional).then((value) {
      sessoesProfissional = value;
      print("sessoesProfissional ${sessoesProfissional.length}");
    });
  }

  String getMes(int mes){
    switch(mes){
      case 1:
        return "JANEIRO";
      case 2:
        return "FEVEREIRO";
      case 3:
        return "MARÇO";
      case 4:
        return "ABRIL";
      case 5:
        return "MAIO";
      case 6:
        return "JUNHO";
      case 7:
        return "JULHO";
      case 8:
        return "AGOSTO";
      case 9:
        return "SETEMBRO";
      case 10:
        return "OUTUBRO";
      case 11:
        return "NOVEMBRO";
      case 12:
        return "DEZEMBRO";
    }
    return "";
  }

  int getIndex(String dia){
    switch (dia) {
      case 'Segunda':
        {
          return 1;
        }
      case 'Terça':
        {
          return 2;
        }
      case 'Quarta':
        {
          return 3;
        }
      case 'Quinta':
        {
          return 4;
        }
      case 'Sexta':
        {
          return 5;
        }
      case 'Sábado':
        {
          return 6;
        }
      case 'Domingo':
        {
          return 0;
        }
    }
    return 7;
  }

  bool getDataValida(DateTime data){
    DateTime hoje = DateTime.now();
    if (data.year>hoje.year) {
      return true;
    } else{
      if (data.month>hoje.month) {
        return true;
      } else{
        if ((data.month==hoje.month)&&(data.day>=hoje.day)){
          return true;
        }
      }
    }
    print(data.month.toString()+" "+hoje.month.toString());
    print(data.day.toString()+" "+hoje.day.toString());
    print("---");
    return false;
  }

  String getDiaSemana(DateTime data) {
    String dia = DateFormat('EEEE').format(data);
    switch (dia) {
      case 'Monday':
        {
          return "Segunda";
        }
      case 'Tuesday':
        {
          return "Terça";
        }
      case 'Wednesday':
        {
          return "Quarta";
        }
      case 'Thursday':
        {
          return "Quinta";
        }
      case 'Friday':
        {
          return "Sexta";
        }
      case 'Saturday':
        {
          return "Sábado";
        }
      case 'Sunday':
        {
          return "Domingo";
        }
    }
    return "";
  }

  DateTime getDayIn(DateTime date){
    String diaSemana = getDiaSemana(date);
    int indexDia = getIndex(diaSemana);
    DateTime diaInicio = date.subtract(Duration(days: indexDia));
    return diaInicio;
  }

  bool contemAgendamento(String hora)  {
    print(_dataSelecionada);
    print("Contém $hora");
    print(sessoesProfissional.length);
    bool result = false;

    if (sessoesProfissional.length==0){
      return false;
    } else{
      sessoesProfissional.forEach((element) {
        if (element.horarioSessao!.compareTo(hora)==0){
          result = true;
        }
      });
    }
    print(result);
    return result;
  }

  List<Widget> listCalendario(double width,
      double heigth, DateTime dataAtual){
    List<String> diasProf = [];
    print("diasProfissional.length ${diasProfissional.length}");
    diasProfissional.forEach((element) {
      print(element.dia!);
      diasProf.add(element.dia!);
    });
    DateTime diaInicio = getDayIn(dataAtual);

    List<Widget> result = [];

    for (int j=0;j<6;j++) {
      for (int i = 0; i < 7; i++) {
        result.add(
            (diasProf.contains(
                getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)))
                    .toUpperCase())
                && (getDataValida(diaInicio.add(Duration(days: (7 * j) + i))))
            ) ?
            InkWell(
              onTap: () async{
                //caso a nova data seja diferente da data da sessao a reagendar message = false
                if ((messageErroData) &
                    (UtilData.obterDataDDMMAAAA(_dataSelecionada)
                        .compareTo(novaData)==0)){
                  print("tudo");

                  messageErroData = false;
                } else {
                  print("nada");
                  print(messageErroData);
                  print(messageErroData);
                  print(_dataSelecionada);
                  print(novaData);


                }
                print(_selectData);
                if (horariosDoDia.length>0){
                  print(horariosDoDia.length);
                  horariosDoDia = [];
                  print("111"+horariosDoDia.length.toString());

                }
                print(horariosDoDia.length);
                //adiciona horarios do dia do profissional
                print("-----");
                print(getDiaSemana(
                    diaInicio.add(Duration(days: (7 * j) + i))));
                diasSalasProfissional.forEach((element) {
                  if (element.dia!.compareTo(getDiaSemana(
                      diaInicio.add(Duration(days: (7 * j) + i))).toUpperCase())==0){
                    horariosDoDia.add(element);
                  }
                });
                print(horariosDoDia.length);

                _dataSelecionada = diaInicio.add(Duration(days: (7 * j) + i));

                novaData = UtilData.obterDataDDMMAAAA(_dataSelecionada);

                // if(novaData.compareTo(widget.sessao.dataSessao!)!=0){
                //     messageErroData = false;
                // }
                await getSessoesProfissional(UtilData.obterDataDDMMAAAA(_dataSelecionada),widget.profissional.id1);
                _selectData=true;

                setState((){});
                print("SetState");
                print(_selectData);
                print(_dataSelecionada);
              },
              child: Card(
                child:
                Container(
                    height: heigth,
                    width: width,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(4.0)
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: heigth/2,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(diaInicio
                                .add(Duration(days: (7 * j) + i))
                                .day
                                .toString(),style: AppTextStyles.subTitleWhite16),
                          ),
                        ),
                        SizedBox(
                          height: heigth/2,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(getMes(diaInicio
                                .add(Duration(days: (7 * j) + i))
                                .month).substring(0, 3),style: AppTextStyles.subTitleWhite16),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            )
                :
            //card com o dia que o profissional não atua
            Card(
              child: Container(
                  height: heigth,
                  width: width,
                  decoration: BoxDecoration(
                      color: (getDataValida(
                          diaInicio.add(Duration(days: (7 * j) + i)))) ?
                      AppColors.labelWhite.withOpacity(0.6) : AppColors.line.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4.0)
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: heigth*0.4,
                          width: width*0.4,
                          child:
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(diaInicio
                                .add(Duration(days: (7 * j) + i))
                                .day
                                .toString()),
                          )
                      ),
                      SizedBox(
                        height: heigth*0.4,
                        width: width*0.4,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(getMes(diaInicio
                              .add(Duration(days: (7 * j) + i))
                              .month).substring(0, 3)),
                        ),
                      )
                    ],
                  )
              ),
            )
        );
      }
    }
    return result;
  }

  Widget selectDataSessao(Size size)  {
    late bool _select = false;
    List<String> dias = [
      "DOMINGO",
      "SEGUNDA",
      "TERÇA",
      "QUARTA",
      "QUINTA",
      "SEXTA",
      "SÁBADO"
    ];
    List<Widget> widgets = listCalendario(
        size.width * 0.035, size.height * 0.05, dataAtual);
    // final Sessao sessaoAlterada = widget.sessao;
    // final List<Sessao> sessoesAlteradas = widget.sessoes;
    return  Container(
        height: size.height * 0.7,
        width: size.width * 0.3,
        color: AppColors.shape,
        child: Column(
          children: [
            Column(
              children: [
                //mes + icones 0.05
                SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 4.0),
                          child: Text("${getMes(mesAtual)}/${anoAtual}"),

                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (anoAtual > DateTime.now().year) {
                                  if (mesAtual == 1) {
                                    mesAtual = 12;
                                    anoAtual--;
                                  } else {
                                    mesAtual--;
                                  }
                                } else {
                                  if (mesAtual > DateTime.now().month) {
                                    mesAtual--;
                                  }
                                }
                                print(mesAtual);
                                print(anoAtual);
                                dataAtual = DateTime(anoAtual, mesAtual, 1);
                                widgets = listCalendario(
                                    size.width * 0.035, size.height * 0.05,
                                    dataAtual);
                                setState(() {});
                              },
                              child:Container(
                                width: size.width*0.04,
                                height: size.height*0.03,
                                alignment: Alignment.center,
                                // margin: EdgeInsets.all(100.0),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle
                                ),
                                child: Icon(
                                    size: size.height*0.03,
                                    Icons.arrow_left_outlined),
                              ),),
                            InkWell(
                              onTap: () {
                                if (mesAtual == 12) {
                                  mesAtual = 1;
                                  anoAtual++;
                                } else {
                                  mesAtual++;
                                }
                                print(mesAtual);
                                print(anoAtual);
                                dataAtual = DateTime(anoAtual, mesAtual, 1);
                                widgets = listCalendario(
                                    size.width * 0.035, size.height * 0.05,
                                    dataAtual);
                                setState(() {});
                              },
                              child: Container(
                                width: size.width*0.04,
                                height: size.height*0.03,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle
                                ),
                                child: Icon(
                                    size:  size.height*0.03,
                                    Icons.arrow_right_outlined),
                              ),),

                          ],
                        )
                        // })
                      ],
                    )
                ),
                //Dias da semana 0.07
                SizedBox(
                  height: size.height * 0.05,
                  width: size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var items in dias)
                        Card(
                          elevation: 8,
                          color: AppColors.green,
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.035,
                            color: AppColors.secondaryColor,
                            child: Center(
                              child: Text(items.substring(0, 3),
                                style: AppTextStyles.labelBlack16Lex,),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                //calendário 0.4
                SizedBox(
                    height: size.height * 0.4,
                    width: size.width * 0.3,
                    child: Column(
                        children: [
                          for (int j = 0; j < 6; j++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (int i = 0; i < 7; i++)
                                  widgets[(j * 7) + i],
                              ],)
                        ]
                    )
                ),
              ],
            ),


            //horários do dia selecionado
            (_selectData) ?
            SizedBox(
                height: size.height * 0.2,
                width: size.width * 0.3,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 10),
                      child: Text("Data: ${UtilData.obterDataDDMMAAAA(
                          _dataSelecionada)}"),
                    ),
                    //horarios
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        // for(var itemsProf in diasSalasProfissional)
                        for(var itemsProf in horariosDoDia)
                          (contemAgendamento(itemsProf.hora!))?
                          Container(
                              height: size.height * 0.05,
                              width: size.width * 0.045,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: AppColors.labelWhite,
                                  border: Border.all(color: AppColors.line)

                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: (size.height * 0.045)/2,
                                    width: size.width * 0.045,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(itemsProf.hora!),
                                    ),
                                  ),
                                  SizedBox(
                                    height: (size.height * 0.045)/2,
                                    width: size.width * 0.045,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text("OCUPADO",style: AppTextStyles.labelBold14,),
                                    ),
                                  ),
                                ],
                              )
                          )
                              :
                          InkWell(
                            onTap: () {
                              print(novasDatas.length);
                              print(novaData);
                              _selectReagendamento = true;
                              novoHorario = itemsProf.hora!;
                              novasDatas.add(novaData);
                              novosHorarios.add(novoHorario);
                              bool conflito = false;
                              widget.sessoes.forEach((element) {
                                if ((element.dataSessao!.compareTo(novaData)==0)&&(element.horarioSessao!.compareTo(novoHorario)==0)){
                                  conflito=true;
                                  print(widget.sessoes.length);
                                  print("contem consulta nesta data");
                                }
                              });
                              print("\\\\zzzz");
                              print(_selectData);
                              print(_selectReagendamento);
                              print(novoHorario);


                              _changeSessao = true;
                              check1=false;
                              novasDatas.clear;
                              novosHorarios.clear;
                              novosHorarios.add( itemsProf.hora!);
                              
                              ///
                              // widget.sessao.horarioSessao = novoHorario;
                              // widget.sessao.dataSessao = novaData;
                              // print(widget.sessao.dataSessao);
                              // print(widget.sessaoFinal.dataSessao);
                              // listSessoes.add(widget.sessao);
                              // listSessoes.last.horarioSessao = novoHorario;
                              // listSessoes.last.dataSessao = novaData;
                              // widget.sessao.horarioSessao = novoHorario;
                              // widget.sessao.dataSessao = novaData;
                              // sessaoAlterada.horarioSessao = novoHorario;
                              // sessaoAlterada.dataSessao = novaData;
                              setState((){});
                            },
                            child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.045,
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor2,
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(color: AppColors.line)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:(size.height * 0.045)/2 ,
                                        width: size.width * 0.044,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(itemsProf.hora!),
                                        )
                                    ),
                                    SizedBox(
                                      height:(size.height * 0.045)/2 ,
                                      width: size.width * 0.044,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(itemsProf.sala!),
                                      ),
                                    )



                                  ],
                                )
                            ),
                          ),

                      ],
                    ),
                  ],
                )
            )
                :
            SizedBox(
              height: size.height * 0.2,
              width: size.width * 0.28,
              child: Text("Selecione a data que deseja reagendar a sessão"),
            ),
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.profissional.id1);
    if (diasSalasProfissional.length==0){
      Provider.of<DiasSalasProfissionaisProvider>(context, listen:false)
          .getListDiasSalasByProfissional(widget.profissional.id1).then((value) {
            print(value.length);
            print("aaa");
            if (this.mounted){
              diasSalasProfissional = value;
              diasSalasProfissional.sort((a, b) =>
                  a.hora!.compareTo(b.hora!));
              setState((){});
            }

      });
    }
    if (diasProfissional.length==0){
      Provider.of<DiasProfissionalProvider>
        (context, listen: false)
          .getDiasProfissionalByIdProfissional(widget.profissional.id1)
          .then((value) {
            if (this.mounted){
              diasProfissional = value;
              setState((){});
            }
          });
    }

  }


  void  showSnackBar(String message) {
    print("inside snack");
    SnackBar snack = SnackBar(
      backgroundColor: AppColors.primaryColor,
      content: Text(
        message,
        style: AppTextStyles.labelBlack16Lex,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int getDiferencaDias(String data1, String data2){
    // sessaoFinal.dataSessao
    int dia1, dia2=0;
    int mes1, mes2=0;
    int ano1,ano2=0;
    dia1 = int.parse(data1.substring(0,2));
    dia2 = int.parse(data2.substring(0,2));
    mes1 = int.parse(data1.substring(3,5));
    mes2 = int.parse(data2.substring(3,5));
    ano1 = int.parse(data1.substring(6,10));
    ano2 = int.parse(data2.substring(6,10));
    final data = DateTime(ano2,mes2,dia2).difference(DateTime(ano1,mes1,dia1));
    // diferenca = data.inDays;
    print(data.inDays.toString()+" diferença");
    return data.inDays;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.8,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //calendário com a agenda do profissional
              selectDataSessao(size),
              //informações do reagendamento
              Container(
                  width: size.width * 0.32,
                  height: size.height * 0.75,
                  color: AppColors.shape,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.005,right: size.width * 0.005),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top:10.0,bottom: 5.0),
                            child: Center(
                              child: Text("REAGENDAMENTO SESSÃO", style: AppTextStyles.labelBold16,),

                            )
                        ),

                        //cabeçalho com dados da sessão a ser alterada
                        SizedBox(
                          // color: AppColors.green,
                          width:size.width * 0.35,
                          height: size.height * 0.195,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              SizedBox(
                                width:size.width * 0.35,
                                height: size.height * 0.03,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child:
                                  Text("${widget.sessao.descSessao!.substring(11,widget.sessao.descSessao!.length)}", style: AppTextStyles.subTitleBlack14,)
                                  // Text("${sessaoF.descSessao!.substring(11,widget.sessao.descSessao!.length)}", style: AppTextStyles.subTitleBlack14,)
                                  // :
                                  // Text("${widget.sessao.descSessao!.substring(11,widget.sessao.descSessao!.length)}", style: AppTextStyles.subTitleBlack14,)
                                ),
                              ),
                              //sessão
                              SizedBox(
                                width:size.width * 0.35,
                                height: size.height * 0.03,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text("${widget.sessao.descSessao!.substring(0,11)}",
                                    style: AppTextStyles.subTitleBlack16,),
                                ),
                              ),
                              Text("Situação: ${widget.sessao.situacaoSessao}", style: AppTextStyles.subTitleBlack14,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${widget.sessao.statusSessao}", style: AppTextStyles.labelBold16,),
                                  Text("  |  ${widget.sessao.dataSessao}  |  ", style: AppTextStyles.labelBold16,),
                                  Text("${widget.sessao.horarioSessao}  |", style: AppTextStyles.labelBold16,),
                                ],
                              ),

                              ((_selectData==false||_selectReagendamento==false)
                                  &&(widget.sessoes.length>1))?
                              Row(
                                children: [
                                  Checkbox(
                                      activeColor: AppColors.primaryColor,
                                      value: check2,
                                      onChanged: (value)async{
                                        check2 = value!;
                                        print(check2);
                                        if (check2){
                                          // print()
                                          int dia =  int.parse(widget.sessoes.last.dataSessao!.substring(0,2));
                                          int mes = int.parse(widget.sessoes.last.dataSessao!.substring(3,5));
                                          int ano = int.parse(widget.sessoes.last.dataSessao!.substring(6,10));
                                          String data = UtilData.obterDataDDMMAAAA(DateTime(ano,mes,dia).add(Duration(days: widget.diferenca)));
                                          print(data);
                                          widget.sessoes.forEach((element) {
                                            print(element.dataSessao!);
                                          }); 
                                          // novasDatas.add(data);
                                          await Provider.of<SessaoProvider>(context, listen: false)
                                              .getSessaoByDataSalaHora(
                                              data,widget.sessao.horarioSessao!,
                                              widget.sessao.salaSessao!)
                                              .then((value) async{
                                               if (value){
                                                 print("existe sessão nesta data e hora"
                                                     "${novosHorarios.last} ${data}");
                                                 await Provider.of<SessaoProvider>(
                                                    context, listen: false
                                                 ).getProximoHorarioDisponivel(data,novosHorarios.last,
                                                     widget.sessao.salaSessao!).then((value) {

                                                   novasDatas.clear();
                                                   novosHorarios.clear();

                                                   for (int i =1; i<widget.sessoes.length;i++){
                                                     novasDatas.add(widget.sessoes[i].dataSessao!);
                                                     novosHorarios.add(widget.sessoes[i].horarioSessao!);
                                                   }
                                                   novasDatas.add(data);
                                                   novosHorarios.add(value);
                                                   // novasDatas.removeAt(0);
                                                   // novosHorarios.removeAt(0);
                                                   setState((){});
                                                 });
                                               }else {

                                                 print("else123");
                                                 novasDatas.clear();
                                                 novosHorarios.clear();

                                                 for (int i =1; i<widget.sessoes.length;i++){
                                                   print(widget.sessoes[i].dataSessao!);
                                                   novasDatas.add(widget.sessoes[i].dataSessao!);
                                                   novosHorarios.add(widget.sessoes[i].horarioSessao!);
                                                 }
                                                 novasDatas.add(data);
                                                 novosHorarios.add(widget.sessoes.last.horarioSessao!);
                                                 setState((){});
                                               }
                                          });
                                        } else {
                                          setState((){});
                                        }

                                        // novasDatas.clear();
                                        // novosHorarios.clear();
                                        // if (check2){
                                        //   print(widget.sessoes.length);
                                        //   print("widget.sessoes.length");
                                        //   for (int i=0;i<widget.sessoes.length;i++){
                                        //     print(i+1);
                                        //     novasDatas.add(widget.sessoes[i].dataSessao!);
                                        //     novosHorarios.add(widget.sessoes[i].horarioSessao!);
                                        //   }
                                        //   print("widget.diferenca");
                                        //   print(widget.diferenca);
                                        //   print(novasDatas.last);
                                        //   int dia =  int.parse(novasDatas.last.substring(0,2));
                                        //   int mes = int.parse(novasDatas.last.substring(3,5));
                                        //   int ano = int.parse(novasDatas.last.substring(6,10));
                                        //   String data = UtilData.obterDataDDMMAAAA(DateTime(ano,mes,dia).add(Duration(days: widget.diferenca)));
                                        //
                                        //   await Provider.of<SessaoProvider>(context, listen: false)
                                        //       .getSessaoByDataSalaHora(data,novosHorarios.last,widget.sessao.salaSessao!).then((value) async{
                                        //     if (value){
                                        //       print("data $data");
                                        //       print("data ${novosHorarios.last}");
                                        //       print("data ${widget.sessao.salaSessao!}");
                                        //       print("data $data");
                                        //       print("VAAALUE");
                                        //       await Provider.of<SessaoProvider>(context, listen: false)
                                        //           .getProximoHorarioDisponivel(data, novosHorarios.last, widget.sessao.salaSessao!).then((value){
                                        //         print("vaaa = $value");
                                        //         novasDatas.add(data);
                                        //         novosHorarios.add(value);
                                        //       }).then((value) =>setState((){}) );
                                        //     } else {
                                        //       print("VAAALUE FALSE");
                                        //       novasDatas.add(data);
                                        //       novosHorarios.add(novoHorario);
                                        //       novasDatas.removeAt(0);
                                        //       novosHorarios.removeAt(0);
                                        //       setState((){});
                                        //
                                        //     }
                                        //   });
                                        // }
                                        // setState((){});
                                        //---------------------------------------------------
                                        //  for (int i =0; i<widget.sessoes.length-1;i++){
                                        //                                         int dia =  int.parse(novaData.substring(0,2));
                                        //                                         int mes = int.parse(novaData.substring(3,5));
                                        //                                         int ano = int.parse(novaData.substring(6,10));
                                        //                                         print("diferença = ${widget.diferenca}");
                                        //                                         String data = UtilData.obterDataDDMMAAAA(DateTime(ano,mes,dia).add(Duration(days: widget.diferenca*(i+1))));
                                        //                                         print("data = $data");
                                        //                                         /// validar nova data
                                        //                                        await Provider.of<SessaoProvider>(context, listen: false)
                                        //                                             .getSessaoByDataSalaHora(data,novoHorario,widget.sessao.salaSessao!).then((value) async{
                                        //                                               if (value){
                                        //                                                print("VAAALUE");
                                        //                                                await Provider.of<SessaoProvider>(context, listen: false)
                                        //                                                     .getProximoHorarioDisponivel(data, novoHorario, widget.sessao.salaSessao!).then((value){
                                        //                                                       print("vaaa = $value");
                                        //                                                   novasDatas.add(data);
                                        //                                                   novosHorarios.add(value);
                                        //                                                 });
                                        //                                               } else {
                                        //                                                 print("VAAALUE FALSE");
                                        //                                                 novasDatas.add(data);
                                        //                                                 novosHorarios.add(novoHorario);
                                        //                                               }
                                        //                                         });
                                        //                                       }
                                        //                                       setState((){});
                                      }
                                  ),
                                  Text("Reagendar sessão a partir do próximo agendamento")
                                ],
                              ): Center(),
                              (widget.sessoes.length>=1)?
                              Divider(
                                thickness: 2,
                              ):Center(),

                            ],
                          ),
                        ),
                        //proximas sessões
                        (widget.sessoes.length>=1)?
                        SizedBox(
                          width: size.width * 0.32,
                          height: ((size.height * 0.05)*widget.sessoes.length)+(size.height * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (widget.sessoes.length<1)?
                              Center():
                              (widget.sessoes.length==1)?
                              SizedBox(
                                height: size.height * 0.03,
                                child: Text("Próxima Sessão:"),
                              )
                              :
                              SizedBox(
                                height: size.height * 0.03,
                                child: Text("Próximas Sessões:"),
                              ),

                              //1° sessão
                              Container(
                                color: AppColors.labelBlack.withOpacity(0.3),
                                width:size.width * 0.32,
                                height: size.height * 0.05,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width:(size.width * 0.09),
                                      height: size.height * 0.05,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child:
                                        // (check2)
                                        Text("${widget.sessao.descSessao!.substring(0,11)}", style: AppTextStyles.subTitleBlack14,),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.005,
                                      child: VerticalDivider(),
                                    ),
                                    SizedBox(
                                      width:(size.width * 0.09),
                                      height: size.height * 0.05,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child:
                                        (_selectData)?
                                        Text("${novaData}", style: AppTextStyles.subTitleBlack14,)
                                            :
                                        (check2)?
                                        Text("${novasDatas[0]}", style: AppTextStyles.subTitleBlack14,):
                                        Text("${widget.sessao.dataSessao}", style: AppTextStyles.subTitleBlack14,),

                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.05,
                                      width: size.width * 0.005,
                                      child: VerticalDivider(),
                                    ),
                                    SizedBox(
                                      // color: AppColors.red,
                                      width: size.width * 0.08,
                                      height: size.height * 0.05,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child:
                                        (_selectData)?
                                        Text("$novoHorario ", style: AppTextStyles.subTitleBlack14,)
                                         :
                                        Text("${widget.sessao.horarioSessao!}", style: AppTextStyles.subTitleBlack14,),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.005,
                                      child: VerticalDivider(),
                                    ),
                                    SizedBox(
                                      width:size.width * 0.02,
                                      height: size.height * 0.05,
                                    )
                                  ],
                                ),
                              ),
                              if (widget.sessoes.length>1)
                                for (int i =1; i<widget.sessoes.length; i++)
                              Container(
                                  color: AppColors.labelBlack.withOpacity(0.3),
                                  width:size.width * 0.32,
                                  height: size.height * 0.05,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width:(size.width * 0.09),
                                        height: size.height * 0.05,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text("${widget.sessoes[i].descSessao!.substring(0,11)}", style: AppTextStyles.subTitleBlack14,),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.005,
                                            child: VerticalDivider(),
                                      ),
                                      //data
                                      SizedBox(
                                        width:(size.width * 0.09),
                                        height: size.height * 0.05,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child:
                                          ((check1)||(check2))?
                                          Text("${novasDatas[i]}", style: AppTextStyles.subTitleBlack14,)
                                              :
                                          Text("${widget.sessoes[i].dataSessao}", style: AppTextStyles.subTitleBlack14,),

                                          // Text("${widget.datas[i]}", style: AppTextStyles.subTitleBlack14,),


                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.005,
                                        child: VerticalDivider(),
                                      ),
                                      // horario
                                      SizedBox(
                                        width:(size.width * 0.08),
                                        height: size.height * 0.05,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child:

                                          (check1)?
                                          Text("${novosHorarios[i]}", style: AppTextStyles.subTitleBlack14,)
                                              :
                                          Text("${widget.sessoes[i].horarioSessao}", style: AppTextStyles.subTitleBlack14,),

                                          // Text("${widget.horarios[i]}", style: AppTextStyles.subTitleBlack14,),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.005,
                                        child: VerticalDivider(),
                                      ),
                                      SizedBox(
                                        width:size.width * 0.02,
                                        height: size.height * 0.05,
                                      )
                                    ],
                                  ),
                              ),
                              // for (var items in widget.sessoes)
                                // Container(
                                //     color: AppColors.labelBlack.withOpacity(0.3),
                                //     width:size.width * 0.32,
                                //     height: size.height * 0.05,
                                //     child:Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //       children: [
                                //         SizedBox(
                                //           width:(size.width * 0.09),
                                //           height: size.height * 0.05,
                                //           child: FittedBox(
                                //             fit: BoxFit.scaleDown,
                                //             alignment: Alignment.centerLeft,
                                //             child: Text("${items.descSessao!.substring(0,11)}", style: AppTextStyles.subTitleBlack14,),
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           width: size.width * 0.005,
                                //               child: VerticalDivider(),
                                //         ),
                                //         SizedBox(
                                //           width:(size.width * 0.09),
                                //           height: size.height * 0.05,
                                //           child: FittedBox(
                                //             fit: BoxFit.scaleDown,
                                //             alignment: Alignment.centerLeft,
                                //             child:
                                //             (check2)?
                                //             Text("${items.dataSessao}", style: AppTextStyles.subTitleBlack14,)
                                //                 :
                                //             Text("${items.dataSessao}", style: AppTextStyles.subTitleBlack14,),
                                //
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           width: size.width * 0.005,
                                //           child: VerticalDivider(),
                                //         ),
                                //         SizedBox(
                                //           width:(size.width * 0.08),
                                //           height: size.height * 0.05,
                                //           child: FittedBox(
                                //             fit: BoxFit.scaleDown,
                                //             alignment: Alignment.centerLeft,
                                //             child: Text("${items.horarioSessao}", style: AppTextStyles.subTitleBlack14,),
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           width: size.width * 0.005,
                                //           child: VerticalDivider(),
                                //         ),
                                //         SizedBox(
                                //           width:size.width * 0.02,
                                //           height: size.height * 0.05,
                                //         )
                                //       ],
                                //     ),
                                // ),

                            ],
                          )
                        )
                        :
                        Center(),
                        Divider(
                          thickness: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Nova data: ${novaData}", style: AppTextStyles.subTitleBlack16,),
                            (messageErroData)?
                            Text("Data em conflito com próxima sessão! Tente outra.", style: AppTextStyles.subTitleErroRed10,)
                                :
                            Center(),

                            Text("Novo Horário: ${novoHorario}", style: AppTextStyles.subTitleBlack16,),
                            ((widget.sessoes.length>1)&&
                            (_selectData&&_selectReagendamento))?
                            Row(
                              children: [
                                Checkbox(
                                    activeColor: AppColors.primaryColor,
                                    value: check1,

                                    onChanged: (value)async{
                                      check1 = value!;
                                      print(novasDatas.length);
                                      print("novasDatas.length");
                                      for (int i =0; i<widget.sessoes.length-1;i++){
                                        int dia =  int.parse(novaData.substring(0,2));
                                        int mes = int.parse(novaData.substring(3,5));
                                        int ano = int.parse(novaData.substring(6,10));
                                        print("diferença = ${widget.diferenca}");

                                        String data = UtilData.obterDataDDMMAAAA(DateTime(ano,mes,dia).add(Duration(days: widget.diferenca*(i+1))));
                                        print("data = $data");
                                        /// validar nova data
                                       await Provider.of<SessaoProvider>(context, listen: false)
                                            .getSessaoByDataSalaHora(data,novoHorario,widget.sessao.salaSessao!).then((value) async{
                                              if (value){
                                               print("VAAALUE");
                                               await Provider.of<SessaoProvider>(context, listen: false)
                                                    .getProximoHorarioDisponivel(data, novoHorario, widget.sessao.salaSessao!).then((value){
                                                      print("vaaa = $value");
                                                  novasDatas.add(data);
                                                  novosHorarios.add(value);
                                                });
                                              } else {
                                                print("VAAALUE FALSE");
                                                novasDatas.add(data);
                                                novosHorarios.add(novoHorario);
                                              }
                                        });
                                      }
                                      setState((){});
                                    }
                                ),
                                Text("Alterar data das próximas sessões a partir desta data")
                              ],
                            )
                                :
                            Center(),


                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Center(
                          child: ButtonDisableWidget(
                            isButtonDisabled: (_selectData&&_selectReagendamento)?false:true,
                            onTap: () async {
                              bool changed = false;
                              int count =0;
                              print(novasDatas.length);
                              print("novasDatas.length");
                              // int count =0;
                              novasDatas.forEach((element) async{

                                // for (int i =0; i<novasDatas.length; i++) {
                                  if ((element.compareTo(widget.sessoes[count].dataSessao!)!=0)
                                      || (novosHorarios[count].compareTo(widget.sessoes[count].horarioSessao!)!=0)){
                                    print("alterou");
                                    print(element);
                                    print(novosHorarios[count]);
                                    print(widget.sessoes[count].horarioSessao!);
                                    print(widget.sessoes[count].dataSessao!);
                                    await Provider.of<SessaoProvider>(context, listen: false)
                                                  .updateDataEHora(widget.sessao.id1,element,novosHorarios[count]);
                                                  // .then((value) => Navigator.pop(context));
                                    // print(novosHorarios[count]);
                                  } else{
                                    print("passou batido");
                                    print(element);
                                    print(novosHorarios[count]);
                                    print(widget.sessoes[count].horarioSessao!);
                                    print(widget.sessoes[count].dataSessao!);
                                    print("-----o9lkoomç");
                                  }
                                  count++;
                                // }
                              });
                              Navigator.pop(context);

                              // widget.sessoes.forEach((element) async {
                              //   print("----");
                              //   print(element.dataSessao);
                              //   print(element.horarioSessao);
                              //   print(element.descSessao);
                              //   print(novasDatas[count]);
                              //   print(novosHorarios[count]);
                              //   print(count);
                              //   print("----");
                              //
                              //   count++;
                              //   for (int i =0; i<widget.datas.length; i++){
                              //     if ((element.dataSessao!.compareTo(novasDatas[i])!=0)
                              //     || (element.horarioSessao!.compareTo(novosHorarios[i])!=0)){
                              //       print("111111");
                              //
                              //
                              //       // await Provider.of<SessaoProvider>(context, listen: false)
                              //           //     .updateDataEHora(widget.sessao.id1,novaData,novoHorario)
                              //           //     .then((value) => Navigator.pop(context));
                              //     } else{
                              //       print("000000");
                              //       // print(element.dataSessao);
                              //       // print(element.horarioSessao);
                              //       // print(element.descSessao);
                              //       // print(novasDatas[i]);
                              //       // print(novosHorarios[i]);
                              //       // print("000000");
                              //       if ((widget.sessoes[0].dataSessao!.compareTo(novaData)!=0)
                              //       ||(widget.sessoes[0].horarioSessao!.compareTo(novoHorario)!=0)) {
                              //         // await Provider.of<SessaoProvider>(context, listen: false)
                              //         //     .updateDataEHora(widget.sessao.id1,novaData,novoHorario)
                              //         //     .then((value) => Navigator.pop(context));
                              //         print('alterou');
                              //       }
                              //
                              //     }
                              //
                              //   }
                              //
                              // });
                              //999999999999999999999999999999999999999999999999
                              // print(widget.sessoesFinal.length);
                              // widget.sessoesFinal.forEach((element) {
                              //
                              // });
                              //se só existir uma sessão checar se alterou ao menos
                              //a data ou horario.
                              // print(widget.sessoes.length);
                              // print("widget.sessoes.length");
                              // //caso tenha somente uma sessão para alterar
                              // if (widget.sessoes.length<1){
                              //   if ((widget.sessao.dataSessao!.compareTo(novaData)!=0)
                              //       ||(widget.sessao.horarioSessao!.compareTo(novoHorario)!=0)){
                              //     await Provider.of<SessaoProvider>(context, listen: false)
                              //         .updateDataEHora(widget.sessao.id1,novaData,novoHorario)
                              //         .then((value) => Navigator.pop(context));
                              //   } else {
                              //     print("mesma data");
                              //   }
                              //   //caso tenha mais de uma sessão
                              // } else{
                              //   //checar se existe uma sessão com a mesma data da nova sessçao
                              //   // não permitir 2 sessões no mesmo dia
                              //
                              //   bool contem = false;
                              //   widget.sessoes.forEach((element) {
                              //     if (element.dataSessao!.compareTo(novaData)==0){
                              //       contem=true;
                              //       print(widget.sessoes.length);
                              //       print("contem consulta nesta data");
                              //     }
                              //   });
                              //   if (contem==false){
                              //     print("não contem nesta data");
                              //
                              //     if ((widget.sessao.dataSessao!.compareTo(novaData)!=0)
                              //         ||(widget.sessao.horarioSessao!.compareTo(novoHorario)!=0)){
                              //       await Provider.of<SessaoProvider>(context, listen: false)
                              //           .updateDataEHora(widget.sessao.id1,novaData,novoHorario)
                              //           .then((value) => Navigator.pop(context));
                              //     } else {
                              //       print("mesma data");
                              //     }
                              //   } else {
                              //     messageErroData = true;
                              //     setState((){});
                              //     print("showsnack");
                              //     // _snackbar(context);
                              //     // showSnackBar("Já possui uma sessão com este paciente nesta data!");
                              //   }
                              // }

                            },
                            label: "REAGENDAR",
                            width: MediaQuery.of(context).size.width * 0.07,
                            height: MediaQuery.of(context).size.height * 0.065,
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ])
    );


  }
}

