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

class AppBarProfissional extends StatefulWidget {
  final String nomeUsuario;
  const AppBarProfissional({Key? key, required this.nomeUsuario}) : super(key: key);

  @override
  State<AppBarProfissional> createState() => _AppBarProfissionalState();
}

class _AppBarProfissionalState extends State<AppBarProfissional> {


  @override
  Widget build(BuildContext context) {
    DateTime  data  = DateTime.now();

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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 60,
      color: AppColors.primaryColor,
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: size.width*0.025,
          ),
          //logo
          Container(
              width: size.width*0.1,
              height: 60,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 SizedBox(
                   width: size.width*0.1,
                   height: 48,
                   child:  ClipRRect(
                     borderRadius: BorderRadius.circular(8.0),
                     child: Image.asset(
                         height: 45,
                         width: size.width*0.1,
                         fit: BoxFit.contain,
                         AppImages.logo1),
                   ),
                 ),
                  SizedBox(
                    width: size.width*0.1,
                    height: 12,
                    child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("BETA 1.2", style: AppTextStyles.labelBlack8Lex,),
                        )
                    )

                  )
                ],
              )
          ),
          SizedBox(
            height: 60,
            width: size.width*0.5,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  SizedBox(
                    height: 30,
                    width: size.width*0.5,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text("Olá",style: AppTextStyles.labelBlack12Lex,),
                    )
                  ),
                  SizedBox(
                      height: 30,
                      width: size.width*0.5,
                      child: FittedBox(
                        alignment: Alignment.topLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(widget.nomeUsuario,style: AppTextStyles.labelBlack12Lex,),
                      )
                  ),

                ],
              ),
            ),
          ),

          //extrato
          SizedBox(
              height: 60,
              width: size.width*0.1,
              child: IconButton(
                iconSize: 35,
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "/extrato_profissional_mobile");
                },
                color: AppColors.labelWhite.withOpacity(0.8),
                icon: Icon(Icons.monetization_on),
              )
          ),
          SizedBox(
            height: 80,
            width: size.width*0.025,
          ),
          //pagina inicial
          SizedBox(
              height: 60,
              width: size.width*0.1,
              child: IconButton(
                iconSize: 35,
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "/home_profissional_mobile");
                },
                color: AppColors.labelWhite.withOpacity(0.8),
                icon: Icon(Icons.home),
              )
          ),
          SizedBox(
            height: 80,
            width: size.width*0.025,
          ),
          //sair
          SizedBox(
            height: 60,
            width: size.width*0.1,
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
                    Navigator.pushReplacementNamed(context, "/loginMobile");
                  });
                });
              },
              child: Icon(Icons.logout)
            ),
          ),
          SizedBox(
            height: 80,
            width: size.width*0.025,
          ),
        ],
      ),
    );
  }
}
