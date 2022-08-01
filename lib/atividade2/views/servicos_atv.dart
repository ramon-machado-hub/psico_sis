import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/daows/servicosWs.dart';
import 'package:psico_sis/atividade2/model/servicio_model.dart';
import 'package:psico_sis/atividade2/model/usuario_model.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../widgets/button_widget.dart';
import '../widgets/app_bar_atv_widget.dart';

class ServicosAtv extends StatefulWidget {
  final UsuarioModel usuario;
  const ServicosAtv({Key? key, required this.usuario}) : super(key: key);

  @override
  State<ServicosAtv> createState() => _ServicosAtvState();
}

class _ServicosAtvState extends State<ServicosAtv> {

  late List<ServicoModel> _ls = [];

   Future<List<ServicoModel>> getServicos() async{
     return await ServicoWS.getInstance().getServicos(widget.usuario.tokenUsuario);
   }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getServicos(),
        builder: (context, data){
          if (data.hasError) {
            print("erro ao carregar sistemas do banco");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            _ls = data.data as List<ServicoModel>;
          }
          return SafeArea(
              child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: AppBarAtvWidget(nomeUsuario: widget.usuario.nomeUsuario ),
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
                                      for (var item in _ls)
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
                                                Text(item.nomeServico.toString(), style: AppTextStyles.labelBold16,),
                                                Text("STATUS = ${item.statusServico}"),
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
                          label: "Cadastrar SERVIÇO",
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/cadastrar_servico", arguments: widget.usuario);
                          },
                        ),
                      ],
                    ),
                  )));
        });
  }
}
