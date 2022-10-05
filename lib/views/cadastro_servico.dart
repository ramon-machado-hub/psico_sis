import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/input_text_widget2.dart';
import '../model/Usuario.dart';
import '../model/log_sistema.dart';
import '../model/servico.dart';
import '../provider/log_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_uper_widget.dart';

class CadastroServico extends StatefulWidget {
  const CadastroServico({Key? key}) : super(key: key);

  @override
  State<CadastroServico> createState() => _CadastroServicoState();
}

class _CadastroServicoState extends State<CadastroServico> {
  final _form = GlobalKey<FormState>();
  String _descricao ="";
  String _qtdSessoes = "1";
  String _qtdPacientes = "0";

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
              setState(() {});
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
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarWidget(),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      width: size.width * 0.45,
                      height: size.height * 0.55,
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
                              "CADASTRO SERVIÇO",
                              style: AppTextStyles.labelBold16,
                            ),
                          ),

                          InputTextUperWidget(
                            label: "DESCRIÇÃO",
                            icon: Icons.edit_rounded,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
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

                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: InputTextWidget2(
                              label: "Nº PACIENTES",
                              icon: Icons.onetwothree,
                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Por favor insira um número';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _qtdPacientes = value;
                              },
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              backgroundColor: AppColors.secondaryColor,
                              borderColor: AppColors.line,
                              textStyle:  AppTextStyles.subTitleBlack12,
                              iconColor: AppColors.labelBlack,),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: InputTextWidget2(
                              label: "Nº SESSÕES",
                              icon: Icons.onetwothree,
                              validator: (value) {
                                if ((value!.isEmpty) || (value == null)) {
                                  return 'Por favor insira um número';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _qtdSessoes = value;
                              },
                              keyboardType: TextInputType.number,
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
                  label: "Cadastrar Serviço",
                  onTap: () {
                    if (_form.currentState!.validate()) {
                      Provider.of<ServicoProvider>(context, listen: false)
                          .put(Servico(
                        descricao: _descricao,
                        qtd_pacientes: int.parse(_qtdPacientes),
                        qtd_sessoes: int.parse(_qtdSessoes),
                      ));
                      Provider.of<ServicoProvider>(context, listen: false)
                          .getCount().then((value1) {
                        int count = value1 + 1;
                        Provider.of<LogProvider>(context, listen: false)
                            .put(LogSistema(
                          data: DateTime.now().toString(),
                          uid_usuario: _uid,
                          descricao: "INSERIU SERVICO",
                          id_transacao: count,
                        ));
                        Navigator.pushReplacementNamed(context, "/cadastro_servico");
                      });
                    }
                  }
                ),
              ],
            ),
          ),
        ));
  }
}
