import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/servico.dart';

class ServicoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

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
        'descricao': servico.descricao,
        'qtd_pacientes': servico.qtd_pacientes,
        'qtd_sessoes': servico.qtd_sessoes,
      });
    }
  }
}