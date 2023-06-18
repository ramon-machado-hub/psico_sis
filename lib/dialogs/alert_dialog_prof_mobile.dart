import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_paciente.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/pagamento_profissional.dart';
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
import '../model/pagamento_transacao.dart';
import '../model/sessao.dart';
import '../provider/comissao_provider.dart';
import '../provider/dias_profissional_provider.dart';
import '../provider/paciente_provider.dart';
import '../provider/pagamento_transacao_provider.dart';
import '../provider/servico_provider.dart';
import '../provider/tipo_pagamento_provider.dart';
import '../provider/transacao_provider.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/input_text_widget_mask.dart';

class DialogsProfMobile {

  static int GetDiferenceDays(String data1, String data2) {
    int dia1,
        dia2 = 0;
    int mes1,
        mes2 = 0;
    int ano1,
        ano2 = 0;
    dia1 = int.parse(data1.substring(0, 2));
    dia2 = int.parse(data2.substring(0, 2));
    mes1 = int.parse(data1.substring(3, 5));
    mes2 = int.parse(data2.substring(3, 5));
    ano1 = int.parse(data1.substring(6, 10));
    ano2 = int.parse(data2.substring(6, 10));
    final data = DateTime(ano2, mes2, dia2).difference(
        DateTime(ano1, mes1, dia1));
    print(data.inDays.toString() + " diferença");
    return data.inDays;
  }

