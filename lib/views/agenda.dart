import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/alert_dialog.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/consulta.dart';

class Agenda extends StatefulWidget {
  const Agenda({Key? key}) : super(key: key);

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  @override
  initState() {
    super.initState();
    readJsonProfissionais();
    readJsonPacientes();
    readJsonDiasSalasProfissionais();
  }

  late String _data;
  late String _dia;
  late List<Profissional> _lprofissionais;
  late List<Consulta> _lconsultas = [];
  late List<Paciente> _lpacientes = [];
  late List<DiasSalasProfissionais> _ldiasSalasProfissionais = [];

  //HORARIO FUNCIONAMENTO CLINICA
  final List<String> _listHoras = [
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00"
  ];

  Future<void> readJsonDiasSalasProfissionais() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/dias_salas_profissionais.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _ldiasSalasProfissionais =
          list.map((e) => DiasSalasProfissionais.fromJson(e)).toList();
    });
  }

  Future<void> readJsonProfissionais() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/profissionais_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lprofissionais = list.map((e) => Profissional.fromJson(e)).toList();
    });
  }

  Future<void> readJsonPacientes() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/pacientes_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lpacientes = list.map((e) => Paciente.fromJson(e)).toList();
    });
  }

  //carrega consultas para o futurebuilder
  Future<List<Consulta>> readConsultas() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/consultas_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Consulta.fromJson(e)).toList();
  }

  DiasSalasProfissionais? getDiasSalasProfissionaisByDiaSalaHora(
      String dia, String sala, String hora) {
    try {
      for (int i = 0; i < _ldiasSalasProfissionais.length; i++) {
        if ((_ldiasSalasProfissionais[i]
                    .descDia
                    ?.toLowerCase()
                    .compareTo(dia.toLowerCase()) ==
                0) &&
            (_ldiasSalasProfissionais[i]
                    .descSala
                    ?.toLowerCase()
                    .compareTo(sala.toLowerCase()) ==
                0) &&
            (_ldiasSalasProfissionais[i]
                    .hora
                    ?.toLowerCase()
                    .compareTo(hora.toLowerCase()) ==
                0)) {
          print("dia sala Profissional verificada");
          return _ldiasSalasProfissionais[i];
        }
      }

      return null;
    } catch (e) {
      print("erro getIdProfissionalBySalaDataHora");
      return null;
    }
  }

  //pesquisa se existe alguma consulta naquela data hora e sala
  Consulta? getConsultaByDataAndHoraAndSala(
      List<Consulta> list, String data, String sala, String hora) {
    try {
      for (int i = 0; i < list.length; i++) {
        if ((list[i].dataConsulta?.compareTo(data) == 0) &&
            (list[i].salaConsulta?.compareTo(sala) == 0) &&
            (list[i].horarioConsulta?.compareTo(hora) == 0)) {
          print("data saldata sala hora verificada");
          return list[i];
        }
      }

      // print(list.length);
      // print("simiim");
      return null;
    } catch (e) {
      print("erro getconsultaByData");
      return null;
    }
  }

  String? getNomePacienteById(int? id) {
    if (_lpacientes.isNotEmpty) {
      for (int i = 0; i < _lpacientes.length; i++) {
        if (_lpacientes[i].idPaciente == id) {
          String? nome = _lpacientes[i].nome;
          int length = nome!.length - 1;
          String? primeiroNome = "";
          String? ultimoNome = "";
          String? temp = "";

          for (int j = 0; j < length; j++) {
            if (_lpacientes[i].nome?[j] == " ") {
              primeiroNome = temp;
              break;
            } else {
              temp = '$temp${_lpacientes[i].nome?[j]}';
            }
          }
          temp = "";
          for (int k = length; k > 0; k--) {
            if (_lpacientes[i].nome?[k] == " ") {
              ultimoNome = temp;
              break;
            } else {
              temp = '${_lpacientes[i].nome?[k]}$temp';
            }
          }
          return '$primeiroNome $ultimoNome';
          //           String? temp = "";
          //String? nome = _lprofissionais[i].nome;
          //           int length = nome!.length-1;
          //           String? abreviaNome = "";
          //           String? temp = "";
          //           var charFinalName = _lprofissionais[i].nome?[0];
          //           var charFirstName = _lprofissionais[i].nome?[0];
          //           for(int j = length; j>0; j--) {
          //
          //             if (_lprofissionais[i].nome?[j]==" "){
          //               abreviaNome = '$charFirstName. $temp.';
          //               break;
          //             } else {
          //               temp = _lprofissionais[i].nome?[j];
          //             }
          //           }
          //
          //           return abreviaNome;

          // return _lpacientes[i].nome;
        }
      }
    }
    return "";
  }

  String? getNomeProfissionalById(int? id) {
    if (_lprofissionais.isNotEmpty) {
      for (int i = 0; i < _lprofissionais.length; i++) {
        if (_lprofissionais[i].id == id) {
          String? nome = _lprofissionais[i].nome;
          int length = nome!.length - 1;
          String? abreviaNome = "";
          String? temp = "";
          var charFinalName = _lprofissionais[i].nome?[0];
          var charFirstName = _lprofissionais[i].nome?[0];
          for (int j = length; j > 0; j--) {
            if (_lprofissionais[i].nome?[j] == " ") {
              abreviaNome = '$charFirstName. $temp.';
              break;
            } else {
              temp = _lprofissionais[i].nome?[j];
            }
          }

          return abreviaNome;
        }
      }
    }
    return "";
  }

  //retorna card com informações daquele horario
  Widget getWidgetAgenda(
      List<Consulta> list, String data, String hora, String sala) {
    Consulta? consulta =
        getConsultaByDataAndHoraAndSala(list, data, sala, hora);
    DiasSalasProfissionais? diasSalas =
        getDiasSalasProfissionaisByDiaSalaHora(_dia, sala, hora);
    if (consulta != null) {
      // Card com as informações da consulta
      return Card(
        elevation: 8,
        color: AppColors.shape,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.049,
          width: MediaQuery.of(context).size.width * 0.125,
          child: Row(
            children: [
              //Iniciais profissional
              Padding(
                padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.042,
                    width: MediaQuery.of(context).size.width * 0.04,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(8),
                      // shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          getNomeProfissionalById(consulta.idProfissional)
                              .toString(),
                          style: AppTextStyles.subTitleBlack14,
                        ))),
              ),

              // Text("|"),
              VerticalDivider(
                thickness: 1,
                color: AppColors.labelBlack,
              ),

              //Nome paciente,
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.039,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.019,
                        child: FittedBox(
                            child: Text(
                          consulta.horarioConsulta.toString(),
                          style: AppTextStyles.subTitleBlack14,
                        )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.019,
                        child: FittedBox(
                            child: Text(
                          getNomePacienteById(consulta.idPaciente).toString(),
                          style: AppTextStyles.subTitleBlack14,
                        )),
                      ),
                    ],
                  )),

              //icone edit
              GestureDetector(
                onTap: (){

                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.028,
                  width: MediaQuery.of(context).size.width * 0.012,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child:  IconButton(
                      iconSize: 200,
                      onPressed: (){

                        Dialogs.AlertFinalizarConsulta(context, consulta);
                        // Dialogs.AlertOpcoesConsulta(context, consulta);
                      },
                      icon: Icon(
                          Icons.assignment_turned_in_rounded,
                          color: AppColors.labelBlack,
                        ),
                    ),
                    ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      if (diasSalas != null) {
        //Card informando sala reservada para profissional
        return Card(
          elevation: 8,
          //red
          color: AppColors.shape,
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.049,
              width: MediaQuery.of(context).size.width * 0.16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //Iniciais profissional
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.042,
                        width: MediaQuery.of(context).size.width * 0.04,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(8),

                          // shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              getNomeProfissionalById(diasSalas.idProfissional)
                                  .toString(),
                              style: AppTextStyles.subTitleBlack14,
                            ))),
                  ),
                  VerticalDivider(
                    color: AppColors.labelBlack,
                    thickness: 1,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.080,
                      child: const Text("LIVRE")),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.012,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.check_box_outline_blank),
                        // child: IconButton(
                        //   iconSize: 100,
                        //   onPressed: (){
                        //     Dialogs.AlertOpcoesConsulta(context, _lconsultas[0]);
                        //   },
                        //   icon: Icon(
                        //     Icons.assistant_photo_rounded,
                        //     color: AppColors.green,
                        //   ),
                        // ),
                      ),
                    ),
                  ),

                ],
              )),
        );
      }

      else {
        // Card informando sala livre
        return Card(
          elevation: 8,
          //green
          color: AppColors.shape,
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.049,
              width: MediaQuery.of(context).size.width * 0.125,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SALA LIVRE"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.012,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.assistant_photo_rounded,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      }
    }
  }

  String getsubDay(String dia) {
    switch (dia) {
      case 'Domingo':
        {
          return "Sábado";
        }
      case 'Segunda':
        {
          return "Domingo";
        }
      case 'Terça':
        {
          return "Segunda";
        }
      case 'Quarta':
        {
          return "Terça";
        }
      case 'Quinta':
        {
          return "Quarta";
        }
      case 'Sexta':
        {
          return "Quinta";
        }
      case 'sábado':
        {
          return "Sexta";
        }
    }
    return dia;
  }

  String getDataCorrente() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  String getDiaCorrente() {
    String dia = DateFormat('EEEE').format(DateTime.now());
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

  @override
  Widget build(BuildContext context) {
    _dia = getDiaCorrente();
    // _data = getDataCorrente();
    _data = "03/09/2022";
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: readConsultas(),
        builder: (context, data) {
          if (data.hasError) {
            print("erro ao carregar o json");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            print("entrou");
            // _lprofissionais = data.data as List<Profissional>;
            if (_lconsultas.isEmpty) {
              _lconsultas = data.data as List<Consulta>;
              for (var item in _lconsultas) print(item.horarioConsulta);
            }
          }
          return SafeArea(
              child: Scaffold(
                  // appBar: const PreferredSize(
                  //   preferredSize: Size.fromHeight(80),
                  //   child: AppBarWidget(),
                  // ),
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
                //aba dia
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: AppColors.secondaryColor),
                    height: size.height * 0.05,
                    width: size.width * 0.2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.025,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                                onPressed: () {
                                  print(_dia);
                                  _dia = getsubDay(_dia);

                                  // day = getAddDay();
                                  // print(day);
                                  setState(() {});
                                  print(_dia);
                                },
                                icon: Icon(
                                  Icons.keyboard_double_arrow_left,
                                  color: AppColors.labelWhite,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                _dia,
                                style: AppTextStyles.labelBlack16,
                              )),
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.keyboard_double_arrow_right,
                                  color: AppColors.labelWhite,
                                )),
                          ),
                        ),
                        Text(
                          _data,
                          style: AppTextStyles.labelBlack16,
                        ),
                        //home
                        Center(
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "/home_assistente");
                              },
                              icon: Icon(
                                Icons.home_filled,
                                color: AppColors.labelWhite,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),

                //horario e agenda
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //coluna horário
                    Column(
                      children: [
                        Container(
                          color: AppColors.line,
                          width: MediaQuery.of(context).size.width * 0.07,
                          height: MediaQuery.of(context).size.height * 0.065,
                          child: Card(
                              elevation: 3,
                              color: AppColors.labelWhite,
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "HORÁRIO",
                                        style: AppTextStyles.labelBlack16,
                                      ),
                                    ],
                                  ))),
                        ),

                        //lista de horas
                        Container(
                          color: AppColors.line,
                          width: MediaQuery.of(context).size.width * 0.07,
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: Column(
                            children: [
                              Divider(
                                height: 3,
                                color: AppColors.labelBlack,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.79,
                                child: ListView.builder(
                                    itemCount: _listHoras.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                          elevation: 3,
                                          color: AppColors.labelWhite,
                                          child: SizedBox(
                                              height:
                                                  MediaQuery.of(context).size.height *
                                                      0.049,
                                              width:
                                                  MediaQuery.of(context).size.width *
                                                      0.10,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: AppColors.labelBlack,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      _listHoras[index],
                                                      style:
                                                          AppTextStyles.labelBlack16,
                                                    ),
                                                  ),
                                                ],
                                              )));
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //container com listview SALAS
                    Column(
                      children: [
                        //listview salas (5) horizontal (SALAS)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: MediaQuery.of(context).size.width * 0.80,
                          color: AppColors.blue,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.16,
                                  color: AppColors.line,
                                  child: Card(
                                      elevation: 8,
                                      color: AppColors.labelWhite,
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.10,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.door_back_door_outlined,
                                                color: AppColors.labelBlack,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    "SALA " +
                                                        (index + 1).toString(),
                                                    style: AppTextStyles
                                                        .subTitleBlack14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                                );
                              }),
                        ),

                        //listview horizontal 5 COLUNAS CONSULTAS
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: MediaQuery.of(context).size.height * 0.80,
                          decoration: BoxDecoration(
                            color: AppColors.line,
                            // borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index1) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.79,
                                  width:
                                      MediaQuery.of(context).size.width * 0.16,
                                  color: AppColors.line,
                                  child: Column(
                                    children: [

                                      Divider(
                                        height: 3,
                                        color: AppColors.labelBlack,
                                      ),
                                      //listview Vertical (13)
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.79,
                                        child: ListView.builder(
                                            itemCount: 13,
                                            itemBuilder: (context, index) {
                                              //FUNÇÃO QUE RETORNA WIDGET CART COM LIVRE OU CONSULTA
                                              //GetWidget(hora, data, sala);
                                              print(_lconsultas.length);
                                              if (_lconsultas.isEmpty) {
                                                return Card(
                                                  elevation: 8,
                                                  color: AppColors.shape,
                                                  child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.055,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.125,
                                                      child: Row(
                                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("LIVRE"),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025,
                                                            child: Icon(
                                                              Icons
                                                                  .assistant_photo_rounded,
                                                              color: AppColors
                                                                  .labelBlack,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              } else {
                                                return getWidgetAgenda(
                                                    _lconsultas,
                                                    _data,
                                                    _listHoras[index],
                                                    ("SALA ${index1 + 1}"));
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )));
        });
  }
}
