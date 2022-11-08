import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';

import '../daows/UsuarioWS.dart';
import '../model/Usuario.dart';
import '../model/Profissional.dart';
import '../model/dias_salas_profissionais.dart';
import '../model/sessao.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';

class AgendaAssistente extends StatefulWidget {
  const AgendaAssistente({Key? key}) : super(key: key);

  @override
  State<AgendaAssistente> createState() => _AgendaAssistenteState();
}

class _AgendaAssistenteState extends State<AgendaAssistente> {

  late List<Profissional> itemsProf = [];
  late List<DiasSalasProfissionais> itemsDiasSalasProf = [];
  late List<Profissional> itemsProfissional = [];
  late List<Sessao> itemsSessoes = [];
  late DateTime diaCorrente = DateTime.now();
  late Usuario _usuario = Usuario(
    idUsuario:1,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario:  "",
    tokenUsuario: "",
  );
  String _uid="";
  late int indexHoras = 12;

  final List<String> _listSalas = [
    "SALA 01",
    "SALA 02",
    "SALA 03",
    "SALA 04",
    "SALA 05",
    "SALA 06",
  ];

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
  ];


  String getDiaCorrente(String dia) {
    // String dia = DateFormat('EEEE').format(DateTime.now());
    switch (dia) {
      case 'Monday':
        {
          return "SEGUNDA";
        }
      case 'Tuesday':
        {
          return "TERÇA";
        }
      case 'Wednesday':
        {
          return "QUARTA";
        }
      case 'Thursday':
        {
          return "QUINTA";
        }
      case 'Friday':
        {
          return "SEXTA";
        }
      case 'Saturday':
        {
          return "SÁBADO";
        }
      case 'Sunday':
        {
          return "Domingo";
        }
    }
    return "";
  }

  Future<Usuario> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty){
      print("empity");
      String _uidGet ="";
      print("_uidGet $_uidGet");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    } else{
      print(" not empity");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    }
  }

  String getNomeProfById(String id){
    String? result ="";
    result = itemsProfissional.firstWhere((element) => element.id==(int.parse(id))).nome;
    if (result != null)
    return result;
    else return "";
  }

  Widget getWidgetHora(String hora, String sala,){
    // List<DiasSalasProfissionais> ias = [];
    String dia = getDiaCorrente(DateFormat('EEEE').format(diaCorrente));
    print(itemsDiasSalasProf.length);
    print("itemsDiasSalasProf.length");
    print(hora);
    print(sala);
    print(dia);


    // itemsDiasSalasProf.where((element) => false);
    for (var items in itemsDiasSalasProf){
      print("--------");
      print(items.hora);
      print(items.sala);
      print(items.dia);
      if ((items.dia!.compareTo(dia)==0) &&
          (items.sala!.compareTo(sala)==0)&&
          (items.hora!.compareTo(hora)==0)){
          print("entrooouu=====");
          String? nome = "";

          // await Provider.of<ProfissionalProvider>(context,
          // listen: false).getProfById(items.idProfissional.toString()).then((value) {
          //   nome=value?.nome;
          //   print("nome $nome");
          //   return Text(nome!);
          // } );
        return Card(child: Text(getNomeProfById(items.idProfissional.toString())),);
      } else {
        print("nçao entrou");
      }
    }
    return Text("data");
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DiasSalasProfissionaisProvider>(context,listen: false)
      .getListOcupadas().then((value) {
      itemsDiasSalasProf = value;
    });
    Provider.of<ProfissionalProvider>(context, listen: false)
      .getListProfissionaisAtivos().then((value) {
        itemsProfissional = value;
    });
    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value){
          print("usuário autenticado profissionais");
          PrefsService.getUid().then((value) {
            _uid = value;
            print("_uid initState profissionais $_uid");
            getUsuarioByUid(_uid).then((value) {
              _usuario = value;
              print("Nome ${_usuario.nomeUsuario}");
              if (this.mounted){
                setState((){});
              }
            });

          });
        } else {
          print("usuário não conectado initState Home Assistente");
          ///nav
          Navigator.pushReplacementNamed(
              context, "/login");
        }
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBarWidget2(nomeUsuario: _usuario.nomeUsuario!),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //aba horarios
                    Container(
                      width: size.width*0.2,
                      height: size.height*0.04,
                      decoration: BoxDecoration(
                        color: AppColors.shape,
                        boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                        ],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.0),
                            topLeft: Radius.circular(4.0) )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.keyboard_double_arrow_left,
                              color: AppColors.labelBlack,
                            ),
                            onTap: (){
                              diaCorrente = diaCorrente.subtract(Duration(days: 1));

                              print("subtraiu");
                              print(diaCorrente.day);
                              print(diaCorrente.month);
                              if (getDiaCorrente(DateFormat('EEEE').format(diaCorrente)).compareTo("SÁBADO")==0){
                                indexHoras = 6;
                              } else {
                                indexHoras = 12;
                              }
                              setState((){});
                            },
                          ),
                          SizedBox(
                            width: size.width*0.12,
                            height: size.height*0.04,
                            child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "${getDiaCorrente(DateFormat('EEEE').format(diaCorrente))}    ${diaCorrente.day}/${diaCorrente.month}",
                                  style: AppTextStyles.labelBold16,)),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.keyboard_double_arrow_right,
                              color: AppColors.labelBlack,
                            ),
                            onTap: (){
                              diaCorrente = diaCorrente.add(Duration(days: 1));

                              print("add");
                              print(diaCorrente.day);
                              print(diaCorrente.month);
                              print(diaCorrente.month);
                              if (getDiaCorrente(DateFormat('EEEE').format(diaCorrente)).compareTo("SÁBADO")==0){
                                indexHoras = 6;
                              } else {
                                indexHoras = 12;
                              }
                              setState((){});
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.9,
                      height: size.height * 0.75,
                      decoration: BoxDecoration(
                        color: AppColors.labelWhite,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //coluna Horários
                          Container(
                              width: size.width * 0.06,
                              height: size.height * 0.75,
                              decoration: BoxDecoration(
                                color: AppColors.labelWhite,
                              ),
                              child: Column(
                                children: [

                                  Padding(
                                    padding:  EdgeInsets.all(size.height*0.008),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.line,
                                            borderRadius: BorderRadius.circular(4.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 4.0,
                                              ),
                                            ],
                                        ),
                                        height: size.height * (0.75 / (13))-(size.height*0.016),
                                        width: size.width*0.06-(size.height*0.016),
                                        child: Center(child: FittedBox(child: Text("Horário", style: AppTextStyles.labelBlack14Lex,)))),
                                  ),
                                  for (int i=0; i<12; i++)
                                    Padding(
                                      padding:  EdgeInsets.all(size.height*0.008),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 4.0,
                                                ),
                                              ],
                                            color: (i%2==0)?AppColors.secondaryColor : AppColors.secondaryColor2,
                                            borderRadius: BorderRadius.circular(4.0)
                                          ),
                                          height: size.height * (0.75 / (13))-(size.height*0.016),
                                          width: size.width*0.06-(size.height*0.016),
                                          child: Center(child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(_listHoras[i], style: AppTextStyles.labelBlack14Lex,)))),
                                    )
                                ],
                              )),

                          for (int i=0; i<6; i++)
                          Container(
                              width: (size.width * 0.84)/6,
                              height: size.height * 0.75,
                              decoration: BoxDecoration(
                                color: AppColors.labelWhite,
                              ),
                              child: Column(
                                children: [
                                  //Sala
                                  Padding(
                                    padding: EdgeInsets.all(size.height*0.008),
                                    child: Container(
                                      width: (size.width * 0.84)/6-(size.height*0.016),
                                      height: size.height * 0.75/(13)-(size.height*0.016),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 4.0,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: AppColors.line,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.door_back_door_rounded),
                                          FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(_listSalas[i], style: AppTextStyles.labelBlack16Lex,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //horários sala
                                  for (int j=0; j<indexHoras; j++)
                                    Padding(
                                      padding: EdgeInsets.all(size.height*0.008),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4.0),
                                          color: (j%2==0)?AppColors.secondaryColor : AppColors.secondaryColor2,
                                        ),
                                          width: (size.width * 0.84)/6 - (size.height*0.016),
                                          height: (size.height * 0.75/(13))- (size.height*0.016),
                                          child: Center(child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              //getWidget?
                                              child: getWidgetHora(_listHoras[j], _listSalas[i],),
                                              // FutureBuilder(
                                              //   future: getWidgetHora(_listHoras[j], _listSalas[i],),
                                              //   builder: (BuildContext parentContext, AsyncSnapshot snapshot) {
                                              //     if (snapshot.hasData) {
                                              //       return snapshot.data;
                                              //     } else {
                                              //       return Text('Livres');
                                              //     }
                                              //   }),
                                              // getWidgetHora(_listHoras[j], _listSalas[i],),))!,

                                              // Text(_listHoras[j], style: AppTextStyles.labelBlack14Lex,))),
                                      ),
                                  ))),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
    );
  }
}


