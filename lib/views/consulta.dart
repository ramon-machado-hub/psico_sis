import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/button_widget.dart';

import '../daows/UsuarioWS.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/input_text_widget.dart';

class Consulta extends StatefulWidget {
  const Consulta({Key? key}) : super(key: key);

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {

  late List<Paciente> _lPaciente = [];
  late List<Profissional> _lProfissional = [];

  Future<List<Paciente>> ReadJsonDataPaciente() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/pacientes_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Paciente.fromJson(e)).toList();
  }

  Future<List<Profissional>> ReadJsonDataProfissional() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/profissionais_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Profissional.fromJson(e)).toList();
  }



  String dropdownPagamento = 'À VISTA (DINHEIRO)';
  String dropdownTpConsulta = 'CONSULTA';
  String dropdownProfissional = "";
  String dropdownParceiro = 'AD PROMOTORA';
  String dropdownPaciente = 'ANDRÉ SILVA NASCIMENTO';
  bool checkParceiro = false;

  // future: Future.wait([bar, foo]),

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future:
            Future.wait([ReadJsonDataPaciente(), ReadJsonDataProfissional()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {

          if (snapshot.hasError) {
            print("erro ao carregar o json");
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData) {
            print("entrou");
            _lPaciente =  snapshot.data![0] as List<Paciente>;
            _lProfissional =  snapshot.data![1] as List<Profissional>;
            dropdownProfissional = _lProfissional[0].nome.toString();
            for(var item in _lPaciente)
              print(item.nome);
          }
          return SafeArea(
              child: Scaffold(
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
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColors.shape),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 6.0, right: 6.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text("1",
                                          style: AppTextStyles.subTitleWhite14),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: AppColors.line,
                                    height: 3,
                                  )),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 6.0, right: 6.0),
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
                                    padding:
                                        EdgeInsets.only(left: 6.0, right: 6.0),
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
                            height: size.height * 0.6,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.shape),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Tipo Consulta
                                  Text(
                                    "Tipo de consulta",
                                    style: AppTextStyles.subTitleBlack14,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.labelWhite),
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
                                          'CONSULTA',
                                          'SESSÃO INDIVIDUAL',
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
                                  //DROP PROFISSIONAL
                                  Text("Profissional",
                                      style: AppTextStyles.subTitleBlack14),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.labelWhite),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: DropdownButton<Profissional>(
                                        hint:  Text("Selecione Profissional"),
                                        value: _lProfissional[0],
                                        icon: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                        elevation: 16,
                                        style: TextStyle(
                                            color: AppColors.labelBlack),
                                        underline: Container(
                                          height: 2,
                                          color: AppColors.line,
                                        ),
                                        onChanged: (Profissional? newValue) {
                                          setState(() {
                                            // selectProfissional = newValue!;
                                            // dropdownProfissional = newValue!;
                                          });
                                        },
                                        items: _lProfissional.map(
                                            (Profissional profissional) {
                                          return DropdownMenuItem<Profissional>(
                                            value: profissional,
                                            child: Text(profissional.nome.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  //CHECKBOX ++ DROP PARCEIROS
                                  Container(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            activeColor: AppColors.line,
                                            checkColor: AppColors.labelWhite,
                                            value: checkParceiro,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                checkParceiro = value!;
                                              });
                                            }),
                                        Text(
                                          "Desconto via Parceiro",
                                          style: AppTextStyles.subTitleBlack14,
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        if (checkParceiro)
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.labelWhite),
                                            child: DropdownButton<String>(
                                              value: dropdownParceiro,
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
                                                  dropdownParceiro = newValue!;
                                                });
                                              },
                                              items: <String>[
                                                'AD PROMOTORA',
                                                'MARATÁ',
                                                'RADIANTE',
                                                'SE PROMOTORA',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  //DROP PACIENTES
                                  Text(
                                    "Paciente",
                                    style: AppTextStyles.subTitleBlack14,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.labelWhite),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: DropdownButton<String>(
                                            value: dropdownPaciente,
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
                                                dropdownPaciente = newValue!;
                                              });
                                            },
                                            items: <String>[
                                              'ANDRÉ SILVA NASCIMENTO',
                                              'CARLOS EDUARDO SANTOS SILVA',
                                              'RAFAELA FRANÇA DIAS',
                                              'RAMON LUIZ ALVES MACHADO',
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                        // height: 10,
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, "/cadastro_paciente");
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
                                      // IconButton(
                                      //   color: AppColors.labelWhite,
                                      //   icon: Icon(Icons.add),
                                      //   onPressed: () {
                                      //     Navigator.pushReplacementNamed(
                                      //         context, "/cadastro_paciente");
                                      //   },
                                      // )
                                    ],
                                  ),

                                  //DROP FORMA DE PAGAMENTO
                                  Text(
                                    "Forma de Pagamento",
                                    style: AppTextStyles.subTitleBlack14,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.labelWhite),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: DropdownButton<String>(
                                        value: dropdownPagamento,
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
                                            dropdownPagamento = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'À VISTA (DINHEIRO)',
                                          'À VISTA (PIX)',
                                          'À VISTA (DÉBITO)',
                                          'CARTÃO DE CRÉDITO (VENCIMENTO)',
                                          'CARTÃO DE CRÉDITO (2X)',
                                          'CARTÃO DE CRÉDITO (3X)',
                                          'CARTÃO DE CRÉDITO (4X)',
                                          'POR SESSÃO',
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
                              Navigator.pushReplacementNamed(
                                  context, "/agendamento_consulta");
                            },
                          ),
                        ),
                      ],
                    ),
                  )));
        });
  }
}
