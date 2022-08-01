import 'package:flutter/material.dart';
import 'package:psico_sis/atividade2/views/cadastrar_perfil.dart';
import 'package:psico_sis/atividade2/views/cadastrar_servico.dart';
import 'package:psico_sis/atividade2/views/cadastrar_sistema.dart';
import 'package:psico_sis/atividade2/views/login_page_atv.dart';
import 'package:psico_sis/atividade2/views/home_atv.dart';
import 'package:psico_sis/atividade2/views/perfis_atv.dart';
import 'package:psico_sis/atividade2/views/servicos_atv.dart';
import 'package:psico_sis/atividade2/views/transacoes_atv.dart';
import 'package:psico_sis/atividade2/views/usuarios_atv.dart';
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
import 'package:psico_sis/views/parceiros.dart';
import 'package:psico_sis/views/profissionais.dart';

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
        initialRoute: "/login_atv",
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
