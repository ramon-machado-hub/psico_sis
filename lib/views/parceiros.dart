import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../model/Parceiro.dart';
import '../model/Usuario.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';

class Parceiros extends StatefulWidget {
  const Parceiros({Key? key}) : super(key: key);

  @override
  State<Parceiros> createState() => _ParceirosState();
}

class _ParceirosState extends State<Parceiros> {
  List<Parceiro> items = [];

  StreamSubscription<QuerySnapshot>? parceiroSubscription;
  var db = FirebaseFirestore.instance;
  String _uid="";
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


  @override
  void initState(){
    super.initState();
    parceiroSubscription?.cancel();
    parceiroSubscription =
        db.collection("parceiros").snapshots().listen(
                (snapshot) {
                  setState((){
                      items = snapshot.docs.map(
                            (documentSnapshot) => Parceiro.fromMap(
                          documentSnapshot.data(),
                          int.parse(documentSnapshot.id),
                        )
                      ).toList();
                      if(this.mounted){
                        items.sort((a, b) => a.razaoSocial.toString().compareTo(b.razaoSocial.toString()));
                        setState((){});
                      }
                  });

                });
    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value){
          print("usuário autenticado");
          PrefsService.getUid().then((value) {
            _uid = value;
            print("_uid initState $_uid");
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
  void dispose() {
    // TODO: implement dispose
    parceiroSubscription?.cancel();
    super.dispose();
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
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            child: Column(
                              children: [
                                for (var item in items)
                                  Card(
                                    elevation: 8,
                                    child: ListTile(
                                      trailing:  InkWell(
                                          onTap: (){
                                            Dialogs.AlertAlterarParceiro(context, item, _uid);
                                          },
                                          child: const Icon(Icons.edit)),
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(item.razaoSocial.toString(), style: AppTextStyles.labelBlack16Lex,),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Desconto: ${item.desconto}%", style: AppTextStyles.labelBlack12Lex,),
                                              Text("Fone: ${item.telefone}", style: AppTextStyles.labelBlack12Lex,),
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
                    ),
                  ),
                  ButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    label: "Cadastrar Parceiro",
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/cadastro_parceiro");
                    },
                  ),
                ],
              ),
            )));
    // return FutureBuilder(
    //     future: ReadJsonData(),
    //     builder: (context, data){
    //       if (data.hasError) {
    //         print("erro ao carregar o json");
    //         return Center(child: Text("${data.error}"));
    //       } else if (data.hasData) {
    //         _lp = data.data as List<Parceiro>;
    //         for(var item in _lp)
    //           print(item.razaoSocial);
    //       }
    //       return SafeArea(
    //           child: Scaffold(
    //               appBar: const PreferredSize(
    //                 preferredSize: Size.fromHeight(80),
    //                 child: AppBarWidget(),
    //               ),
    //               body: Container(
    //                 decoration: BoxDecoration(
    //                     gradient: RadialGradient(
    //                       radius: 2.0,
    //                       colors: [
    //                         AppColors.shape,
    //                         AppColors.primaryColor,
    //                       ],
    //                     )),
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(16.0),
    //                       child: Center(
    //                         child: Container(
    //                           width: size.width * 0.45,
    //                           height: size.height * 0.7,
    //                           decoration: BoxDecoration(
    //                               border: Border.fromBorderSide(
    //                                 BorderSide(
    //                                   color: AppColors.line,
    //                                   width: 1,
    //                                 ),
    //                               ),
    //                               borderRadius: BorderRadius.circular(8),
    //                               color: AppColors.shape),
    //                           child: SingleChildScrollView(
    //                             child: Padding(
    //                               padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
    //                               child: Column(
    //                                 children: [
    //                                   for (var item in items)
    //                                     Card(
    //                                       elevation: 8,
    //                                       child: ListTile(
    //                                         trailing:  InkWell(
    //                                             onTap: (){},
    //                                             child: const Icon(Icons.edit)),
    //                                         title: Column(
    //                                           mainAxisAlignment: MainAxisAlignment.start,
    //                                           crossAxisAlignment: CrossAxisAlignment.start,
    //                                           children: [
    //                                             Row(
    //                                               children: [
    //                                                 Text(item.razaoSocial.toString(), style: AppTextStyles.labelBlack16Lex,),
    //                                               ],
    //                                             ),
    //                                             Row(
    //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                               children: [
    //                                                 Text("Desconto: ${item.desconto}%", style: AppTextStyles.labelBlack12Lex,),
    //                                                 Text("Fone: ${item.telefone}", style: AppTextStyles.labelBlack12Lex,),
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //
    //                                       ),
    //                                     )
    //
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //
    //                         ),
    //                       ),
    //                     ),
    //                     ButtonWidget(
    //                       width: MediaQuery.of(context).size.width * 0.2,
    //                       height: MediaQuery.of(context).size.height * 0.1,
    //                       label: "Cadastrar Parceiro",
    //                       onTap: () {
    //                         Navigator.pushReplacementNamed(context, "/cadastro_parceiro");
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               )));
    // });
  }
}
