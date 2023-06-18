import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/servico.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import '../model/Usuario.dart';
import '../provider/servico_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_uper_widget.dart';

class Servicos extends StatefulWidget {
  const Servicos({Key? key}) : super(key: key);

  @override
  State<Servicos> createState() => _ServicosState();
}

class _ServicosState extends State<Servicos> {

  String _parteName = "";
  List<Servico> items = [];
  List<Servico> _lServFinal = [];
  StreamSubscription<QuerySnapshot>? servicoSubscription;
  String _uid = "";

  var db = FirebaseFirestore.instance;
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

  List<Servico> getServParteName(String parteName){
    List<Servico> list = [];
    if (parteName.length==0) {
      list = _lServFinal;
    } else {
      _lServFinal.forEach((element) {
        if (element.descricao?.substring(0,parteName.length).compareTo(parteName)==0)
          list.add(element);
      });
    }
    return list;
  }
  //List<Paciente> getPaciParteName(String parteName){
  //     List<Paciente> list = [];
  //     print("parteName = ${parteName.length}");
  //     print("_lpFinal = ${_lpFinal.length}");
  //
  //     if (parteName.length==0){
  //       list = _lpFinal;
  //       // return list;
  //     } else {
  //       _lpFinal.forEach((element) {
  //         if (element.nome?.substring(0,parteName.length).compareTo(parteName)==0)
  //           list.add(element);
  //       });
  //     }
  //
  //
  //     // if(list.length>0){
  //     //   // items.clear();
  //     //   items = list;
  //     // } else {
  //     //   // items.clear();
  //     //   list = _lpFinal;
  //     // }
  //
  //     // setState((){});
  //     print("list = ${list.length}");
  //     return list;
  //   }

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
    if (items.length==0){
      Provider.of<ServicoProvider>(context, listen: false).getListServicos().then((value) {
          items = value;
          items.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
          _lServFinal = items;
      } );
    }
    // servicoSubscription?.cancel();
    // servicoSubscription =
    //     db.collection("servicos").snapshots().listen(
    //             (snapshot) {
    //                 items = snapshot.docs.map(
    //                         (documentSnapshot) => Servico.fromMap(
    //                       documentSnapshot.data(),
    //                       documentSnapshot.id,
    //                     )
    //                 ).toList();
    //                 setState((){
    //                   items.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
    //                   _lServFinal = items;
    //                 });
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
    servicoSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: 	Scaffold(
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
                                    print("_lpFinal length ${_lServFinal.length}");
                                    if(_parteName.length==0){
                                      print("parteName = 0 $_parteName");
                                      // items.clear();
                                      print("items = getPaciParteName($_parteName)");
                                      items = getServParteName(_parteName);
                                      print(items.length.toString()+"aaa");
                                    } else {
                                      print("getPaciParteName");
                                      print("items = getPaciParteName($_parteName)");
                                      items = getServParteName(_parteName);
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

                            SizedBox(
                              height: size.height * 0.56,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16,right: 16),
                                  child: Column(
                                    children: [


                                      for (var item in items)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            trailing: InkWell(
                                                onTap: (){
                                                  Dialogs.AlertAlterarServico(context, item, _uid);
                                                },
                                                child: Icon(Icons.edit)),
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${item.descricao.toString()} "),
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                //   children: [
                                                //     Row(children: [
                                                //       Text("Qtd Pacientes: "),
                                                //       Text(item.qtd_sessoes.toString(),
                                                //         style: AppTextStyles.labelBlack14Lex,),
                                                //     ],),
                                                //     Row(children: [
                                                //       Text("Qtd Sessões "),
                                                //       Text(item.qtd_sessoes.toString(),
                                                //         style: AppTextStyles.labelBlack14Lex,),
                                                //     ],)
                                                //   ],
                                                // ),

                                              ],
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Row(children: [
                                                  Text("Qtd Pacientes: "),
                                                  Text(item.qtd_pacientes.toString(),
                                                    style: AppTextStyles.labelBlack14Lex,),
                                                ],),
                                                SizedBox(width: 30,),
                                                Row(children: [
                                                  Text("Qtd Sessões "),
                                                  Text(item.qtd_sessoes.toString(),
                                                    style: AppTextStyles.labelBlack14Lex,),
                                                ],)
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
                    label: "Cadastrar Serviço",
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/cadastro_servico");
                    },
                  ),
                ],
              ),
            )));
  }
}
