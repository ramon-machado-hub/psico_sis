class Sessao {
  String? idTransacao;
  String? dataSessao;
  String? salaSessao;
  String? horarioSessao;
  String? tipoSessao;
  String? idPaciente;
  String? idProfissional;
  //Presencial, On line.
  String? descSessao;
  //Sessao 1/4
  String? statusSessao;
  String? situacaoSessao;
  //Agendada, Finalizada, Remarcada, Cancelada
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }


  Sessao(
      {
        this.idTransacao,
        this.dataSessao,
        this.horarioSessao,
        this.tipoSessao,
        this.descSessao,
        this.salaSessao,
        this.statusSessao,
        this.situacaoSessao,
        this.idProfissional,
        this.idPaciente,
      });


  factory Sessao.fromJson1(dynamic json) {
    return Sessao(
      idTransacao: json['id_transacao'],
      salaSessao: json['sala_sessao'],
      statusSessao: json['status_sessao'],
      dataSessao: json['data_sessao'],
      descSessao: json['desc_sessao'],
      horarioSessao: json['horario_sessao'],
      tipoSessao: json['tipo_sessao'],
      situacaoSessao: json['situacao'],
      idPaciente: json['id_paciente'],
      idProfissional: json['id_profissional'],
    );
  }

  Sessao.fromJson(Map<String, dynamic> json) {
    idTransacao = json['id_transacao'];
    dataSessao = json['data_sessao'];
    horarioSessao = json['horario_sessao'];
    tipoSessao = json['tipo_sessao'];
    descSessao = json['desc_sessao'];
    salaSessao = json['sala_sessao'];
    statusSessao = json['status_sessao'];
    situacaoSessao = json['situacao'];
    idPaciente = json['id_paciente'];
    idProfissional = json['id_profissional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transacao'] = this.idTransacao;
    data['data_sessao'] = this.dataSessao;
    data['horario_sessao'] = this.horarioSessao;
    data['tipo_sessao'] = this.tipoSessao;
    data['desc_sessao'] = this.descSessao;
    data['sala_sessao'] = this.salaSessao;
    data['status_sessao'] = this.statusSessao;
    data['situacao_sessao'] = this.situacaoSessao;
    data['id_paciente'] = idPaciente;
    data['id_profissional'] = idProfissional;
    return data;
  }
}
