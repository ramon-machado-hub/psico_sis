import 'dart:html';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_prof_mobile.dart';
import 'package:psico_sis/model/dias_profissional.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/pagamento_transacao_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/servico_profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/provider/transacao_provider.dart';
import 'package:psico_sis/service/prefs_service.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar__profissional_widget.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/comissao.dart';
import '../model/login.dart';
import '../model/pagamento_transacao.dart';
import '../model/servico.dart';
import '../model/sessao.dart';
import '../provider/comissao_provider.dart';
import '../provider/dias_profissional_provider.dart';
import '../provider/dias_salas_profissionais_provider.dart';
import '../provider/usuario_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/menu_icon_button_widget.dart';


class HomePageProfissionalMobile extends StatefulWidget {

  const HomePageProfissionalMobile({Key? key}) : super(key: key);

  @override
  State<HomePageProfissionalMobile> createState() => _HomePageStateProfissionalMobile();
}

class _HomePageStateProfissionalMobile extends State<HomePageProfissionalMobile> {

  var db = FirebaseFirestore.instance;
  String _uid="";
  late Profissional _usuario = Profissional(
    nome: "",cpf: "",dataNascimento: "",email: "",endereco: "",id: "",numero: "",senha: "",status: "",telefone: "",);

  late int mesAtual = DateTime.now().month;
  late int anoAtual = DateTime.now().year;
  late DateTime _dataCorrente = DateTime.now();
  bool messageErroData = false;
  List<DiasSalasProfissionais> _listDiasProfissional = [];
  List<String> _diasProfissional = [];




