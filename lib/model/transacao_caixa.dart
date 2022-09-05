class TransacaoCaixa {
  int? idTransacao;
  late String dataTransacao;
  late int valorTransacao;
  late String descricaoTransacao;
  late String tpPagamento;
  late  String tpTransao;

  TransacaoCaixa(
      {this.idTransacao,
        required  this.dataTransacao,
        required this.valorTransacao,
        required this.descricaoTransacao,
        required this.tpPagamento,
        required this.tpTransao});

  TransacaoCaixa.fromJson(Map<String, dynamic> json) {
    idTransacao = json['id_transacao'];
    dataTransacao = json['data_transacao'];
    valorTransacao = json['valor_transacao'];
    descricaoTransacao = json['descrição_transacao'];
    tpPagamento = json['tp_pagamento'];
    tpTransao = json['tp_transação'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transacao'] = this.idTransacao;
    data['data_transacao'] = this.dataTransacao;
    data['valor_transacao'] = this.valorTransacao;
    data['descricao_transacao'] = this.descricaoTransacao;
    data['tp_pagamento'] = this.tpPagamento;
    data['tp_transação'] = this.tpTransao;
    return data;
  }
}