// import 'dart:ffi';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_agenda.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import '../model/Paciente.dart';
import '../model/Usuario.dart';
import '../model/Profissional.dart';
import '../model/dias_salas_profissionais.dart';
import '../model/sessao.dart';
import '../model/tipo_pagamento.dart';
import '../provider/servico_profissional_provider.dart';
import '../provider/servico_provider.dart';
import '../provider/tipo_pagamento_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';

class AgendaAssistente extends StatefulWidget {
  // final DateTime? data;
  const AgendaAssistente({Key? key, }) : super(key: key);

  @override
  State<AgendaAssistente> createState() => _AgendaAssistenteState();
}

class _AgendaAssistenteState extends State<AgendaAssistente> {

  late List<Profissional> itemsProf = [];
  late List<DiasSalasProfissionais> itemsDiasSalasProf = [];
  late List<DiasSalasProfissionais> itemsBuscaSalasProf = [];
  late List<Sessao> _sessoesDoDia = [];
  late List<Profissional> itemsProfissional = [];
  late List<Sessao> itemsSessoes = [];
  late Sessao _sessaoAtual = Sessao(
  );
  late DateTime diaCorrente = DateTime.now();
  // late DateTime diaCorrente = (widget.data==null)? DateTime.now(): widget.data!;

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
    "SALA 07",
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

  // String getNomeProfById(String id){
  //   String result ="";
  //   // result = itemsProfissional.firstWhere((element) => (element.id?.compareTo(id)==0)).nome;
  //   print(itemsProfissional.length);
  //   itemsProfissional.forEach((element) {
  //     if (element.id1.compareTo(id)==0){
  //       result = element.nome!;
  //       print('aeeww');
  //     }
  //   });
  //   if (result != null){
  //     print('achou prof');
  //     print(result);
  //     return result;
  //   }
  //   else {
  //     print('NÃO achou prof');
  //
  //     return "";}
  // }

  String getNomeProfissionalIniciais(String nome) {
    String nomeAbreviado ="";
    for (int i = 0; i < nome.length; i++) {
       if(nome.substring(i,i+1).compareTo(" ")==0){
          nomeAbreviado += nome.substring(0,i+2)+".";
          break;
       }
    }
    return nomeAbreviado;
  }

  //
  // bool contemSessaoAnt(String hora, String sala){
  //   bool result = false;
  //   for(var item in _sessoesDoDia) {
  //     if ((item.salaSessao!.compareTo(sala) == 0)
  //         && (item.dataSessao!.compareTo(
  //             UtilData.obterDataDDMMAAAA(diaCorrente)) == 0)
  //         && (item.horarioSessao!.compareTo(hora) == 0)) {
  //       _sessaoAtual = item;
  //       result = true;
  //     }
  //   }
  //   return result;
  // }

  bool contemSessao(String hora, String sala){
    bool result = false;
    for(var item in _sessoesDoDia) {
      if ((item.salaSessao!.compareTo(sala) == 0)
          && (item.dataSessao!.compareTo(
              UtilData.obterDataDDMMAAAA(diaCorrente)) == 0)
          && (item.horarioSessao!.compareTo(hora) == 0)) {
           _sessaoAtual = item;
           result = true;
      }
    }
    return result;
  }

