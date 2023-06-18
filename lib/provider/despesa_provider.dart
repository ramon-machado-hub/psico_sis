import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/categoria_despesa.dart';
import 'package:psico_sis/model/despesa.dart';

import '../model/servico.dart';

class DespesaProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<Despesa> getDespesaById(String id) async{

    final documentSnapshhot = await db.collection('despesas').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
        documentSnapshhot.data() as Map<String, dynamic>;
        final desp = Despesa.fromJson(doc);
        desp.id1= documentSnapshhot.id;
        return desp;
    } else {
      return Despesa(descricao: "não existe", hora: '',categoria: '', valor: '', data: '', retirada: '');
    }
  }

  Future<List<Despesa>> getDespesasDoDia(DateTime date) async {
    String data = UtilData.obterDataDDMMAAAA(date);
    final querySnapshot = await db.collection('despesas')
        .where("data", isEqualTo: data)
        .get();
    final allData = querySnapshot.docs.map((e) {
      final despesa = Despesa.fromJson(e.data());
      despesa.id1 = e.id;
      return despesa;
    }).toList();
    return allData;
  }

  Future<List<Despesa>> getListDespesas() async{
    final querySnapshot = await db.collection('despesas').get();
    final allData = querySnapshot.docs.map((e) {
      final json = e.data();
      final desp = Despesa.fromJson(e.data());
      desp.id1 = e.id;
      return desp;
    }).toList();
    return allData;
  }


  Future<String> put(Despesa despesa) async {
      print("despesa provider");
      var itemRef = db.collection("despesas");
      var doc = itemRef.doc().id;
      db.collection('despesas').doc(doc).set({
        'descricao': despesa.descricao,
        'data': despesa.data,
        'valor': despesa.valor,
        'categoria': despesa.categoria,
        'hora': despesa.hora,
        'retirada': despesa.retirada,
      }).then((value) => print('Salvou despesa ${doc}'));
      return doc;
  }



  // void remove(String id) async {
  //   db.collection("despesa").doc(id).delete();
  //   notifyListeners();
  // }
}