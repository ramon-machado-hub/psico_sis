import 'package:flutter/material.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/views/agenda_assistente.dart';
import 'package:psico_sis/views/agendamento_consulta.dart';
import 'package:psico_sis/views/aniversariantes.dart';
import 'package:psico_sis/views/cadastro_paciente.dart';
import 'package:psico_sis/views/cadastro_parceiro.dart';
import 'package:psico_sis/views/cadastro_profissional.dart';
import 'package:psico_sis/views/cadastro_profissional_2.dart';
import 'package:psico_sis/views/cadastro_profissional_3.dart';
import 'package:psico_sis/views/caixa.dart';
import 'package:psico_sis/views/confirmar_consulta.dart';
import 'package:psico_sis/views/consulta.dart';
import 'package:psico_sis/views/especialidades.dart';
import 'package:psico_sis/views/home_page.dart';
import 'package:psico_sis/views/home_page_assistente.dart';
import 'package:psico_sis/views/login_page.dart';
import 'package:psico_sis/views/pacientes.dart';
import 'package:psico_sis/views/parceiro.dart';
import 'package:psico_sis/views/profissionais.dart';

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
          "/aniversariantes": (context) => const Aniversariantes(),
          "/agenda_assistente": (context) => const AgendaAssistente(),
          "/agendamento_consulta": (context) => const AgendamentoConsulta(),
          "/cadastro_paciente": (context) => const CadastroPacientes(),
          "/cadastro_parceiro": (context) => const CadastroParceiro(),
          "/cadastro_profissional": (context) => const CadastroProfissional(),
          "/cadastro_profissional2": (context) => const CadastroProfissional2(),
          "/cadastro_profissional3": (context) => const CadastroProfissional3(),
          "/caixa": (context) => const Caixa(),
          "/confirmar_consulta": (context) => const ConfirmarConsulta(),
          "/consulta": (context) => const Consulta(),
          "/pacientes": (context) => const Pacientes(),
          "/parceiro": (context) => const Parceiro(),
          "/especialidades": (context) => const Especialidades(),
          "/profissionais": (context) => const Profissionais(),
        }
    );
  }
}
