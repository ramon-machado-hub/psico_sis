import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/Especialidade.dart';
import 'package:psico_sis/model/despesa.dart';
import 'package:psico_sis/model/pacientes_parceiros.dart';
import 'package:psico_sis/model/pagamento_profissional.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/model/tipo_pagamento.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/categoria_despesa_provider.dart';
import 'package:psico_sis/provider/despesa_provider.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/provider/paciente_parceiro_provider.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/pagamento_profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/provider/transacao_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/button_disable_widget.dart';

import '../dialogs/alert_dialog_agenda.dart';
import '../model/Paciente.dart';
import '../model/Parceiro.dart';
import '../model/Profissional.dart';
import '../model/categoria_despesa.dart';
import '../model/comissao.dart';
import '../model/log_sistema.dart';
import '../model/servico.dart';
import '../model/sessao.dart';
import '../provider/comissao_provider.dart';
import '../provider/log_provider.dart';
import '../provider/parceiro_provider.dart';
import '../provider/servico_profissional_provider.dart';
import '../provider/sessao_provider.dart';
import '../provider/tipo_pagamento_provider.dart';
import '../themes/app_text_styles.dart';
import 'button_widget.dart';
import 'drop_down_widget.dart';
import 'input_text_lower_widget.dart';
import 'input_text_uper_widget.dart';
import 'input_text_widget.dart';
import 'input_text_widget2.dart';
import 'input_text_widget_mask.dart';
import 'list_hours_widget.dart';

class Dialogs {

  static Future<void> AlertDialogExtrato(
      parentContext,
      List<Comissao> listComissao,
      List<Profissional> listProf,
      List<Paciente> listPaciente,
      List<TransacaoCaixa> listTransacao,
      List<Sessao> listSessao,
      DateTime dataCorrente
      ) {

    ScrollController controllerProfissional = ScrollController();
    ScrollController controllerSessoes = ScrollController();
    DateTime diaCorrente = DateTime.now();
    List<Profissional> profDoDia = [];
    List<Sessao> sessaoDoProfissional = [];
    List<Comissao> comissaoDoProfissional = [];
    Profissional profissionalSelecionado;
    String dropdownProfissional = "";
    String saldoDoDia = "0,00";
    bool processandoSaldo = false;

    List<Comissao> getListComissaoDoProfissional(String id){
      List<Comissao> list = [];
      // listComissao.forEach((element) {
      print("getListComissaoDoProfissional $id");
      print(listComissao.length);
      print(sessaoDoProfissional.length);

      for (int j =0; j<listComissao.length;j++){

        if (listComissao[j].idProfissional.compareTo(id)==0){
           String transacao = listComissao[j].idTransacao;
           bool result = false;
           for (int i =0; i<sessaoDoProfissional.length;i++){
             if (sessaoDoProfissional[i].idTransacao!.compareTo(transacao)==0){
               result = true;
               print("achou");
             }
           }

           if (!result){
             print("não achou");
             list.add(listComissao[j]);

           }
         }
      }
      return list;
    }

    List<Sessao> getListSessaoDoProfissional(String id) {
      List<Sessao> list = [];
      listSessao.forEach((element) {
         if (element.idProfissional!.compareTo(id)==0){
           list.add(element);
         }
      });
      list.sort((a,b) {
        int aHora = int.parse(a.horarioSessao!.substring(0,2));
        int aMin = 0;
        int bHora = int.parse(b.horarioSessao!.substring(0,2));
        int bMin = 0;
        if (aHora==bHora){
          return aMin.compareTo(bMin);
        } else {
          return aHora.compareTo(bHora);
        }
      });
      list.forEach((element) {
         print(element.horarioSessao);
      });
      print("--------");
      return list;
    }

    List<Profissional> getListProfDoDia(DateTime dia){
         List<Profissional> result = [];
         List<String> listId = [];
         listProf.forEach((element) {
          listSessao.map((e) => e.idProfissional).forEach((element1) {
            // if (element1.
            if (listId.contains(element1)==false){
              listId.add(element1!);
            }
          });
         });
         listId.forEach((element) {
            result.add(listProf.firstWhere((element1) => element1.id1.compareTo(element)==0));
         });
         result.sort((a,b)=>a.nome!.compareTo(b.nome!));
         return result;
    }

    String getNomePaciente(String id){
      String result ="";
      result = listPaciente.firstWhere((element) => element.id1.compareTo(id)==0).nome!;
      return result;
    }


    bool avanca(){
      DateTime hoje = DateTime.now();
      if(dataCorrente.year<hoje.year){
        return true;
      } else if (dataCorrente.month<hoje.month){
        return true;
      } else if((dataCorrente.month==hoje.month)&&(dataCorrente.day<hoje.day)){
        return true;
      }
      return false;
    }

    Profissional getProfByName(String nome){
      Profissional profissional = Profissional(
        nome: "NÃO ENCONTROU"
      );
      listProf.forEach((element) {
        if (element.nome!.compareTo(nome)==0){
           profissional = element;
        }
      });
      return profissional;

    }

    List<DropdownMenuItem<String>> getDropdownProfissionaisDoDia(List<Profissional> list, Size size) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].nome.toString(),
          child: SizedBox(
            width: size.width*0.22,
            child: Text(list[i].nome.toString(),),
          )
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    Future<String> getNomePacienteByTransacaoComissao(String id)async{
        String nome ="";
       await Provider.of<TransacaoProvider>(parentContext, listen: false)
            .getTransacaoById2(id).then((value) async {
             await Provider.of<PacienteProvider>(parentContext, listen: false).getPaciente(value!.idPaciente).then((value) {
                 nome = value.nome!;
             });
        });
       return nome;
    }

    Future<String> getDescServicoByTransacaoComissao(String id)async{
      String desc ="";
      await Provider.of<TransacaoProvider>(parentContext, listen: false)
          .getTransacaoById2(id).then((value) async {
           desc = value!.descricaoTransacao;
      });
      return desc;
    }

    Future<String> getValorTransacao(String id)async{
      String valor ="";
      await Provider.of<TransacaoProvider>(parentContext, listen: false)
          .getTransacaoById2(id).then((value) async {
        valor = value!.valorTransacao;
      });
      return valor;
    }

