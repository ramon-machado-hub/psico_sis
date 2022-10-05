class Dias {
  int? id;
  String? descricao;

  Dias({this.id, this.descricao});

  Dias.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
  }

  Dias.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.descricao = map['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    return data;
  }
}
