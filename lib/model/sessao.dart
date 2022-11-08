class Sessao {
  int? idSessao;
  String? dataSessao;
  String? horarioSessao;
  int? valorSessao;
  String? tipoSessao;
  String? descSessao;
  int? idProfissional;
  int? idPaciente;
  String? salaSessao;
  String? statusSessao;
  String? situacaoSessao;

  Sessao(
      {this.idSessao,
        this.dataSessao,
        this.horarioSessao,
        this.valorSessao,
        this.tipoSessao,
        this.descSessao,
        this.idProfissional,
        this.idPaciente,
        this.salaSessao,
        this.statusSessao,
        this.situacaoSessao});


  factory Sessao.fromJson1(dynamic json) {
    return Sessao(
      idSessao: int.parse(json['id']),
      idProfissional: json['id_profissional'],
      idPaciente: json['id_servico'],
      salaSessao: json['sala_sessao'],
      situacaoSessao: json['situacao_sessao'],
      statusSessao: json['status_sessao'],
      dataSessao: json['data_sessao'],
      descSessao: json['desc_sessao'],
      horarioSessao: json['horario_sessao'],
      tipoSessao: json['tipo_sessao'],
      valorSessao: json['valor_sessao'],
    );
  }

  Sessao.fromJson(Map<String, dynamic> json) {
    idSessao = json['id'];
    dataSessao = json['data_sessao'];
    horarioSessao = json['horario_sessao'];
    valorSessao = json['valor_sessao'];
    tipoSessao = json['tipo_sessao'];
    descSessao = json['desc_sessao'];
    idProfissional = json['id_profissional'];
    idPaciente = json['id_paciente'];
    salaSessao = json['sala_sessao'];
    statusSessao = json['status_sessao'];
    situacaoSessao = json['situacao_sessao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_sessao'] = this.idSessao;
    data['data_sessao'] = this.dataSessao;
    data['horario_sessao'] = this.horarioSessao;
    data['valor_sessao'] = this.valorSessao;
    data['tipo_sessao'] = this.tipoSessao;
    data['desc_sessao'] = this.descSessao;
    data['id_profissional'] = this.idProfissional;
    data['id_paciente'] = this.idPaciente;
    data['sala_sessao'] = this.salaSessao;
    data['status_sessao'] = this.statusSessao;
    data['situacao_sessao'] = this.situacaoSessao;
    return data;
  }
}
