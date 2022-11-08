import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/dias_horarios.dart';

class DiasHorariosProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;


  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('dias_horas')
        .get();

    if(_myDoc.docs.isEmpty){
      return 0;
    } else {
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      return _myDocCount.length;
    }
  }



  Stream<DocumentSnapshot<Map<String, dynamic>>> getDiasById(String id) {
    return db.collection('dias_horarios').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListDias() {
    return db.collection('dias').snapshots();
  }

  Future<void> put(DiasHorarios diasHorarios) async {
    print("put ${diasHorarios.id}");
    if (diasHorarios.id == null) {
      int id = await getCount();
      print(id);
      await db.collection('dias_horas').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'dia': diasHorarios.dia,
        'hora': diasHorarios.hora,
      });
    }else {
      db.collection('dias_horas').doc("${diasHorarios.id}").set({
        'id': diasHorarios.id,
        'dia': diasHorarios.dia,
        'hora': diasHorarios.hora,
      });
    }
  }


}