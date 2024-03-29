class ServicosProfissional {
  String? id;
  String? idProfissional;
  String? idServico;
  String? valor;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  ServicosProfissional(
      {this.id, this.idProfissional, this.idServico, this.valor});

  ServicosProfissional.fromJson(Map<String, dynamic> json) {
    // id = int.parse(json['id']);
    idProfissional = json['id_profissional'];
    idServico = json['id_servico'];
    valor = json['valor'];
  }

  ServicosProfissional.fromMap(Map<String, dynamic> map, String id){
    this.id = id;
    this.idProfissional = map['id_profissional'];
    this.idServico = map['id_servico'];
    this.valor = map['valor'];
  }

  factory ServicosProfissional.fromJson1(dynamic json) {
    return ServicosProfissional(
      //id: int.parse(json['id']),
      idProfissional: json['id_profissional'],
      idServico: json['id_servico'],
      valor: json['valor'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    data['id_profissional'] = this.idProfissional;
    data['id_servico'] = this.idServico;
    data['valor'] = this.valor;
    return data;
  }
}
