import 'package:flutter/material.dart';
import 'package:psico_sis/daows/UsuarioWS.dart';
import 'package:psico_sis/model/Usuario.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';

import '../themes/app_colors.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/menu_icon_button_widget.dart';

class HomePageAssistente extends StatefulWidget {
  const HomePageAssistente({Key? key}) : super(key: key);

  @override
  State<HomePageAssistente> createState() => _HomePageStateAssitente();
}

class _HomePageStateAssitente extends State<HomePageAssistente> {
  // loadUsuario() async {
  //   List<Usuario> ls = await UsuarioWS.getInstance().getAll();
  //   ls.forEach((element) {print(element.emailUsuario);});
  // }

  @override
  Widget build(BuildContext context) {
    // loadUsuario();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarWidget(),
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
          width: size.width * 0.6,
          height: size.height * 0.7,
          child: Wrap(
            runAlignment: WrapAlignment.center,
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            spacing: size.width * 0.03,
            runSpacing: size.height * 0.05,
            children: [

              MenuIconButtonWidget(
                  label: "Agenda",
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  iconData: Icons.calendar_month_rounded,
                  onTap: () {
                    // Navigator.pushReplacementNamed(context, "/agenda_assistente");
                    Navigator.pushReplacementNamed(context, "/agenda");
                  }),


              MenuIconButtonWidget(
                  label: "Aniversariantes",
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  iconData: Icons.cake_rounded,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/aniversariantes");
                  }),



              MenuIconButtonWidget(
                  label: "Caixa",
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  iconData: Icons.monetization_on,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/caixa");
                  }),

              MenuButtonWidget(
                label: "Sessões",
                height: size.width * 0.1,
                width: size.width * 0.1,
                image: AppImages.consulta_icon,
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/sessao");
                },
              ),
              MenuButtonWidget(
                label: "Especialidades",
                height: size.width * 0.1,
                width: size.width * 0.1,
                image: AppImages.experiencia,
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/especialidades");
                },
              ),

              MenuButtonWidget(
                label: "Paciente",
                height: size.width * 0.1,
                width: size.width * 0.1,
                image: AppImages.paciente2,
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/pacientes");
                },
              ),
              MenuIconButtonWidget(
                  label: "Parceiros",
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  iconData: Icons.handshake_rounded,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/parceiro");
                  }),


              MenuIconButtonWidget(
                  label: "Profissionais",
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  iconData: Icons.people_alt,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/profissionais");
                  }),

            ],
          ),
        )), // child: Container(
      ),
    );
  }
}
