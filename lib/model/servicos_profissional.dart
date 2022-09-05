class ServicosProfissional {
  int? id;
  int? idProfissional;
  int? idServico;
  int? valor;

  ServicosProfissional(
      {this.id, this.idProfissional, this.idServico, this.valor});

  ServicosProfissional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProfissional = json['id_profissional'];
    idServico = json['id_servico'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_profissional'] = this.idProfissional;
    data['id_servico'] = this.idServico;
    data['valor'] = this.valor;
    return data;
  }
}
