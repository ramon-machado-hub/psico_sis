class Comissao {
  late String idProfissional;
  late String idTransacao;
  late String idPagamento;
  late String dataGerada;
  late String dataPagamento;
  late String valor;
  late String situacao;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  Comissao({required this.idProfissional,required this.idPagamento,required this.idTransacao, required this.dataGerada, required this.dataPagamento, required this.valor, required this.situacao});

  Comissao.fromJson(Map<String, dynamic> json) {
    idProfissional = json['id_profissional'];
    idTransacao = json['id_transacao'];
    idPagamento = json['id_pagamento'];
    dataGerada = json['data_gerada'];
    dataPagamento = json['data_pagamento'];
    valor = json['valor'];
    situacao = json['situacao'];
  }

  factory Comissao.fromJson1(dynamic json) {
    return Comissao(
      idProfissional: json['id_profissional'],
      idTransacao: json['id_transacao'],
      idPagamento: json['id_pagamento'],
      dataGerada: json['data_gerada'],
      dataPagamento: json['data_pagamento'],
      valor: json['valor'],
      situacao: json['situacao'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_profissional'] = this.idProfissional;
    data['id_transacao'] = this.idTransacao;
    data['id_pagamento'] = this.idPagamento;
    data['data_gerada'] = this.dataGerada;
    data['data_pagamento'] = this.dataPagamento;
    data['valor'] = this.valor;
    data['situacao'] = this.situacao;
    return data;
  }
  Comissao.fromMap(Map<String, dynamic> map, String id){
    this.idProfissional = map['id_profissional'];
    this.idTransacao = map['id_transacao'];
    this.idPagamento = map['id_pagamento'];
    this.dataGerada = map['data_gerada'];
    this.valor = map['valor'];
    this.dataPagamento = map['data_pagamento'];
    this.situacao = map['situacao'];
  }
}