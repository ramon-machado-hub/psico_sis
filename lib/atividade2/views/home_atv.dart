import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../daows/UsuarioWS.dart';
import '../../model/Usuario.dart';
import '../../themes/app_colors.dart';
import '../model/usuario_model.dart';
import '../widgets/app_bar_atv_widget.dart';
import '../widgets/menu_button_atv_widget.dart';

class HomeAtv extends StatefulWidget {
  final UsuarioModel usuario;

  const HomeAtv({Key? key, required this.usuario}) : super(key: key);

  @override
  State<HomeAtv> createState() => _HomeAtvState();
}



class _HomeAtvState extends State<HomeAtv> {
  late List<Usuario> _lu = [];
  late Usuario _usuario;


  void loadUsuarios(String token) async {
    print("aqui");
    _lu = await UsuarioWS.getInstance().getAll(token);

    print(_lu.length);
    _lu.forEach((element) {
      if (element.tokenUsuario==token){
        _usuario = element;
        print("usuario = ${_usuario.nomeUsuario}");
      }
      print(element.emailUsuario);
    });
  }

  void loadAtivos(String token) async {
    print("aquiW");
    _lu = await UsuarioWS.getInstance().getAtivos(token);
    print(_lu.length);
    _lu.forEach((element) {
      print(element.emailUsuario);
    });
  }


  @override
  Widget build(BuildContext context) {
    // loadUsuarios(widget.usuario.tokenUsuario);

    Size size = MediaQuery.of(context).size;
    double space = size.width * 0.05;
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarAtvWidget(nomeUsuario: widget.usuario.nomeUsuario,),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 2.5,
              colors: [
                AppColors.shape,
                AppColors.primaryColor,
              ],
            )),
        child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.labelWhite,
                borderRadius: BorderRadius.circular(25),
              ),
              width: size.width * 0.5,
              height: size.height * 0.7,
              child: Padding(
                padding: EdgeInsets.only(left:space, right: space),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,

                  alignment: WrapAlignment.spaceAround,
                  spacing: size.width * 0.05,
                  runSpacing: size.height * 0.05,
                  children: [
                    MenuButtonAtvWidget(
                      label: "SISTEMAS",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      icon: Icons.system_security_update_good_sharp,
                      onTap: (){
                        Navigator.pushNamed(context, "/sistemas_atv", arguments: widget.usuario);
                      },
                    ),
                    MenuButtonAtvWidget(
                      label: "TRANSAÇÕES",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      icon: Icons.start_rounded,
                      onTap: (){
                        Navigator.pushNamed(context, "/transacao_atv", arguments: widget.usuario);
                      },
                    ),
                    MenuButtonAtvWidget(
                      label: "USUARIOS",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      icon: Icons.account_box_sharp,
                      onTap: (){
                        Navigator.pushNamed(context, "/usuario_atv", arguments: widget.usuario);
                      },
                    ),
                    MenuButtonAtvWidget(
                      label: "PERFIS",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      icon: Icons.people_alt,
                      onTap: (){
                        Navigator.pushNamed(context, "/perfil_atv", arguments: widget.usuario);
                      },
                    ),
                    MenuButtonAtvWidget(
                      label: "SERVIÇOS",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      icon: Icons.list_alt_outlined,
                      onTap: (){
                        Navigator.pushNamed(context, "/servico_atv", arguments: widget.usuario);
                      },
                    ),
                    MenuButtonAtvWidget(
                      label: "LOG",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      icon: Icons.web_stories,
                      onTap: (){},
                    ),

                  ],
                ),
              ),
            )), // child: Container(
      ),
    );
  }
}