    Future <String> getSaldoDoDia() async{
      processandoSaldo = true;
      String valorAtual = "";
      double saldo = 0;
      print(sessaoDoProfissional.length);
      for (int i =0; i<sessaoDoProfissional.length; i++ ){

        if ((sessaoDoProfissional[i].situacaoSessao!.compareTo("PAGO")==0)
        ){
          
          await Provider.of<ComissaoProvider>(parentContext, listen: false)
              .getComissaoByTransacao(sessaoDoProfissional[i].idTransacao!).then((value) {
            if ((value.dataPagamento.compareTo("")==0)||(value.dataPagamento.compareTo(UtilData.obterDataDDMMAAAA(dataCorrente))==0)){
              print(UtilData.obterDataDDMMAAAA(dataCorrente)+" dataCorrente");
              print( value.valor);
              valorAtual = value.valor.replaceAll(',', '.');
              print("add $valorAtual");
              saldo += NumberFormat().parse(valorAtual);
            } else {
              print(value.id1);
              print(UtilData.obterDataDDMMAAAA(dataCorrente)+" dataCorrente");
              print("nao add ${value.dataPagamento}");
            }

          });
        }

      }

      for(int i=0; i<comissaoDoProfissional.length;i++){
        valorAtual = comissaoDoProfissional[i].valor.replaceAll(',', '.');
        saldo += NumberFormat().parse(valorAtual);
      }

       print("Saldo = $saldo");
      processandoSaldo = false;
      return UtilBrasilFields.obterReal(saldo);
    }

    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
        context: parentContext,
        builder: (context) {
          profDoDia = getListProfDoDia(diaCorrente);
          profissionalSelecionado =  profDoDia.first;
          dropdownProfissional = profDoDia.first.nome!;

          sessaoDoProfissional = getListSessaoDoProfissional(profDoDia.first.id1);
          comissaoDoProfissional = getListComissaoDoProfissional(profDoDia.first.id1);
          // saldoDoDia = getSaldoDoDia();
            return StatefulBuilder(
                builder: (parentContext,setState)=>AlertDialog(
                  title: Container(
                    // color: AppColors.red,
                    width: size.width*0.9,
                    height: size.height*0.75,
                    child: Column(
                      children: [
                        //CABEÇALHO
                        Text("EXTRATO PROFISSIONAL "),

                        Divider(thickness: 3,),

                        //detalhes + sessões
                        Container(
                          // color: AppColors.blue,

                          width: size.width*0.8,
                          height: size.height*0.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // color: AppColors.labelBlack,
                                width: size.width*0.29,
                                height: size.height*0.64,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // color: Colors.red,
                                          width: size.width*0.02,
                                          height: size.height*0.04,
                                          child: InkWell(
                                            child: Container(
                                              width: size.width*0.02,
                                              height: size.height*0.03,
                                              alignment: Alignment.center,
                                              // margin: EdgeInsets.all(100.0),
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Icon(
                                                size: size.height*0.03,
                                                Icons.keyboard_double_arrow_left,
                                                color: AppColors.labelBlack,
                                              ),

                                            ),
                                            onTap: () async{
                                              String dia = DateFormat('EEEE').format(dataCorrente);
                                              print(dia);
                                              listComissao.clear();
                                              if (dia.compareTo("Monday")==0) {
                                                print("-3");

                                                dataCorrente = dataCorrente.subtract(Duration(days: 3));
                                              } else{
                                                print("-1");
                                                dataCorrente = dataCorrente.subtract(Duration(days: 1));
                                              }
                                              await Provider.of<ComissaoProvider>(context, listen:false)
                                                  .getComissaoDoDia(UtilData.obterDataDDMMAAAA(dataCorrente)).then((value) {
                                                listComissao = value;
                                                print(listComissao.length.toString()+"!!!");
                                              });
                                              profDoDia.clear();
                                              comissaoDoProfissional.clear();
                                              await  Provider.of<SessaoProvider>(context, listen: false)
                                                  .getListSessoesDoDia(UtilData.obterDataDDMMAAAA(dataCorrente)).then((value){
                                                print("aaaadddd");
                                                listSessao.clear();
                                                listSessao = value;
                                                profDoDia.clear();
                                                profDoDia = getListProfDoDia(dataCorrente);
                                                profissionalSelecionado =  profDoDia.first;
                                                sessaoDoProfissional = getListSessaoDoProfissional(profDoDia.first.id1);
                                                comissaoDoProfissional = getListComissaoDoProfissional(profDoDia.first.id1);

                                                // comissaoDoProfissional = gelListComissaoDoProfissional(profDoDia.firs.id1);
                                                // comis
                                                dropdownProfissional =  profDoDia.first.nome!;
                                                // Dialogs.AlertDialogExtrato(context,_lprofissionais, _lpacientes, _transacoesCaixaDoDia, sessoesDoDia,_dataCorrente);

                                              });
                                              setState((){});
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width*0.05,
                                          height: size.height*0.06,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(UtilData.obterDataDDMMAAAA(dataCorrente).substring(0,5))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.red,
                                          width: size.width*0.02,
                                          height: size.height*0.04,
                                          child: InkWell(
                                            child: Container(
                                              width: size.width*0.02,
                                              height: size.height*0.03,
                                              alignment: Alignment.center,
                                              // margin: EdgeInsets.all(100.0),
                                              decoration: BoxDecoration(
                                                  color: avanca()?AppColors.primaryColor: AppColors.line,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Icon(
                                                size: size.height*0.03,
                                                Icons.keyboard_double_arrow_right,
                                                color: AppColors.labelBlack,
                                              ),

                                            ),
                                            onTap: avanca()?()async{
                                              String dia = DateFormat('EEEE').format(dataCorrente);
                                              print(dia);
                                              listComissao.clear();
                                              if (dia.compareTo("Friday")==0) {
                                                print("+3");

                                                dataCorrente = dataCorrente.add(Duration(days: 3));

                                              } else{
                                                print("+1");

                                                dataCorrente = dataCorrente.add(Duration(days: 1));
                                              }
                                              await Provider.of<ComissaoProvider>(context, listen:false)
                                                  .getComissaoDoDia(UtilData.obterDataDDMMAAAA(dataCorrente)).then((value) {
                                                listComissao = value;
                                                print(listComissao.length.toString()+"!!!");
                                              });
                                              // dataCorrente = dataCorrente.add(Duration(days: 1));
                                              profDoDia.clear();
                                              comissaoDoProfissional.clear();
                                              await  Provider.of<SessaoProvider>(context, listen: false)
                                                  .getListSessoesDoDia(UtilData.obterDataDDMMAAAA(dataCorrente)).then((value){
                                                listSessao.clear();
                                                profDoDia.clear();
                                                listSessao = value;
                                                profDoDia = getListProfDoDia(dataCorrente);
                                                profissionalSelecionado =  profDoDia.first;
                                                sessaoDoProfissional = getListSessaoDoProfissional(profDoDia.first.id1);
                                                comissaoDoProfissional = getListComissaoDoProfissional(profDoDia.first.id1);

                                                dropdownProfissional =  profDoDia.first.nome!;
                                                //  listSessao.clear();
                                                //                                         listSessao = value;
                                                //                                         profDoDia.clear();
                                                //                                         profDoDia = getListProfDoDia(dataCorrente);
                                                //                                         profissionalSelecionado =  profDoDia.first;
                                                //                                         sessaoDoProfissional = getListSessaoDoProfissional(profDoDia.first.id1);
                                                //                                         dropdownProfissional =  profDoDia.first.nome!;

                                              });
                                              setState((){});
                                            }:null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height*0.02,
                                    ),
                                    //dropdown
                                    Text("Selecione um PROFISSIONAL", style: AppTextStyles.labelBlack12Lex),
                                    Container(
                                      // color: Colors.red,
                                      width: size.width*0.25,
                                      height: size.height*0.06,
                                      child: DropdownButton<String>(
                                        value: dropdownProfissional,
                                        icon:  SizedBox(
                                          width: size.width*0.03,
                                          // alignment: Alignment.centerRight,
                                          child: Center(
                                            child:Icon(Icons.arrow_drop_down_sharp),),
                                        ),
                                        elevation: 16,
                                        style: TextStyle(color: AppColors.labelBlack),
                                        underline: Container(

                                          height: 2,
                                          color: AppColors.line,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownProfissional = newValue!;
                                            profissionalSelecionado = getProfByName(dropdownProfissional);
                                            sessaoDoProfissional.clear();
                                            comissaoDoProfissional.clear();
                                            sessaoDoProfissional = getListSessaoDoProfissional(profissionalSelecionado.id1);
                                            comissaoDoProfissional = getListComissaoDoProfissional(profissionalSelecionado.id1);

                                          });
                                        },
                                        items: getDropdownProfissionaisDoDia(profDoDia, size),
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: size.height*0.02,
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      width: size.width*0.25,
                                      height: size.height*0.25,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("PROFISSIONAL", style: AppTextStyles.labelBlack14Lex),
                                          Text(profissionalSelecionado.nome!, style: AppTextStyles.labelBlack20Lex),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("DATA: ", style: AppTextStyles.labelBlack14Lex),
                                              Text(UtilData.obterDataDDMMAAAA(dataCorrente), style: AppTextStyles.labelBlack16Lex)
                                            ],
                                          ),
                                          FutureBuilder(
                                              future: getSaldoDoDia(),
                                              builder: (BuildContext parentContext, AsyncSnapshot snapshot2){
                                                if (snapshot2.hasData) {
                                                  String result =  snapshot2.data as String;
                                                  if (processandoSaldo){
                                                    return CircularProgressIndicator();
                                                  }
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("SALDO DO DIA: ",style: AppTextStyles.labelBlack14Lex,),
                                                      Text(result, style: AppTextStyles.labelBlack20Lex,)
                                                    ],
                                                  );
                                                } else {
                                                  return Center();
                                                }
                                              }
                                          )

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: size.width*0.51,
                                  height: size.height*0.64,
                                  decoration: BoxDecoration(
                                      color: AppColors.shape,
                                      borderRadius: BorderRadius.circular(6.0)
                                  ),
                                  child: ListView.builder(
                                      itemCount: sessaoDoProfissional.length+comissaoDoProfissional.length,
                                      controller: controllerSessoes,

                                      itemBuilder: (buidContext,index){
                                        print(comissaoDoProfissional.length.toString()+"c");
                                        if (index<sessaoDoProfissional.length){
                                          return Padding(
                                            padding: EdgeInsets.all(size.height*0.005),
                                            child: Container(
                                              height: size.height*0.06,
                                              width: size.width*0.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.0),
                                                color: AppColors.labelWhite,
                                              ),
                                              child: Row(
                                                children: [
                                                  //horário
                                                  SizedBox(
                                                      height: size.height*0.06,
                                                      width: size.width*0.05,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: size.height*0.03,
                                                            width: size.width*0.05,
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text(sessaoDoProfissional[index].horarioSessao!),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: size.height*0.03,
                                                            width: size.width*0.05,
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text(sessaoDoProfissional[index].descSessao!.substring(6,11),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  //nome + descricao serviço
                                                  SizedBox(
                                                    height: size.height*0.06,
                                                    width: size.width*0.25,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      // mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: size.height*0.03,
                                                          width: size.width*0.3,
                                                          child: Text(getNomePaciente(sessaoDoProfissional[index].idPaciente!)),
                                                        ),
                                                        SizedBox(
                                                            height: size.height*0.03,
                                                            width: size.width*0.3,
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(sessaoDoProfissional[index].descSessao!.substring(11,sessaoDoProfissional[index].descSessao!.length), style: AppTextStyles.labelBlack12Lex,),
                                                            )
                                                        ),


                                                      ],
                                                    ),
                                                  ),

                                                  //pagamento
                                                  SizedBox(
                                                    height: size.height*0.06,
                                                    width: size.width*0.2,
                                                    child:  FutureBuilder(
                                                        future: Provider.of<TransacaoProvider>(parentContext, listen: false).getTransacaoById2(sessaoDoProfissional[index].idTransacao!),
                                                        builder: (BuildContext parentContext, AsyncSnapshot snapshot) {
                                                          if (snapshot.hasData) {
                                                            TransacaoCaixa result =  snapshot.data as TransacaoCaixa;
                                                            String data = result.dataTransacao;
                                                            return FutureBuilder(
                                                                future: Provider.of<ComissaoProvider>(parentContext, listen: false).getComissaoByTransacao(result.id1),
                                                                builder: (BuildContext parentContext, AsyncSnapshot snapshot1){
                                                                  if (snapshot1.hasData) {
                                                                    Comissao comissao = snapshot1.data as Comissao;
                                                                    return
                                                                      // (data.compareTo(UtilData.obterDataDDMMAAAA(dataCorrente))==0)
                                                                      ((comissao.dataPagamento.compareTo(UtilData.obterDataDDMMAAAA(dataCorrente))==0)
                                                                          || (comissao.dataPagamento.compareTo("")==0)
                                                                      )
                                                                          ?
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            height: size.height*0.03,
                                                                            width: size.width*0.2,
                                                                            child: FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              child: (sessaoDoProfissional[index].situacaoSessao!.compareTo("PAGO")!=0)?
                                                                              Text("COMISSAO: R\$ "+comissao.valor,style: AppTextStyles.labelRed12Lex,)
                                                                                  :
                                                                              Text("COMISSAO: R\$ "+comissao.valor,style: AppTextStyles.labelBlack12Lex,),
                                                                              // child: Text(sessaoDoProfissional[index].situacaoSessao!+" R\$ "+result.valorTransacao),
                                                                            ),
                                                                          ),

                                                                          SizedBox(
                                                                            height: size.height*0.03,
                                                                            width: size.width*0.2,
                                                                            child: FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              //red
                                                                              // child: (comissao.situacao.compareTo("PENDENTE")==0)?
                                                                              child: (sessaoDoProfissional[index].situacaoSessao!.compareTo("PAGO")!=0)?
                                                                              Text(comissao.situacao+" R\$ "+result.valorTransacao,style: AppTextStyles.labelRed12Lex,):
                                                                              Text(sessaoDoProfissional[index].situacaoSessao!+" R\$ "+result.valorTransacao+"   |   DIA "+result.dataTransacao,style: AppTextStyles.labelBlack12Lex,),
                                                                              // Text(comissao.situacao+" "+sessaoDoProfissional[index].situacaoSessao!+" R\$ "+result.valorTransacao+"   |    DIA "+result.dataTransacao,style: AppTextStyles.labelBlack12Lex,),
                                                                              // child: Text(" DIA "+result.dataTransacao+"   |   "+sessaoDoProfissional[index].situacaoSessao!+" R\$ "+result.valorTransacao,style: AppTextStyles.labelBlack16Lex,),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                          :
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,

                                                                        children: [
                                                                          SizedBox(
                                                                            height: size.height*0.03,
                                                                            width: size.width*0.2,
                                                                            child: FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              child: (sessaoDoProfissional[index].situacaoSessao!.compareTo("PAGO")!=0)?
                                                                              Text("COMISSAO: R\$ " +comissao.valor,style: AppTextStyles.labelRed12Lex,)
                                                                                  :
                                                                              Text("COMISSAO: R\$ " +comissao.valor,style: AppTextStyles.labelLine12Lex,),
                                                                              // child: Text(sessaoDoProfissional[index].situacaoSessao!+" R\$ "+result.valorTransacao),
                                                                            ),

                                                                          ),
                                                                          SizedBox(
                                                                            height: size.height*0.03,
                                                                              width: size.width*0.2,
                                                                            child: FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              // child: (comissao.situacao.compareTo("PENDENTE")==0)?
                                                                              child: (sessaoDoProfissional[index].situacaoSessao!.compareTo("PAGO")!=0)?
                                                                              Text(comissao.situacao+" R\$ "+result.valorTransacao,style: AppTextStyles.labelRed12Lex,)
                                                                                  :
                                                                              Text(sessaoDoProfissional[index].situacaoSessao!+" R\$ "+result.valorTransacao+"   |   DIA "+result.dataTransacao,style: AppTextStyles.labelLine12Lex,),
                                                                            ),

                                                                          ),

                                                                        ],
                                                                      );
                                                                  }  else {
                                                                    return SizedBox(
                                                                      width: 15,
                                                                      height: 15,
                                                                      child: CircularProgressIndicator(),
                                                                    );
                                                                  }
                                                                });
                                                            // return Text(" "+result.valorTransacao+" DIA "+result.dataTransacao);
                                                          }else {
                                                            return Center(
                                                                child: Text(sessaoDoProfissional[index].situacaoSessao!, style: AppTextStyles.labelRed12Lex,)
                                                            );
                                                          }
                                                        }
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.all(size.height*0.005),
                                              child:  Container(
                                                height: size.height*0.06,
                                                width: size.width*0.5,
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.0),
                                                color: AppColors.labelWhite,),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width*0.05,
                                                    ),
                                                    //nome+serviço
                                                    SizedBox(
                                                      height: size.height*0.06,
                                                      width: size.width*0.25,
                                                      child:  Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,

                                                        children: [
                                                          FutureBuilder(
                                                              future: getNomePacienteByTransacaoComissao(comissaoDoProfissional[index-sessaoDoProfissional.length].idTransacao),
                                                              builder: (BuildContext parentContext, AsyncSnapshot snapshot2){
                                                                if (snapshot2.hasData) {
                                                                  String nomePaciente = snapshot2.data as String;
                                                                  return Text(nomePaciente);
                                                                } else {
                                                                  return Center();
                                                                }
                                                              }
                                                          ),

                                                          FutureBuilder(
                                                              future:  getDescServicoByTransacaoComissao(comissaoDoProfissional[index-sessaoDoProfissional.length].idTransacao),
                                                              builder: (BuildContext parentContext, AsyncSnapshot snapshot2){
                                                                if (snapshot2.hasData) {
                                                                  String descricao = snapshot2.data as String;
                                                                  return Text(descricao, style: AppTextStyles.labelBlack12Lex,);
                                                                } else {
                                                                  return Center();
                                                                }
                                                              }
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //pagamento
                                                    SizedBox(
                                                        height: size.height*0.06,
                                                        width: size.width*0.2,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,

                                                          children: [
                                                            Text("COMISSÃO: R\$ "+comissaoDoProfissional[index-sessaoDoProfissional.length].valor,style: AppTextStyles.labelBlack12Lex,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,

                                                              children: [
                                                                Text("PAGO: R\$ ",style: AppTextStyles.labelBlack12Lex,),
                                                                FutureBuilder(
                                                                    future:  getValorTransacao(comissaoDoProfissional[index-sessaoDoProfissional.length].idTransacao),
                                                                    builder: (BuildContext parentContext, AsyncSnapshot snapshot){
                                                                      if (snapshot.hasData) {
                                                                        String valor = snapshot.data as String;
                                                                        return Text(valor, style: AppTextStyles.labelBlack12Lex,);
                                                                      } else {
                                                                        return Center();
                                                                      }
                                                                    }
                                                                ),
                                                                Text("  |  DIA ${UtilData.obterDataDDMMAAAA(dataCorrente)}",style: AppTextStyles.labelBlack12Lex,),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                    ),


                                                  ],
                                                ),
                                          )
                                          );
                                        }

                                        // return Padding(padding: EdgeInsets.only(top:size.height*0.001),
                                        //   child: Container(
                                        //     height: size.height*0.05,
                                        //     width: size.width*0.7,
                                        //     color: AppColors.line,
                                        //     child: ListTile(
                                        //         title: Row(
                                        //           children: [
                                        //             Text(sessaoDoProfissional[index].horarioSessao!+" "),
                                        //
                                        //             Text(getNomePaciente(sessaoDoProfissional[index].idPaciente!)),
                                        //           ],
                                        //         ),
                                        //         subtitle: Row(
                                        //           crossAxisAlignment: CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(sessaoDoProfissional[index].descSessao!),
                                        //
                                        //             Row(
                                        //               children: [
                                        //                 Text(sessaoDoProfissional[index].situacaoSessao!+" | "),
                                        //                 FutureBuilder(
                                        //                     future: Provider.of<TransacaoProvider>(parentContext, listen: false).getTransacaoById2(sessaoDoProfissional[index].idTransacao!),
                                        //                     builder: (BuildContext parentContext, AsyncSnapshot snapshot) {
                                        //                       if (snapshot.hasData) {
                                        //                         TransacaoCaixa result =  snapshot.data as TransacaoCaixa;
                                        //                         return FutureBuilder(
                                        //                             future: Provider.of<ComissaoProvider>(parentContext, listen: false).getComissaoByTransacao(result.id1),
                                        //                             builder: (BuildContext parentContext, AsyncSnapshot snapshot1){
                                        //                               if (snapshot1.hasData) {
                                        //                                 Comissao comissao = snapshot1.data as Comissao;
                                        //                                 return Text(" R\$ "+result.valorTransacao+ " DIA "+result.dataTransacao+" | COMISSAO: R\$ " +comissao.valor+" ");
                                        //                               }  else {
                                        //                                 return SizedBox(
                                        //                                   width: 15,
                                        //                                   height: 15,
                                        //                                   child: CircularProgressIndicator(),
                                        //                                 );
                                        //                               }
                                        //                             });
                                        //                         // return Text(" "+result.valorTransacao+" DIA "+result.dataTransacao);
                                        //                       }else {
                                        //                         return Center(
                                        //                             child: Text("")
                                        //                         );
                                        //                       }
                                        //                     }
                                        //                 ),
                                        //               ],
                                        //
                                        //             ),
                                        //
                                        //           ],
                                        //         )
                                        //     ),
                                        //   ),
                                        // );
                                      }),
                              ),
                            ],
                          ),
                        ),

