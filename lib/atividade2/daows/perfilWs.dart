import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:psico_sis/atividade2/model/perfil_model.dart';
import 'package:http/http.dart' as http;


class PerfilWs {
  static PerfilWs? _instance;

  PerfilWs._internal(){}

  static PerfilWs getInstance(){
    if (_instance == null){
      _instance = PerfilWs._internal();
    }
    return _instance!;
  }

  Future<List<PerfilModel>> getPerfis(String token) async {
    Response response = await http.post(
        Uri.parse('http://localhost:8080/perfil/getperfis'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({"token": token}));

    if (response.statusCode ==200){
      print("request getperfis validou");
      // print(response.body);
      var dados = jsonDecode(response.body);
      // print("dados = "+dados);
      List<PerfilModel> ls = (dados as List).map((e) => PerfilModel.fromJson(e)).toList();
      return ls;
    } else {
      print("request gettransacoes não validou");
      return [];
    }
  }


}