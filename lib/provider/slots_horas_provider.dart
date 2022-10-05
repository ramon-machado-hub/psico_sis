import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/servico.dart';

class SlotsHorasProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('slots_horas')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    if (_myDocCount.length==0){
      return 0;
    }
    return int.parse(_myDocCount.last.id);
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSlotHoraById(String id) {
    return db.collection('slots_horas').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListSlotHora() {
    return db.collection('slots_horas').snapshots();
  }

  Future<void> put(Servico servico) async {
    if (servico.id == null) {
      int id = await getCount();
      db.collection('slots_horas').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'horario': servico.descricao,
      });
    }else {
      db.collection('slots_horas').doc(servico.id.toString()).set({
        'horario': servico.descricao,
      });
    }
  }
}