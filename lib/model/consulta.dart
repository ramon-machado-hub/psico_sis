class Consulta {
  int? idConsulta;
  String? dataConsulta;
  String? horarioConsulta;
  int? valorConsulta;
  String? tpConsulta;
  String? descConsulta;
  int? idProfissional;
  int? idPaciente;
  String? salaConsulta;
  String? statusConsulta;
  String? situacaoConsulta;

  Consulta(
      {this.idConsulta,
       this.dataConsulta,
       this.horarioConsulta,
       this.valorConsulta,
       this.tpConsulta,
       this.descConsulta,
       this.idProfissional,
       this.idPaciente,
       this.salaConsulta,
       this.statusConsulta,
       this.situacaoConsulta});

  Consulta.fromJson(Map<String, dynamic> json) {
    idConsulta = json['id'];
    dataConsulta = json['data_consulta'];
    horarioConsulta = json['horario_consulta'];
    valorConsulta = json['valor'];
    tpConsulta = json['tp_consulta'];
    descConsulta = json['desc_consulta'];
    idProfissional = json['id_profissional'];
    idPaciente = json['id_paciente'];
    salaConsulta = json['sala_consulta'];
    statusConsulta = json['status_consulta'];
    situacaoConsulta = json['situacao_consulta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_consulta'] = this.idConsulta;
    data['data_consulta'] = this.dataConsulta;
    data['horario_consulta'] = this.horarioConsulta;
    data['valor_consulta'] = this.valorConsulta;
    data['tp_consulta'] = this.tpConsulta;
    data['desc_consulta'] = this.descConsulta;
    data['id_profissional'] = this.idProfissional;
    data['id_paciente'] = this.idPaciente;
    data['sala_consulta'] = this.salaConsulta;
    data['status_consulta'] = this.statusConsulta;
    data['situacao_consulta'] = this.situacaoConsulta;
    return data;
  }
}
