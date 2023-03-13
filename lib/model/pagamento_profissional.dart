class PagamentoProfissional {
  late String idProfissional;
  late String data;
  late String valor;
  late String hora;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  PagamentoProfissional({required this.idProfissional, required this.data, required this.hora, required this.valor,});

  PagamentoProfissional.fromJson(Map<String, dynamic> json) {
    idProfissional = json['id_profissional'];
    data = json['data'];
    hora = json['hora'];
    valor = json['valor'];
  }

  factory PagamentoProfissional.fromJson1(dynamic json) {
    return PagamentoProfissional(
      idProfissional: json['id_profissional'],
      data: json['data'],
      hora: json['hora'],
      valor: json['valor'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_profissional'] = this.idProfissional;
    data['data'] = this.data;
    data['hora'] = this.hora;
    data['valor'] = this.valor;
    return data;
  }
  PagamentoProfissional.fromMap(Map<String, dynamic> map, String id){
    this.idProfissional = map['id_profissional'];
    this.valor = map['valor'];
    this.data = map['data'];
    this.hora = map['hora'];
  }
}