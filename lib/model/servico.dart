class Servico {
  int? id;
  String? descricao;
  int? qtd_pacientes;

  Servico({this.id, this.descricao, required this.qtd_pacientes});

  Servico.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    qtd_pacientes = json['qtd_pacientes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['qtd_pacientes'] = this.qtd_pacientes;
    return data;
  }
}