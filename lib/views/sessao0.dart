import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/arguments/sessao2_arguments.dart';
import 'package:psico_sis/model/Especialidade.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/button_widget.dart';
import 'package:psico_sis/widgets/drop_down_item_widget.dart';

import '../daows/UsuarioWS.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/servico.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';

class Sessao0 extends StatefulWidget {
  const Sessao0({Key? key}) : super(key: key);

  @override
  State<Sessao0> createState() => _Sessao0State();
}

class _Sessao0State extends State<Sessao0> {
  late List<bool> _lCheckSelected = [];
  late ServicosProfissional _servicoProfissional;
  late String _selectServico = "";
  late double _selectValorServico = 0;
  late List<Profissional> _lProfissional = [];
  late List<Servico> _lServicos = [];
  late List<ServicosProfissional> _lServProfisional = [];
  late List<Especialidade> _lEspecialidade = [];
  late List<ServicosProfissional> _lServByProfissional = [];
  late Profissional _profissionalSelected;
  late bool _selectProfissional = false;

  Future<void> ReadJsonDataProfissional() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/profissionais_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lProfissional = list.map((e) => Profissional.fromJson(e)).toList();
    });
  }

  Future<void> ReadJsonDataServicosProfissional() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/servicos_profissional_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lServProfisional =
          list.map((e) => ServicosProfissional.fromJson(e)).toList();
    });
  }

  Future<void> ReadJsonDataServicos() async {
    final jsondata = await rootBundle.loadString('jsonfile/servicos_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lServicos = list.map((e) => Servico.fromJson(e)).toList();
    });
  }

  Future<void> ReadJsonDataEspecialidade() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/especialidades_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lEspecialidade = list.map((e) => Especialidade.fromJson(e)).toList();
    });
  }

  // String dropdownPagamento = 'À VISTA (DINHEIRO)';
  // String dropdownTpConsulta = 'CONSULTA';
  // String dropdownProfissional = "";
  // String dropdownParceiro = 'AD PROMOTORA';
  // String dropdownPaciente = 'ANDRÉ SILVA NASCIMENTO';
  bool checkParceiro = false;

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

  List<DropdownMenuItem<String>> getDropdownServicosProfissional(
      int id_profissional, List<Profissional> list) {
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

  String getNomeProfissionalById(int id, List<Profissional> list) {
    String value = "ID não encontrado";
    list.forEach((element) {
      if (element.id == id) {
        value = element.nome.toString();
      }
    });
    return value;
  }

  String getDescServicoById(int? id, List<Servico> list) {
    String value = "ID Serviço não encontrado";
    print(list.length);
    list.forEach((element) {
      if (element.id == id) {
        value = element.descricao.toString();
      }
    });
    return value;
  }

  List<ServicosProfissional> getServProfByIdProfissional(
      int? idProfissional, List<ServicosProfissional> list) {
    List<ServicosProfissional> listServ = [];

    list.forEach((element) {
      if (element.idProfissional == idProfissional) {
        listServ.add(element);
      }
    });
    return listServ;
  }

  // String getDescAndValorServicoByIdProfissional(int id_profissional,List<Servico> listServ, List<ServicosProfissional> list){
  //   String value = "";
  //   for (int i =0; i<list.length; i++){
  //     if (list[i].idProfissional==id_profissional){
  //       value = getDescServicoById(list[i].idServico, listServ)+" RS "+list[i].valor.toString();
  //     }
  //   }
  //   return value;
  // }

  @override
  initState() {
    super.initState();
    ReadJsonDataProfissional();
    ReadJsonDataServicos();
    ReadJsonDataServicosProfissional();
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
          width: size.width,
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
                            backgroundColor: AppColors.line,
                            child: Text("2"),
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
                            backgroundColor: AppColors.line,
                            child: Text("3"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              //container com as informações da consulta
              Center(
                child: Container(
                  width: size.width * 0.45,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.shape),
                  child: Row(
                    children: [
                      //profissionais
                      //implementar filtros
                      Container(
                        width: size.width * 0.20,
                        height: size.height * 0.6,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8)),
                        ),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller:
                                ScrollController(keepScrollOffset: true),
                            itemCount: _lProfissional.length,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Card(
                                  elevation: 8,
                                  child: InkWell(
                                    onTap: () {
                                      _selectProfissional = true;
                                      _profissionalSelected =
                                          _lProfissional[index];
                                      _lServByProfissional =
                                          getServProfByIdProfissional(
                                              _lProfissional[index].id,
                                              _lServProfisional);
                                      _lServByProfissional.forEach((element) {
                                        _lCheckSelected.add(false);
                                      });
                                      setState(() {});
                                    },
                                    child: ListTile(
                                      trailing: InkWell(
                                          onTap: () {
                                            Dialogs.AlertDetalhesProfissional(context, _lProfissional[index]);
                                          },
                                          child:
                                              const Icon(Icons.library_books)),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_lProfissional[index]
                                              .nome
                                              .toString(), style: AppTextStyles.labelBlack16Lex,),
                                          Text("PICOLOGO"),
                                          Row(
                                            children: const [
                                              Text("SEG |"),
                                              Text(" TER |"),
                                              Text(" QUA"),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),

                      SizedBox(
                        width: size.width * 0.25,
                        height: size.height * 0.6,
                        child: Column(
                          children: [
                            _selectProfissional
                                ?
                                //Detalhes Profissional
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: Text(
                                        _profissionalSelected.nome.toString(),
                                        style: AppTextStyles.labelBlack20,
                                      )),
                                      const Text("Serviços"),
                                      //container Serviços do profissional
                                      Container(
                                        height: size.height * 0.5,
                                        width: size.width * 0.22,
                                        decoration: BoxDecoration(
                                            color: AppColors.line),
                                        child: ListView.builder(
                                            itemCount:
                                            _lServByProfissional.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 4.0,
                                                    left: 8.0,
                                                    right: 8.0,
                                                    bottom: 4.0),
                                                child: Container(
                                                  height:
                                                  size.height * 0.06,
                                                  width: size.width * 0.20,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.shape,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(3),
                                                  ),
                                                  //
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                    children: [
                                                      Container(
                                                        width: size.width *
                                                            0.13,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(getDescServicoById(
                                                              _lServByProfissional[
                                                              index]
                                                                  .idServico,
                                                              _lServicos),
                                                            style: AppTextStyles.labelBlack14Lex,),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                          size.width *
                                                              0.04,
                                                          child: Center(
                                                            child: Text(
                                                              "${_lServByProfissional[
                                                              index]
                                                                  .valor},00",
                                                              style: AppTextStyles
                                                                  .labelBlack16Lex,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: size.width *
                                                            0.02,
                                                        child: Checkbox(
                                                          value:
                                                          _lCheckSelected[
                                                          index],
                                                          onChanged:
                                                              (value) {
                                                            if (_lCheckSelected[
                                                            index]) {
                                                              //verdadeiro desmarcar
                                                              _lCheckSelected[
                                                              index] = false;
                                                              setState((){});
                                                            } else {
                                                              // falso marcar
                                                              //desmarcar todos
                                                              for (int i =0; i<_lCheckSelected.length; i++){
                                                                _lCheckSelected[i] = false;
                                                              }
                                                              //marcar
                                                              _lCheckSelected[
                                                              index] = true;
                                                              _selectValorServico =
                                                                _lServByProfissional[index].valor! as double;
                                                              _servicoProfissional = _lServByProfissional[index];
                                                              _selectServico = getDescServicoById(
                                                                  _lServByProfissional[
                                                                  index]
                                                                      .idServico,
                                                                  _lServicos);
                                                              setState((){});
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      Text("Selecione um Serviço"),

                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      "Selecione um Profissional",
                                      style: AppTextStyles.labelBlack20,
                                    ),
                                  ),
                          ],
                        ),

                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Center(
                child: ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "AVANÇAR >>",
                  onTap: () {
                    if (_selectServico!=""){
                      // bool teste = _selectServico.compareTo("other");
                      List<String> lSessao =[];
                      List<String> lhoraSessao =[];
                      List<String> lDataSessao =[];
                      List<double> lValorSessao =[];
                      //fazer um teste com a quantidade de sessões daquele serviço
                      if (_selectServico.toLowerCase().compareTo("pacote 4 sessões")==0){

                        //gerar lista 4 sessões
                        for(int i =0; i<4; i++){
                          lSessao.add("PACOTE 4 SESSÕES ${i+1}/4");
                          lValorSessao.add(_selectValorServico/4);
                          lDataSessao.add("INDEFINIDO");
                          lhoraSessao.add("INDEFINIDO");
                        }
                        Sessao2Arguments sessao =
                        Sessao2Arguments(_profissionalSelected, _servicoProfissional, lSessao,
                            lValorSessao, lDataSessao, lhoraSessao );
                        Navigator.pushReplacementNamed(context, "/sessao22", arguments: sessao);
                        print("entrou aqui");
                      } else {
                        lSessao.add(_selectServico);
                        lValorSessao.add(_selectValorServico);
                        lDataSessao.add("INDEFINIDO");
                        lhoraSessao.add("INDEFINIDO");
                        Sessao2Arguments sessao =
                        Sessao2Arguments(_profissionalSelected, _servicoProfissional, lSessao,
                            lValorSessao, lDataSessao, lhoraSessao );
                        Navigator.pushReplacementNamed(context, "/sessao22", arguments: sessao);
                        print("não entrou aqui");
                        // lValorSessao[0] = _selectValorServico;
                        //     Navigator.pushReplacementNamed(context, "/sessao22", arguments: _profissionalSelected);
                      }

                    }

                  },
                ),
              ),
            ],
          ),
        ));
  }
}