                        // saldo do dia
                        // Container(
                        //     color: AppColors.labelWhite,
                        //     width: size.width*0.8,
                        //     height: size.height*0.06,
                        //
                        //     child: Align(
                        //         alignment: Alignment.centerRight,
                        //         child: Padding(
                        //             padding: EdgeInsets.only(right: size.width*0.004),
                        //             child: FutureBuilder(
                        //                 future: getSaldoDoDia(),
                        //                 builder: (BuildContext parentContext, AsyncSnapshot snapshot2){
                        //                   if (snapshot2.hasData) {
                        //                     String result =  snapshot2.data as String;
                        //                     if (processandoSaldo){
                        //                       return CircularProgressIndicator();
                        //                     }
                        //                     return Text("Saldo do dia R\$ $result");
                        //                   } else {
                        //                     return Center();
                        //                   }
                        //                 }
                        //             )
                        //           // Text("Saldo do dia: R\$ 0,00", style: AppTextStyles.labelBlack16Lex,),
                        //         )
                        //     )
                        // ),

                      ],
                    )
                  ),
                  actions:<Widget> [
                    ButtonWidget(
                      onTap: ()async{
                        Navigator.pop(context);
                      },
                      label: "FECHAR",
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: MediaQuery.of(context).size.height * 0.065,
                    ),
                  ],
                //  actions: <Widget>[
                  //                 SimpleDialogOption(child: Text("Salvar"), onPressed: () {}),]
                )

            );
        }
    );

  }

  static Future<void> AlertDialogProfissional(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Especialidade"),
          actions: <Widget>[
            SimpleDialogOption(child: Text("Salvar"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option2"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option3"), onPressed: () {})
          ],
        );
      },
    );
  }

