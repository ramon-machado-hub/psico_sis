import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/daows/perfilWs.dart';
import 'package:psico_sis/atividade2/model/usuario_model.dart';
import 'package:psico_sis/widgets/button_widget.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../model/perfil_model.dart';
import '../widgets/app_bar_atv_widget.dart';

class PerfisAtv extends StatefulWidget {

  final UsuarioModel usuarioModel;

  const PerfisAtv({Key? key, required this.usuarioModel}) : super(key: key);

  @override
  State<PerfisAtv> createState() => _PerfisAtvState();
}

class _PerfisAtvState extends State<PerfisAtv> {

  late List<PerfilModel> _lp = [];

  Future<List<PerfilModel>> getPerfis() async {
    return await PerfilWs.getInstance().getPerfis(widget.usuarioModel.tokenUsuario);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getPerfis(),
        builder: (context, data){
          if (data.hasError) {
            print("erro ao carregar getPerfis do banco");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            _lp = data.data as List<PerfilModel>;
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
                                      for (var item in _lp)
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
                                                Text("ID: "+item.idPerfil.toString(), style: AppTextStyles.labelBold16,),
                                                Text("DESCRIÇÃO: "+item.nomePerfil.toString(), style: AppTextStyles.labelBold16,),
                                                Text("STATUS = ${item.statusPerfil}"),
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
                          label: "Cadastrar PERFIL",
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/cadastrar_perfil", arguments: widget.usuarioModel);
                          },
                        ),
                      ],
                    ),
                  )));
        });
  }
}
