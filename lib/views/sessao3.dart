import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/arguments/sessao3_arguments.dart';
import 'package:psico_sis/arguments/sessao4_arguments.dart';
import 'package:psico_sis/model/Parceiro.dart';
import 'package:psico_sis/model/forma_pagamento.dart';
import 'package:psico_sis/model/servico.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/button_widget.dart';
import 'package:psico_sis/widgets/drop_down_item_widget.dart';

import '../daows/UsuarioWS.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';

class Sessao3 extends StatefulWidget {
  final Sessao3Arguments arguments;
  const Sessao3({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Sessao3> createState() => _Sessao3State();
}

class _Sessao3State extends State<Sessao3> {
  late int _indexNomePacientes = 0;
  late bool _checkParceiro = false;
  late String dropdownTpPagamento = "";
  late String dropdownTpParceiro = "";
  late List<Paciente> _lPaciente = [];
  late List<Parceiro> _lParceiro = [];
  late List<Servico> _lServicos = [];
  late List<Paciente> _lPacientesSelecionados = [];
  late List<FormaPagamento> _lFormaPagamento = [];
  late Servico? _servico;
  late List<String> _listNomesPacientes = [];

  //mensagem de avisos
  void showSnackBar(String message) {
    SnackBar snack = SnackBar(
      backgroundColor: AppColors.secondaryColor,
      content: Text(
        message,
        style: AppTextStyles.labelWhite16Lex,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> ReadJsonDataServico() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/servicos_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lServicos = list.map((e) => Servico.fromJson(e)).toList();
      _lServicos.forEach((element) {
        if (element.id==widget.arguments.servico.idServico){
          _servico = element;
        }
      });
    });
  }

  Future<void> ReadJsonDataParceiro() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/parceiros_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lParceiro = list.map((e) => Parceiro.fromJson(e)).toList();
      _lParceiro.sort((a, b) => a.razaoSocial.toString().compareTo(b.razaoSocial.toString()));
      dropdownTpParceiro="${_lParceiro.first.razaoSocial} ${_lParceiro.first.desconto}%";
    });
  }

  Future<void> ReadJsonDataPaciente() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/pacientes_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {

      _lPaciente = list.map((e) => Paciente.fromJson(e)).toList();
      _lPaciente.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
    });
  }

  Future<void> ReadJsonDataFormaPagamento() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/formas_pagamento_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lFormaPagamento = list.map((e) => FormaPagamento.fromJson(e)).toList();
      _lFormaPagamento.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
      dropdownTpPagamento=_lFormaPagamento.first.descricao.toString();
    });
  }

  List<DropdownMenuItem<String>> getDropdownFormaPagamento(List<FormaPagamento> list) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i=0; i<list.length; i++){
      var newDropdown = DropdownMenuItem(
        value: list[i].descricao.toString(),
        child: Text(list[i].descricao.toString()),
      );
      dropDownItems.add(newDropdown);
    }
    return dropDownItems;
  }

  List<DropdownMenuItem<String>> getDropdownParceiro(List<Parceiro> list) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i=0; i<list.length; i++){
      var newDropdown = DropdownMenuItem(
        value: "${list[i].razaoSocial} ${list[i].desconto}%",
        child: Text("${list[i].razaoSocial} ${list[i].desconto}%"),
      );
      dropDownItems.add(newDropdown);
    }
    return dropDownItems;
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
      ReadJsonDataPaciente();
      ReadJsonDataServico();
      ReadJsonDataFormaPagamento();
      ReadJsonDataParceiro();
      for (int i =0; i<widget.arguments.qtdPacientes; i++){
        _listNomesPacientes.add("INDEFINIDO");
      }
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
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 2.0,
              colors: [
                AppColors.shape,
                AppColors.primaryColor,
              ],
            )),
        child: Row(
          children: [
            //informações ficha sessão
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.02, right: size.width * 0.02),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    height: size.height * 0.6,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: AppColors.labelWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0,left: 8.0,right: 8.0),
                      child: Column(
                        children: [
                          //tipo serviço
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "TIPO SERVIÇO: ",
                                    style: AppTextStyles.labelBlack12Lex,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Text(
                                "aaa",
                                // "${getDescServicoById(widget.arguments.servico.idServico)}",
                                style: AppTextStyles.labelBlack14Lex,
                              ),
                            ],
                          ),
                          //nome profissional
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "PROFISSIONAL:",
                                    style: AppTextStyles.labelBlack12Lex,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Text(
                                widget.arguments.profissional.nome.toString(),
                                style: AppTextStyles.labelBlack14Lex,
                              ),
                            ],
                          ),
                          //Pacientes
                          for (int i =0; i<widget.arguments.qtdPacientes; i++)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text("PACIENTE ${i+1}: ",
                                        style: AppTextStyles.labelBlack12Lex,)),
                                ),
                                Text(" ${_listNomesPacientes[i]}", style: AppTextStyles.labelBlack14Lex),
                              ],
                            ),

                          //divider
                          Padding(
                            padding: EdgeInsets.only(bottom: size.height * 0.02),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.labelBlack,
                            ),
                          ),
                          //sessões
                       for (int i = 0; i < widget.arguments.sessoes.length; i++)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: size.width * 0.13,
                                    height: size.height * 0.03,
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(widget.arguments.sessoes[i],
                                          style: AppTextStyles.labelBlack12Lex,))),
                                SizedBox(
                                    width: size.width * 0.06,
                                    height: size.height * 0.03,
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(widget.arguments.HorariosSessoes[i],
                                          style: AppTextStyles.labelBlack12Lex,))),
                                SizedBox(
                                    width: size.width * 0.06,
                                    height: size.height * 0.03,
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(widget.arguments.datasSessoes[i],
                                          style: AppTextStyles.labelBlack12Lex,))),
                                SizedBox(
                                  width: size.width * 0.03,
                                  height: size.height * 0.03,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "${widget.arguments.valorSessoes[i].toString()},00",
                                      style: AppTextStyles.labelBlack14Lex,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          //valor total
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      "Valor Total: ",
                                      style: AppTextStyles.labelBlack12Lex,
                                      textAlign: TextAlign.right,
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${widget.arguments.servico.valor},00",
                                    style: AppTextStyles.labelBlack14Lex,
                                    textAlign: TextAlign.right,
                                  ))
                            ],
                          ),
                          //divider
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.02),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.labelBlack,
                            ),
                          ),


                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Pagamento:"),
                                  Container(
                                    width: size.width*0.18,
                                    height: size.height*0.06,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.secondaryColor),
                                    child: Padding(
                                      padding:  EdgeInsets.all(4.0),
                                      child: DropdownButton<String>(
                                        value: dropdownTpPagamento,
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
                                            dropdownTpPagamento = newValue!;}
                                          );
                                        },
                                        items: getDropdownFormaPagamento(_lFormaPagamento),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              const Text("VÍNCULO PARCEIRO"),
                              Checkbox(value: _checkParceiro,
                                  onChanged: (value){
                                    _checkParceiro = value!;
                                    setState((){});
                                  })
                            ],
                          ),
                          if (_checkParceiro)
                            Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Parceiro:"),
                                  Container(
                                    width: size.width*0.18,
                                    height: size.height*0.06,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.secondaryColor),
                                    child: Padding(
                                      padding:  EdgeInsets.all(4.0),
                                      child: DropdownButton<String>(
                                        value: dropdownTpParceiro,
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
                                            dropdownTpParceiro = newValue!;}
                                          );
                                        },
                                        items: getDropdownParceiro(_lParceiro),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //informações paciente / passos
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //container com indicadores dos passos
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
                              backgroundColor: AppColors.primaryColor.withOpacity(0.6),
                              child: Text("1",
                                  style: AppTextStyles.labelBlack16Lex),
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
                              backgroundColor: AppColors.primaryColor.withOpacity(0.6),
                              child: Text("2",
                                  style: AppTextStyles.labelBlack16Lex),
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
                              backgroundColor: AppColors.primaryColor,
                              child: Text("3",
                                  style: AppTextStyles.labelWhite16Lex),
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
                              backgroundColor: AppColors.labelBlack.withOpacity(0.3),
                              child: Text("4",
                                  style: AppTextStyles.labelBlack16Lex),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //lista de pacientes
                Container(
                  width: size.width * 0.3,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: AppColors.line,
                          width: 0.8,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(3),
                      color: AppColors.shape),
                  child: Column(
                    children: [
                      SizedBox(
                          height: size.height*0.094,
                          child: Text("SELECIONE O PACIENTE ${_indexNomePacientes+1}", style: AppTextStyles.subTitleBlack16,)),
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: AppColors.line,
                              width: 0.8,
                            ),
                          ),
                        ),
                        child: ListView.builder(
                            itemCount: _lPaciente.length,
                            itemBuilder: (BuildContext context, int index,){
                              return Card(
                                elevation: 8,
                                child: InkWell(
                                  onTap: (){
                                    // print(_indexNomePacientes);
                                    // print(widget.arguments.qtdPacientes);
                                    if (_indexNomePacientes<widget.arguments.qtdPacientes){
                                      _lPacientesSelecionados.add(_lPaciente[index]);
                                      _listNomesPacientes.insert(_indexNomePacientes, _lPaciente[index].nome.toString());
                                      _indexNomePacientes++;
                                      setState((){});
                                      showSnackBar(
                                          "Paciente adicionado: ${_lPaciente[index].nome}");
                                    } else{
                                      showSnackBar(
                                          "Você já adicionou Todos os paciente! Clique em avançar.");
                                    }

                                  },
                                  child: ListTile(
                                    title: Text(_lPaciente[index].nome.toString()),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                //botão cadastrar paciente
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "AVANÇAR",
                  onTap: () {
                    if (_checkParceiro) {
                      Sessao4Arguments sessao4 = Sessao4Arguments(
                        widget.arguments.profissional, widget.arguments.servico,
                        widget.arguments.sessoes, widget.arguments.valorSessoes,
                        widget.arguments.datasSessoes, dropdownTpPagamento, widget.arguments.HorariosSessoes,
                        _lPacientesSelecionados,);
                      sessao4.parceiro = _lParceiro[0];
                      Navigator.pushReplacementNamed(
                          context, "/sessao4", arguments: sessao4);
                    } else{
                      Sessao4Arguments sessao4 = Sessao4Arguments(
                        widget.arguments.profissional, widget.arguments.servico,
                        widget.arguments.sessoes,  widget.arguments.valorSessoes,
                        widget.arguments.datasSessoes, dropdownTpPagamento, widget.arguments.HorariosSessoes,
                        _lPacientesSelecionados,);
                      sessao4.parceiro = null;
                      Navigator.pushReplacementNamed(
                          context, "/sessao4", arguments: sessao4);
                    }



                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
