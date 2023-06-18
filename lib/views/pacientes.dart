import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/pacientes_parceiros.dart';
import 'package:psico_sis/provider/parceiro_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import 'package:psico_sis/widgets/input_text_uper_widget.dart';
import '../dialogs/alert_dialog_paciente.dart';
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

  late List<Paciente> items = [];
  late List<Paciente> _lpFinal = [];
  // StreamSubscription<QuerySnapshot>? pacienteSubscription;
  final ScrollController scrollController = ScrollController();

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

  // Future<List<Paciente>> getPacientes()async{
  //   return await Provider.of<PacienteProvider>(context, listen: false).getListPacientes2();
  // }

  String getIdadePaciente (String data){
    // print(data);
    int dia = int.parse(data.substring(0,2));
    int mes = int.parse(data.substring(3,5));
    int ano = int.parse(data.substring(6,10));
    DateTime nascimento = DateTime(ano,mes,dia);
    DateTime hoje = DateTime.now();

    int idade = hoje.year - nascimento.year;
    int meses = 0;
    if (hoje.month<nascimento.month)
      idade--;
    else if (hoje.month==nascimento.month){
      if (hoje.day<nascimento.day)
        idade--;
    }
    if (idade==0){
      meses = hoje.month-nascimento.month;
      return "$meses meses";
    } else if(idade==1){
      return idade.toString()+" ano";
    }
    return idade.toString()+" anos";
  }

  @override
  void initState(){
    super.initState();
    scrollController.addListener(() {
      
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          Provider.of<PacienteProvider>(context, listen: false).getListPacientes2().then((value) {
            print("add");
            // items.clear();
            // '_lpFinal'.clear();
            items = value;
            _lpFinal = value;
            setState((){});
            // if (this.mounted){
            //   items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
            //   _lpFinal.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
            //   setState((){});
            // }
          } );
        }
      }
    });

    if (items.length==0){
      Provider.of<PacienteProvider>(context, listen: false).getListPacientes2().then((value) {
        print("initStatePacientes");
        items = value;
        _lpFinal = value;
        // if (this.mounted){
        //   items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
        //   _lpFinal.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
        //   setState((){});
        // }
      } );
    }

    //______________________________________--__
    // Provider.of<PacienteProvider>(context, listen: false).getListPacientes().then((value) {
    //   print("initStatePacientes");
    //   items = value;
    //   _lpFinal = items;
    //   if (this.mounted){
    //     items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
    //     _lpFinal.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
    //     setState((){});
    //   }
    // } );
    //_________________________________________
    // pacienteSubscription?.cancel();
    // pacienteSubscription =
    //     db.collection("pacientes").snapshots().listen(
    //             (snapshot) {
    //               setState((){
    //                 items = snapshot.docs.map(
    //                         (documentSnapshot) => Paciente.fromMap(
    //                       documentSnapshot.data(),
    //                       documentSnapshot.id,
    //                     )
    //                 ).toList();
    //
    //                 if(_lpFinal.length==0){
    //                   _lpFinal = snapshot.docs.map(
    //                           (documentSnapshot) => Paciente.fromMap(
    //                         documentSnapshot.data(),
    //                         documentSnapshot.id,
    //                       )
    //                   ).toList();
    //                 }
    //
    //
    //                 if (this.mounted){
    //                   items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
    //                   _lpFinal.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
    //                   setState((){});
    //                 }
    //               });
    //
    //         });

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
    // pacienteSubscription?.cancel();
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
                                      print("0 ${_parteName.length}");
                                      print("items = getPaciParteName($_parteName)");
                                      items = _lpFinal;
                                      print(items.length.toString()+"aaa");
                                    } else {
                                      print("maior - 0");
                                      print("items = getListByParteOfName($_parteName)");
                                      await Provider.of<PacienteProvider>(context,listen: false)
                                          .getListByParteOfName(_parteName).then((value) {
                                            // items.clear();
                                            items = value;
                                      });
                                    }
                                    print("items = ${items.length})");
                                    print("_lpFinal = ${_lpFinal.length}");
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

                              child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: items.length,
                                  itemBuilder: (context, index){
                                    return Card(
                                        child: ListTile(
                                            title: Text("${items[index].nome!} ${getIdadePaciente(items[index].dataNascimento!)} | ${items[index].id1.substring(0,4)}"),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Fone: ${items[index].telefone}", style: AppTextStyles.subTitleBlack14,),
                                                Text("Data Nascimento: ${items[index].dataNascimento}", style: AppTextStyles.subTitleBlack14,),
                                              ],
                                            ),
                                            trailing: InkWell(
                                              onTap: (){
                                                DialogsPaciente.AlterarDadosPaciente(context, _uid, items[index]);
                                                setState((){});
                                              },
                                              child: Icon(Icons.edit),
                                            )

                                        ));
                              })

                              //_________________________________
                              // StreamBuilder<QuerySnapshot>(
                              //   stream: Provider.of<PacienteProvider>(context, listen: false).getPac(),
                              //   builder: (context, snapshot){
                              //     if (snapshot.hasData) {
                              //       // final pacientes = snapshot.data!.docs.length;
                              //       return ListView.builder(
                              //           controller: ScrollController(),
                              //           itemCount: snapshot.data!.docs.length,
                              //           itemBuilder: (context, index){
                              //             DocumentSnapshot doc = snapshot.data!.docs[index];
                              //             return Card(child: ListTile(title: Text(doc['nome_paciente']),),);
                              //       });
                              //
                              //     }
                              //       return Text("a");
                              //   },
                              // )
                              //_____________________________________


                              // SingleChildScrollView(
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 4.0, right: 16.0, left: 16.0),
                              //     child: Column(
                              //       children: [
                              //         for (var item in items)
                              //           Card(
                              //             elevation: 8,
                              //             child: ListTile(
                              //               trailing:  InkWell(
                              //                   onTap: (){
                              //                     print(item.endereco);
                              //                     String idParceiro = "";
                              //                     Provider.of<PacientesParceirosProvider>(context, listen: false)
                              //                         .getParceiroByPaciente(item.idPaciente!).then((value) {
                              //                           print("value $value");
                              //                         idParceiro=value;
                              //                         List<PacientesParceiros> listPP = [];
                              //                         Provider.of<PacientesParceirosProvider>(context, listen: false)
                              //                           .getListAll().then((value)
                              //                           {
                              //                             listPP=value;
                              //
                              //                             List<Parceiro> listP = [];
                              //                             Provider.of<ParceiroProvider>(context, listen: false)
                              //                                 .getListParceiros().then((value) {
                              //                               listP=value;
                              //                               print("existParceiro $idParceiro");
                              //                               if (idParceiro.compareTo("0")==0){
                              //                                 //NÃO POSSUI PARCEIRO
                              //                                 print("NÃO POSSUI PARCEIRO");
                              //
                              //                                 print("listP ${listP.length}");
                              //                                 print("idParceiro $idParceiro");
                              //
                              //                                 print("listPP ${listPP.length}");
                              //                                 print(listP.first.razaoSocial);
                              //                                 ///ordenar lista parceiros
                              //                                 listP.sort((a,b)=> a.razaoSocial.toString().compareTo(b.razaoSocial.toString()));
                              //                                 // items.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                              //                                 Dialogs.AlertAlterarPaciente(context, item,listP.first.razaoSocial!, idParceiro, listP,listPP, _uid);
                              //                                 // Navigator.pop(context);
                              //                               } else {
                              //                                 print("POSSUI PARCEIRO");
                              //                                 listP.sort((a,b)=> a.razaoSocial.toString().compareTo(b.razaoSocial.toString()));
                              //                                 print("idParceiro POSSUI $idParceiro");
                              //
                              //                                 print("listPP ${listPP.length}");
                              //                                 print("listP ${listP.length}");
                              //                                 print("listP.first.razaoSocial! ${listP.first.razaoSocial!}");
                              //                                 // print(item.)
                              //                                 Dialogs.AlertAlterarPaciente(context, item,listP.first.razaoSocial!, idParceiro, listP,listPP,_uid);
                              //                                 // Navigator.pushReplacementNamed(
                              //                                 //     context, "/cadastro_paciente");
                              //                               }
                              //                             });
                              //                           });
                              //                           });
                              //
                              //
                              //                     } );
                              //                   },
                              //                   child: const Icon(Icons.edit_rounded)),
                              //               title: Column(
                              //                 mainAxisAlignment: MainAxisAlignment.start,
                              //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(item.nome.toString(), style: AppTextStyles.labelBold16,),
                              //                   Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                     children: [
                              //                       Text("Fone: ${item.telefone}", style: AppTextStyles.subTitleBlack14,),
                              //                       Text("Data Nascimento: ${item.dataNascimento}", style: AppTextStyles.subTitleBlack14,),
                              //                     ],
                              //                   ),
                              //                 ],
                              //               ),
                              //
                              //             ),
                              //           )
                              //       ],
                              //     ),
                              //   ),
                              // ),
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
