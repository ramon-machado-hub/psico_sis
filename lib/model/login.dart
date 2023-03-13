class Login {
  int? id;
  String? id_usuario;
  String? tipo_usuario;
  String? uid;
  late final String _id;
  String get id1 => _id;
  set id1(String value) {
    _id = value;
  }

  Login(
      { int? id,
        String? id_usuario,
        String? tipo_usuario,
      }) {
    if (id != null) {
      this.id = id;
    }
    if (id_usuario != null) {
      this.id_usuario = id_usuario;
    }
    if (tipo_usuario != null) {
      this.tipo_usuario = tipo_usuario;
    }
  }


  Login.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    id_usuario = json['id_usuario'];
    tipo_usuario = json['tipo_usuario'];
  }

  factory Login.fromJson1(dynamic json) {
    return Login(
        id: int.parse(json['id']),
        id_usuario: json['id_usuario'],
        tipo_usuario: json['tipo_usuario'] as String,
    );
  }

  Login.fromSnapshot(String uid, Map<String, dynamic> snapshot){
    print("Usuario.fromSnapshot");
    this.id = int.parse(snapshot['id']);
    this.id_usuario = snapshot['id_usuario'];
    this.tipo_usuario = snapshot['tipo_usuario'];
  }

  Login.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.id_usuario = id_usuario;
    this.tipo_usuario = map['tipo_usuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_usuario'] = this.id_usuario;
    data['tipo_usuario'] = this.tipo_usuario;
    return data;
  }
}