/*
  static Future<void> AlertSalasHoras(parentContext, String dia) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("SALAS"),

              Container(
                color: AppColors.primaryColor,
                width: 400,
                child: Column(
                  children: [
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn(),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn2(),
                    ),
                  ],
                ),
              )
            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("Cancelar"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }
*/

  // Future<Usuario> getUsuarioByUid(String uid) async {
  //   print("uid getUsuarioByUid $uid");
  //   if (uid.isEmpty){
  //     print("empity");
  //     String _uidGet ="";
  //     print("_uidGet $_uidGet");
  //     return Provider.of<UsuarioProvider>(context, listen: false)
  //         .getUsuarioByUid2(uid);
  //   } else{
  //     print(" not empity");
  //     return Provider.of<UsuarioProvider>(context, listen: false)
  //         .getUsuarioByUid2(uid);
  //   }
  //
  // }

  //ALTERAR ESPECIALIDADE

  static Future<void> AlertAlterarEspecialidade(
      parentContext, Especialidade especialidade, String uid) {
    final _form = GlobalKey<FormState>();
    String _descEspecialidade = especialidade.descricao!;
    print("id_especialidade $_descEspecialidade");

    print("$_descEspecialidade desssc");

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return AlertDialog(
            title: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ALTERAR ESPECIALIDADE ${_descEspecialidade}"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: InputTextUperWidget(
                      label: "DESCRIÇÃO ESPECIALIDADE",
                      initalValue: _descEspecialidade,
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        if (value.compareTo(especialidade.descricao!) == 0) {
                          return 'Altere a descrição da Especialidade';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _descEspecialidade = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle: AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("ALTERAR"),
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      //Alterando Especialidade
                      Provider.of<EspecialidadeProvider>(context, listen: false)
                          .put(Especialidade(
                        // idEspecialidade: especialidade.idEspecialidade,
                        descricao: _descEspecialidade,
                      ))
                          .then((value) {
                        Provider.of<LogProvider>(context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: uid,
                          descricao: "Alterando especialidade",
                          id_transacao: "0",
                        ));
                        // Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, "/especialidades");
                      });
                    }
                  }),
              SimpleDialogOption(
                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  // SALVAR PACIENTE
  // alocar parceiro ao paciente
  static Future<void> AlertConfirmarPaciente(
      parentContext,
      String nome,
      String nomeResponsavel,
      String endereco,
      String data,
      String telefone,
      String cpf,
      int numero,
      List<Parceiro> list,
      String uid) {
    bool _isCheck = false;
    bool _checkButton = false;
    final _form = GlobalKey<FormState>();

    List<DropdownMenuItem<String>> getDropdownParceiros(List<Parceiro> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].razaoSocial.toString(),
          child: Text(list[i].razaoSocial.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    Size size = MediaQuery.of(parentContext).size;
    String dropdownTpConsulta = list.first.razaoSocial.toString();
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("SALVAR PACIENTE"),),
                    //NOME
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("Nome: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$nome", style: AppTextStyles.labelBlack16Lex,),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("Nome responsável: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$nomeResponsavel",style: AppTextStyles.labelBlack16Lex,),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("Endereço: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$endereco",style: AppTextStyles.labelBlack16Lex),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("Numero: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$numero",style: AppTextStyles.labelBlack16Lex,),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("Telefone: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$telefone",style: AppTextStyles.labelBlack16Lex,),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("CPF: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$cpf",style: AppTextStyles.labelBlack16Lex,),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        children: [
                          Text("DATA NASCIMENTO: ",style: AppTextStyles.labelBlack14Lex,),
                          Text("$data",style: AppTextStyles.labelBlack16Lex,),
                        ],
                      ),
                    ),
                    //Parceiro
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       checkColor: Colors.greenAccent,
                    //       activeColor: Colors.red,
                    //       value: _isCheck,
                    //       onChanged: (bool? value) {
                    //         setState(() {
                    //           _isCheck = value!;
                    //         });
                    //       },
                    //     ),
                    //     // if (_isCheck)
                    //     Text(
                    //       'ADICIONAR PARCEIRO',
                    //       style: AppTextStyles.labelBlack16Lex,
                    //     ),
                    //   ],
                    // ),
                    // if (_isCheck)
                      // SizedBox(
                      //   width: size.width * 0.35,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Selecione o PARCEIRO",
                      //         style: AppTextStyles.subTitleBlack16,
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: AppColors.labelWhite),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(4.0),
                      //           child: DropdownButton<String>(
                      //             value: dropdownTpConsulta,
                      //             icon: const Icon(Icons.arrow_drop_down_sharp),
                      //             elevation: 16,
                      //             style: TextStyle(color: AppColors.labelBlack),
                      //             underline: Container(
                      //               height: 2,
                      //               color: AppColors.line,
                      //             ),
                      //             onChanged: (String? newValue) {
                      //               setState(() {
                      //                 dropdownTpConsulta = newValue!;
                      //               });
                      //             },
                      //             items: getDropdownParceiros(list),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                  ],
                ),
              ),
              actions: <Widget>[
                ButtonDisableWidget(
                    isButtonDisabled: _checkButton,
                    onTap: (){
                      _checkButton = !_checkButton;
                      setState((){});
                      if (_form.currentState!.validate()) {
                        //SALVANDO PACIENTE
                        String id_paciente = "";
                        Paciente paciente = Paciente(
                          nome: nome,
                          nome_responsavel: nomeResponsavel,
                          cpf: cpf,
                          endereco: endereco,
                          numero: numero,
                          dataNascimento: data,
                          telefone: telefone,
                        );
                        paciente.id1 = "";
                        Provider.of<PacienteProvider>(context, listen: false)
                            .put(paciente)
                            .then((value) async {
                          id_paciente = value;

                          if (_isCheck) {
                            //salvando paciente Parceiro
                            // await Provider.of<PacientesParceirosProvider>(
                            //     context,
                            //     listen: false)
                            //     .put(PacientesParceiros(
                            //     idPaciente: id_paciente,
                            //     idParceiro: 0,
                            //     status: "ATIVO"));
                            // await Provider.of<LogProvider>(context,
                            //     listen: false)
                            //     .put(LogSistema(
                            //   data: DateTime.now().toString(),
                            //   uid_usuario: uid,
                            //   descricao: "INSERIU PACIENTE/PARCEIRO",
                            //   id_transacao: id_paciente.toString(),
                            // ));
                          }

                          //SALVANDO LOG
                          await Provider.of<LogProvider>(context, listen: false)
                              .put(LogSistema(
                            data: DateTime.now().toString(),
                            uid_usuario: uid,
                            descricao: "INSERIU PACIENTE",
                            id_transacao: id_paciente,
                          ));
                          Navigator.pushReplacementNamed(
                              context, "/cadastro_paciente");
                        });
                      }
                    },
                    label: "CONFIRMAR",
                    width: size.width*0.1,
                    height: size.height*0.06),
                // SimpleDialogOption(
                //     child: Text("CONFIRMAR"),
                //     onPressed: () {
                //       if (_form.currentState!.validate()) {
                //         //SALVANDO PACIENTE
                //         String id_paciente = "";
                //         Paciente paciente = Paciente(
                //           nome: nome,
                //           nome_responsavel: nomeResponsavel,
                //           cpf: cpf,
                //           endereco: endereco,
                //           numero: numero,
                //           dataNascimento: data,
                //           telefone: telefone,
                //         );
                //         paciente.id1 = "";
                //         Provider.of<PacienteProvider>(context, listen: false)
                //             .put(paciente)
                //             .then((value) async {
                //               id_paciente = value;
                //
                //               if (_isCheck) {
                //                 //salvando paciente Parceiro
                //                 // await Provider.of<PacientesParceirosProvider>(
                //                 //     context,
                //                 //     listen: false)
                //                 //     .put(PacientesParceiros(
                //                 //     idPaciente: id_paciente,
                //                 //     idParceiro: 0,
                //                 //     status: "ATIVO"));
                //                 // await Provider.of<LogProvider>(context,
                //                 //     listen: false)
                //                 //     .put(LogSistema(
                //                 //   data: DateTime.now().toString(),
                //                 //   uid_usuario: uid,
                //                 //   descricao: "INSERIU PACIENTE/PARCEIRO",
                //                 //   id_transacao: id_paciente.toString(),
                //                 // ));
                //               }
                //
                //               //SALVANDO LOG
                //               await Provider.of<LogProvider>(context, listen: false)
                //                   .put(LogSistema(
                //                 data: DateTime.now().toString(),
                //                 uid_usuario: uid,
                //                 descricao: "INSERIU PACIENTE",
                //                 id_transacao: id_paciente,
                //               ));
                //               Navigator.pushReplacementNamed(
                //                   context, "/cadastro_paciente");
                //         });
                //       }
                //     }),
                // SimpleDialogOption(
                //     child: Text("CANCELAR"),
                //     onPressed: () {
                //       Navigator.pop(context);
                //     }),
                ButtonWidget(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    label: "CANCELAR",
                    width: size.width*0.1,
                    height: size.height*0.06),
              ],
            ),
          );
        });
  }

  //ALTERAR PACIENTE
  static Future<void> AlertAlterarPaciente(
      parentContext,
      Paciente paciente,
      String primeiroParceiro,
      String id_parceiro,
      List<Parceiro> list,
      List<PacientesParceiros> listPP,
      String uid) async {
    bool _isCheck = false;
    bool _alocarParceiro = false;
    bool _desalocarParceiro = false;

    Parceiro? parceiro;
    Provider.of<ParceiroProvider>(parentContext, listen: false)
        .getParceiroById2(id_parceiro, list)
        .then((value) {
      parceiro = value;
      print("existParceiro ");
    });

    if (id_parceiro.compareTo("0") == 0) {
      print("aloca");
      _alocarParceiro = true;
    } else {
      print("desaloca");
      _desalocarParceiro = true;
      print("desaloca $_desalocarParceiro");
    }
    print("List<Parceiro> list ${list.length}");
    final _form = GlobalKey<FormState>();
    String _nome = paciente.nome!;
    int _numero = paciente.numero!;
    String _endereco = paciente.endereco!;
    String _telefone = paciente.telefone!;
    String _dataNascimento = paciente.dataNascimento!;
    String _cpf = paciente.cpf!;
    print("_nome ${_nome}");
    print("_endereco ${_endereco}");
    print("_telefone ${_telefone}");

    String dropdown = primeiroParceiro;
    List<DropdownMenuItem<String>> getDropdownParceiros(List<Parceiro> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].razaoSocial.toString(),
          child: Text(list[i].razaoSocial.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    print("compareto ${dropdown.compareTo(list.first.razaoSocial.toString())}");
    print("dropdownTpConsulta ${dropdown}");

    bool isValidDate(String date) {
      try {
        DateTime.parse(date);
        return true;
      } catch (e) {
        return false;
      }
    }

    return showDialog(
      barrierColor: AppColors.shape,
      context: parentContext,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(child: Text("ALTERAR PACIENTE")),
                ),

                //NOME
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: InputTextUperWidget(
                    label: "NOME PACIENTE",
                    initalValue: _nome,
                    icon: Icons.edit,
                    validator: (value) {
                      if ((value!.isEmpty) || (value == null)) {
                        return 'Insira um NOME';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _nome = value;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.line,
                    textStyle: AppTextStyles.subTitleBlack12,
                    iconColor: AppColors.labelBlack,
                  ),
                ),
                //CPF
                Row(
                  children: [
                    //CPF
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: InputTextWidgetMask(
                        label: "CPF",
                        initalValue: _cpf,
                        icon: Icons.badge_outlined,
                        input: CpfInputFormatter(),
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Insira um CPF';
                          }
                          if (value.length < 11) {
                            return 'CPF incompleto';
                          } else {
                            if (UtilBrasilFields.isCPFValido(value) == false) {
                              return 'CPF inválido.';
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _cpf = value;
                        },
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle: AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,
                      ),
                    ),
                    //TELEFONE
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: InputTextWidgetMask(
                        input: TelefoneInputFormatter(),
                        initalValue: _telefone,
                        label: "TELEFONE",
                        icon: Icons.local_phone,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Insira um TELEFONE';
                          }
                          if (value.length < 14) {
                            return 'Número Incompleto';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _telefone = value;
                        },
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle: AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,
                      ),
                    ),
                  ],
                ),
                //ENDEREÇO
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.26,
                      child: InputTextUperWidget(
                        label: "ENDEREÇO",
                        initalValue: _endereco,
                        icon: Icons.location_on_outlined,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Insira um ENDEREÇO';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _endereco = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle: AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.142,
                      child: InputTextWidgetMask(
                        input: FilteringTextInputFormatter.digitsOnly,
                        label: "NÚMERO",
                        initalValue: _numero.toString(),
                        icon: Icons.onetwothree,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Insira um NÚMERO';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _numero = int.parse(value);
                        },
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle: AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,
                      ),
                    ),
                  ],
                ),
                //DATA NASCIMENTO
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: InputTextWidgetMask(
                    label: "DATA DE NASCIMENTO",
                    icon: Icons.date_range_rounded,
                    input: DataInputFormatter(),
                    initalValue: _dataNascimento,
                    validator: (value) {
                      if ((value!.isEmpty) || (value == null)) {
                        return 'Insira um texto';
                      }
                      if (value.length < 10) {
                        return 'Data incompleta';
                      } else {
                        ///validar data;
                        if (isValidDate(value)) {
                          return 'Data inválida';
                        }
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _dataNascimento = value;
                    },
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.line,
                    textStyle: AppTextStyles.subTitleBlack12,
                    iconColor: AppColors.labelBlack,
                  ),
                ),

                //Parceiro
                (_desalocarParceiro)
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  'PARCEIRO: ',
                                  style: AppTextStyles.labelBlack14Lex,
                                ),
                              ),
                              Text(
                                parceiro!.razaoSocial.toString(),
                                style: AppTextStyles.labelBlack16Lex,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Checkbox(
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.red,
                                  value: _isCheck,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isCheck = value!;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                'DESVINCULAR PARCEIRO',
                                style: AppTextStyles.labelBlack16Lex,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Checkbox(
                              checkColor: Colors.greenAccent,
                              activeColor: Colors.red,
                              value: _isCheck,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCheck = value!;
                                  print("valor drop $dropdown");
                                });
                              },
                            ),
                          ),
                          // if (_isCheck)
                          Text(
                            'ADICIONAR PARCEIRO',
                            style: AppTextStyles.labelBlack16Lex,
                          ),
                        ],
                      ),

                if ((_isCheck) && (_alocarParceiro))
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: SizedBox(
                      width: MediaQuery.of(parentContext).size.width * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.labelWhite),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DropdownButton<String>(
                                value: dropdown,
                                icon: const Icon(Icons.arrow_drop_down_sharp),
                                elevation: 16,
                                style: TextStyle(color: AppColors.labelBlack),
                                underline: Container(
                                  height: 2,
                                  color: AppColors.line,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdown = newValue!;
                                  });
                                },
                                items: getDropdownParceiros(list),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            SimpleDialogOption(
                child: Text("ALTERAR"),
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    //Alterando PACIENTE
                    Provider.of<PacienteProvider>(context, listen: false)
                        .put(Paciente(
                      idPaciente: paciente.idPaciente,
                      nome: _nome,
                      cpf: _cpf,
                      endereco: _endereco,
                      numero: _numero,
                      dataNascimento: _dataNascimento,
                      telefone: _telefone,
                    ))
                        .then((value) async {
                      //SE FOR ALOCAR OU DESALOCAR SALVAR NO PACIENTES PARCEIROS
                      String result = "";
                      if (_isCheck) {
                        if (_alocarParceiro) {
                          int idParceiroAlocado = Provider.of<ParceiroProvider>(
                                  context,
                                  listen: false)
                              .getIdByRazao(dropdown, list);
                          await Provider.of<LogProvider>(context, listen: false)
                              .put(LogSistema(
                            data: DateTime.now().toString(),
                            uid_usuario: uid,
                            descricao: "ALTEROU PACIENTE",
                            id_transacao: paciente.idPaciente.toString(),
                          ));
                          await Provider.of<PacientesParceirosProvider>(context,
                                  listen: false)
                              .put(PacientesParceiros(
                                  idPaciente: paciente.idPaciente,
                                  idParceiro: idParceiroAlocado,
                                  status: 'ATIVO'));

                          result = "INSERIU PACIENTE/PARCEIRO";
                        } else if (_desalocarParceiro) {
                          print("DESALOCAR");
                          //pegando id a ser alterado
                          int idPP = Provider.of<PacientesParceirosProvider>(
                                  context,
                                  listen: false)
                              .getIdByRazao(paciente.idPaciente.toString(),
                                  id_parceiro, listPP);
                          print("idPP $idPP");
                          await Provider.of<LogProvider>(context, listen: false)
                              .put(LogSistema(
                            data: DateTime.now().toString(),
                            uid_usuario: uid,
                            descricao: "ALTEROU PACIENTE",
                            id_transacao: paciente.idPaciente.toString(),
                          ));
                          await Provider.of<PacientesParceirosProvider>(context,
                                  listen: false)
                              .put(PacientesParceiros(
                                  idPacientesParceiros: idPP,
                                  idPaciente: paciente.idPaciente,
                                  idParceiro: int.parse(id_parceiro),
                                  status: 'INATIVO'));

                          result = "DESALOCOU PACIENTE/PARCEIRO";
                          print("desalocou");
                        }
                      }
                      print("log result $result");
                      Provider.of<LogProvider>(context, listen: false)
                          .put(LogSistema(
                        data: DateTime.now().toString(),
                        uid_usuario: uid,
                        descricao: result,
                        id_transacao: paciente.idPaciente.toString(),
                      ));
                      Navigator.pushReplacementNamed(
                          context, "/home_assistente");
                    });
                  }
                }),
            SimpleDialogOption(
                child: Text("CANCELAR"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  static Future<void> AlertAlterarServico(
      parentContext, Servico servico, String uid) {
    final _form = GlobalKey<FormState>();
    String _descServico = servico.descricao!;
    String _qtdSessoes = servico.qtd_sessoes!.toString();
    String _qtdPacientes = servico.qtd_pacientes!.toString();

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return AlertDialog(
            title: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ALTERAR SERVIÇO ${_descServico}"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: InputTextUperWidget(
                      label: "DESCRIÇÃO SERVIÇO",
                      initalValue: _descServico,
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _descServico = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle: AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: InputTextWidget2(
                      label: "QUANTIDADE SESSÕES",
                      initalValue: _qtdSessoes.toString(),
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _qtdSessoes = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle: AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: InputTextWidget2(
                      label: "QUANTIDADE PACIENTES",
                      initalValue: _qtdPacientes,
                      icon: Icons.edit,
                      validator: (value) {
                        if ((value!.isEmpty) || (value == null)) {
                          return 'Por favor insira uma descrição';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _qtdPacientes = value;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      backgroundColor: AppColors.secondaryColor,
                      borderColor: AppColors.line,
                      textStyle: AppTextStyles.subTitleBlack12,
                      iconColor: AppColors.labelBlack,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("EXCLUIR"),
                  onPressed: () {
                    Navigator.pop(context);
                    Dialogs.AlertConfirmarExclusaoServico(parentContext, servico, uid);

                    // Provider.of<ServicoProvider>(context, listen: false)
                    //     .remove(servico.id.toString());
                    // Provider.of<ServicoProvider>(context, listen: false).remove
                  }),
              SimpleDialogOption(
                  child: Text("ALTERAR"),
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      //Alterando Especialidade
                      Provider.of<ServicoProvider>(context, listen: false)
                          .put(Servico(
                        id: servico.id,
                        descricao: _descServico,
                        qtd_pacientes: int.parse(_qtdPacientes),
                        qtd_sessoes: int.parse(_qtdSessoes),
                      ))
                          .then((value) {
                        Provider.of<LogProvider>(context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: uid,
                          descricao: "Alterando Serviço",
                          id_transacao: servico.id,
                        ));
                        Navigator.pop(context);
                      });
                    }
                  }),
              SimpleDialogOption(
                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  static Future<void> AlertConfirmarExclusaoServico(
      parentContext, Servico servico, String uid) {
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return AlertDialog(
              title: Column(
                children: [
                  Text("CONFIRMAR EXCLUSÃO:"),
                  Text("SERVIÇO: ${servico.descricao}"),
                  Text("SESSÕES: ${servico.qtd_sessoes}"),
                  Text("PACIENTES: ${servico.qtd_pacientes}"),
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("CONFIRMAR"),
                    onPressed: () {
                      Provider.of<ServicoProvider>(context, listen: false)
                          .remove(servico.id.toString());
                      Provider.of<LogProvider>(context, listen: false).put(
                          LogSistema(data: DateTime.now().toString(),id_transacao: servico.id,descricao: "REMOVEU SERVIÇO", uid_usuario: uid));
                      Navigator.pop(context);
                    }),
                SimpleDialogOption(
                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ]);
        });
  }

  static Future<void> AlertAlterarParceiro(
      parentContext, Parceiro parceiro, String uid) {
    print("razaoSocial ${parceiro.razaoSocial}");
    print("numero ${parceiro.numero}");
    print("telefone ${parceiro.telefone}");
    print("id ${parceiro.id}");
    print("status ${parceiro.status}");
    print("desconto ${parceiro.desconto}");
    print("email ${parceiro.email}");
    print("cnpj ${parceiro.cnpj}");
    print("endereco ${parceiro.endereco}");

    final _form = GlobalKey<FormState>();
    String _razao = parceiro.razaoSocial!;
    String _cnpj = parceiro.cnpj!;
    String _email = parceiro.email!;
    String _telefone = parceiro.telefone!;
    String _status = parceiro.status!;
    String _endereco = parceiro.endereco!;
    int _desconto = parceiro.desconto!;
    int _numero = parceiro.numero!;
    String _porcentagem = "5";
    print("id_razao $_razao");

    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text(
                                "ALTERAR PARCEIRO ${parceiro.razaoSocial}")),
                        //razão social
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: InputTextUperWidget(
                            label: "RAZÃO SOCIAL",
                            initalValue: parceiro.razaoSocial,
                            icon: Icons.edit,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira uma RAZÃO SOCIAL';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _razao = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle: AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,
                          ),
                        ),
                        //cnpj
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: InputTextWidgetMask(
                            label: "CNPJ",
                            initalValue: parceiro.cnpj,
                            icon: Icons.badge_outlined,
                            input: CnpjInputFormatter(),
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira uma RAZÃO SOCIAL';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _cnpj = value;
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle: AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,
                          ),
                        ),
                        // telefone
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: InputTextWidgetMask(
                            label: "TELEFONE",
                            initalValue: parceiro.telefone,
                            icon: Icons.local_phone,
                            input: TelefoneInputFormatter(),
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um TELEFONE';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _telefone = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle: AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,
                          ),
                        ),
                        //email
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: InputTextLowerWidget(
                            label: "EMAIL",
                            initalValue: parceiro.email,
                            icon: Icons.email_rounded,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira uma EMAIL';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle: AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,
                          ),
                        ),
                        //endereço
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: InputTextUperWidget(
                                label: "ENDEREÇO",
                                initalValue: parceiro.endereco,
                                icon: Icons.location_on_outlined,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Por favor insira uma ENDEREÇO';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _endereco = value;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle: AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,
                              ),
                            ),
                            //numero
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.14,
                              child: InputTextWidget2(
                                label: "NÚMERO",
                                initalValue: parceiro.numero.toString(),
                                icon: Icons.edit,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Por favor insira uma RENDEREÇO';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _numero = int.parse(value);
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle: AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Desconto"),
                            DropDownWidget(
                              list: [
                                "5",
                                "10",
                                "15",
                                "20",
                                "25",
                                "30",
                                "35",
                                "40"
                              ],
                              valueDrop1: _desconto.toString(),
                              onChanged: (value) {
                                _porcentagem = value!;
                                _desconto = int.parse(_porcentagem);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    SimpleDialogOption(
                        child: Text("ALTERAR"),
                        onPressed: () {
                          if (_form.currentState!.validate()) {
                            //Alterando PARCEIRO
                            Provider.of<ParceiroProvider>(context,
                                    listen: false)
                                .put(Parceiro(
                              id: parceiro.id,
                              razaoSocial: _razao,
                              telefone: _telefone,
                              endereco: _endereco,
                              email: _email,
                              desconto: _desconto,
                              status: _status,
                              cnpj: _cnpj,
                              numero: _numero,
                            ))
                                .then((value) {
                              print("salvou");
                              Provider.of<LogProvider>(context, listen: false)
                                  .put(LogSistema(
                                data: DateTime.now().toString(),
                                uid_usuario: uid,
                                descricao: "ALTEROU PARCEIRO",
                                id_transacao: parceiro.id.toString(),
                              ));
                              Navigator.pop(context);
                              // Navigator.pushReplacementNamed(context, "/home_assistente");
                            });
                          }
                        }),
                    SimpleDialogOption(
                        child: Text("CANCELAR"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                )));
  }


  static Future<void> AlertConfirmRemoverCategoria(parentContext, CategoriaDespesa categoriaDespesa ){



    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return  AlertDialog(
            title: SizedBox(
              width: size.width*0.5,
              height: size.height*0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("DESEJA REMOVER ESTA CATEGORIA?", style: AppTextStyles.labelBlack16Lex,),
                  SizedBox(
                    height: size.height*0.03,
                  ),
                  Text(categoriaDespesa.descricao!, style: AppTextStyles.labelBlack16Lex,),
                ],
              ),
            ),

            actions: [
              SimpleDialogOption(
                child: Text("Remover"),
                onPressed: ()async{
                  await Provider.of<CategoriaDespesaProvider>(parentContext, listen: false).remove(categoriaDespesa.id1);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text("Fechar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }


  static Future<void> AlertRemoverCategoria(parentContext, List<CategoriaDespesa> listCategoriaDespesa ){



    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {
          return  AlertDialog(
            title: SizedBox(
              width: size.width*0.7,
              height: size.height*0.7,
              child: Column(
                children: [
                  Text("REMOVER CATEGORIA", style: AppTextStyles.labelBlack16Lex,),
                  Container(
                    color: AppColors.line,
                    width: size.width*0.6,
                    height: size.height*0.6,
                    child: ListView.builder(
                        itemCount: listCategoriaDespesa.length,
                        itemBuilder: (BuildContext, index){
                          return Card(
                            child: ListTile(
                              title: Text(listCategoriaDespesa[index].descricao!),
                              trailing: Container(
                                // color: Colors.red,
                                width: size.width*0.02,
                                height: size.height*0.04,
                                child: InkWell(
                                  child: Container(
                                    width: size.width*0.02,
                                    height: size.height*0.03,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(
                                      size: size.height*0.03,
                                      Icons.delete_outlined,
                                      color: AppColors.labelBlack,
                                    ),

                                  ),
                                  onTap: () async{
                                    // AlertConfirmRemoverCategoria
                                    await Dialogs.AlertConfirmRemoverCategoria(parentContext, listCategoriaDespesa[index]);

                                    Navigator.pop(context);
                                  },
                                ),
                              ),

                              // IconButton(
                              //   onPressed: (){},
                              //   icon: Icon(Icons.delete_outlined),
                              // ),
                            ),
                          );
                        }),


                  ),
                ],
              ),
            ),

            actions: [
              // SimpleDialogOption(
              //   child: Text("FECHAR"),
              //   onPressed: ()async{
              //
              //     Navigator.pop(context);
              //   },
              // ),
              SimpleDialogOption(
                child: Text("Fechar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }


  static Future<void> AlertCadastrarCategoria(parentContext, List<CategoriaDespesa> listCategoriaDespesa ){
    final _form = GlobalKey<FormState>();
    bool containCategoria = false;
    String categoria ="";
    Size size = MediaQuery.of(parentContext).size;

    bool existCategoria(String descricao) {
      bool result = false;
      listCategoriaDespesa.forEach((element) {
            if (element.descricao!.toUpperCase().compareTo(descricao.toUpperCase())==0){
              result = true;
            }
      });
      return result;
    }


    return showDialog(
      barrierColor: AppColors.shape,
      context: parentContext,
        builder: (context) {
          return  AlertDialog(
             title: Form(
               key: _form,
               child:SizedBox(
                width: size.width*0.35,
                child: Column(
                  children: [
                    Text("CADASTRO CATEGORIA", style: AppTextStyles.labelBlack16Lex,),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child:InputTextUperWidget(
                        label: "DESCRIÇÃO",
                        icon: Icons.perm_contact_cal_sharp,
                        validator: (value) {
                          if ((value!.isEmpty) || (value == null)) {
                            return 'Por favor insira um texto';
                          }
                          if (existCategoria(value)){
                            return 'Categoria já existe';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          categoria = value;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        backgroundColor: AppColors.secondaryColor,
                        borderColor: AppColors.line,
                        textStyle:  AppTextStyles.subTitleBlack12,
                        iconColor: AppColors.labelBlack,),

                    ),

                  ],
                ),
               ),


             ),
            actions: [
              SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: ()async{
                 if (_form.currentState!.validate()){
                   await Provider.of<CategoriaDespesaProvider>(parentContext, listen: false).put(
                       CategoriaDespesa(
                           descricao: categoria
                       )
                   ).then((value) {
                     // listCategoriaDespesa.add(CategoriaDespesa(descricao: categoria));
                     listCategoriaDespesa.sort((a,b)=> a.descricao!.toUpperCase().compareTo(b.descricao!.toUpperCase()));
                     // Dialogs.AlertCadastrarDespesa(parentContext, listCategoriaDespesa);
                     print("salvou");
                     Navigator.pop(context);
                   });
                 }

                  // Navigator.pop(context);
                },
              ),
                SimpleDialogOption(
                  child: Text("Fechar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
            ],
          );
        }
    );
  }

  static Future<void> AlertInadimplentes(parentContext,
      _uid,
      List<Sessao> list,
      List<Profissional> listProfissional,
      List<ServicosProfissional> listServicoProfissional,

      ) {
    var seen = Set<String>();

    // List<Sessao> uniqueList = list.where((element) => seen.add(element.idPaciente!)).toList();
    for (int i=0;i<list.length;i++){
          print("----");
         print(list[i].descSessao!.substring(7,8));
      }
    List<Sessao> uniqueList = list.where((element) => element.descSessao!.substring(7,8).compareTo("1")==0).toList();
    // List<Sessao> uniqueList = [];
    // for (int i=0;i<list.length;i++){
    //    if (list[i].descSessao!.substring(8,9).compareTo("1")==0){
    //      uniqueList.add(list[i]);
    //    }
    // }
    final _form = GlobalKey<FormState>();
    Size size = MediaQuery.of(parentContext).size;

    Profissional getProfissionalById(String id){
      Profissional result = Profissional();
      result = listProfissional.firstWhere((element) => element.id1.compareTo(id)==0);
      return result;
    }

    Future<String> getNomePaciente(String id)async{
      String result = "";
      await Provider.of<PacienteProvider>(parentContext, listen: false)
          .getPaciente(id).then((value) {
           result = value.nome!;
           return result;
      });
      return result;
    }
    Future<String> getValorServicoByDesc(String desc, String idProf)async{
      String result = "";
      String valorSessao = "";
      await Provider.of<ServicoProvider>(parentContext, listen: false)
          .getServicoByDesc( desc)
          .then((value) async{
        result = value.id1;
        await Provider.of<ServicoProfissionalProvider>(parentContext, listen: false)
            .getServByServicoProfissional(idProf,result).then((value) {
          valorSessao = value.valor!;
          print(result);
          return valorSessao;
        });
      });
      return valorSessao;

    }

    String getNameProfissional(String id){
      // String result="";
      var result = listProfissional.firstWhere((element) => element.id1.compareTo(id)==0);
      return result.nome!;
    }


    return showDialog(
      barrierColor: AppColors.shape,
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
                title: Form(
                  key: _form,
                  child: Container(
                    width: size.width*0.9,
                    height: size.height*0.7,
                    color: AppColors.labelWhite,
                    child: Column(
                      children: [
                        Text("INADIMPLENTES"),
                        Container(
                          width: size.width*0.65,
                          height: size.height*0.6,
                          decoration: BoxDecoration(
                            color: AppColors.shape,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left:4, right: 4),
                            child: ListView.builder(
                                itemCount: uniqueList.length,
                                itemBuilder: (buildContext, index){
                                  return Card(
                                    child: ListTile(
                                        trailing: Column(
                                          children: [
                                            InkWell(
                                              onTap: ()async{
                                                List<TipoPagamento> tiposPagamento = [];
                                                Paciente paciente = Paciente();
                                                String valor = "";
                                                await getValorServicoByDesc(uniqueList[index].descSessao!.substring(11, uniqueList[index].descSessao!.length),
                                                    uniqueList[index].idProfissional!).then((value) {
                                                  valor = value;
                                                });
                                                Profissional prof = getProfissionalById(uniqueList[index].idProfissional!);
                                                await Provider.of<TipoPagamentoProvider>(context, listen: false)
                                                    .getTiposPagamentos().then((value) {
                                                  tiposPagamento = value;
                                                  tiposPagamento.sort((a,b)=>a.descricao.toLowerCase().replaceAll("à", "a").compareTo(b.descricao.toLowerCase().replaceAll("à", "a")));
                                                });

                                                await Provider.of<PacienteProvider>(context,listen: false).getPaciente(uniqueList[index].idPaciente!).then((value) {
                                                  paciente = value;
                                                });
                                                String valorSessao = "";
                                                getValorServicoByDesc(
                                                    uniqueList[index].descSessao!.substring(11, uniqueList[index].descSessao!.length),
                                                    uniqueList[index].idProfissional!
                                                  // desc, idProf

                                                ).then((value) {
                                                  valorSessao = value;
                                                });
                                                await DialogsAgendaAssistente.AlertDialogRegistrarPagamento(context, _uid, uniqueList[index], paciente, prof, tiposPagamento, valor);
                                                Navigator.pop(context);
                                              },
                                              // alignment: Alignment.center,

                                              child: Icon(Icons.monetization_on,
                                                color: AppColors.primaryColor,
                                                // size: 35,
                                              ),
                                            ),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("PAGAR"),
                                            )
                                          ],
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [
                                                Text(uniqueList[index].id1.substring(0,5), style: AppTextStyles.labelBlack12Lex,),
                                                // Text(, ),
                                                Text(uniqueList[index].descSessao!.substring(11, uniqueList[index].descSessao!.length)),
                                                FutureBuilder(
                                                  //list[index].descSessao!.substring(11, list[index].descSessao!.length)
                                                    future: getValorServicoByDesc(
                                                        uniqueList[index].descSessao!.substring(11, uniqueList[index].descSessao!.length),
                                                        uniqueList[index].idProfissional!),
                                                    builder: (BuildContext parentContext, AsyncSnapshot snapshot) {

                                                      if (snapshot.hasData) {
                                                        String result =  snapshot.data as String;
                                                        return Text(result);
                                                      }else {
                                                        return Center(
                                                            child: Text("")
                                                        );
                                                      }
                                                    }),
                                              ],
                                            ),
                                            FutureBuilder(
                                              //list[index].descSessao!.substring(11, list[index].descSessao!.length)
                                                future: getNomePaciente(uniqueList[index].idPaciente!),
                                                builder: (BuildContext parentContext, AsyncSnapshot snapshot) {

                                                  if (snapshot.hasData) {
                                                    String result =  snapshot.data as String;
                                                    return Text(result);
                                                  }else {
                                                    return Center(
                                                        child: Text("")
                                                    );
                                                  }
                                                }),
                                            Text(getNameProfissional(uniqueList[index].idProfissional!),
                                              style: AppTextStyles.labelBlack14,),


                                          ],
                                        ),
                                        subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("SESSÃO "+uniqueList[index].statusSessao!),
                                                  Text(" EM "+uniqueList[index].dataSessao!),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Text(uniqueList[index].situacaoSessao!),
                                                  Text(uniqueList[index].idTransacao!),
                                                ],
                                              ),
                                            ]
                                        )
                                    ),
                                  );
                                }),
                          )
                        )
                      ],
                    ),
                  )
                ),
                actions: [
                 SimpleDialogOption(
                     child: Text("CANCELAR"),
                     onPressed: () {
                       Navigator.pop(context);
                     }),
               ],
            )
        );
      }
    );

  }



  static Future<void> AlertCadastrarDespesa(parentContext, List<CategoriaDespesa> list) {
    final _form = GlobalKey<FormState>();
    String valor = "";
    String descricao = "";
    String dropdown = list.first.descricao!;
    bool checkCaixa = false;
    bool checkConta = false;
    bool showMessage = false;

    List<DropdownMenuItem<String>> getDropdownCategoriaDespesas() {
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

    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
        barrierColor: AppColors.shape,
        context: parentContext,
        builder: (context) {

          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
            title: Form(
              key: _form,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("Despesa"),
                ),
                SizedBox(
                  width: MediaQuery.of(parentContext).size.width * 0.35,
                  child: InputTextUperWidget(
                    label: "DESCRIÇÃO DESPESA",
                    icon: Icons.edit,
                    validator: (value) {
                      if ((value!.isEmpty) || (value == null)) {
                        return 'Por favor insira um texto';
                      }
                      return null;
                    },
                    onChanged: (value){
                      descricao = value;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.line,
                    textStyle: AppTextStyles.subTitleBlack12,
                    iconColor: AppColors.labelBlack,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(parentContext).size.width * 0.2,
                  child: InputTextWidgetMask(
                    label: "VALOR",
                    icon: Icons.monetization_on_outlined,
                    validator: (value) {
                      if ((value!.isEmpty) || (value == null)) {
                        return 'Insira um valor';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      valor = value;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    backgroundColor: AppColors.secondaryColor,
                    borderColor: AppColors.line,
                    textStyle: AppTextStyles.subTitleBlack12,
                    iconColor: AppColors.labelBlack,
                    input: CentavosInputFormatter(),
                  ),
                ),
                //dropDown
                Row(
                  children: [
                    // drop
                    SizedBox(
                      width: MediaQuery.of(parentContext).size.width * 0.25,
                      height: MediaQuery.of(parentContext).size.height * 0.06,
                      child: Padding(padding: EdgeInsets.only(left: 65),
                        child: DropdownButton<String>(
                          value: dropdown,
                          // alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_drop_down_sharp),
                          elevation: 16,
                          style: TextStyle(color: AppColors.labelBlack),
                          underline: Container(
                            height: 2,
                            color: AppColors.line,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdown = newValue!;
                            });
                          },
                          items: getDropdownCategoriaDespesas(),
                        ),
                      ),

                    ),
                    //botao
                    // IconButton(onPressed: (){
                    //   Dialogs.AlertCadastrarCategoria(parentContext, list);
                    // }, icon: Icon(Icons.add)),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02, right: size.width*0.02),
                      child:  Container(
                        // color: Colors.red,
                        width: size.width*0.02,
                        height: size.height*0.04,
                        child: InkWell(
                          child: Container(
                            width: size.width*0.02,
                            height: size.height*0.03,
                            alignment: Alignment.center,
                            // margin: EdgeInsets.all(100.0),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle
                            ),
                            child: Icon(
                              size: size.height*0.03,
                              Icons.add,
                              color: AppColors.labelBlack,
                            ),

                          ),
                          onTap: () async{
                            print("AlertCadastrarCategoria");
                            print(list.length);
                            await Dialogs.AlertCadastrarCategoria(parentContext, list);

                            await Provider.of<CategoriaDespesaProvider>(parentContext, listen:false).getListCategorias().then((value) {
                              list.clear;
                              list = value;
                              setState((){
                                print("setState");
                                print(list.length);
                              });
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      width: size.width*0.02,
                      height: size.height*0.04,
                      child: InkWell(
                        child: Container(
                          width: size.width*0.02,
                          height: size.height*0.03,
                          alignment: Alignment.center,
                          // margin: EdgeInsets.all(100.0),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle
                          ),
                          child: Icon(
                            size: size.height*0.03,
                            Icons.remove,
                            color: AppColors.labelBlack,
                          ),

                        ),
                        onTap: () async{
                         await Dialogs.AlertRemoverCategoria(parentContext, list);
                         await Provider.of<CategoriaDespesaProvider>(parentContext, listen:false).getListCategorias().then((value) {
                           list.clear;
                           list = value;
                           setState((){
                             print("setState");
                             print(list.length);
                           });
                         });
                        },
                      ),
                    ),
                  ],
                ),
                //checkbox retirada
                SizedBox(
                  width: MediaQuery.of(parentContext).size.width * 0.3,
                  height: MediaQuery.of(parentContext).size.height * 0.2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: checkCaixa,
                              onChanged: (value){
                                if ((checkConta==false)&&(checkCaixa==false)){
                                  showMessage=false;
                                }
                                checkCaixa = value!;
                                if (checkCaixa){
                                  checkConta = false;
                                }
                                setState((){});
                              }
                          ),
                          Text("Retirada CAIXA")
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: checkConta,
                              onChanged: (value){
                                if ((checkConta==false)&&(checkCaixa==false)){
                                  showMessage=false;
                                }
                                checkConta = value!;
                                if (checkConta){
                                  checkCaixa = false;
                                }
                                setState((){});
                              }
                          ),
                          Text("Retirada CONTA BANCÁRIA")
                        ],
                      ),
                      ((checkConta==false)&&(checkCaixa==false))&&(showMessage)?
                      SizedBox(
                        width: size.width*0.2,
                        child: Text("Selecione uma retirada",
                          style: AppTextStyles.subTitleRed14,
                          textAlign: TextAlign.start,),

                      )
                        :
                      Center(),
                    ],
                  )
                ),
              ],
            ),),
            actions: <Widget>[
              SimpleDialogOption(
                  child: Text("SALVAR"),
                  onPressed: () async{
                      if ((_form.currentState!.validate())&&(checkCaixa||checkConta)){
                        String valorSemPonto = valor.substring(0,valor.length-3).replaceAll('.', '')+valor.substring(valor.length-3,valor.length);
                        print(valorSemPonto);
                        print("valorSemPonto");
                          await Provider.of<DespesaProvider>(context, listen: false)
                              .put(Despesa(
                            data: UtilData.obterDataDDMMAAAA(DateTime.now()),
                            hora: UtilData.obterHoraHHMM(DateTime.now()),
                            valor: valorSemPonto,
                            descricao: descricao,
                            categoria: dropdown,
                            retirada: (checkCaixa)?"CAIXA":"CONTA BANCÁRIA",
                          )).then((value) {
                            print('salvou desp');
                            setState((){});
                            Navigator.pushReplacementNamed(context, "/caixa");

                            // Navigator.pop(context);
                          } );
                      } else {
                        if ((checkConta==false)&&(checkCaixa==false)){
                          showMessage = true;
                          setState((){});
                        }
                      }

                    // Navigator.pop(context);
                  }),
              SimpleDialogOption(
                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          )
          );
        });
  }

  static Future<void> AlertDetalhesPagamentoProfissional(
      parentContext, Profissional profissional, PagamentoProfissional pagamento,
      List<Comissao> listComissao,
      // List<Paciente> listPacientes
      ) {

    Future<Paciente> getPacienteByTransacao(String idTransacao)async{
      Paciente paciente = Paciente();
      print("akkkk");
      //recupera o pagamento
      // String idTransacao = listComissao.first.idTransacao;
      await Provider.of<TransacaoProvider>(parentContext, listen: false).getTransacaoById2(idTransacao).then((value) async{
        String idPaciente = value!.idPaciente;
        print("achou pac = ${idPaciente}");

        await Provider.of<PacienteProvider>(parentContext, listen: false).getPaciente(idPaciente).then((value)async{
          paciente = value;
          print("achou paciente = ${paciente.nome}");
          return paciente;
        });
      });
      print("não achou paciente = ${paciente.nome!}");

      return paciente;
    }

    Future<String> getServicoByTransacao(String idTransacao)async{
      String result = "";
      print("akkkk");
      //recupera o pagamento
      // String idTransacao = listComissao.first.idTransacao;
      await Provider.of<TransacaoProvider>(parentContext, listen: false).getTransacaoById2(idTransacao).then((value) async{
        result = value!.descricaoTransacao;
        return result;
      });
      print("não achou servico ");

      return result;
    }


    // Paciente getPaciente(String id){
    //   return listPacientes.firstWhere((element) => element.id1.compareTo(id)==0);
    // }

    Size size = MediaQuery.of(parentContext).size;
    return showDialog(
        context: parentContext,
        // barrierColor: AppColors.shape,
        builder: (context) {

          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Container(
                width: size.width*0.8,
                height: size.height*0.7,
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: size.width*0.2,
                          height: size.height*0.6,
                          // color: AppColors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                               child: Text("DETALHES PAGAMENTO"),
                              ),
                              Divider(thickness: 3,),
                              Text(
                                "PROFISSIONAL: ",
                                style: AppTextStyles.labelBlack16Lex,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  profissional.nome.toString(),
                                  style: AppTextStyles.labelBlackBold20Slin,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "DATA: ",
                                    style: AppTextStyles.labelBlack16Lex,
                                  ),
                                  Text(
                                    pagamento.data.toString(),
                                    style: AppTextStyles.labelBlackBold20Slin,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "HORA: ",
                                    style: AppTextStyles.labelBlack16Lex,
                                  ),
                                  Text(
                                    pagamento.hora.toString(),
                                    style: AppTextStyles.labelBlackBold20Slin,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "VALOR:",
                                    style: AppTextStyles.labelBlack16Lex,
                                  ),
                                  Text(
                                    " R\$ "+pagamento.valor.toString(),
                                    style: AppTextStyles.labelBlackBold20Slin,
                                  ),
                                ],
                              ),

                              // Row(
                              //   children: [
                              //
                              //
                              //   ],
                              // ),


                            ],
                          ),
                        ),
                        Container(
                          width: size.width*0.3,
                          height: size.height*0.6,
                          // color: AppColors.red,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.shape
                          ),
                          child: ListView.builder(
                            itemCount: listComissao.length,
                            itemBuilder: (context, index){
                              return Padding(padding: EdgeInsets.all(size.width*0.002),
                                child: Container(
                                  width: size.width*0.3,
                                  height: size.height*0.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.labelWhite
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width*0.25-(size.width*0.002)*2,
                                        height: size.height*0.1-(size.width*0.002)*2,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: size.width*0.008),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // Text("${listComissao[index].id1}"),
                                              FutureBuilder(
                                                future: getPacienteByTransacao(listComissao[index].idTransacao),
                                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                                  print(listComissao[index].idTransacao);
                                                  if (snapshot.hasData){
                                                    Paciente paciente = snapshot.data as Paciente;
                                                    return FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(paciente.nome!,
                                                          style: AppTextStyles.labelBold14,));
                                                  } else {
                                                    if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    } else {
                                                      return Center(
                                                          child: Text(""));
                                                    }
                                                  }
                                                },
                                              ),
                                              FutureBuilder(
                                                future: getServicoByTransacao(listComissao[index].idTransacao),
                                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                                  // print(listComissao[index].idTransacao);
                                                  if (snapshot.hasData){
                                                    String descricao = snapshot.data as String;
                                                    return FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(descricao,
                                                          style: AppTextStyles.labelBlack12Lex,));
                                                  } else {
                                                    if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    } else {
                                                      return Center(
                                                          child: Text(""));
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ),
                                      SizedBox(
                                        width: size.width*0.05,
                                        height: size.height*0.1,
                                        child: Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text("R\$ "+listComissao[index].valor),
                                          ),
                                        )
                                      ),


                                    ],
                                  ),
                                ),
                              );
                            },

                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  //FECHAR CAIXA
  static Future<void> AlertFecharCaixa(
    parentContext,
  ) {
    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("DESPESAS: 50,00"),
                Text("PAGAMENTO COMISSÃO"),
                Text("DINHEIRO"),
                Text("PIX"),
                Text("CARTÃO DE CRÉDITO"),
                Text("CARTÃO DE DÉDITO"),
              ],
            ),
            actions: [
              SimpleDialogOption(
                  child: Text("SALVAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              SimpleDialogOption(
                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  static Future<void> AlertConfirmPagamento(parentContext, Profissional profissional,String valorComissao){
    Size size = MediaQuery.of(parentContext).size;
    TransacaoCaixa? _transacao = null;

    // Future
    return showDialog(
      context: parentContext,
      barrierColor: AppColors.shape,
      builder: (context){
        return StatefulBuilder(
            builder: (parentContext, setState){
              return AlertDialog(
                title: Container(
                  width: size.width*0.6,
                  height: size.height*0.75,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: size.height*0.04),
                        child: Text("CONFIRMAR PAGAMENTO", style: AppTextStyles.labelBold22,),
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: size.width*0.3,
                            height: size.height*0.6,
                            child: FutureBuilder(
                                future: Provider.of<ComissaoProvider>
                                  (context,listen: false)
                                    .getListComissaoPendenteByProfissional(profissional.id1),
                                builder: (context, snapshot){
                                  if (snapshot.hasData) {
                                    List<Comissao> comissoes = snapshot.data as List<Comissao>;
                                    comissoes.forEach((element) {
                                      print(element.id1);
                                    });
                                    return Column(
                                        children: [
                                          Text("COMISSÕES"),
                                          Container(
                                            width: size.width*0.28,
                                            height: size.height*0.5,
                                            color: AppColors.shape,
                                            child:  ListView.builder(
                                                itemCount: comissoes.length,
                                                itemBuilder: (parentContext, index){
                                                  return Card(
                                                    child: ListTile(
                                                      leading: Container(
                                                        // color: AppColors.blue,
                                                          width: size.width*0.06,
                                                          height: size.height*0.1,
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            alignment: Alignment.centerRight,
                                                            child: Text("R\$ ${comissoes[index].valor}", style: AppTextStyles.labelBlack16Lex,),
                                                          )
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(comissoes[index].situacao),


                                                          //desc transação + paciente
                                                          FutureBuilder(
                                                              future: Provider.of<TransacaoProvider>(context,listen: false)
                                                                  .getTransacaoById2(comissoes[index].idTransacao),
                                                              builder: (context, snapshot){
                                                                if(snapshot.hasData){
                                                                  // TransacaoCaixa transacao =  snapshot.data as TransacaoCaixa;

                                                                  _transacao =  snapshot.data as TransacaoCaixa;
                                                                  setState;
                                                                  return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(_transacao!.descricaoTransacao),
                                                                      FutureBuilder(
                                                                          future: Provider.of<PacienteProvider>(context,listen: false)
                                                                              .getPacienteById2(_transacao!.idPaciente),
                                                                          builder: (context, snapshot){
                                                                            print("entrou");
                                                                            if(snapshot.hasData){
                                                                              Paciente paciente =  snapshot.data as Paciente;
                                                                              return Text(paciente.nome!);
                                                                            } else{
                                                                              return Center();
                                                                            }
                                                                          })
                                                                    ],
                                                                  );
                                                                } else{
                                                                  return Center();
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                      title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                          Text(comissoes[index].dataGerada),
                                                          Text(comissoes[index].id1.substring(0,4)),
                                                        ]
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ]
                                      );
                                    }else {
                                      if (snapshot.hasError){
                                        return Center(
                                            child: Text("Comissão não encontrada")
                                        );
                                      }
                                      return Center(
                                          child: Text("Comissão não encontrada")
                                      );
                                    }
                                    // return Text("Especialidade não encontrada");
                                  }),
                            ),
                            Container(
                              width: size.width*0.25,
                              height: size.height*0.3,
                              // color: AppColors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.only(
                                      left:size.width*0.01, right: size.width*0.01),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // color: AppColors.green,
                                          width: size.width*0.23,
                                          height: size.height*0.04,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text("PROFISSIONAL:",
                                              style: AppTextStyles.labelBlack14Lex,),

                                          ),
                                        ),
                                        Container(
                                          // color: AppColors.green,

                                          width: size.width*0.23,
                                          height: size.height*0.06,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text("${profissional.nome}", style: AppTextStyles.labelBlack16Lex,),
                                          ),
                                        ),
                                        Container(
                                          // color: AppColors.blue,
                                          width: size.width*0.23,
                                          height: size.height*0.04,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text("TOTAL:", style: AppTextStyles.labelBlackBold20Slin,),
                                          ),
                                        ),
                                        Container(
                                          // color: AppColors.blue,
                                          width: size.width*0.23,
                                          height: size.height*0.09,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text("R\$ $valorComissao", style: AppTextStyles.labelBold33,),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.center,
                                    child:  ButtonWidget(
                                      onTap: ()async{
                                        //inserindo pagamento profissional
                                        await Provider.of<PagamentoProfissionalProvider>(context, listen: false)
                                            .put(
                                            PagamentoProfissional(
                                                idProfissional: profissional.id1,
                                                data: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                                hora: UtilData.obterHoraHHMM(DateTime.now()),
                                                valor: valorComissao )).then((value) async{
                                          await Provider.of<ComissaoProvider>(context, listen: false)
                                              .PagarComissoes(profissional.id1,value);

                                        });
                                        //editar comissão como paga

                                        // Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, "/caixa");
                                      },
                                      label: "EFETUAR PAGAMENTO",
                                      width: MediaQuery.of(context).size.width * 0.07,
                                      height: MediaQuery.of(context).size.height * 0.065,
                                    ),
                                  )
                                ],
                              ),
                            )

                          ],
                        ),

                      ],
                    ),
                  ),
                actions: [
                  SimpleDialogOption(
                      child: Text("FECHAR"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              );
            }
        );
      }
    );

  }

  static Future<void> AlertPagamentoComissao(
      parentContext, List<Profissional> profissionalPendentes){

    List<String> valoresComissao = [];
    Size size = MediaQuery.of(parentContext).size;
    String valorComissao = "";
    return showDialog(
      context: parentContext,
      barrierColor: AppColors.shape,
      builder: (context){
        return StatefulBuilder(
          builder: (parentContext, setState){
            return AlertDialog(
               title: Container(
                width: size.width*0.6,
                height: size.height*0.75,
                child: Column(
                  children: [
                    Text("SELECIONE UM PROFISSIONAL PARA REALIZAR O PAGAMENTO",
                      style: AppTextStyles.labelBold22,
                    ),
                    Container(
                      width: size.width*0.58,
                      height: size.height*0.6,
                      color: AppColors.shape,
                      child: ListView.builder(
                      itemCount: profissionalPendentes.length,
                      itemBuilder: (contex,index){
                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(profissionalPendentes[index].nome!),
                                  Row(
                                    children: [
                                      Text("R\$ "),
                                      FutureBuilder(
                                          future: Provider.of<ComissaoProvider>
                                            (context,listen: false)
                                              .getValorComissaoByProfissional(profissionalPendentes[index].id1),
                                          builder: (context, snapshot){
                                            if (snapshot.hasData) {
                                              valorComissao = snapshot.data as String;
                                              valoresComissao.add(valorComissao);
                                              print(valorComissao);
                                              return Text(valorComissao);
                                            }else {
                                              if (snapshot.hasError){
                                                return Center(
                                                    child: Text("")
                                                );
                                              }
                                              return Center(
                                                  child: Text("")
                                              );
                                            }
                                            // return Text("Especialidade não encontrada");
                                          })
                                    ],
                                  ),
                                  // Text("0,00"),
                                ],
                              ),
                              onTap: (){
                                Dialogs.AlertConfirmPagamento(parentContext, profissionalPendentes[index], valoresComissao[index]);
                              },
                              trailing: Icon(Icons.payment),

                            )
                          );
                      }),
                    )
                  ],
                )

            ),
               actions: [
                 SimpleDialogOption(
                     child: Text("FECHAR"),
                     onPressed: () {
                       Navigator.pop(context);
                     }),
               ],
            );
          }
        );
      }
    );

  }


  //PAGAMENTO COMISSÃO PROFISSIONAL
  static Future<void> AlertPagarProfissional(
      parentContext, List<Profissional> list) {
    String valorComissao = "0,00";
    String dropdown = list.first.nome.toString();

    List<DropdownMenuItem<String>> getDropdownProfissionais(
        List<Profissional> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].nome.toString(),
          child: Text(list[i].nome.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    String getIdProfissionalSelecionado(String nome){
      String id = "";
      list.forEach((element) {
        if (element.nome!.compareTo(nome)==0){
          print("aaa ${element.id1}");
          id = element.id1;
        }
      });
      return id;
    }

    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context) {
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pagar Comissão Proffisional", style: AppTextStyles.labelBold16),
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width * 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Selecione o Profissional:  ",
                          style: AppTextStyles.subTitleBlack14,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.shape),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton<String>(
                              value: dropdown,
                              icon: const Icon(Icons.arrow_drop_down_sharp),
                              elevation: 16,
                              style: TextStyle(color: AppColors.labelBlack),
                              underline: Container(
                                height: 2,
                                color: AppColors.line,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdown = newValue!;
                                });
                              },
                              items: getDropdownProfissionais(list),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //valor comissão
                  Container(
                    height: MediaQuery.of(parentContext).size.height * 0.07,
                    width: MediaQuery.of(parentContext).size.width * 0.17,
                    child: Row(children: [
                      SizedBox(
                        height: MediaQuery.of(parentContext).size.height * 0.07,
                        width: MediaQuery.of(parentContext).size.width * 0.052,
                        child: Center(
                          child: Icon(Icons.monetization_on_outlined),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(parentContext).size.height * 0.07,
                        width: MediaQuery.of(parentContext).size.width * 0.118,
                        color: AppColors.secondaryColor,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(children: [
                            Text("R\$"),
                            FutureBuilder(
                                future: Provider.of<ComissaoProvider>
                                  (context,listen: false)
                                    .getValorComissaoByProfissional(getIdProfissionalSelecionado(dropdown)),
                                builder: (context, snapshot){
                                  if (snapshot.hasData) {
                                    valorComissao = snapshot.data as String;
                                      return Text(valorComissao);
                                  }else {
                                    if (snapshot.hasError){
                                      return Center(
                                          child: Text("Comissão não encontrada")
                                      );
                                    }
                                    return Center(
                                        child: Text("Comissão não encontrada")
                                    );
                                  }
                                  // return Text("Especialidade não encontrada");
                                })
                          ]),
                        ),
                      ),
                    ],),
                  ),

                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("PAGAR"),
                    onPressed: () async{
                      await Provider.of<PagamentoProfissionalProvider>(context, listen: false)
                          .put(
                          PagamentoProfissional(
                          idProfissional: getIdProfissionalSelecionado(dropdown),
                          data: UtilData.obterDataDDMMAAAA(DateTime.now()),
                          hora: UtilData.obterHoraHHMM(DateTime.now()),
                          valor: valorComissao ));
                      //editar comissão como paga
                      await Provider.of<ComissaoProvider>(context, listen: false)
                          .PagarComissoes(getIdProfissionalSelecionado(dropdown),"");
                      Navigator.pop(context);
                    }),
                SimpleDialogOption(
                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  //DropWidiget
  static Widget DropWidgetProfissional(parentContext, List<Profissional> list) {
    String dropdownProfissional = list.first.nome.toString();

    List<DropdownMenuItem<String>> getDropdownProfissionais(
        List<Profissional> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].nome.toString(),
          child: Text(list[i].nome.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    return StatefulBuilder(
      builder: (parentContext, setState) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.labelWhite),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<String>(
            value: dropdownProfissional,
            icon: const Icon(Icons.arrow_drop_down_sharp),
            elevation: 16,
            style: TextStyle(color: AppColors.labelBlack),
            underline: Container(
              height: 2,
              color: AppColors.line,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownProfissional = newValue!;
                print(newValue);
                print(dropdownProfissional);
              });
            },
            items: getDropdownProfissionais(list),
          ),
        ),
      ),
    );
  }

  static Future<void> AlertFinalizarConsulta(parentContext, Sessao sessao) {
    String dropdownTpPagamento = "";
    List<TipoPagamento> items = [];
    StreamSubscription<QuerySnapshot>? tpPagamentoSubscription;
    var db = FirebaseFirestore.instance;

    List<DropdownMenuItem<String>> getDropdownTpPagamento() {
      tpPagamentoSubscription?.cancel();
      tpPagamentoSubscription =
          db.collection("tipos_pagamento").snapshots().listen((snapshot) {
        items = snapshot.docs
            .map((documentSnapshot) => TipoPagamento.fromMap(
                  documentSnapshot.data(),
                  int.parse(documentSnapshot.id),
                ))
            .toList();
        items.sort(
            (a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
      });
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < items.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: items[i].descricao.toString(),
          child: Text(items[i].descricao.toString()),
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }

    return showDialog(
        context: parentContext,
        barrierColor: AppColors.shape,
        builder: (context) {
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pagamento Comissão Proffisional"),
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width * 0.35,
                    child: Column(
                      children: [
                        Text(
                          "Selecione o Tipo de pagamento",
                          style: AppTextStyles.subTitleBlack16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.labelWhite),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton<String>(
                              value: dropdownTpPagamento,
                              icon: const Icon(Icons.arrow_drop_down_sharp),
                              elevation: 16,
                              style: TextStyle(color: AppColors.labelBlack),
                              underline: Container(
                                height: 2,
                                color: AppColors.line,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownTpPagamento = newValue!;
                                });
                              },
                              items: getDropdownTpPagamento(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //valor comissão
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width * 0.2,
                    child: InputTextWidget(
                      label: "VALOR",
                      icon: Icons.monetization_on_outlined,
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
                  )
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("PAGAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SimpleDialogOption(
                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  //Opções Consulta
  static Future<void> AlertOpcoesConsulta(parentContext, Sessao sessao) {
    bool check1 = false, check2 = false, check3 = false;
    void zerarCheck() {
      check1 = false;
      check2 = false;
      check3 = false;
    }

    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(
            builder: (parentContext, setState) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sessao.dataSessao.toString()),
                  Text(sessao.salaSessao.toString()),
                  Text(sessao.horarioSessao.toString()),
                  Text(sessao.tipoSessao.toString()),
                  Text(sessao.descSessao.toString()),
                  Text("Situação: ${sessao.statusSessao.toString()}"),
                  Divider(
                    color: AppColors.labelBlack,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: check1,
                          onChanged: (value) {
                            zerarCheck();
                            check1 = true;
                            setState(() {});
                          }),
                      Text("Finalizar consulta")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: check2,
                          onChanged: (value) {
                            zerarCheck();
                            check2 = true;
                            setState(() {});
                          }),
                      Text("Reagendar consulta")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: check3,
                          onChanged: (value) {
                            zerarCheck();
                            check3 = true;
                            setState(() {});
                          }),
                      Text("Cancelar consulta")
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                SimpleDialogOption(
                    child: Text("Ok"),
                    onPressed: () {
                      if (check1) {
                        print("entrou");
                        // AlertFinalizarConsulta(context,consulta);
                        Navigator.pop(context);
                      }
                    }),
                SimpleDialogOption(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  static Future<void> AlertHorasTrabalhadas(parentContext, String dia) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Selecione os horários ofertados na " + dia),
              Container(
                color: AppColors.primaryColor,
                width: 400,
                child: Column(
                  children: [
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      // direction: Axis.horizontal,
                      children: ListHousColumn2(),
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  static Future<void> AlertConfirmSistema(parentContext, String descricao) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("DESEJA REALMENTE SALVAR O SISTEMA ABAIXO"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(descricao),
              ),
            ],
          ),
          actions: <Widget>[
            SimpleDialogOption(
                child: Text("SIM"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                child: Text("NÃO"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}

List<Widget> ListHousColumn() {
  List<Widget> list = [];
  String hour = "";
  for (int i = 8; i < 14; i++) {
    if (i < 10) {
      hour = "0" + i.toString() + ":00";
    } else {
      hour = i.toString() + ":00";
    }
    list.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListHoursWidget(
          hour: hour,
        ),
      ),
    ));
  }
  return list;
}

List<Widget> ListHousColumn2() {
  List<Widget> list = [];
  String hour = "";
  for (int i = 14; i < 20; i++) {
    if (i < 10) {
      hour = "0" + i.toString() + ":00";
    } else {
      hour = i.toString() + ":00";
    }
    list.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListHoursWidget(
          hour: hour,
        ),
      ),
    ));
  }
  return list;
}
