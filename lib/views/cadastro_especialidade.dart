import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/Especialidade.dart';
import 'package:psico_sis/provider/especialidade_provider.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import '../model/Usuario.dart';
import '../model/log_sistema.dart';
import '../provider/log_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_uper_widget.dart';

class CadastroEspecialidade extends StatefulWidget {
  const CadastroEspecialidade({Key? key}) : super(key: key);

  @override
  State<CadastroEspecialidade> createState() => _CadastroEspecialidadeState();
}

class _CadastroEspecialidadeState extends State<CadastroEspecialidade> {
  // List<Especialidade> items = [];
  StreamSubscription<QuerySnapshot>? especialidadeSubscription;
  final _form = GlobalKey<FormState>();
  var db = FirebaseFirestore.instance;

  String _uid="";
  String _descricao ="";
  late Usuario _usuario = Usuario(
    idUsuario:0,
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


  bool containDescricao(String descricao){
    print("email $descricao");
    bool result = false;

    // items.forEach((element) {
    //   print("${element.descricao}  =  $descricao");
    //   if (element.descricao.compareTo(descricao)==0){
    //     result = true;
    //   }
    // });
    return result;
  }

  @override
  void initState(){
    super.initState();


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
              setState((){});
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
/*
    especialidadeSubscription =
        db.collection("especialidades").snapshots().listen((snapshot) {
          items = snapshot.docs
              .map((documentSnapshot) => Especialidade.fromMap(
            documentSnapshot.data(),
            int.parse(documentSnapshot.id),
          ))
              .toList();
          // setState(() {
          //   items.sort(
          //           (a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
          // });
        });
*/

  }

  @override
  void dispose() {
    // TODO: implement dispose
    especialidadeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      width: size.width * 0.45,
                      height: size.height * 0.45,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Text(
                              "CADASTRO ESPECIALIDADE",
                              style: AppTextStyles.labelBold16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: InputTextUperWidget(
                                label: "DESCRIÇÃO",
                                icon: Icons.perm_contact_cal_sharp,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Por favor insira um texto';
                                  }
                                  if (containDescricao(value)){
                                    return 'Especialidade cadastrada';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _descricao = value;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle:  AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "Cadastrar Especialidade",
                  onTap: () {
                    if (_form.currentState!.validate()){
                      //salvando especialidade
                      Provider.of<EspecialidadeProvider>(context, listen: false)
                          .put(Especialidade(
                        descricao: _descricao,
                      ));
                      //id especialidade gerada
                      Provider.of<EspecialidadeProvider>(context, listen: false)
                          .getCount().then((value1) {
                        int count = value1+1;
                        //salvando no log
                        Provider.of<LogProvider>(context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: _uid,
                          descricao: "Cadastro especialidade",
                          ///id transação via put
                          id_transacao: count.toString(),
                        ));
                        Navigator.pushReplacementNamed(context, "/cadastro_especialidade");
                      });
                    }

                  },
                ),
              ],
            ),
          ),
        ));
  }
}
