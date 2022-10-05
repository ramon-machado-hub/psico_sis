class Servico {
  int? id;
  String? descricao;
  int? qtd_pacientes;
  int? qtd_sessoes;

  Servico({this.id, this.descricao, required this.qtd_pacientes, required this.qtd_sessoes});

  Servico.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    qtd_pacientes = json['qtd_pacientes'];
    qtd_sessoes = json['qtd_sessoes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['qtd_pacientes'] = this.qtd_pacientes;
    data['qtd_sessoes'] = this.qtd_sessoes;
    return data;
  }
  Servico.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.descricao = map['descricao'];
    this.qtd_pacientes = map['qtd_pacientes'];
    this.qtd_sessoes = map['qtd_sessoes'];
  }
}