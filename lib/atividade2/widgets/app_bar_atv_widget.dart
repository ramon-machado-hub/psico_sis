import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psico_sis/themes/app_text_styles.dart';

import '../../themes/app_colors.dart';

class AppBarAtvWidget extends StatefulWidget {
  final String nomeUsuario;
  const AppBarAtvWidget({Key? key, required this.nomeUsuario}) : super(key: key);

  @override
  State<AppBarAtvWidget> createState() => _AppBarAtvWidgetState();
}

class _AppBarAtvWidgetState extends State<AppBarAtvWidget> {



  @override
  Widget build(BuildContext context) {
    DateTime  data  = DateTime.now();
    String hora = "${data.hour}:${data.minute}";
    String dataAtual = "${data.day}/${data.month}";
    return AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.labelWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Olá"),
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
                  //alterar para usuarioModel parametro widget
                  // Navigator.pushReplacementNamed(context, "/home_atv", arguments: widget.);
                },
                color: AppColors.labelWhite.withOpacity(0.8),
                 icon: Icon(Icons.home),
              )
            ),

            //relogio
            Expanded(
              flex: 2,
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.shape,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          
                          child: Text("${data.day}/${data.month}", style: AppTextStyles.labelClock22)),
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
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    height: 80,
                    width: 60,
                    alignment: Alignment.centerLeft,
                    child: const Center(
                      child:  Text(
                        "Sair",
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          ],
        ));
  }
}
