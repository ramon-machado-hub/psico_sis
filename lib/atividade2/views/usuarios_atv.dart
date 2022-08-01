import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/model/usuario_model.dart';
import 'package:psico_sis/atividade2/widgets/app_bar_atv_widget.dart';
import 'package:psico_sis/daows/UsuarioWS.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_text_styles.dart';

import '../../model/Usuario.dart';
import '../../widgets/button_widget.dart';

class UsuariosAtv extends StatefulWidget {
  final UsuarioModel usuarioModel;

  const UsuariosAtv({Key? key, required this.usuarioModel}) : super(key: key);

  @override
  State<UsuariosAtv> createState() => _UsuariosAtvState();
}

class _UsuariosAtvState extends State<UsuariosAtv> {

  late List<Usuario> _lu = [];
  Future<List<Usuario>> getUsuarios() async {
    return UsuarioWS.getInstance().getAll(widget.usuarioModel.tokenUsuario);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUsuarios(),
        builder: (context, data){
          if (data.hasError) {
            print("erro ao carregar transacoes do banco");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            _lu = data.data as List<Usuario>;
          }
          return SafeArea(
              child: Scaffold(
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
                                      for (var item in _lu)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            trailing:  InkWell(
                                                onTap: (){},
                                                child: const Icon(Icons.edit)),
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Nome: ${item.nomeUsuario}", style: AppTextStyles.labelBold16,),
                                                Text("Login: ${item.loginUsuario}"),
                                                Text("Email: ${item.emailUsuario}"),
                                                Text("Status: ${item.statusUsuario}"),
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
                          label: "Cadastrar Usuario",
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/cadastrar_usuario", arguments: widget.usuarioModel);
                          },
                        ),
                      ],
                    ),
                  )));
        });
  }
}
