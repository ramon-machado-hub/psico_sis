import 'package:psico_sis/model/Profissional.dart';
import 'package:psico_sis/model/servicos_profissional.dart';

import '../model/Paciente.dart';
import '../model/Parceiro.dart';
import '../model/servico.dart';

class Sessao4Arguments {
  final Profissional profissional;
  final ServicosProfissional servicoProfissional;
  // final Servico servico;
  final List<String> sessoes;
  final List<double> valorSessoes;
  final List<String> datasSessoes;
  final List<String> HorariosSessoes;
  final List<Paciente> pacientes;
  final String tipoPagamento;
  late Parceiro? parceiro;

  Sessao4Arguments(this.profissional, this.servicoProfissional,  this.sessoes,
      this.valorSessoes, this.datasSessoes, this.tipoPagamento,
      this.HorariosSessoes, this.pacientes,);
}