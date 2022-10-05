class TipoPagamento {
  int? idTpPagamento;
  late String descricao;

  TipoPagamento({this.idTpPagamento, required this.descricao});

  TipoPagamento.fromJson(Map<String, dynamic> json) {
    idTpPagamento = json['id_tp_pagamento'];
    descricao = json['descricao'];
  }

  TipoPagamento.fromMap(Map<String, dynamic> map, int id){
    this.idTpPagamento = id;
    this.descricao = map['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_tp_pagamento'] = this.idTpPagamento;
    data['descricao'] = this.descricao;
    return data;
  }
}
