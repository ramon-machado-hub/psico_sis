import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/dias_horarios.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';

class DiasSalasProfissionaisProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<DiasSalasProfissionais?> exist(String hora, String dia, String sala)async{
    DiasSalasProfissionais dias;
    var documents = await db.collection('dias_salas_profissionais')
        .where("dia", isEqualTo: dia)
        .where("hora", isEqualTo: hora)
        .where("sala", isEqualTo: sala).get();
    if (documents.size>0){
      dias = DiasSalasProfissionais(
        idProfissional: int.parse(documents.docs[0]['id_profissional']),
        dia: documents.docs[0]['dia'],
        sala: documents.docs[0]['sala'],
        hora: documents.docs[0]['hora'],
      );
      return dias;
    }
    return null;
  }

  ///checar somente o dia outras validações fazer na propria página
  Future<bool?> salaOcupada(String hora, String dia, String sala)async{
    DiasSalasProfissionais dias;
    var documents = await db.collection('dias_salas_profissionais')
        .where("dia", isEqualTo: dia)
        .where("hora", isEqualTo: hora)
        .where("sala", isEqualTo: sala).get();
    if (documents.size>0){
      return true;
    } else {
      return false;
    }
  }

  Future<List<DiasSalasProfissionais>> getListOcupadas() async{
    List<DiasSalasProfissionais> result= [];
    var documents = await db.collection('dias_salas_profissionais').get();
    for(int i =0; i<documents.size; i++){
      result.add(DiasSalasProfissionais(
        id: int.parse(documents.docs[i]['id']),
        idProfissional: int.parse(documents.docs[i]['id_profissional']),
        dia: documents.docs[i]['dia'],
        sala: documents.docs[i]['sala'],
        hora: documents.docs[i]['hora'],
      ));
    }
    return result;
  }


  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('dias_salas_profissionais')
        .get();

    if(_myDoc.docs.isEmpty){
      return 0;
    } else {
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      return _myDocCount.length;
    }
  }



  Stream<DocumentSnapshot<Map<String, dynamic>>> getDiasById(String id) {
    return db.collection('dias_salas_profissionais').doc(id).snapshots();
  }

  Future<List<DiasSalasProfissionais>> getListDiasSalas() async{
    final querySnapshot = await db.collection('dias_salas_profissionais').get();
    final allData = querySnapshot.docs.map((doc) {
      final dias = DiasSalasProfissionais.fromJson(doc.data());
      dias.id1 = doc.id;
      return dias;
    }).toList();
    return allData;
  }

  Future<void> put2(DiasSalasProfissionais diasSalasProfissionais) async {
    if (diasSalasProfissionais.id != null){
      db.collection('back_dias_salas_profissionais').doc(diasSalasProfissionais.id.toString())
          .set({
        'id': diasSalasProfissionais.id.toString(),
        'dia': diasSalasProfissionais.dia,
        'hora': diasSalasProfissionais.hora,
        'id_profissional': diasSalasProfissionais.idProfissional.toString(),
        'sala': diasSalasProfissionais.sala,
      });
    }
  }

  Future<void> put(DiasSalasProfissionais diasSalasProfissionais) async {
    print("put ${diasSalasProfissionais.id}");
    if (diasSalasProfissionais.id == null) {
      int id = await getCount();
      print(id);
      db.collection('dias_salas_profissionais').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'dia': diasSalasProfissionais.dia,
        'hora': diasSalasProfissionais.hora,
        'id_profissional': diasSalasProfissionais.idProfissional.toString(),
        'sala': diasSalasProfissionais.sala,
      });
    }else {
      db.collection('dias_salas_profissionais').doc("${diasSalasProfissionais.id}").set({
        'id': (diasSalasProfissionais.id).toString(),
        'dia': diasSalasProfissionais.dia,
        'hora': diasSalasProfissionais.hora,
        'id_profissional': diasSalasProfissionais.idProfissional,
        'sala': diasSalasProfissionais.sala,
      });
    }
  }


}