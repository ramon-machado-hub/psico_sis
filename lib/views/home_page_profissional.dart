import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
import '../provider/usuario_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/menu_icon_button_widget.dart';


class HomePageProfissional extends StatefulWidget {

  const HomePageProfissional({Key? key}) : super(key: key);

  @override
  State<HomePageProfissional> createState() => _HomePageStateProfissional();
}

class _HomePageStateProfissional extends State<HomePageProfissional> {

  var db = FirebaseFirestore.instance;
  String _uid="";
  // late Usuario _usuario = Usuario(
  //   idUsuario:1,
  //   senhaUsuario: "",
  //   loginUsuario: "",
  //   dataNascimentoUsuario: "",
  //   telefone: "",
  //   nomeUsuario: "",
  //   emailUsuario: "",
  //   statusUsuario:  "",
  //   tokenUsuario: "",
  // );

  late Profissional _usuario = Profissional(
    nome: "",cpf: "",dataNascimento: "",email: "",endereco: "",id: "",numero: "",senha: "",status: "",telefone: "",);

  Future<Profissional> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty){
      print("empity");
      String _uidGet ="";
      print("_uidGet $_uidGet");
      return Provider.of<ProfissionalProvider>(context, listen: false)
          .getProfissional(_uidGet);
    } else{
      print(" not empity");
      return Provider.of<ProfissionalProvider>(context, listen: false)
          .getProfissional(uid);
    }

  }


  @override
  void initState(){
    super.initState();
    Future.wait([
      PrefsService.isAuth().then((value) async {
        if (value){
          print("usuário autenticado home");
         await PrefsService.getUid().then((value) async {
            _uid = value;
            print("_uid initState home $_uid");
            await getUsuarioByUid(_uid).then((value) {
              _usuario = value;
            }).then((value) {
              if (this.mounted){
                setState((){
                  print("setState home");
                });
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
          preferredSize: Size.fromHeight(80),

          child: AppBarWidget2(nomeUsuario: _usuario.nome!),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.labelWhite,
                  AppColors.shape,
                ],
              )),
          child: Center(
              child: Text("TELA PROFISSIONAL")
          ), // child: Container(
        ),
      ),
    );
  }
}