  // bool contemSessaoAnterior(String hora, String sala){
  //   bool result = false;
  //   for(var item in _sessoesDoDia) {
  //     if ((item.salaSessao!.compareTo(sala) == 0)
  //         && (item.dataSessao!.compareTo(
  //             UtilData.obterDataDDMMAAAA(diaCorrente)) == 0)
  //         && (item.horarioSessao!.compareTo(hora) == 0)) {
  //       _sessaoAtual = item;
  //       result = true;
  //     }
  //   }
  //   return result;
  // }
  Future<Widget> getWidgetAgendamentoAnterior(String hora, String sala) async {
    bool flag = false;
    String idProfissional = "";
    for (var item in _sessoesDoDia){
      if (
          (item.dataSessao!.compareTo(UtilData.obterDataDDMMAAAA(diaCorrente))==0)
          && (item.horarioSessao!.compareTo(hora) == 0)
          && (item.salaSessao!.compareTo(sala) == 0)
      ){
        flag = true;
        idProfissional = item.idProfissional!;
      }
    }

    return flag?
    Center(
      child: FutureBuilder(
        future: getProfissionalById(idProfissional),
        builder: (BuildContext parentContext, AsyncSnapshot snapshot){
          if (snapshot.hasData){
            Profissional profissional = snapshot.data as Profissional;
            return FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(getNomeProfissionalIniciais(profissional.nome!),
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
    )
        :
    Center(
      child: Text("LIVRE"),
    );
  }

  Future<Widget> getWidgetAgendamentoProfissional(String hora, String sala)async{
    bool flag = false;
    String idProfissional = "";
    for(var item in itemsDiasSalasProf) {
      if (
      (item.sala!.compareTo(sala) == 0)
          &&
      (item.dia!.compareTo(getDiaCorrente(DateFormat('EEEE').format(diaCorrente))) == 0)
          && (item.hora!.compareTo(hora) == 0)) {
        flag = true;
        idProfissional = item.idProfissional!;
      }
    }
    // print(flag);
    // print("flag");
    return (flag)?
        // Card(
        //   child: ListTile(
        //     title: FutureBuilder(
        //         future: Provider.of<ProfissionalProvider>(context,listen: false)
        //             .getProfissional(idProfissional),
        //         builder: (context, snapshot){
        //           if (snapshot.hasData){
        //             Profissional profissional = snapshot.data as Profissional;
        //             return FittedBox(
        //                 fit: BoxFit.contain,
        //                 child: Text(profissional.nome!,  style: AppTextStyles.labelBold12,)
        //             );
        //           } else {
        //             return Center(
        //                 child: Text("")
        //             );
        //           }
        //         }),
        //   ),
        // )
        // Card(
        //   child: Text("Ocupado"),
        // )
        Center(
          child: FutureBuilder(
              future: getProfissionalById(idProfissional),
              // future: Provider.of<ProfissionalProvider>(context,listen: false)
              //           .getProfissional(idProfissional),
              builder: (BuildContext parentContext, AsyncSnapshot snapshot){
                if (snapshot.hasData){
                  Profissional profissional = snapshot.data as Profissional;
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(getNomeProfissionalIniciais(profissional.nome!),
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
        )
        :
        Center(
          child: Text("LIVRE"),
        );
  }

  Future<Profissional> getProfissionalById(String id) async {
     return  itemsProfissional.firstWhere((element) => element.id1.compareTo(id)==0);
  }
  // Future<Paciente> getPacienteById(String id) async {
  //   return  .firstWhere((element) => element.id1.compareTo(id)==0);
  // }

  Future<Widget> getWidgetAgendamento(String hora, String sala, double height, double width) async{
    String dia = getDiaCorrente(DateFormat('EEEE').format(diaCorrente));
    late Profissional _profissional;
    late Paciente _paciente;
    bool result = false;
    Sessao sessao = Sessao();
    if ((dia.compareTo("Domingo")==0)||(dia.compareTo("SÁBADO")==0)){
      return Center(child:Text("LIVRE"));
    } 
    //checa se existe sessão para aquele dia
    for(var item in _sessoesDoDia) {
      if ((item.salaSessao!.compareTo(sala) == 0)
          && (item.dataSessao!.compareTo(
              UtilData.obterDataDDMMAAAA(diaCorrente)) == 0)
          && (item.horarioSessao!.compareTo(hora) == 0)) {
        sessao = item;
        result = true;
      }
    }

    bool dataPassada(){
      int dia = diaCorrente.day;
      int mes = diaCorrente.month;
      int ano = diaCorrente.year;

      int diaAtual = DateTime.now().day;
      int mesAtual = DateTime.now().month;
      int anoAtual = DateTime.now().year;

      if (ano<anoAtual){
        return true;
      } else if(ano>anoAtual){
        return false;
      } else if (ano == anoAtual){
        if (mes<mesAtual){
          return true;
        } else if (mes>mesAtual){
          return false;
        } else if (mes == mesAtual){
          if (dia<diaAtual){
            return true;
          } else {
            return false;
          }
        }
      }
      return false;
    }

    return (contemSessao(hora, sala))?
        Row(
          children: [
           Container(
             height: height,
             width: width*0.7,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(4.0),
               color: (sessao.statusSessao!.compareTo("FINALIZADA")==0)?AppColors.line:AppColors.shape,
             ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SizedBox(
                   height: height/2,
                   width: width*0.7,
                   child: FutureBuilder(
                       // future: Provider.of<ProfissionalProvider>(context,listen: false)
                       //     .getProfissional(sessao.idProfissional!),
                       future: getProfissionalById(sessao.idProfissional!),
                       builder: (context, snapshot){
                         if (snapshot.hasData){
                           Profissional profissional = snapshot.data as Profissional;
                           _profissional = profissional;
                           return Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child:Text(
                                    getNomeProfissionalIniciais(profissional.nome!),
                                    style: AppTextStyles.labelBold12,)
                               ),
                           );
                         } else {
                           if (snapshot.hasError) {
                             return Text('Error: ${snapshot.error}');
                           } else {
                             return Center(
                                 child: Text(""));
                           }
                         }
                       }),
                 ),
                 SizedBox(
                     height: height/2,
                     width: width*0.7,
                     child: FutureBuilder(
                         future: Provider.of<PacienteProvider>(context,listen: false)
                             .getPaciente(sessao.idPaciente!),
                         builder: (context, snapshot){
                           if (snapshot.hasData){
                             Paciente paciente = snapshot.data as Paciente;
                             _paciente = paciente;
                             return Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0),
                               child:FittedBox(
                                 fit: BoxFit.contain,
                                 child: Text(paciente.nome!.substring(0,15)+"...",
                                   textAlign: TextAlign.center,
                                   style: AppTextStyles.subTitleBlack,
                                 )  ),
                             );
                           } else {
                             if (snapshot.hasError) {
                               return Text('Error: ${snapshot.error}');
                             } else {
                               return Center(
                                   child: Text(""));
                             }
                           }
                         }),

                 ),

               ],
             ),
           ),
          SizedBox(
            height: height,
            width: width*0.15,
              child:

              // (sessao.statusSessao!.compareTo("AGENDADA")==0)?
              (sessao.situacaoSessao!.compareTo("PAGO")==0)?

              Center(
                child:  Icon(
                // size: (25.0),
                Icons.check_circle,
                color: AppColors.labelBlack,
              ),)
                  :
              InkWell(
                onTap: ()async{
                  List<TipoPagamento> tiposPagamento = [];
                  await Provider.of<TipoPagamentoProvider>(context, listen: false)
                      .getTiposPagamentos().then((value) {
                    tiposPagamento = value;
                    tiposPagamento.sort((a,b)=>a.descricao.toLowerCase().replaceAll("à", "a").compareTo(b.descricao.toLowerCase().replaceAll("à", "a")));
                  });
                  String result = "";
                  String valorSessao = "";
                  await Provider.of<ServicoProvider>(context, listen: false)
                      .getServicoByDesc(sessao.descSessao!
                        .substring(11,sessao.descSessao!.length))
                      .then((value) async{
                      result = value.id1;
                      await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          .getServByServicoProfissional(_profissional.id1,result).then((value) {
                          valorSessao = value.valor!;
                          print(result);
                      });
                  });
                  await DialogsAgendaAssistente.AlertDialogRegistrarPagamento(context, _uid, sessao, _paciente, _profissional, tiposPagamento, valorSessao);
                  setState((){});
                },
                 child: Icon(
                      size: (25.0),
                      // ((sessao.statusSessao!.compareTo("FINALIZADA")==0)||(sessao.statusSessao!.compareTo("CONFIRMADA")==0))?
                      // ((sessao.situacaoSessao!.compareTo("PAGO")==0))?
                      Icons.monetization_on,
                      color: AppColors.red,
                    ),
              )
          ),
          SizedBox(
            height: height,
            width: width*0.15,
            child: FittedBox(
                fit: BoxFit.contain,
                child: InkWell(
                    onTap: (sessao.statusSessao!.compareTo("FINALIZADA")==0)? null :
                        ()async {
                      Sessao sessaof = new Sessao(
                        idProfissional: sessao.idProfissional,
                        idTransacao:  sessao.idTransacao,
                        idPaciente: sessao.idPaciente,
                        dataSessao: sessao.dataSessao,
                        horarioSessao: sessao.horarioSessao,
                        tipoSessao: sessao.tipoSessao,
                        statusSessao: sessao.statusSessao,
                        salaSessao: sessao.salaSessao,
                        situacaoSessao: sessao.situacaoSessao,
                        descSessao: sessao.descSessao,
                      );
                      sessaof.id1=sessao.id1;
                      print(sessao.id1);
                      print("sessao.id1");
                      await DialogsAgendaAssistente.AlertDialogOpcoes(context, _uid,
                          sessao, sessaof,
                          _paciente, _profissional ).then((value) {

                            setState((){});
                          });
                    },
                    child: Padding(padding: EdgeInsets.all(4.0),
                      child: Container(
                        height: height,
                        width: width*0.15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:(sessao.statusSessao!.compareTo("FINALIZADA")==0)?
                          AppColors.labelBlack:AppColors.primaryColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            size: (15.0),
                            Icons.edit,
                            color:(sessao.statusSessao!.compareTo("FINALIZADA")==0)?
                            AppColors.shape:AppColors.labelWhite,
                          ),
                        ),
                        

                      )

              )
            ))
          )
        ],
        )
        :
    // (UtilData.obterDataDDMMAAAA(diaCorrente).compareTo(UtilData.obterDataDDMMAAAA(DateTime.now()))==0)
    (!dataPassada())
        ?FutureBuilder(
            future: getWidgetAgendamentoProfissional(hora, sala),
            builder:  (BuildContext parentContext, AsyncSnapshot snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return FittedBox(
                    fit: BoxFit.contain,
                    child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return snapshot.data;
              }
              return Text("LIVRE");
            }
        )
    :
    Center();
  }

