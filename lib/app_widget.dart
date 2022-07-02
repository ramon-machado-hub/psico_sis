import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/views/agenda_assistente.dart';
import 'package:psico_sis/views/home_page.dart';
import 'package:psico_sis/views/home_page_assistente.dart';
import 'package:psico_sis/views/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PsicoSys',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: AppColors.primaryColor,
        ),
        initialRoute: "/login",
        routes: {
          "/login": (context) => const LoginPage(),
          "/home": (context) => const HomePage(),
          "/home_assistente": (context) => const HomePageAssistente(),
          "/agenda_assistente": (context) => const AgendaAssistente(),
        }
    );
  }
}