  static Future<void> AlertDialogAgendaDoDia(
      parentContext, String uid,
      List<Sessao> sessao,
      Profissional profissional,
      DateTime data,
      List<String> horarios,
      ) {
    late int _cont =0;
    

    Future<String> getDataTransacao(BuildContext context, String id)async{
      String result = "00/00/0000";
      await Provider.of<TransacaoProvider>(context, listen: false).getTransacaoById2(id).then((value) {
        if (value!=null){
          result=value.dataTransacao;
          print("value.dataTransacao");
          print(value.dataTransacao);
          return value.dataTransacao;
        } else {
          print("00/00/0000");
          return "00/00/0000";

        }
      });
      print("return $result");
      return result;
    }

    Future<Comissao> getComissaoProfissional(BuildContext context, String id_transacao,)async{
      Comissao comissao = Comissao(
          dataPagamento: "",idTransacao: "",
          idProfissional: "", situacao: "", idPagamento: "",
          valor: "", dataGerada: "");
      await Provider.of<ComissaoProvider>(context, listen:false)
          .getComissaoByTransacao(id_transacao).then((value) {
          comissao = value;
      });

      return comissao;

    }

    Future<String> getValorTransacao(BuildContext context, String id)async{
      String result = "0,00";
      await Provider.of<TransacaoProvider>(context, listen: false).getTransacaoById2(id).then((value) {
        if (value!=null){
          result=value.valorTransacao;
          print("value.valorTransacao");
          print(value.valorTransacao);
          return value.valorTransacao;
        } else {
          print("00/00/0000");
          return "00/00/0000";

        }
      });
      print("return $result");
      return result;
    }
    bool contemSessao(String horario){
      bool result = false;
      for (int i=0;i<sessao.length;i++){
        if (sessao[i].horarioSessao!.compareTo(horario)==0){
          result = true;
        }
      }
      return result;
    }

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        useRootNavigator: false,
        builder: (BuildContext dialogContext) {
          Size size = MediaQuery
              .of(parentContext)
              .size;
          // int _cont =0;


          // int diferenca = getDiferencaDias(sessaoReagendar.dataSessao!, sessao[1].dataSessao!);
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  print(sessao.length);
                  return Container(
                    width: size.width * 0.9,
                    height: size.height * 0.8,
                    child: Column(
                      children: [
                        //close
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(padding: EdgeInsets.only(right: size.height*0.006),
                              child: Text(UtilData.obterDataDDMMAAAA(data), style: AppTextStyles.labelWhite14Lex,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(bottom: size.height*0.006),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.red,
                                          border: Border.all(color: AppColors.labelBlack)

                                      ),
                                      // alignment: Alignment.centerRight,
                                      width: size.height * 0.03,
                                      height: size.height * 0.03,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerRight,

                                        child:Icon(Icons.close),
                                      )
                                  ),
                                )
                              ),),

                          ],
                        ),
                        //listview
                        Container(
                          color: AppColors.shape,
                          width: size.width * 0.85,
                          height: size.height*((0.055*horarios.length)+((horarios.length+1)*0.006)),
                          child: ListView.builder(
                             itemCount: horarios.length,
                             itemBuilder: (BuildContext, index){
                                int diferenca = horarios.length-sessao.length;
                                if (contemSessao(horarios[index])==false){
                                  print("index = $index cont = $_cont");

                                  _cont++;
                                  return Padding(
                                    padding: EdgeInsets.only(top: size.height*0.006,right: size.height*0.01,left: size.height*0.01),
                                    child: Container(
                                        width: size.width*0.8,
                                        height: size.height*0.055,
                                        decoration: BoxDecoration(
                                            color: AppColors.line,
                                            borderRadius: BorderRadius.circular(4.0)
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width*0.1,
                                              height: size.height*0.055,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(horarios[index]),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width*0.5,
                                              height: size.height*0.055,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.center,
                                                child: Text("LIVRE"),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  );
                                } else {
                                  print("index = $index cont = $_cont");
                                    return Padding(
                                      padding: EdgeInsets.only(top: size.height*0.006,right: size.height*0.01,left: size.height*0.01),
                                      child: Container(
                                          width: size.width*0.8,
                                          height: size.height*0.055,
                                          decoration: BoxDecoration(
                                              color: AppColors.labelWhite,
                                              borderRadius: BorderRadius.circular(4.0)
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: size.width*0.1,
                                                height: size.height*0.55,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(sessao[index-_cont].horarioSessao!),
                                                ),
                                              ),
                                              //nome+descrição
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: size.width*0.45,
                                                    height: size.height*0.0275,
                                                    child: FutureBuilder(
                                                      future: Provider.of<PacienteProvider>
                                                        (parentContext,listen: false)
                                                          .getPaciente(sessao[index-_cont].idPaciente!),
                                                      builder: (context, AsyncSnapshot snapshot){
                                                        if (snapshot.hasData){
                                                          Paciente paciente = snapshot.data as Paciente;
                                                          return FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            alignment: Alignment.centerLeft,
                                                            child: (paciente.nome!.length>22)?
                                                             Text("${paciente.nome!.substring(0,21)}...",style: AppTextStyles.labelBlack12Lex)
                                                                :
                                                             Text(paciente.nome!,style: AppTextStyles.labelBlack12Lex),
                                                          );

                                                        } else {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: size.width*0.1,
                                                              height: size.height*0.06,
                                                              child: CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        }
                                                      },

                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width*0.45,
                                                    height: size.height*0.0275,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(sessao[index-_cont].descSessao!.substring(7,sessao[index-_cont].descSessao!.length), style: AppTextStyles.labelBlack12Lex,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //pagamento
                                              Container(
                                                  width: size.width*0.1,
                                                  height: size.height*0.055,
                                                  // color: AppColors.primaryColor,
                                                  child: Column(
                                                    children: [
                                                      (sessao[index-_cont].situacaoSessao!.compareTo("PAGO")==0)?
                                                      FutureBuilder(
                                                          future: getComissaoProfissional(context, sessao[index-_cont].idTransacao!),
                                                          builder: (context, AsyncSnapshot snapshot) {
                                                            if (snapshot.hasData){
                                                              Comissao result = snapshot.data as Comissao;
                                                              print(result.situacao+"result");
                                                              return Column(
                                                                children: [
                                                                  //Status + data
                                                                  SizedBox(
                                                                      width: size.width*0.1,
                                                                      height: size.height*0.0275,
                                                                      child: Row(
                                                                        children: [
                                                                          SizedBox(
                                                                              width: size.width*0.03,
                                                                              height: size.height*0.025,
                                                                              child: FittedBox(
                                                                                fit: BoxFit.scaleDown,
                                                                                child: Icon(Icons.check_circle_rounded, color: AppColors.green,),
                                                                              )
                                                                          ),

                                                                          SizedBox(
                                                                              width: size.width*0.06,
                                                                              height: size.height*0.0275,
                                                                              child: FittedBox(
                                                                                fit: BoxFit.scaleDown,
                                                                                child: (result.dataPagamento.compareTo("")==0)?Text("HOJE"):Text(result.dataPagamento.substring(0,5)),
                                                                              )
                                                                          ),
                                                                        ],
                                                                      )
                                                                  ),
                                                                  SizedBox(
                                                                      width: size.width*0.1,
                                                                      height: size.height*0.0275,
                                                                      child: Text(result.valor)
                                                                  )
                                                                ],
                                                              );
                                                            } else {
                                                              return Center(child: Text("0,00"));
                                                            }

                                                          }

                                                      )
                                                      // SizedBox(
                                                      //     width: size.width*0.1,
                                                      //     height: size.height*0.03,
                                                      //   child:Row(
                                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //     children: [
                                                      //       SizedBox(
                                                      //         width: size.width*0.03,
                                                      //         height: size.height*0.025,
                                                      //         child: FittedBox(
                                                      //           fit: BoxFit.scaleDown,
                                                      //           child: Icon(Icons.check_circle_rounded, color: AppColors.green,),
                                                      //         )
                                                      //       ),
                                                      //       SizedBox(
                                                      //         width: size.width*0.06,
                                                      //         height: size.height*0.03,
                                                      //         child: FutureBuilder(
                                                      //             future: getDataTransacao(parentContext, sessao[index].idTransacao!),
                                                      //             builder: (context, AsyncSnapshot snapshot){
                                                      //              if (snapshot.hasData){
                                                      //                 String result = snapshot.data as String;
                                                      //                 print(result+"result");
                                                      //                 return FittedBox(
                                                      //                   fit: BoxFit.scaleDown,
                                                      //                   child: Text(result.substring(0,5)),
                                                      //                 );
                                                      //              } else {
                                                      //                return Center(child: Text("N"));
                                                      //              }
                                                      //             }
                                                      //         )
                                                      //       ),
                                                      //     ],
                                                      //   )
                                                      // )
                                                          :
                                                      SizedBox(
                                                          width: size.width*0.1,
                                                          height: size.height*0.055,
                                                          child: Column(
                                                            children: [
                                                              //SizedBox(
                                                              //width: size.width*0.1,
                                                              //height: size.height*0.025,
                                                              //child:  FittedBox(
                                                              //fit: BoxFit.scaleDown,
                                                              //child: Icon(Icons.monetization_on, color: AppColors.red,),
                                                              //),
                                                              //),
                                                              SizedBox(
                                                                width: size.width*0.03,
                                                                height: size.height*0.025,
                                                                child:  FittedBox(
                                                                  fit: BoxFit.scaleDown,
                                                                  child: Icon(Icons.check_circle_rounded, color: AppColors.red,),
                                                                )
                                                              ),
                                                              SizedBox(
                                                                  width: size.width*0.1,
                                                                  height: size.height*0.03,
                                                                  child:  FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Text("AGUARDANDO"),
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                      // (sessao[index].situacaoSessao!.compareTo("PAGO")==0)?
                                                      // SizedBox(
                                                      //     width: size.width*0.1,
                                                      //     height: size.height*0.03,
                                                      //     child: FittedBox(
                                                      //         fit: BoxFit.scaleDown,
                                                      //         child:  FutureBuilder(
                                                      //             future: getComissaoProfissional(parentContext, sessao[index].idTransacao!),
                                                      //             builder: (context, AsyncSnapshot snapshot){
                                                      //               if (snapshot.hasData){
                                                      //                 Comissao result = snapshot.data as Comissao;
                                                      //                 print(result.situacao+"result");
                                                      //                 return FittedBox(
                                                      //                   fit: BoxFit.scaleDown,
                                                      //                   child: Text(result.valor),
                                                      //                 );
                                                      //               } else {
                                                      //                 return Center(child: Text("0,00"));
                                                      //               }
                                                      //             }
                                                      //         )
                                                      //         // FutureBuilder(
                                                      //         //     future: getValorTransacao(parentContext, sessao[index].idTransacao!),
                                                      //         //     builder: (context, AsyncSnapshot snapshot){
                                                      //         //       if (snapshot.hasData){
                                                      //         //         String result = snapshot.data as String;
                                                      //         //         print(result+"result");
                                                      //         //         return FittedBox(
                                                      //         //           fit: BoxFit.scaleDown,
                                                      //         //           child: Text(result),
                                                      //         //         );
                                                      //         //       } else {
                                                      //         //         return Center(child: Text("0,00"));
                                                      //         //       }
                                                      //         //     }
                                                      //         // )
                                                      //     )
                                                      // )
                                                      //     :
                                                      // SizedBox(
                                                      //     width: size.width*0.1,
                                                      //     height: size.height*0.03,
                                                      //     child: FittedBox(
                                                      //         fit: BoxFit.scaleDown,
                                                      //         child:Text("AGUARDANDO")
                                                      //     )
                                                      // )

                                                    ],
                                                  )
                                              )
                                            ],
                                          )
                                      ),
                                    );
                                }
                                return Padding(
                                    padding: EdgeInsets.only(top: size.height*0.01,right: size.height*0.01,left: size.height*0.01),
                                    child:
                                    (contemSessao(horarios[index])==false)?
                                    Container(
                                        width: size.width*0.8,
                                        height: size.height*0.06,
                                        decoration: BoxDecoration(
                                            color: AppColors.labelWhite,
                                            borderRadius: BorderRadius.circular(4.0)
                                        ),
                                        child: Text("LIVRE $index ${horarios[index]}")
                                    ):
                                      Container(
                                          width: size.width*0.8,
                                          height: size.height*0.06,
                                          decoration: BoxDecoration(
                                              color: AppColors.labelWhite,
                                              borderRadius: BorderRadius.circular(4.0)
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: size.width*0.1,
                                                height: size.height*0.06,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(sessao[index].horarioSessao!),
                                                ),
                                              ),
                                              //nome+descrição
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: size.width*0.5,
                                                    height: size.height*0.03,
                                                    child: FutureBuilder(
                                                      future: Provider.of<PacienteProvider>
                                                        (parentContext,listen: false)
                                                          .getPaciente(sessao[index].idPaciente!),
                                                      builder: (context, AsyncSnapshot snapshot){
                                                        if (snapshot.hasData){
                                                          Paciente paciente = snapshot.data as Paciente;
                                                          return FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(paciente.nome!),
                                                          );

                                                        } else {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: size.width*0.1,
                                                              height: size.height*0.06,
                                                              child: CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        }
                                                      },

                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width*0.5,
                                                    height: size.height*0.03,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(sessao[index].descSessao!.substring(7,sessao[index].descSessao!.length)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //pagamento
                                              Container(
                                              width: size.width*0.1,
                                              height: size.height*0.06,
                                              // color: AppColors.primaryColor,
                                              child: Column(
                                                children: [
                                                  (sessao[index].situacaoSessao!.compareTo("PAGO")==0)?
                                                   FutureBuilder(
                                                      future: getComissaoProfissional(context, sessao[index].idTransacao!),
                                                       builder: (context, AsyncSnapshot snapshot) {
                                                         if (snapshot.hasData){
                                                           Comissao result = snapshot.data as Comissao;
                                                           print(result.situacao+"result");
                                                           return Column(
                                                             children: [
                                                               //Status + data
                                                               SizedBox(
                                                                 width: size.width*0.1,
                                                                 height: size.height*0.03,
                                                                 child: Row(
                                                                   children: [
                                                                     SizedBox(
                                                                         width: size.width*0.03,
                                                                         height: size.height*0.025,
                                                                         child: FittedBox(
                                                                           fit: BoxFit.scaleDown,
                                                                           child: Icon(Icons.check_circle_rounded, color: AppColors.green,),
                                                                         )
                                                                     ),

                                                                     SizedBox(
                                                                         width: size.width*0.06,
                                                                         height: size.height*0.03,
                                                                         child: FittedBox(
                                                                           fit: BoxFit.scaleDown,
                                                                           child: (result.dataPagamento.compareTo("")==0)?Text("HOJE"):Text(result.dataPagamento.substring(0,5)),
                                                                         )
                                                                     ),
                                                                   ],
                                                                 )
                                                               ),
                                                               SizedBox(
                                                                   width: size.width*0.1,
                                                                   height: size.height*0.03,
                                                                   child: Text(result.valor)
                                                               )
                                                             ],
                                                           );
                                                         } else {
                                                           return Center(child: Text("0,00"));
                                                         }

                                                       }

                                                   )
                                                   // SizedBox(
                                                   //     width: size.width*0.1,
                                                   //     height: size.height*0.03,
                                                   //   child:Row(
                                                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   //     children: [
                                                   //       SizedBox(
                                                   //         width: size.width*0.03,
                                                   //         height: size.height*0.025,
                                                   //         child: FittedBox(
                                                   //           fit: BoxFit.scaleDown,
                                                   //           child: Icon(Icons.check_circle_rounded, color: AppColors.green,),
                                                   //         )
                                                   //       ),
                                                   //       SizedBox(
                                                   //         width: size.width*0.06,
                                                   //         height: size.height*0.03,
                                                   //         child: FutureBuilder(
                                                   //             future: getDataTransacao(parentContext, sessao[index].idTransacao!),
                                                   //             builder: (context, AsyncSnapshot snapshot){
                                                   //              if (snapshot.hasData){
                                                   //                 String result = snapshot.data as String;
                                                   //                 print(result+"result");
                                                   //                 return FittedBox(
                                                   //                   fit: BoxFit.scaleDown,
                                                   //                   child: Text(result.substring(0,5)),
                                                   //                 );
                                                   //              } else {
                                                   //                return Center(child: Text("N"));
                                                   //              }
                                                   //             }
                                                   //         )
                                                   //       ),
                                                   //     ],
                                                   //   )
                                                   // )
                                                      :
                                                  SizedBox(
                                                      width: size.width*0.1,
                                                      height: size.height*0.06,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: size.width*0.1,
                                                            height: size.height*0.03,
                                                            child:  Icon(Icons.monetization_on, color: AppColors.red,),
                                                          ),
                                                          SizedBox(
                                                            width: size.width*0.1,
                                                            height: size.height*0.03,
                                                            child:  FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("AGUARDANDO"),
                                                            )
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  // (sessao[index].situacaoSessao!.compareTo("PAGO")==0)?
                                                  // SizedBox(
                                                  //     width: size.width*0.1,
                                                  //     height: size.height*0.03,
                                                  //     child: FittedBox(
                                                  //         fit: BoxFit.scaleDown,
                                                  //         child:  FutureBuilder(
                                                  //             future: getComissaoProfissional(parentContext, sessao[index].idTransacao!),
                                                  //             builder: (context, AsyncSnapshot snapshot){
                                                  //               if (snapshot.hasData){
                                                  //                 Comissao result = snapshot.data as Comissao;
                                                  //                 print(result.situacao+"result");
                                                  //                 return FittedBox(
                                                  //                   fit: BoxFit.scaleDown,
                                                  //                   child: Text(result.valor),
                                                  //                 );
                                                  //               } else {
                                                  //                 return Center(child: Text("0,00"));
                                                  //               }
                                                  //             }
                                                  //         )
                                                  //         // FutureBuilder(
                                                  //         //     future: getValorTransacao(parentContext, sessao[index].idTransacao!),
                                                  //         //     builder: (context, AsyncSnapshot snapshot){
                                                  //         //       if (snapshot.hasData){
                                                  //         //         String result = snapshot.data as String;
                                                  //         //         print(result+"result");
                                                  //         //         return FittedBox(
                                                  //         //           fit: BoxFit.scaleDown,
                                                  //         //           child: Text(result),
                                                  //         //         );
                                                  //         //       } else {
                                                  //         //         return Center(child: Text("0,00"));
                                                  //         //       }
                                                  //         //     }
                                                  //         // )
                                                  //     )
                                                  // )
                                                  //     :
                                                  // SizedBox(
                                                  //     width: size.width*0.1,
                                                  //     height: size.height*0.03,
                                                  //     child: FittedBox(
                                                  //         fit: BoxFit.scaleDown,
                                                  //         child:Text("AGUARDANDO")
                                                  //     )
                                                  // )

                                                ],
                                              )
                                            )
                                          ],
                                        )
                                      )
                                        // :

                                  );
                              }
                          ),
                        )
                      //Saldo do Dia
                      ],
                    ),
                  );
                }),
          );
        }
    );
  }
}