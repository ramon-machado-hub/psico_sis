import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/model/usuario_model.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_text_widget.dart';
import '../widgets/app_bar_atv_widget.dart';

class CadastrarUsuario extends StatefulWidget {
  final UsuarioModel usuarioModel;
  const CadastrarUsuario({Key? key, required this.usuarioModel}) : super(key: key);

  @override
  State<CadastrarUsuario> createState() => _CadastrarUsuarioState();
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {

  final _form = GlobalKey<FormState>();
  String _nome= "";
  String _login= "";
  String _email= "";
  String _senha= "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarAtvWidget(nomeUsuario: widget.usuarioModel.nomeUsuario ),
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      width: size.width * 0.45,
                      height: size.height * 0.4,
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
                            padding: EdgeInsets.only(top: 12.0, bottom: size.height*0.05),
                            child: Text(
                              "CADASTRO USUÁRIO",
                              style: AppTextStyles.labelBold16,
                            ),
                          ),
                          InputTextWidget(
                            label: "Nome",
                            icon: Icons.border_color_sharp,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _nome = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                          InputTextWidget(
                            label: "Login",
                            icon: Icons.border_color_sharp,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _login = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                          InputTextWidget(
                            label: "Senha",
                            icon: Icons.password,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _senha = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                          InputTextWidget(
                            label: "Email",
                            icon: Icons.email,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.line,
                            textStyle:  AppTextStyles.subTitleBlack12,
                            iconColor: AppColors.labelBlack,),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "CADASTRAR PERFIL",
                  onTap: () async {
                    if (_form.currentState!.validate()){
                      Dialogs.AlertConfirmSistema(context, _nome);
                      // if (await SistemaWs.getInstance()
                      //     .saveSistema(SistemaModel(nomeSistema: _descricao,statusSistema: "A"),widget.usuarioModel.tokenUsuario)){
                      //   Navigator.pushReplacementNamed(context,"/sistemas_atv", arguments: widget.usuarioModel);
                      // }

                    }

                  },
                ),
              ],
            ),
          ),
        ));
  }
}
