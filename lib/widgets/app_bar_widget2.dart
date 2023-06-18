import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/service/authenticate_service.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/themes/app_text_styles.dart';

import '../model/log_sistema.dart';
import '../provider/log_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_colors.dart';

class AppBarWidget2 extends StatefulWidget {
  final String nomeUsuario;
  const AppBarWidget2({Key? key, required this.nomeUsuario}) : super(key: key);

  @override
  State<AppBarWidget2> createState() => _AppBarWidget2State();
}

class _AppBarWidget2State extends State<AppBarWidget2> {



  @override
  Widget build(BuildContext context) {
    DateTime  data  = DateTime.now();

    // String hora = "${data.hour}:${data.minute}";

    String hora = UtilData.obterHoraHHMM(data);
    String dataAtual = UtilData.obterDataDDMM(data);
    int dia = data.day;
    int mes = data.month;
    if (dia<10 && mes<10){
      dataAtual="0$dia/0$mes";
    } else {
      if (dia<10){
        dataAtual = "0$dia/$mes";
      }
      if (mes<10){
        dataAtual = "$dia/0$mes";
      }
    }
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,

        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                      height: 50,
                      width:  50,
                      fit: BoxFit.fill,
                      AppImages.logo1),
                ),
                  Text("Versão 1.3", style: AppTextStyles.labelBlack8Lex,)
                ],
              )
            ),
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Text("Olá"),
                    Text(widget.nomeUsuario),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: IconButton(
                iconSize: 40,
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "/home_assistente");
                },
                color: AppColors.labelWhite.withOpacity(0.8),
                 icon: Icon(Icons.home),
              )
            ),

            //relogio
            Expanded(
              flex: 2,
              child: Container(
                width: 65,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.shape,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(dataAtual, style: AppTextStyles.labelClock22)),
                      ),
                      VerticalDivider(
                        width: 5,
                        color: AppColors.labelBlack,
                        thickness: 2,
                        endIndent: 5,
                        indent: 5,
                      ),
                      Flexible(
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(hora, style: AppTextStyles.labelClock22,textAlign: TextAlign.center)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  String uid = await Provider.of<UsuarioProvider>(context, listen: false)
                      .getDataUid();
                  AuthenticateService().signOut().then((value) async{
                    Provider.of<LogProvider>(context, listen: false)
                        .put(LogSistema(
                      data: DateTime.now().toString(),
                      uid_usuario: uid,
                      descricao: "Logout",
                      id_transacao: "0",
                    )).then((value) {
                        PrefsService.logout();
                        Navigator.pushReplacementNamed(context, "/login");
                    });
                  });


                },
                child: const SizedBox(
                    height: 80,
                        width: 60,
                    child: Icon(Icons.logout)),
                // child: Container(
                //     height: 80,
                //     width: 60,
                //     alignment: Alignment.centerLeft,
                //     child: const Center(
                //       child:  Text(
                //         "Sair",
                //         textAlign: TextAlign.center,
                //       ),
                //     )),
              ),
            ),
          ],
        ));
  }
}
