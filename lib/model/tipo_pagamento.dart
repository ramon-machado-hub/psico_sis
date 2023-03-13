class TipoPagamento {
  late String descricao;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  TipoPagamento({required this.descricao});

  TipoPagamento.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
  }

  TipoPagamento.fromMap(Map<String, dynamic> map, int id){
    this.descricao = map['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['descricao'] = this.descricao;
    return data;
  }
}
