import 'package:flutter/material.dart';
import 'package:psico_sis/arguments/sessao4_arguments.dart';
import 'package:psico_sis/atividade2/views/cadastrar_perfil.dart';
import 'package:psico_sis/atividade2/views/cadastrar_servico.dart';
import 'package:psico_sis/atividade2/views/cadastrar_sistema.dart';
import 'package:psico_sis/atividade2/views/login_page_atv.dart';
import 'package:psico_sis/atividade2/views/home_atv.dart';
import 'package:psico_sis/atividade2/views/perfis_atv.dart';
import 'package:psico_sis/atividade2/views/servicos_atv.dart';
import 'package:psico_sis/atividade2/views/transacoes_atv.dart';
import 'package:psico_sis/atividade2/views/usuarios_atv.dart';
import 'package:psico_sis/model/Profissional.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/views/agenda.dart';
import 'package:psico_sis/views/agenda_assistente.dart';
import 'package:psico_sis/views/sessao22.dart';
import 'package:psico_sis/views/sessao3.dart';
import 'package:psico_sis/views/sessao0.dart';
import 'package:psico_sis/views/sessao2.dart';
import 'package:psico_sis/views/aniversariantes.dart';
import 'package:psico_sis/views/cadastro_paciente.dart';
import 'package:psico_sis/views/cadastro_parceiro.dart';
import 'package:psico_sis/views/cadastro_profissional.dart';
import 'package:psico_sis/views/cadastro_profissional_2.dart';
import 'package:psico_sis/views/cadastro_profissional_3.dart';
import 'package:psico_sis/views/cadastro_profissional_4.dart';
import 'package:psico_sis/views/caixa.dart';
import 'package:psico_sis/views/sessao4.dart';
import 'package:psico_sis/views/sessao1.dart';
import 'package:psico_sis/views/especialidades.dart';
import 'package:psico_sis/views/home_page.dart';
import 'package:psico_sis/views/home_page_assistente.dart';
import 'package:psico_sis/views/login_page.dart';
import 'package:psico_sis/views/pacientes.dart';
import 'package:psico_sis/views/parceiros.dart';
import 'package:psico_sis/views/profissionais.dart';

import 'arguments/sessao2_arguments.dart';
import 'arguments/sessao3_arguments.dart';
import 'atividade2/model/usuario_model.dart';
import 'atividade2/views/cadastrar_transacao.dart';
import 'atividade2/views/cadastrar_usuario.dart';
import 'atividade2/views/sistemas_atv.dart';
import 'model/Usuario.dart';

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
        // initialRoute: "/login_atv",
        initialRoute: "/login",
        routes: {
          "/login": (context) => const LoginPage(),
          "/home": (context) => const HomePage(),
          "/home_assistente": (context) => const HomePageAssistente(),
          "/aniversariantes": (context) => const Aniversariantes(),
          "/agenda_assistente": (context) => const AgendaAssistente(),
          "/agenda": (context) => const Agenda(),
          "/cadastro_paciente": (context) => const CadastroPacientes(),
          "/cadastro_parceiro": (context) => const CadastroParceiro(),
          "/cadastro_profissional": (context) => const CadastroProfissional(),
          "/cadastro_profissional2": (context) => const CadastroProfissional2(),
          "/cadastro_profissional3": (context) => const CadastroProfissional3(),
          "/cadastro_profissional4": (context) => const CadastroProfissional4(),
          "/caixa": (context) => const Caixa(),
          // "/sessao4": (context) => const Sessao4(),
          "/sessao": (context) => const Sessao0(),
          "/sessao1": (context) => const Sessao1(),
          "/sessao2": (context) => const Sessao2(),
          "/sessao22": (context) => Sessao22(arguments: ModalRoute.of(context)!.settings.arguments as Sessao2Arguments,),
          "/sessao3": (context) => Sessao3(arguments: ModalRoute.of(context)!.settings.arguments as Sessao3Arguments,),
          "/sessao4": (context) => Sessao4(arguments: ModalRoute.of(context)!.settings.arguments as Sessao4Arguments,),
          "/pacientes": (context) => const Pacientes(),
          "/parceiro": (context) => const Parceiros(),
          "/especialidades": (context) => const Especialidades(),
          "/profissionais": (context) => const Profissionais(),
          //atividade
          "/login_atv": (context) => const LoginPageAtv(),
          "/home_atv": (context) => HomeAtv(usuario: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/sistemas_atv": (context) => SistemasAtv(usuario: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/cadastrar_sistema": (context) => CadastrarSistema(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/cadastrar_servico": (context) => CadastrarServico(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/cadastrar_perfil": (context) => CadastrarPerfil(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/cadastrar_transacao": (context) => CadastrarTransacao(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/cadastrar_usuario": (context) => CadastrarUsuario(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/transacao_atv": (context) => TransacoesAtv(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/servico_atv": (context) => ServicosAtv(usuario: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/usuario_atv": (context) => UsuariosAtv(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
          "/perfil_atv": (context) => PerfisAtv(usuarioModel: ModalRoute.of(context)!.settings.arguments as UsuarioModel),
        //  user: ModalRoute.of(context)!.settings.arguments as UserModel,
        }
    );
  }
}
