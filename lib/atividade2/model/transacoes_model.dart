class TransacaoModel {
  int? idTransacao;
  late String nomeTransacao;
  late String statusTransacao;
  late String urlTransacao;
  late int idServico;

  TransacaoModel({this.idTransacao, required this.nomeTransacao, required this.statusTransacao, required this.urlTransacao, required this.idServico});

  TransacaoModel.fromJson(Map<String, dynamic> json) {
    idTransacao = json['idTransacao'];
    nomeTransacao = json['nomeTransacao'];
    statusTransacao = json['statusTransacao'];
    urlTransacao = json['urlTransacao'];
    idServico = json['idServico'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idTransacao'] = idTransacao;
    data['nomeTransacao'] = nomeTransacao;
    data['statusTransacao'] = statusTransacao;
    data['urlTransacao'] = urlTransacao;
    data['idServico'] = idServico;
    return data;
  }
}

