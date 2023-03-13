import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Especialidade.dart';
import '../model/Usuario.dart';
import '../provider/especialidade_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/button_widget.dart';

class Especialidades extends StatefulWidget {
  const Especialidades({Key? key}) : super(key: key);

  @override
  State<Especialidades> createState() => _EspecialidadesState();
}

class _EspecialidadesState extends State<Especialidades> {
  List<Especialidade> especialidades = [];
  // StreamSubscription<QuerySnapshot>? especialidadeSubscription;
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


  Future<Usuario> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid esp $uid");
    if (uid.isEmpty) {
      print("empity");
      String _uidGet = "";
      print("_uidGet $_uidGet");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    } else {
      print(" not empity esp");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    }
  }

  @override
  void initState() {
    super.initState();


    Future.wait([
      PrefsService.isAuth().then((value) {
        if (value) {
          print("usuário autenticado especiali");
          PrefsService.getUid().then((value) {
            _uid = value;
            print("_uid initState esp $_uid");
            getUsuarioByUid(_uid).then((value) {
              _usuario = value;
              print("Nome especialidade ${_usuario.nomeUsuario}");
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

    if (especialidades.length==0){
      Provider.of<EspecialidadeProvider>(context,listen: false)
          .getEspecialidades().then((value) {
            especialidades = value;
            especialidades.sort((a,b)=>a.descricao!.compareTo(b.descricao!));
            setState((){});
      });
    }
    // especialidadeSubscription?.cancel();
    // especialidadeSubscription =
    //     db.collection("especialidades").snapshots().listen((snapshot) {
    //       items = snapshot.docs
    //           .map((documentSnapshot) => Especialidade.fromMap(
    //         documentSnapshot.data(),
    //         documentSnapshot.id,
    //       ))
    //           .toList();
    //       items.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
    //
    //       // setState(() {
    //       //   items.sort(
    //       //       (a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
    //       // });
    //     });


  }

  @override
  void dispose() {
    // TODO: implement dispose
    // especialidadeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("uario builder especialidade = ${_usuario.nomeUsuario}");
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
                            padding: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            child: Column(
                              children: [
                                for (var item in especialidades)
                                  Card(
                                    elevation: 8,
                                    child: ListTile(
                                      trailing: InkWell(
                                          onTap: (){
                                            Dialogs.AlertAlterarEspecialidade(context, item, _uid);
                                          },
                                          child: const Icon(Icons.edit)),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.descricao.toString()),
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
                    label: "Cadastrar Especialidade",
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, "/cadastro_especialidade");
                    },
                  ),
                ],
              ),
            )));
  }
// return FutureBuilder(
//     future: ReadJsonData(),
//     builder: (context, data){
//       if (data.hasError) {
//         print("erro ao carregar o json");
//         return Center(child: Text("${data.error}"));
//       } else if (data.hasData) {
//         print("json sucesso ${items.length}");
//         _le = data.data as List<Especialidade>;
//         for(var item in items)
//           print(item.descricao);
//         // for(var item in _le)
//         //   print(item.descricao);
//       }
//     return SafeArea(
//         child: 	Scaffold(
//             appBar: const PreferredSize(
//               preferredSize: Size.fromHeight(80),
//               child: AppBarWidget(),
//             ),
//             body: Container(
//               decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     radius: 2.0,
//                     colors: [
//                       AppColors.shape,
//                       AppColors.primaryColor,
//                     ],
//                   )),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Center(
//                       child: Container(
//                         width: size.width * 0.45,
//                         height: size.height * 0.7,
//                         decoration: BoxDecoration(
//                             border: Border.fromBorderSide(
//                               BorderSide(
//                                 color: AppColors.line,
//                                 width: 1,
//                               ),
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                             color: AppColors.shape),
//                         child: SingleChildScrollView(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 16, left: 16,right: 16),
//                             child: Column(
//                               children: [
//                                 for (var item in items)
//                                   Card(
//                                     elevation: 8,
//                                     child: ListTile(
//                                       leading: Icon(Icons.edit),
//                                       title: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(item.descricao.toString()),
//                                         ],
//                                       ),
//
//                                     ),
//                                   )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   ButtonWidget(
//                     width: MediaQuery.of(context).size.width * 0.2,
//                     height: MediaQuery.of(context).size.height * 0.1,
//                     label: "Cadastrar Especialidade",
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, "/cadastro_especialidade");
//                     },
//                   ),
//                 ],
//               ),
//             )));
// });
}
