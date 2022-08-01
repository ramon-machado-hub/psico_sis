class Especialidade {
  int? idEspecialidade;
  String? descricao;

  Especialidade({this.idEspecialidade, this.descricao});

  Especialidade.fromJson(Map<String, dynamic> json) {
    idEspecialidade = json['id_especialidade'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_especialidade'] = this.idEspecialidade;
    data['descricao'] = this.descricao;
    return data;
  }
}
