import 'package:psico_sis/model/Profissional.dart';
import 'package:psico_sis/model/servicos_profissional.dart';

class Sessao2Arguments {
  final Profissional profissional;
  final ServicosProfissional servico;
  final List<String> sessoes;
  final List<double> valorSessoes;
  final List<String> datasSessoes;
  final List<String> horarioSessoes;
  Sessao2Arguments(this.profissional, this.servico, this.sessoes,
      this.valorSessoes, this.datasSessoes, this.horarioSessoes);
}