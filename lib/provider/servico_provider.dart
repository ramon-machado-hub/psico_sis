import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/servico.dart';

class ServicoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  late List<Servico> listServ = [];

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('servicos')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    if (_myDocCount.length==0){
      return 0;
    }
    return _myDocCount.length;
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getServicoById(String id) {
    return db.collection('servicos').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListServicos() {
    return db.collection('servicos').snapshots();
  }

  Future<List<Servico>> getListServicos1() async {
    List<Servico> _list = [];
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await db.collection('servicos').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element) {
      // print("aqui");
      Servico servico = Servico.fromJson1(element);
      // print(servico.id);
      // print(servico.descricao);
      // print(servico.qtd_pacientes);
      // print(servico.qtd_sessoes);
      _list.add(servico);
    });
    print("_list.l serv ${_list.length}");
    // listServ = _list;
    return _list;
  }


  Future<void> put2(Servico servico) async {
    // if (servico.id == null) {
    //   int id = await getCount();
      db.collection('back_servicos').doc(servico.id.toString()).set({
        'id': servico.id,
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      }).then((value) => print('cadastrou novo back serviço'));
    // }

  }

  Future<String> put3(Servico servico) async {

    if (servico.id == null) {
      print("serv provider");
      var itemRef = db.collection("servicos");
      var doc = itemRef.doc().id;
      // int id = await getCount();
      db.collection('servicos').doc(doc).set({
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      }).then((value) => print('salvou uhru ${doc}'));
      return doc;
    }else {
      db.collection('servicos').doc(servico.id).set({
        'id': servico.id,
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      }).then((value) => print("alterou serviços ${servico.id}"));
    }
    return "não salvou";
  }

  Future<void> put(Servico servico) async {
    if (servico.id == null) {
      int id = await getCount();
      db.collection('servicos').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      });
    }else {
      db.collection('servicos').doc(servico.id.toString()).set({
        'id': servico.id,
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      });
    }

  }

  void remove(String id) async {
    db.collection("servicos").doc(id).delete();
    notifyListeners();
  }
}