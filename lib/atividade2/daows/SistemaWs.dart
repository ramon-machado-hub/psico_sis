import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:psico_sis/atividade2/model/sistema_model.dart';

class SistemaWs {
  static SistemaWs? _instance;
  SistemaWs._internal() {}

  static SistemaWs getInstance() {
    if (_instance == null) {
      _instance = SistemaWs._internal();
    }
    return _instance!;
  }

  Future<List<SistemaModel>> getSistemas(String token) async {
    Response response = await http.post(
        Uri.parse('http://localhost:8080/sistema/getsistemas'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({"token": token}));

    if (response.statusCode ==200){
      print("request getsistemas validou");
      var dados = jsonDecode(response.body);
      List<SistemaModel> ls = (dados as List).map((e) => SistemaModel.fromJson(e)).toList();
      return ls;
    } else {
      print("request getsistemas não validou");
      return [];
    }
  }

  Future<bool> saveSistema(SistemaModel sistema, String token) async {

    Response response = await http.post(
        Uri.parse('http://localhost:8080/sistema/createsistema'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({"nome_sistema":sistema.nomeSistema,"status_sistema":"A","token": token}));

    if (response.statusCode ==200){
      print("request createsistema validou");
      var dados = jsonDecode(response.body);
      return true;

    } else {
      print("request createsistema não validou");
      return false;
    }
  }

}