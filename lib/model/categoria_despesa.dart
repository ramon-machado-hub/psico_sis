class CategoriaDespesa {
  String? descricao;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  CategoriaDespesa({this.descricao,});

  CategoriaDespesa.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
  }

  factory CategoriaDespesa.fromJson1(dynamic json) {
    return CategoriaDespesa(
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['descricao'] = this.descricao;
    return data;
  }
  CategoriaDespesa.fromMap(Map<String, dynamic> map, String id){
    this.descricao = map['descricao'];
  }
}