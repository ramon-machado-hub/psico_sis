import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/pacientes_parceiros.dart';
import 'package:psico_sis/provider/parceiro_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import 'package:psico_sis/widgets/input_text_uper_widget.dart';
import '../model/Paciente.dart';
import '../model/Parceiro.dart';
import '../model/Usuario.dart';
import '../provider/paciente_parceiro_provider.dart';
import '../provider/paciente_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/button_widget.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({Key? key}) : super(key: key);

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {

  List<Paciente> items = [];
  List<Paciente> _lpFinal = [];
  StreamSubscription<QuerySnapshot>? pacienteSubscription;
  String dropdownValue = 'Consulta Avaliativa';
  String _parteName = "";
  bool checkParceiro = false;
  var db = FirebaseFirestore.instance;
  String _uid = "";
  late Usuario _usuario = Usuario(
    idUsuario: 1,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario: "",
    tokenUsuario: "",
  );

  List<Paciente> getPaciParteName(String parteName){
    List<Paciente> list = [];
    print("parteName = ${parteName.length}");
    print("_lpFinal = ${_lpFinal.length}");

    if (parteName.length==0){
      list = _lpFinal;
      // return list;
    } else {
      _lpFinal.forEach((element) {
        if (element.nome?.substring(0,parteName.length).compareTo(parteName)==0)
          list.add(element);
      });
    }


    // if(list.length>0){
    //   // items.clear();
    //   items = list;
    // } else {
    //   // items.clear();
    //   list = _lpFinal;
    // }

    // setState((){});
    print("list = ${list.length}");
    return list;
  }


  Future<Usuario> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty) {
      print("empity");
      String _uidGet = "";
      print("_uidGet $_uidGet");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    } else {
      print(" not empity");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    }
  }

  @override
  void initState(){
    super.initState();
    pacienteSubscription?.cancel();
    pacienteSubscription =
        db.collection("pacientes").snapshots().listen(
                (snapshot) {
                  setState((){
                    items = snapshot.docs.map(
                            (documentSnapshot) => Paciente.fromMap(
                          documentSnapshot.data(),
                          int.parse(documentSnapshot.id),
                        )
                    ).toList();

                    if(_lpFinal.length==0){
                      _lpFinal = snapshot.docs.map(
                              (documentSnapshot) => Paciente.fromMap(
                            documentSnapshot.data(),
                            int.parse(documentSnapshot.id),
                          )
                      ).toList();
                    }


                    if (this.mounted){
                      items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                      _lpFinal.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                      setState((){});
                    }
                  });

            });

    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value) {
          print("usuário autenticado");
          PrefsService.getUid().then((value) {
            _uid = value;
            print("_uid initState $_uid");
            getUsuarioByUid(_uid).then((value) {
              _usuario = value;
              print("Nome ${_usuario.nomeUsuario}");
              if (this.mounted){
                setState(() {});
              }
            });
          });
        } else {
          print("usuário não conectado initState Home Assistente");

          ///nav
          Navigator.pushReplacementNamed(context, "/login");
        }
      }),
    ]);

  }




  @override
  void dispose() {
    // TODO: implement dispose
    pacienteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar:  PreferredSize(
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Container(
                        width: size.width * 0.45,
                        height: size.height * 0.7,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.line,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.shape),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
                              child: SizedBox(
                                width: size.width * 0.45,
                                height: size.height * 0.08,
                                child: InputTextUperWidget(
                                  label: "Pesquisar por nome", icon: Icons.search_rounded,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  onChanged: (value) async{
                                    print("------------------------");
                                    _parteName = value;
                                    print("_parteName $_parteName length ${_parteName.length}");
                                    print("_lpFinal length ${_lpFinal.length}");
                                    if(_parteName.length==0){
                                      print("parteName = 0 $_parteName");
                                      // items.clear();
                                      print("items = getPaciParteName($_parteName)");
                                      items = getPaciParteName(_parteName);
                                      print(items.length.toString()+"aaa");
                                    } else {
                                      print("getPaciParteName");
                                      print("items = getPaciParteName($_parteName)");
                                      items = getPaciParteName(_parteName);
                                      print("items.length "+items.length.toString()+" aaa");
                                    }
                                    setState((){});
                                  },
                                  backgroundColor: AppColors.secondaryColor,
                                  borderColor: AppColors.line,
                                  textStyle:  AppTextStyles.subTitleBlack12,
                                  iconColor: AppColors.labelBlack,),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Container(
                              width: size.width * 0.45,
                              height: size.height * 0.55,

                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0, right: 16.0, left: 16.0),
                                  child: Column(
                                    children: [


                                      for (var item in items)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            trailing:  InkWell(
                                                onTap: (){
                                                  print(item.endereco);
                                                  String idParceiro = "";
                                                  Provider.of<PacientesParceirosProvider>(context, listen: false)
                                                      .getParceiroByPaciente(item.idPaciente!).then((value) {
                                                        print("value $value");
                                                      idParceiro=value;
                                                      List<PacientesParceiros> listPP = [];
                                                      Provider.of<PacientesParceirosProvider>(context, listen: false)
                                                        .getListAll().then((value)
                                                        {
                                                          listPP=value;

                                                          List<Parceiro> listP = [];
                                                          Provider.of<ParceiroProvider>(context, listen: false)
                                                              .getListParceiros().then((value) {
                                                            listP=value;
                                                            print("existParceiro $idParceiro");
                                                            if (idParceiro.compareTo("0")==0){
                                                              //NÃO POSSUI PARCEIRO
                                                              print("NÃO POSSUI PARCEIRO");

                                                              print("listP ${listP.length}");
                                                              print("idParceiro $idParceiro");

                                                              print("listPP ${listPP.length}");
                                                              print(listP.first.razaoSocial);
                                                              ///ordenar lista parceiros
                                                              listP.sort((a,b)=> a.razaoSocial.toString().compareTo(b.razaoSocial.toString()));
                                                              // items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                                                              Dialogs.AlertAlterarPaciente(context, item,listP.first.razaoSocial!, idParceiro, listP,listPP, _uid);
                                                              // Navigator.pop(context);
                                                            } else {
                                                              print("POSSUI PARCEIRO");
                                                              listP.sort((a,b)=> a.razaoSocial.toString().compareTo(b.razaoSocial.toString()));
                                                              print("idParceiro POSSUI $idParceiro");

                                                              print("listPP ${listPP.length}");
                                                              print("listP ${listP.length}");
                                                              print("listP.first.razaoSocial! ${listP.first.razaoSocial!}");
                                                              // print(item.)
                                                              Dialogs.AlertAlterarPaciente(context, item,listP.first.razaoSocial!, idParceiro, listP,listPP,_uid);
                                                              // Navigator.pushReplacementNamed(
                                                              //     context, "/cadastro_paciente");
                                                            }
                                                          });
                                                        });


                                                  } );
                                                },
                                                child: const Icon(Icons.edit_rounded)),
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item.nome.toString()),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Fone: ${item.telefone}", style: AppTextStyles.labelBold16,),
                                                    Text("Data Nascimento: ${item.dataNascimento}", style: AppTextStyles.labelBold16,),
                                                  ],
                                                ),
                                              ],
                                            ),

                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    label: "Cadastrar Paciente",
                    onTap: () {

                      Navigator.pushReplacementNamed(
                          context, "/cadastro_paciente");
                    },
                  ),
                ],
              ),
            )));
  }
}
