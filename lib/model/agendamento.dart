class Agendamento{
  String? descServico;
  int? qtdSessoes;
  String? idProfissional;
  String? idPaciente;
  String? valorAgendamento;
  String? formaPagamento;
  //Á vista, Cartão, Pix, Não informado.
  String? statusPagamento;
  //Aguardando, Pendente, Efetuado
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  Agendamento({
    this.descServico,
    this.qtdSessoes,
    this.idProfissional,
    this.idPaciente,
    this.valorAgendamento,
    this.formaPagamento,
    this.statusPagamento,
  });

  factory Agendamento.fromJson1(dynamic json) {
    return Agendamento(
      descServico: json['desc_servico'],
      qtdSessoes: json['qtd_sessoes'],
      idProfissional: json['id_profissional'],
      idPaciente: json['id_paciente'],
      valorAgendamento: json['valor_agendamento'],
      formaPagamento: json['forma_pagamento'],
      statusPagamento: json['status_pagamento'],
    );
  }

  Agendamento.fromJson(Map<String, dynamic> json) {
    descServico = json['desc_servico'];
    qtdSessoes = json['qtd_sessoes'];
    idProfissional = json['id_profissional'];
    idPaciente = json['id_paciente'];
    valorAgendamento = json['valor_agendamento'];
    formaPagamento = json['forma_pagamento'];
    statusPagamento = json['status_pagamento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc_servico'] = this.descServico;
    data['qtd_sessoes'] = this.qtdSessoes;
    data['id_profissional'] = this.idProfissional;
    data['id_paciente'] = this.idPaciente;
    data['valor_agendamento'] = this.valorAgendamento;
    data['forma_pagamento'] = this.formaPagamento;
    data['status_pagamento'] = this.statusPagamento;
    return data;
  }
}