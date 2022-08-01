class SistemaModel {
  int? idSistema;
  late String nomeSistema;
  late String statusSistema;

  SistemaModel({this.idSistema, required this.nomeSistema, required this.statusSistema});

  SistemaModel.fromJson(Map<String, dynamic> json) {
    idSistema = json['idSistema'];
    nomeSistema = json['nomeSistema'];
    statusSistema = json['statusSistema'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idSistema'] = idSistema;
    data['nomeSistema'] = nomeSistema;
    data['statusSistema'] = statusSistema;
    return data;
  }
}

