import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/servico.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import '../model/Usuario.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/button_widget.dart';

class Servicos extends StatefulWidget {
  const Servicos({Key? key}) : super(key: key);

  @override
  State<Servicos> createState() => _ServicosState();
}

class _ServicosState extends State<Servicos> {


  List<Servico> items = [];
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
    servicoSubscription?.cancel();
    servicoSubscription =
        db.collection("servicos").snapshots().listen(
                (snapshot) {
                    items = snapshot.docs.map(
                            (documentSnapshot) => Servico.fromMap(
                          documentSnapshot.data(),
                          int.parse(documentSnapshot.id),
                        )
                    ).toList();
                    setState((){
                      items.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
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
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16,right: 16),
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
                                          Text(item.descricao.toString()),
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
