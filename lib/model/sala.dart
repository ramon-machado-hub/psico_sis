class Sala {
  int? idSala;
  late String descricao;

  Sala({this.idSala, required this.descricao});

  Sala.fromJson(Map<String, dynamic> json) {
    idSala = json['id_sala'];
    descricao = json['descricao'];
  }

  Sala.fromMap(Map<String, dynamic> map, int id){
    this.idSala = id;
    this.descricao = map['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_sala'] = this.idSala;
    data['descricao'] = this.descricao;
    return data;
  }
}
