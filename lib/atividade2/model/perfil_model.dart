class PerfilModel {
  int? idPerfil;
  late String nomePerfil;
  late String statusPerfil;

  PerfilModel({this.idPerfil, required this.nomePerfil, required this.statusPerfil});

  PerfilModel.fromJson(Map<String, dynamic> json) {
    idPerfil = json['idPerfil'];
    nomePerfil = json['nomePerfil'];
    statusPerfil = json['statusPerfil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPerfil'] = this.idPerfil;
    data['nomePerfil'] = this.nomePerfil;
    data['statusPerfil'] = this.statusPerfil;
    return data;
  }
}
