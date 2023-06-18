class Despesa {
  late String descricao;
  late String data;
  late String hora;
  late String valor;
  late String categoria;
  late String retirada;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  Despesa({required this.descricao,required this.data, required this.hora, required this.valor, required this.categoria, required this.retirada });

  Despesa.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
    data = json['data'];
    hora = json['hora'];
    valor = json['valor'];
    categoria = json['categoria'];
    retirada = json['retirada'];
  }

  factory Despesa.fromJson1(dynamic json) {
    return Despesa(
      descricao: json['descricao'],
        data: json['data'],
        hora: json['hora'],
        valor: json['valor'],
        categoria: json['categoria'],
        retirada: json['retirada'],

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['descricao'] = this.descricao;
    data['data'] = this.data;
    data['hora'] = this.hora;
    data['valor'] = this.valor;
    data['categoria'] = this.categoria;
    data['retirada'] = this.retirada;

    return data;
  }
  Despesa.fromMap(Map<String, dynamic> map, String id){
    this.descricao = map['descricao'];
    this.data = map['data'];
    this.hora = map['hora'];
    this.valor = map['valor'];
    this.categoria = map['categoria'];
    this.retirada = map['retirada'];
  }
}