class TransacaoCaixa {
  int? idTransacao;
  late String dataTransacao;
  String? horaTransacao;
  late String valorTransacao;
  late String descontoClinica;
  late String descontoProfissional;
  late String descricaoTransacao;
  late String tpPagamento;
  late String tpTransacao;
  late String idPaciente;
  late String idProfissional;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  TransacaoCaixa(
      { this.idTransacao,
        this.horaTransacao,
        required  this.descontoClinica,
        required  this.descontoProfissional,
        required  this.dataTransacao,
        required this.valorTransacao,
        required this.descricaoTransacao,
        required this.tpPagamento,
        required this.tpTransacao,
        required this.idProfissional,
        required this.idPaciente});

  TransacaoCaixa.fromJson(Map<String, dynamic> json) {
    dataTransacao = json['data'];
    descontoProfissional = json['desconto_profissional'];
    descontoClinica = json['desconto_clinica'];
    valorTransacao = json['valor'];
    horaTransacao = json['hora_transacao'];
    descricaoTransacao = json['descricao'];
    tpPagamento = json['tipo_pagamento'];
    tpTransacao = json['tipo_transacao'];
    idPaciente = json['id_paciente'];
    idProfissional = json['id_profissional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desconto_clinica'] = this.descontoClinica;
    data['desconto_profissional'] = this.descontoProfissional;
    data['data_transacao'] = this.dataTransacao;
    data['hora_transacao']= this.horaTransacao;
    data['valor_transacao'] = this.valorTransacao;
    data['descricao_transacao'] = this.descricaoTransacao;
    data['tp_pagamento'] = this.tpPagamento;
    data['tp_transacao'] = this.tpTransacao;
    data['id_paciente'] = this.idPaciente;
    data['id_profissional'] = this.idProfissional;
    return data;
  }
}