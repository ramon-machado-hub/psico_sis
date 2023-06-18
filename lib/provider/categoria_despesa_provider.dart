import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/categoria_despesa.dart';

import '../model/servico.dart';

class CategoriaDespesaProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<CategoriaDespesa> _listCategoria =[];

  Future<CategoriaDespesa> getCategoriaById(String id) async{

    final documentSnapshhot = await db.collection('categoria_despesas').doc(id).get();
    if (documentSnapshhot.exists){
      final Map<String, dynamic> doc =
        documentSnapshhot.data() as Map<String, dynamic>;
        final cat = CategoriaDespesa.fromJson(doc);
        cat.id1= documentSnapshhot.id;
        return cat;
    } else {
      return CategoriaDespesa(descricao: "não existe",);
    }
  }

  Future<List<CategoriaDespesa>> getListCategorias() async{
    final querySnapshot = await db.collection('categoria_despesas').get();
    if(_listCategoria.length==0){
      final allData = querySnapshot.docs.map((e) {
        final json = e.data();
        final cat = CategoriaDespesa.fromJson(e.data());
        cat.id1 = e.id;
        return cat;
      }).toList();
      _listCategoria = allData;
      return allData;
    } else {
      return _listCategoria;
    }
  }


  Future<String> put(CategoriaDespesa categoriaDespesa) async {

      print("serv provider");
      var itemRef = db.collection("categoria_despesas");
      var doc = itemRef.doc().id;
      db.collection('categoria_despesas').doc(doc).set({
        'descricao': categoriaDespesa.descricao,
      }).then((value) => print('Salvou categoria despesas ${doc}'));
      categoriaDespesa.id1=doc;
      _listCategoria.add(categoriaDespesa);
      return doc;
  }



  Future<void> remove(String id) async {
    db.collection("categoria_despesas").doc(id).delete().then((value) => print("removeu categoria $id"));
    _listCategoria.removeWhere((element) => element.id1.compareTo(id)==0);
    notifyListeners();
  }
}