  Future<Profissional> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty){
      print("empity");
      String _uidGet ="";
      print("_uidGet $_uidGet");
      return await Provider.of<ProfissionalProvider>(context, listen: false)
          .getProfissional(_uidGet);
    } else{
      print(" not empity $uid");
      return await Provider.of<ProfissionalProvider>(context, listen: false)
          .getProfissional(uid);
    }

  }


  @override
  void initState(){
    _usuario.id1="";
    super.initState();
    Future.wait([
      PrefsService.isAuth().then((value) async {
        if (value){
          print("usuário autenticado HomePageProfissional");
          await PrefsService.getUid().then((value) async {
            _uid = value;
            print("_uid initState HomePageProfissional $_uid");
            await getUsuarioByUid(_uid).then((value) {
              _usuario = value;
            }).then((value) {
              if (this.mounted) {
                setState((){
                  print("setState HomePageProfissional ${_diasProfissional.length}");
                });
              }
            });
          });
          if (_diasProfissional.length==0){
            await Provider.of<DiasSalasProfissionaisProvider>(context,listen: false)
                .getDiasProfissionalByIdProfissional(_uid).then((value) {
              _listDiasProfissional = value;
              print(value.length);
              print("length ===+${_uid}.");
              for (int i =0; i<value.length;i++) {
                if (_diasProfissional.contains(value[i].dia) == false) {
                  print("add");
                  _diasProfissional.add(value[i].dia!);
                } else {
                  print("nao add ${value[i].dia} ");
                }
              }
              setState((){});
            });
          }
        } else {
          print("usuário não conectado initState HomeProfissional");
          ///nav
          Navigator.pushReplacementNamed(
              context, "/loginMobile");
        }
      }),
    ]);
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

  DateTime getDayIn(DateTime date){
    String diaSemana = getDiaSemana(date);
    int indexDia = getIndex(diaSemana);
    DateTime diaInicio = date.subtract(Duration(days: indexDia));
    return diaInicio;
  }

  List<Widget> listCalendario(double width,
      double heigth, DateTime dataAtual){
    List<String> diasProf = [];
    print("diasProfissional ${_listDiasProfissional.length} ${_diasProfissional.length}");
    diasProf=_diasProfissional;
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
                DateTime data = diaInicio.add(Duration(days: (7 * j) + i));
                print(data);

                await Provider.of<SessaoProvider>(context, listen: false,)
                    .getListSessoesDoDiaByProfissional(UtilData.obterDataDDMMAAAA(data), _uid)
                    .then((value) async {
                  List<Sessao> list = value;
                  list.sort((a,b) {
                    int aHora = int.parse(a.horarioSessao!.substring(0,2));
                    int aMin = int.parse(a.horarioSessao!.substring(3,5));
                    int bHora = int.parse(b.horarioSessao!.substring(0,2));
                    int bMin = int.parse(b.horarioSessao!.substring(3,5));
                    if (aHora==bHora){
                      return aMin.compareTo(bMin);
                    } else {
                      return aHora.compareTo(bHora);
                    }
                  });
                  List<String> horarios =[];
                  String diaSemana = getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)));
                  print("dia ==="+diaSemana);
                  for (int i=0; i<_listDiasProfissional.length;i++){
                    if (_listDiasProfissional[i].dia!.compareTo(diaSemana.toUpperCase())==0){
                      horarios.add(_listDiasProfissional[i].hora!);
                      print("addddd");
                    }
                  }
                  horarios.sort((a,b) {
                    int aHora = int.parse(a.substring(0,2));
                    int aMin = int.parse(a.substring(3,5));
                    int bHora = int.parse(b.substring(0,2));
                    int bMin = int.parse(b.substring(3,5));
                    if (aHora==bHora){
                      return aMin.compareTo(bMin);
                    } else {
                      return aHora.compareTo(bHora);
                    }
                  });
                  DialogsProfMobile.AlertDialogAgendaDoDia(context, _uid, list, _usuario, data,horarios);

                });

                //caso a nova data seja diferente da data da sessao a reagendar message = false
                // if ((messageErroData) &
                // (UtilData.obterDataDDMMAAAA(_dataSelecionada)
                //     .compareTo(novaData)==0)){
                //   print("tudo");
                //
                //   messageErroData = false;
                // } else {
                //   print("nada");
                //   print(messageErroData);
                //   print(messageErroData);
                //   print(_dataSelecionada);
                //   print(novaData);
                //
                //
                // }
                // print(_selectData);
                // if (horariosDoDia.length>0){
                //   print(horariosDoDia.length);
                //   horariosDoDia = [];
                //   print("111"+horariosDoDia.length.toString());
                //
                // }
                // print(horariosDoDia.length);
                // //adiciona horarios do dia do profissional
                // print("-----");
                // print(getDiaSemana(
                //     diaInicio.add(Duration(days: (7 * j) + i))));
                // diasSalasProfissional.forEach((element) {
                //   if (element.dia!.compareTo(getDiaSemana(
                //       diaInicio.add(Duration(days: (7 * j) + i))).toUpperCase())==0){
                //     horariosDoDia.add(element);
                //   }
                // });
                // print(horariosDoDia.length);
                //
                // _dataSelecionada = diaInicio.add(Duration(days: (7 * j) + i));
                //
                // novaData = UtilData.obterDataDDMMAAAA(_dataSelecionada);
                //
                // // if(novaData.compareTo(widget.sessao.dataSessao!)!=0){
                // //     messageErroData = false;
                // // }
                // await getSessoesProfissional(UtilData.obterDataDDMMAAAA(_dataSelecionada),widget.profissional.id1);
                // _selectData=true;
                //
                // setState((){});
                // print("SetState");
                // print(_selectData);
                // print(_dataSelecionada);
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
                          height: heigth*0.45,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(diaInicio
                                .add(Duration(days: (7 * j) + i))
                                .day
                                .toString(),style: AppTextStyles.labelBlack16Lex),
                          ),
                        ),
                        SizedBox(
                          height: heigth*0.45,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(getMes(diaInicio
                                .add(Duration(days: (7 * j) + i))
                                .month).substring(0, 3),style: AppTextStyles.labelBlack16Lex),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            )
                :
            getDataValida(diaInicio.add(Duration(days: (7 * j) + i)))?
            Card(
              child: Container(
                  height: heigth,
                  width: width,
                  decoration: BoxDecoration(
                      color:AppColors.labelWhite.withOpacity(0.5),
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
                              .toString(),
                            style: getDataValida(
                                diaInicio.add(Duration(days: (7 * j) + i))) ? AppTextStyles.labelBlack14:AppTextStyles.labelLine14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: heigth*0.4,
                        width: width*0.4,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(getMes(diaInicio
                              .add(Duration(days: (7 * j) + i))
                              .month).substring(0, 3),
                            style: getDataValida(
                                diaInicio.add(Duration(days: (7 * j) + i))) ? AppTextStyles.labelBlack14:AppTextStyles.labelLine14,
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ):
            FutureBuilder(
                future: Provider.of<SessaoProvider>(context,listen: false)
                    .getListSessoesDoDiaByProfissional(UtilData.obterDataDDMMAAAA(diaInicio.add(Duration(days: (7 * j) + i))),_usuario.id1),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData){
                    print(snapshot.data);
                    List<Sessao> list = snapshot.data as List<Sessao>;
                    if (list.length==0){
                      return InkWell(
                        onTap: null,
                        child: Card(
                          child: Container(
                              height: heigth,
                              width: width,
                              decoration: BoxDecoration(
                                  color: (
                                      getDataValida(
                                          diaInicio.add(Duration(days: (7 * j) + i)))) ?
                                  AppColors.primaryColor.withOpacity(0.5) : AppColors.primaryColor.withOpacity(0.2),
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
                                          .toString(),
                                        style: getDataValida(
                                            diaInicio.add(Duration(days: (7 * j) + i))) ? AppTextStyles.labelBlack14:AppTextStyles.labelLine14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: heigth*0.4,
                                    width: width*0.4,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(getMes(diaInicio
                                          .add(Duration(days: (7 * j) + i))
                                          .month).substring(0, 3),
                                        style: getDataValida(
                                            diaInicio.add(Duration(days: (7 * j) + i))) ? AppTextStyles.labelBlack14:AppTextStyles.labelLine14,
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () async {
                          DateTime data = diaInicio.add(Duration(days: (7 * j) + i));
                          print(data);

                          await Provider.of<SessaoProvider>(context, listen: false,)
                              .getListSessoesDoDiaByProfissional(UtilData.obterDataDDMMAAAA(data), _uid)
                              .then((value) async {
                            List<Sessao> list = value;
                            list.sort((a,b) {
                              int aHora = int.parse(a.horarioSessao!.substring(0,2));
                              int aMin = int.parse(a.horarioSessao!.substring(3,5));
                              int bHora = int.parse(b.horarioSessao!.substring(0,2));
                              int bMin = int.parse(b.horarioSessao!.substring(3,5));
                              if (aHora==bHora){
                                return aMin.compareTo(bMin);
                              } else {
                                return aHora.compareTo(bHora);
                              }
                            });
                            List<String> horarios =[];
                            String diaSemana = getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)));
                            print("dia ==="+diaSemana);
                            for (int i=0; i<_listDiasProfissional.length;i++){
                              if (_listDiasProfissional[i].dia!.compareTo(diaSemana.toUpperCase())==0){
                                horarios.add(_listDiasProfissional[i].hora!);
                                print("addddd");
                              }
                            }
                            horarios.sort((a,b) {
                              int aHora = int.parse(a.substring(0,2));
                              int aMin = int.parse(a.substring(3,5));
                              int bHora = int.parse(b.substring(0,2));
                              int bMin = int.parse(b.substring(3,5));
                              if (aHora==bHora){
                                return aMin.compareTo(bMin);
                              } else {
                                return aHora.compareTo(bHora);
                              }
                            });
                            DialogsProfMobile.AlertDialogAgendaDoDia(context, _uid, list, _usuario, data,horarios);


                          });
                        },
                        child: Card(
                          child: Container(
                              height: heigth,
                              width: width,
                              decoration: BoxDecoration(
                                  color:AppColors.primaryColor.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(4.0)
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: heigth*0.5,
                                    width: width*0.4,
                                    child:
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(diaInicio
                                          .add(Duration(days: (7 * j) + i))
                                          .day
                                          .toString(),
                                        style: getDataValida(
                                            diaInicio.add(Duration(days: (7 * j) + i))) ? AppTextStyles.labelLine14:AppTextStyles.labelWhite14Lex,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: heigth*0.5,
                                    width: width*0.4,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(getMes(diaInicio
                                          .add(Duration(days: (7 * j) + i))
                                          .month).substring(0, 3),
                                        style: getDataValida(
                                            diaInicio.add(Duration(days: (7 * j) + i))) ? AppTextStyles.labelBlack14:AppTextStyles.labelWhite14Lex,
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      );
                    }

                  } else {
                    return  Card(
                      child: SizedBox(
                          height: heigth,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CircularProgressIndicator(),
                          )
                      ),
                    );
                  }
                }
            )
          //card de dias passado

        );
      }
    }
    return result;
  }

  List<Widget> getListDays(Size size,DateTime dataCorrente){
    List<Widget> result = [];
    List<Widget> widgets = listCalendario(
        size.width * 0.035, size.height * 0.05, dataCorrente);
    result.add(Center());
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
          List<Widget> widgets = listCalendario(
              size.width * 0.1, size.height * 0.05, _dataCorrente);
          return  Column(
              children: [
                SizedBox(
                  height: size.height*0.01,
                ),
                //Extrato
                Container(
                  width: size.width*0.85,
                  height: size.height*0.1,
                  decoration: BoxDecoration(
                      color: AppColors.shape,
                      borderRadius: BorderRadius.circular(4.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: size.width*0.85,
                        height: size.height*0.05,
                        child: Row(
                          children: [
                              SizedBox(
                                width: size.width*0.425,
                                height: size.height*0.05,
                                child: FittedBox(

                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Text("SALDO DO DIA:", style: AppTextStyles.labelBlack16Lex,),)),
                            SizedBox(
                                width: size.width*0.425,
                                height: size.height*0.05,
                                child: FittedBox(

                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder(
                                    future: getComissoes(context, _usuario.id1, _dataCorrente),
                                    builder: (context, AsyncSnapshot snapshot) {
                                       if (snapshot.hasData){
                                         String result = snapshot.data as String;
                                         print("result = $result");
                                         return Text("  R\$ $result", style: AppTextStyles.labelBlack16Lex,);
                                       } else {
                                         return Text("  R\$ 0,00", style: AppTextStyles.labelBlack16Lex,);
                                       }
                                       return Center();
                                    }
                                  ),
                                ))
                          ],
                        )
                      ),
                      SizedBox(
                          width: size.width*0.85,
                          height: size.height*0.05,
                          child: Row(
                            children: [
                              SizedBox(
                                  width: size.width*0.425,
                                  height: size.height*0.05,
                                  child: FittedBox(

                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text("À RECEBER:", style: AppTextStyles.labelBlack16Lex,),
                                  )),
                              SizedBox(
                                  width: size.width*0.425,
                                  height: size.height*0.05,
                                  child: FittedBox(

                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: FutureBuilder(
                                        future: getComissoesAReceber(context, _usuario.id1,),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData){
                                            String result = snapshot.data as String;
                                            print("result = $result");
                                            return Text("  R\$ $result", style: AppTextStyles.labelBlack16Lex,);
                                          } else {
                                            // return Text("  R\$ 0,00", style: AppTextStyles.labelBlack16Lex,)
                                            return CircularProgressIndicator();
                                          }
                                          return Center();
                                        }
                                    ),
                                  ))
                            ],
                          )
                      ),

                      // SizedBox(
                      //   width: size.width*0.85,
                      //   height: size.height*0.06,
                      //   child: Row(
                      //     // mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       SizedBox(
                      //           width: size.width*0.3,
                      //           height: size.height*0.06,
                      //           child: FittedBox(
                      //
                      //             fit: BoxFit.scaleDown,
                      //             alignment: Alignment.centerRight,
                      //             child:  Text("EXTRATO", style: AppTextStyles.labelBlack16Lex,),
                      //
                      //           )),
                      //       SizedBox(
                      //           width: size.width*0.05,
                      //           height: size.height*0.06,
                      //           child: FittedBox(
                      //
                      //             fit: BoxFit.scaleDown,
                      //             alignment: Alignment.centerRight,
                      //             child:  Icon(Icons.list_alt)
                      //
                      //           )),
                      //
                      //     ],
                      //   )
                      // )
                    ],
                  )
                ),
                SizedBox(
                  height: size.height*0.01,
                ),
                Container(
                  height: size.height * 0.55,
                  width: size.width * 0.85,
                  color: AppColors.shape,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //mes + icones 0.05
                      SizedBox(
                          height: size.height * 0.05,
                          width: size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //agenda
                              SizedBox(
                                  height: size.height * 0.03,
                                  width: size.width * 0.25,
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: size.height * 0.03,
                                          width: size.width * 0.05,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Icon(Icons.calendar_today_rounded, color: AppColors.line,),
                                          )
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                        width: size.width * 0.2,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text("AGENDA", style: AppTextStyles.labelLine14,),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              //botao + mes + botao
                              SizedBox(
                                height: size.height * 0.05,
                                width: size.width * 0.35,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print("mes = $mesAtual");
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
                                        _dataCorrente = DateTime(anoAtual, mesAtual, 1);
                                        widgets = listCalendario(
                                            size.width * 0.035, size.height * 0.05,
                                            _dataCorrente);
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

                                    SizedBox(
                                      height: size.height * 0.03,
                                      width: size.width * 0.25,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                            child: Text("${getMes(mesAtual)}/${anoAtual}", style: AppTextStyles.labelBlack14Lex,),
                                          )

                                      ),
                                    ),

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
                                        _dataCorrente = DateTime(anoAtual, mesAtual, 1);
                                        widgets = listCalendario(
                                            size.width * 0.035, size.height * 0.05,
                                            _dataCorrente);
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
                                ),
                              ),
                              SizedBox(
                                width: size.width*0.25,
                              )
                            ],
                          )
                      ),

                      //Dias da semana
                      SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 7; i++)
                              Card(
                                child: Container(
                                    height: size.height * 0.05,
                                    width: size.width * 0.1,
                                    decoration: BoxDecoration(
                                        color: ((i==0)||(i==6))?AppColors.line:(_diasProfissional.contains(dias[i]))?AppColors.primaryColor.withOpacity(0.75):AppColors.line,
                                        borderRadius: BorderRadius.circular(4.0)

                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: (_diasProfissional.contains(dias[i]))?
                                      Text(dias[i].substring(0,3), style: AppTextStyles.labelWhite16Lex,)
                                          :
                                      Text(dias[i].substring(0,3), style: AppTextStyles.labelBlack12Lex,),
                                    )
                                ),
                              )
                          ],
                        ),
                      ),
                      //calendario
                      SizedBox(
                          height: size.height * 0.4,
                          width: size.width * 0.85,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
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
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ]);
        });
  }

  Future<String> getComissoesAReceber(context, String idProf) async{
    String result = "0,00";
    double saldo = 0;
    await Provider.of<SessaoProvider>(context,listen: false)
        .getListPendentesByProfissional(idProf).then((value) async {
          List<Sessao> listSessao = [];
          listSessao=value;
          listSessao.sort((a,b)=> a.idPaciente!.compareTo(b.idPaciente!));
          for (int i =0; i<listSessao.length; i++) {
            if (listSessao[i].descSessao!.substring(7,8).compareTo("1")==0){
              await Provider.of<ServicoProvider>(context, listen: false)
                  .getServicoByDesc(listSessao[i].descSessao!.substring(11,listSessao[i].descSessao!.length))
                  .then((value) async {
                String idServ = value.id1;
                await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                    .getServByServicoProfissional(idProf,idServ).then((value){
                  result = value.valor!.replaceAll(',', '.');
                  print("add ${listSessao[i].id1}");
                  saldo+= (NumberFormat().parse(result))*0.7;
                });
              });
            }

            // if (i>0){
            //        // if (listSessao[i].idPaciente!.compareTo(listSessao[i-1].idPaciente!)!=0){
            //        //   await Provider.of<ServicoProvider>(context, listen: false)
            //        //       .getServicoByDesc(listSessao[i].descSessao!.substring(11,listSessao[i].descSessao!.length))
            //        //       .then((value) async {
            //        //     String idServ = value.id1;
            //        //     await Provider.of<ServicoProfissionalProvider>(context, listen: false)
            //        //         .getServByServicoProfissional(idProf,idServ).then((value){
            //        //       result = value.valor!.replaceAll(',', '.');
            //        //       print("add ${listSessao[i].id1}");
            //        //       saldo+= NumberFormat().parse(result);
            //        //     });
            //        //   });
            //        // }
            //    } else {
            //      // await Provider.of<ServicoProvider>(context, listen: false)
            //      //     .getServicoByDesc(listSessao[i].descSessao!.substring(11,listSessao[i].descSessao!.length))
            //      //     .then((value) async {
            //      //      String idServ = value.id1;
            //      //      await Provider.of<ServicoProfissionalProvider>(context, listen: false)
            //      //          .getServByServicoProfissional(idProf,idServ).then((value){
            //      //          result = value.valor!.replaceAll(',', '.');
            //      //          print("add ${listSessao[i].id1}");
            //      //
            //      //          saldo+= NumberFormat().parse(result);
            //      //      });
            //      // });
            //
            //
            //    }

          }
    });

    return saldo.toStringAsFixed(2).replaceAll('.', ',');


  }

  Future<String> getComissoes(context,String idProfissional, DateTime data)async{
    String result = "0,00";
    double saldo = 0;
    await Provider.of<ComissaoProvider>(context, listen: false)
        .getComissaoDoDiaByProfissional(UtilData.obterDataDDMMAAAA(data),idProfissional).then((value) {
        // .getComissaoDoDiaByProfissional("26/05/2023",idProfissional).then((value) {
          if (value.isNotEmpty){
            for (var item in value){
              result = item.valor.replaceAll(',', '.');
              saldo += NumberFormat().parse(result);
              print("== saldo $saldo");
            }
          }
    });
    print(saldo);
    return saldo.toStringAsFixed(2).replaceAll('.', ',');

  }


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    // print("usuario depois do builder = ${_usuario.nomeUsuario}");
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),

          child: AppBarProfissional(nomeUsuario: _usuario.nome!),
        ),
        // bottomNavigationBar: Container,
        body: (_usuario.id1.compareTo("")==0)?
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.labelWhite,
                  AppColors.shape,
                ],
              )),
        )
            :
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.labelWhite,
                  AppColors.shape,
                ],
              )),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[

                selectDataSessao(context, size),
              ]
          ), // child: Container(
        ),
      ),
    );
  }
}
