class PagamentoTransacao {
  late String dataPagamento;
  late String horaPagamento;
  late String valorPagamento;
  late String valorTotalPagamento;
  late String tipoPagamento;
  late String descServico;
  late String idTransacao;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  PagamentoTransacao(
      { required this.dataPagamento,
        required this.horaPagamento,
        required  this.valorPagamento,
        required  this.valorTotalPagamento,
        required  this.tipoPagamento,
        required this.descServico,
        required this.idTransacao,});

  PagamentoTransacao.fromJson(Map<String, dynamic> json) {
    dataPagamento = json['data'];
    horaPagamento = json['hora'];
    valorPagamento = json['valor'];
    valorTotalPagamento = json['valor_transacao'];
    tipoPagamento = json['tipo_pagamento'];
    descServico = json['descricao'];
    idTransacao = json['id_transacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.dataPagamento;
    data['hora'] = this.horaPagamento;
    data['valor_pagamento'] = this.valorPagamento;
    data['valor_total']= this.valorTotalPagamento;
    data['tipo_pagamento'] = this.tipoPagamento;
    data['descricao'] = this.descServico;
    data['id_transacao'] = this.idTransacao;
    return data;
  }
}