import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:psico_sis/atividade2/model/servicio_model.dart';
import 'package:http/http.dart' as http;

class ServicoWS {
  static ServicoWS? _instance;

  ServicoWS._internal(){}

  static ServicoWS getInstance(){
    if (_instance == null){
      _instance = ServicoWS._internal();
    }
    return _instance!;
  }

  Future<List<ServicoModel>> getServicos(String token) async {
    Response response = await http.post(Uri.parse('http://localhost:8080/servico/getservicos'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode({"token": token}));
    if (response.statusCode ==200){
      print("request getservicoss validou");
      var dados = jsonDecode(response.body);
      List<ServicoModel> ls = (dados as List).map((e) => ServicoModel .fromJson(e)).toList();
      return ls;
    } else {
        print("request getsistemas não validou");
        return [];
    }

  }



}