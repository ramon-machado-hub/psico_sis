class FormaPagamento {
  int? id;
  String? descricao;

  FormaPagamento({this.id, this.descricao});

  FormaPagamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
  }

  FormaPagamento.fromMap(Map<String, dynamic> map, int id){
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
