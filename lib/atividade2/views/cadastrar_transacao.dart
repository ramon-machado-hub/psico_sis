import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/model/transacoes_model.dart';
import 'package:psico_sis/atividade2/model/usuario_model.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_text_widget.dart';
import '../daows/transacaoWs.dart';
import '../widgets/app_bar_atv_widget.dart';

class CadastrarTransacao extends StatefulWidget {
  final UsuarioModel usuarioModel;
  const CadastrarTransacao({Key? key, required this.usuarioModel}) : super(key: key);

  @override
  State<CadastrarTransacao> createState() => _CadastrarTransacaoState();
}

class _CadastrarTransacaoState extends State<CadastrarTransacao> {

  final _form = GlobalKey<FormState>();
  String _descricao= "";
  String _url="";
  String _idServico="";
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
                              "CADASTRAR TRANSAÇÃO",
                              style: AppTextStyles.labelBold16,
                            ),
                          ),
                          InputTextWidget(
                            label: "DESCRIÇÃO",
                            icon: Icons.border_color_sharp,
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
                          InputTextWidget(
                            label: "URL",
                            icon: Icons.device_hub,
                            validator: (value) {
                              if ((value!.isEmpty) || (value == null)) {
                                return 'Por favor insira um texto';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _url = value;
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
                  label: "CADASTRAR TRANSAÇÃO",
                  onTap: () async {
                    if (_form.currentState!.validate()){
                      Dialogs.AlertConfirmSistema(context, _descricao);
                      if (await TransacaoWs.getInstance()
                          .saveTransacao(TransacaoModel(nomeTransacao: _descricao, statusTransacao: "A", urlTransacao: _url, idServico: 2),widget.usuarioModel.tokenUsuario)){
                        Navigator.pushReplacementNamed(context,"/transacao_atv", arguments: widget.usuarioModel);
                      }

                    }

                  },
                ),
              ],
            ),
          ),
        ));
  }
}
