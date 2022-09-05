import 'package:psico_sis/model/Profissional.dart';
import 'package:psico_sis/model/servicos_profissional.dart';

class Sessao3Arguments {
  final Profissional profissional;
  final ServicosProfissional servico;
  final int qtdPacientes;
  final List<String> sessoes;
  final List<double> valorSessoes;
  final List<String> datasSessoes;
  final List<String> HorariosSessoes;
  Sessao3Arguments(this.profissional, this.servico, this.qtdPacientes, this.sessoes, this.valorSessoes, this.datasSessoes, this.HorariosSessoes);
}