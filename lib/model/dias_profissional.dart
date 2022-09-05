class DiasProfissional {
  int? id;
  int? idProfissional;
  String? descricao;

  DiasProfissional({this.id, this.idProfissional, this.descricao});

  DiasProfissional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProfissional = json['id_profissional'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_profissional'] = this.idProfissional;
    data['descricao'] = this.descricao;
    return data;
  }
}