  Future<Widget> getWidgetHora(String hora, String sala,) async {
    // List<DiasSalasProfissionais> ias = [];
    String dia = getDiaCorrente(DateFormat('EEEE').format(diaCorrente));
    print(itemsDiasSalasProf.length);
    print("itemsDiasSalasProf.length");
    print(hora);
    print(sala);
    print(dia);
    String? nome = "LIVRE";
    bool agendado = false;
    for (var value1 in _sessoesDoDia) {
           if(   (value1.salaSessao!.compareTo(sala)==0)
               &&(value1.dataSessao!.compareTo(UtilData.obterDataDDMMAAAA(diaCorrente))==0)
               &&(value1.horarioSessao!.compareTo(hora)==0)){
                return Column(
                  children: [
                      FutureBuilder(
                          future: getNomeProfissional(value1.idProfissional!),
                          // future: Provider.of<ProfissionalProvider>(context,listen: false)
                          //     .getProfissional(value1.idProfissional!),
                          builder: (context, snapshot){
                            if (snapshot.hasData){
                              Profissional profissional = snapshot.data as Profissional;
                              return FittedBox(
                                fit: BoxFit.contain,
                                child: Text(profissional.nome!,  style: AppTextStyles.labelBold12,)
                              );
                            } else {
                              return Center(
                                  child: Text("")
                              );
                            }
                      }),
                    FutureBuilder(
                        future: Provider.of<PacienteProvider>(context,listen: false)
                            .getPaciente(value1.idPaciente!),
                        builder: (context, snapshot){
                          if (snapshot.hasData){
                            Paciente paciente = snapshot.data as Paciente;
                            return FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                children: [
                                  Text("PACIENTE: ",  style: AppTextStyles.labelBold12,),
                                  Text(paciente.nome!,  style: AppTextStyles.labelBold12,)

                                ],
                              )
                            );
                          } else {
                            return Center(
                                child: Text("")
                            );
                          }
                        }),

                  ],
                );
           }
    }
    for (var items in itemsBuscaSalasProf) {
      if (( items.hora!.compareTo(hora)==0) &&
          (items.sala!.compareTo(sala)==0) &&
          (items.dia!.compareTo(dia)==0)
      ) {
        await getProfissionalById(items.idProfissional!).then((value) {
            nome = value.nome;
            print("nome $nome");
            return Text(nome!);
        });
       // await Provider.of<ProfissionalProvider>(context,
       //            listen: false).getProfById(items.idProfissional!).then((value) {
       //              nome = value?.nome;
                    print("nome $nome");
                    // return Text(nome!);
                  // } );
      }

    }
    // if (nome?.compareTo("LIVRE")==0){
    if (nome!=null){
      return Text(nome!);
    } else {
      return Text("Livre");
    }
    // }
    // itemsDiasSalasProf.where((element) => false);
    // var prof = itemsDiasSalasProf.firstWhere((element) =>
    //   element.hora!.contains(hora) &&
    //   element.sala!.contains(sala)
    //     // ((element.hora!.compareTo(hora)==0) &&
    //     // (element.sala!.compareTo(sala)==0)),
    // );
    //var nome = itemsServ.firstWhere((element) => element.id==id,);


    // if (prof ==null){
    //   return Text("data");
    // } else {
    //   Card(child: Text(getNomeProfById(prof.idProfissional!)),);
    // }
    // for (var items in itemsDiasSalasProf){
    //   print("--------");
    //   print(items.hora);
    //   print(items.sala);
    //   print(items.dia);
    //   if ((items.sala!.compareTo(sala)==0)&&
    //       (items.hora!.compareTo(hora)==0)){
    //       print("entrooouu=====");
    //       String? nome = "";
    //
    //       // await Provider.of<ProfissionalProvider>(context,
    //       // listen: false).getProfById(items.idProfissional.toString()).then((value) {
    //       //   nome=value?.nome;
    //       //   print("nome $nome");
    //       //   return Text(nome!);
    //       // } );
    //     return Card(child: Text(getNomeProfById(items.idProfissional.toString())),);
    //
    //   } else {
    //     print("nçao entrou");
    //   }
    // }

  }

  @override
  void initState() {
    super.initState();
    String dia_inicio  = getDiaCorrente(DateFormat('EEEE').format(diaCorrente));
    print(dia_inicio);
    print('dia === $dia_inicio');
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
      if (_sessoesDoDia.length==0)
        Provider.of<SessaoProvider>(context, listen: false)
            // .getListSessoes().then((value) {
          .getListSessoesDoDia(UtilData.obterDataDDMMAAAA(diaCorrente)).then((value){
          _sessoesDoDia = value;
        }),
      if(itemsProfissional.length==0)
        Provider.of<ProfissionalProvider>(context, listen: false)
            .getListProfissionaisAtivos().then((value) {
          itemsProfissional = value;
        }),
      if (itemsDiasSalasProf.length==0)
        Provider.of<DiasSalasProfissionaisProvider>(context,listen: false)
            .getListOcupadas(dia_inicio).then((value) {
          print(value.length);
          print('length ===');
          itemsDiasSalasProf = value;
          itemsBuscaSalasProf = value;
        })
    ]);
  }

  Future<String> getNomeProfissional(String id)async{
    String result = " ";
    result = itemsProfissional.firstWhere((element) => element.id1.compareTo(id)==0).nome!;
    return result;
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
                      width: size.width*0.25,
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
                           //botão
                          InkWell(
                            child: Container(
                              width: size.width*0.03,
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
                              diaCorrente = diaCorrente.subtract(Duration(days: 7));

                              print("subtraiu");
                              print(diaCorrente.day);
                              print(diaCorrente.month);
                              if (getDiaCorrente(DateFormat('EEEE').format(diaCorrente)).compareTo("SÁBADO")==0){
                                indexHoras = 6;
                              } else {
                                indexHoras = 12;
                              }
                              await Provider.of<DiasSalasProfissionaisProvider>
                                (context, listen: false)
                                  .getListOcupadas(
                                  getDiaCorrente(DateFormat('EEEE')
                                      .format(diaCorrente))
                              ).then((value) {
                                print('aaa');
                                print(value.length);
                                itemsDiasSalasProf=value;
                                itemsBuscaSalasProf=value;
                              });
                              await Provider.of<SessaoProvider>(context,
                                  listen: false).getListSessoesDoDia(
                                  UtilData.obterDataDDMMAAAA(diaCorrente)).then((value) {

                                // _sessoesDoDia.clear();
                                _sessoesDoDia = value;
                                _sessoesDoDia.forEach((element) {
                                  print("===== +"+_sessoesDoDia.length.toString());
                                  print(element.id1);
                                  print(element.dataSessao);
                                  print(element.dataSessao);
                                  print(element.idProfissional);
                                  print(element.dataSessao);
                                  print(element.horarioSessao);
                                  print(element.salaSessao);
                                });
                              });
                              setState((){});
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: size.width*0.03,
                              height: size.height*0.03,
                              alignment: Alignment.center,
                              // margin: EdgeInsets.all(100.0),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle
                              ),
                              child: Icon(
                                size: size.height*0.03,
                                Icons.keyboard_arrow_left,
                                color: AppColors.labelBlack,
                              ),

                            ),
                            onTap: () async{
                              diaCorrente = diaCorrente.subtract(Duration(days: 1));

                              print("subtraiu");
                              print(diaCorrente.day);
                              print(diaCorrente.month);
                              if (getDiaCorrente(DateFormat('EEEE').format(diaCorrente)).compareTo("SÁBADO")==0){
                                indexHoras = 6;
                              } else {
                                indexHoras = 12;
                              }
                              await Provider.of<DiasSalasProfissionaisProvider>
                                (context, listen: false)
                                  .getListOcupadas(
                                  getDiaCorrente(DateFormat('EEEE')
                                      .format(diaCorrente))
                              ).then((value) {
                                print('aaa');
                                print(value.length);
                                itemsDiasSalasProf=value;
                                itemsBuscaSalasProf=value;
                              });
                              await Provider.of<SessaoProvider>(context,
                                  listen: false).getListSessoesDoDia(
                                  UtilData.obterDataDDMMAAAA(diaCorrente)).then((value) {

                                    // _sessoesDoDia.clear();
                                    _sessoesDoDia = value;
                                    _sessoesDoDia.forEach((element) {
                                      print("===== +"+_sessoesDoDia.length.toString());
                                      print(element.id1);
                                      print(element.dataSessao);
                                       print(element.dataSessao);
                                       print(element.idProfissional);
                                       print(element.dataSessao);
                                       print(element.horarioSessao);
                                       print(element.salaSessao);
                                    });
                              });
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
                                  "${getDiaCorrente(DateFormat('EEEE').format(diaCorrente))}    ${UtilData.obterDataDDMMAAAA(diaCorrente).substring(0,5)}",
                                  style: AppTextStyles.labelBold16,)),
                          ),
                          InkWell(
                            child: Container(
                              width: size.width*0.03,
                              height: size.height*0.03,
                              alignment: Alignment.center,
                              // margin: EdgeInsets.all(100.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle
                              ),
                              child: Icon(
                                 size: size.height*0.03,
                                 Icons.keyboard_arrow_right,
                                 color: AppColors.labelBlack,
                              ),

                            ),
                            onTap: () async{
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
                              await Provider.of<DiasSalasProfissionaisProvider>
                                (context, listen: false)
                                  .getListOcupadas(
                                  getDiaCorrente(DateFormat('EEEE')
                                      .format(diaCorrente))
                              ).then((value) {
                                print('aaa');
                                print(value.length);
                                itemsDiasSalasProf=value;
                                itemsBuscaSalasProf=value;
                              });
                              await Provider.of<SessaoProvider>(context,
                                  listen: false).getListSessoesDoDia(
                                  UtilData.obterDataDDMMAAAA(diaCorrente)).then((value) {

                                // _sessoesDoDia.clear();
                                _sessoesDoDia = value;
                                _sessoesDoDia.forEach((element) {
                                  print("===== +"+_sessoesDoDia.length.toString());
                                  print(element.id1);
                                  print(element.dataSessao);
                                  print(element.idProfissional);
                                  print(element.dataSessao);
                                  print(element.horarioSessao);
                                  print(element.salaSessao);
                                });
                              });
                              setState((){});
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: size.width*0.03,
                              height: size.height*0.03,
                              alignment: Alignment.center,
                              // margin: EdgeInsets.all(100.0),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle
                              ),
                              child: Icon(
                                size: size.height*0.03,
                                Icons.keyboard_double_arrow_right,
                                color: AppColors.labelBlack,
                              ),

                            ),
                            onTap: () async{
                              diaCorrente = diaCorrente.add(Duration(days: 7));

                              print("add");
                              print(diaCorrente.day);
                              print(diaCorrente.month);
                              print(diaCorrente.month);
                              if (getDiaCorrente(DateFormat('EEEE').format(diaCorrente)).compareTo("SÁBADO")==0){
                                indexHoras = 6;
                              } else {
                                indexHoras = 12;
                              }
                              await Provider.of<DiasSalasProfissionaisProvider>
                                (context, listen: false)
                                  .getListOcupadas(
                                  getDiaCorrente(DateFormat('EEEE')
                                      .format(diaCorrente))
                              ).then((value) {
                                print('aaa');
                                print(value.length);
                                itemsDiasSalasProf=value;
                                itemsBuscaSalasProf=value;
                              });
                              await Provider.of<SessaoProvider>(context,
                                  listen: false).getListSessoesDoDia(
                                  UtilData.obterDataDDMMAAAA(diaCorrente)).then((value) {

                                // _sessoesDoDia.clear();
                                _sessoesDoDia = value;

                              });
                              setState((){});
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.9,
                      height: size.height * 0.81,
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
                              height: size.height * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.labelWhite,
                              ),
                              child: Column(
                                children: [

                                  Padding(
                                    padding:  EdgeInsets.only(
                                        bottom:size.height*0.008,
                                        right: size.height*0.008,
                                        left: size.height*0.008,),
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
                                        height: size.height * (0.8 / (13))-(size.height*0.016),
                                        width: size.width*0.06-(size.height*0.016),
                                        child: Center(child: FittedBox(child: Text("Horário", style: AppTextStyles.labelBlack14Lex,)))),
                                  ),

                                  for (int i=0; i<12; i++)
                                    Card(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: (i%2==0)?AppColors.secondaryColor : AppColors.secondaryColor2,
                                            borderRadius: BorderRadius.circular(4.0)
                                          ),
                                          height: size.height * (0.8 / (13))-(size.height*0.013),
                                          width: size.width*0.06-(size.height*0.016),
                                          child: Center(child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(_listHoras[i], style: AppTextStyles.labelBlack14Lex,)))),
                                    )
                                ],
                              )),

                          //salas
                          for (int i=0; i<7; i++)
                          Container(
                              width: (size.width * 0.84)/7,
                              height: size.height * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.labelWhite,
                              ),
                              child: Column(
                                children: [
                                  //Sala
                                  Padding(
                                    padding: EdgeInsets.only(bottom: size.height*0.008,
                                      right: size.height*0.008, left: size.height*0.008,
                                    ),
                                    child: Container(
                                      width: (size.width * 0.84)/7-(size.height*0.016),
                                      height: ((size.height * 0.8)/(13)) - (size.height*0.012),
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
                                    Card(
                                      child:Container(
                                        decoration: BoxDecoration(
                                          color: (j%2==0)?AppColors.secondaryColor : AppColors.secondaryColor2,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        width: ( (size.width * 0.84)/7) - (size.height*0.016),
                                        height: ((size.height * 0.8)/(13)) - (size.height*0.013),
                                        child: FutureBuilder(
                                          future: getWidgetAgendamento(_listHoras[j], _listSalas[i],((size.height * 0.8)/(13)) - (size.height*0.013),( (size.width * 0.84)/7) - (size.height*0.016), ),
                                          builder: (BuildContext parentContext, AsyncSnapshot snapshot){
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: CircularProgressIndicator()
                                                  );
                                              }
                                              if (snapshot.hasData) {
                                                 return snapshot.data;
                                              }
                                              return Center(child: Text("LIVRE"),);
                                          },
                                        ),
                                      )
                                    ),

                                    // (itemsDiasSalasProf.length>0)?
                                    // FutureBuilder(
                                    //     future: getWidgetAgendamento(_listHoras[j], _listSalas[i],),
                                    //     builder: (BuildContext parentContext, AsyncSnapshot snapshot){
                                    //       if (snapshot.connectionState == ConnectionState.waiting) {
                                    //         return FittedBox(
                                    //             fit: BoxFit.contain,
                                    //             child: CircularProgressIndicator());
                                    //       }
                                    //       if (snapshot.hasData) {
                                    //         return snapshot.data;
                                    //       }
                                    //       return Card(
                                    //         child: SizedBox(
                                    //             width:((size.width * 0.84)/6)-(((size.width * 0.84)/6)*10),
                                    //             height: ((size.height * 0.75)/(13))-(((size.height * 0.75)/13)/10),
                                    //             child:Text("LIVRE"))
                                    //       );
                                    //     }):
                                    // Card(
                                    //     child: SizedBox(
                                    //         width:((size.width * 0.84)/6)-(((size.width * 0.84)/6)*10),
                                    //         height: ((size.height * 0.75)/(13))-(((size.height * 0.75)/13)/10),
                                    //         child:Text("LIVRE"))
                                    // ),
                                  //  -------------------------------------------------------------
                                  //   Padding(
                                  //     padding: EdgeInsets.all(size.height*0.008),
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.circular(4.0),
                                  //         color: (j%2==0)?AppColors.secondaryColor : AppColors.secondaryColor2,
                                  //       ),
                                  //         width: (size.width * 0.84)/6 - (size.height*0.016),
                                  //         height: (size.height * 0.8/(13))- (size.height*0.016),
                                  //         child: Center(
                                  //           child: FittedBox(
                                  //              //getWidget?
                                  //             child: itemsDiasSalasProf.length>0?
                                  //               FutureBuilder(
                                  //                   // future: getWidgetHora(_listHoras[j], _listSalas[i],),
                                  //                   future: getWidgetAgendamento(_listHoras[j], _listSalas[i],),
                                  //                   builder: (BuildContext parentContext, AsyncSnapshot snapshot){
                                  //                     if (snapshot.connectionState == ConnectionState.waiting) {
                                  //                       return FittedBox(
                                  //                           fit: BoxFit.contain,
                                  //                           child: CircularProgressIndicator());
                                  //                     }
                                  //                     if (snapshot.hasData) {
                                  //                       return snapshot.data;
                                  //                     }
                                  //
                                  //                     return Text("LIVRE");
                                  //                   }):
                                  //               Text('LIVRE'),
                                  //     ),
                                  // ))),
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


