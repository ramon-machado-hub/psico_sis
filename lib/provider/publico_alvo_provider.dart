import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/Especialidade.dart';

class PublicoAlvoProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('publico_alvo')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return int.parse(_myDocCount.last.id);
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPublicoAlvoById(String id) {
    return db.collection('publico_alvo').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListPublicoAlvo() {
    return db.collection('publico_alvo').snapshots();
  }

  Future<void> put(Especialidade especialidade) async {
    if (especialidade.idEspecialidade == null) {
      int id = await getCount();
      db.collection('publico_alvo').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'descricao': especialidade.descricao,
      });
    }else {
      db.collection('publico_alvo').doc(especialidade.idEspecialidade.toString()).set({
        'descricao': especialidade.descricao,
      });
    }
  }
}