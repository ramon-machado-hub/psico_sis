class LogSistema {
  int? id;
  String? uid_usuario;
  String? descricao;
  int? id_transacao;
  String? data;

  LogSistema({this.id, this.uid_usuario, this.descricao, this.id_transacao, this.data});

  LogSistema.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid_usuario = json['uid_usuario'];
    descricao = json['descricao'];
    id_transacao = json['id_transacao'];
    data = json['data'];
  }

  LogSistema.fromMap(Map<String, dynamic> map, int id){
    this.id = id;
    this.uid_usuario = map['uid_usuario'];
    this.descricao = map['descricao'];
    this.id_transacao = map['id_transacao'];
    this.data = map['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid_usuario'] = this.uid_usuario;
    data['descricao'] = this.descricao;
    data['id_transacao'] = this.id_transacao;
    data['data'] = this.data;
    return data;
  }
}
