class ServicoModel {
  int? idServico;
  late String nomeServico;
  late String statusServico;
  late String urlServico;
  late int idSistema;

  ServicoModel(
      {this.idServico,
       required this.nomeServico,
       required this.statusServico,
       required this.urlServico,
       required this.idSistema});

  ServicoModel.fromJson(Map<String, dynamic> json) {
    idServico = json['idServico'];
    nomeServico = json['nomeServico'];
    statusServico = json['statusServico'];
    urlServico = json['urlServico'];
    idSistema = json['idSistema'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idServico'] = this.idServico;
    data['nomeServico'] = this.nomeServico;
    data['statusServico'] = this.statusServico;
    data['urlServico'] = this.urlServico;
    data['idSistema'] = this.idSistema;
    return data;
  }
}
