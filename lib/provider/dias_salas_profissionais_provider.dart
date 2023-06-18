import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/dias_horarios.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';

class DiasSalasProfissionaisProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<DiasSalasProfissionais> diasProfissionais = [];

  Future<DiasSalasProfissionais?> exist(String hora, String dia, String sala)async{
    DiasSalasProfissionais dias;
    var documents = await db.collection('dias_salas_profissionais')
        .where("dia", isEqualTo: dia)
        .where("hora", isEqualTo: hora)
        .where("sala", isEqualTo: sala).get();
    if (documents.size>0){
      dias = DiasSalasProfissionais(
        idProfissional: documents.docs[0]['id_profissional'],
        dia: documents.docs[0]['dia'],
        sala: documents.docs[0]['sala'],
        hora: documents.docs[0]['hora'],
      );
      return dias;
    }
    return null;
  }
  //getDiasProfissionalByIdProfissional
  Future<List<DiasSalasProfissionais>> getDiasProfissionalByIdProfissional(String id,) async{
    List<String> list = [];
    var documents = await db.collection('dias_salas_profissionais')
        .where("id_profissional", isEqualTo: id).get();
    final allData = documents.docs.map((doc) {
      final dias = DiasSalasProfissionais.fromJson(doc.data());
      dias.id1 = doc.id;
      return dias;
    }).toList();

    // list = allData.map((e) => e.dia  );
    // for (int i=0; i<allData.length; i++){
      //   if (list.contains(allData[i].dia)==false){
      //     print("add");
      //     list.add(allData[i].dia!);
      //   } else {print("nao add ${allData[i].dia} ");}
    // }
    print("allData = ${allData.length}");
    return allData;

  }


  Future<List<DiasSalasProfissionais>> getHorariosDoDiaByProfissional(String id, String dia) async{
    // List<DiasSalasProfissionais> list = [];
    var documents = await db.collection('dias_salas_profissionais')
      .where("dia", isEqualTo: dia)
      .where("id_profissional", isEqualTo: id).get();
    final allData = documents.docs.map((doc) {
      final dias = DiasSalasProfissionais.fromJson(doc.data());
      dias.id1 = doc.id;
      return dias;
    }).toList();
    return allData;

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

  Future<List<DiasSalasProfissionais>> getList() async{

    if (diasProfissionais.length==0){
      final  querySnapshot = await db.collection('dias_salas_profissionais').get();
      final allData = querySnapshot.docs.map((doc) {
        final dias = DiasSalasProfissionais.fromJson(doc.data());
        dias.id1 = doc.id;
        diasProfissionais.add(dias);
        return dias;
      }).toList();
      return allData;
    } else {
      return diasProfissionais;
    }

  }

  Future<List<DiasSalasProfissionais>> getListOcupadas(String dia) async{
    if (diasProfissionais.length==0){
      final  querySnapshot = await db.collection('dias_salas_profissionais')
          .where("dia", isEqualTo: dia).get();

      final allData = querySnapshot.docs.map((doc) {
        final dias = DiasSalasProfissionais.fromJson(doc.data());
        dias.id1 = doc.id;
        return dias;
      }).toList();
      print(allData.length);
      print('object');
      return allData;
    }  else {
      List<DiasSalasProfissionais> result = [];
      diasProfissionais.forEach((element) {
        if (element.dia!.compareTo(dia)==0){
          result.add(element);
        }
      });
      return result;
    }

  }






  Stream<DocumentSnapshot<Map<String, dynamic>>> getDiasById(String id) {
    return db.collection('dias_salas_profissionais').doc(id).snapshots();
  }

  // Future<List<DiasSalasProfissionais>> getListDiasSalas() async{
  //   final querySnapshot = await db.collection('back_dias_salas_profissionais2').get();
  //   final allData = querySnapshot.docs.map((doc) {
  //     final dias = DiasSalasProfissionais.fromJson(doc.data());
  //     dias.id1 = doc.id;
  //     return dias;
  //   }).toList();
  //   return allData;
  // }

  Future<List<DiasSalasProfissionais>> getListDiasSalasByProfissional(String id) async{
    if (diasProfissionais.length==0){
      final querySnapshot = await db.collection('dias_salas_profissionais')
          .where("id_profissional", isEqualTo: id).get();
      final allData = querySnapshot.docs.map((doc) {
        final dias = DiasSalasProfissionais.fromJson(doc.data());
        dias.id1 = doc.id;
        return dias;
      }).toList();
      return allData;
    } else {
      List<DiasSalasProfissionais> result = [];
      diasProfissionais.forEach((element) {
        if (element.idProfissional!.compareTo(id)==0){
          result.add(element);
        }
      });
      return result;
    }
  }

  // Future<void> updateIdProf(DiasSalasProfissionais diasSalasProfissionais) async {
  //     db.collection('dias_salas_profissionais').doc(diasSalasProfissionais.id.toString())
  //         .update({
  //       'id_profissional': diasSalasProfissionais.idProfissional.toString(),
  //     });
  // }


  Future<String> put2(DiasSalasProfissionais diasSalasProfissionais) async {
    String result = "";
    // var itemRef = db.collection("dias_salas_profissionais");
    // var doc = itemRef.doc().id;
    // print(doc);
    if (diasSalasProfissionais.id1 != null){
      result = diasSalasProfissionais.id1;
      db.collection('dias_salas_profissionais').doc(diasSalasProfissionais.id1)
          .set({
        // 'id': diasSalasProfissionais.id.toString(),
        'dia': diasSalasProfissionais.dia,
        'hora': diasSalasProfissionais.hora,
        'id_profissional': diasSalasProfissionais.idProfissional.toString(),
        'sala': diasSalasProfissionais.sala,
      });
    }
    return result;
  }

  Future<void> put(DiasSalasProfissionais diasSalasProfissionais) async {
    print("put DiasSalas id = ${diasSalasProfissionais.id}");
    if (diasSalasProfissionais.id == null) {
      var itemRef = db.collection("dias_salas_profissionais");
      var doc = itemRef.doc().id;
      db.collection('dias_salas_profissionais').doc(doc).set({
        'dia': diasSalasProfissionais.dia,
        'hora': diasSalasProfissionais.hora,
        'id_profissional': diasSalasProfissionais.idProfissional.toString(),
        'sala': diasSalasProfissionais.sala,
      }).then((value) => print("inseriu dias Salas = $doc"));
      diasSalasProfissionais.id1 = doc;
      diasProfissionais.add(diasSalasProfissionais);
    }else {
      db.collection('dias_salas_profissionais').doc(diasSalasProfissionais.id).set({
        // 'id': (diasSalasProfissionais.id).toString(),
        'dia': diasSalasProfissionais.dia,
        'hora': diasSalasProfissionais.hora,
        'id_profissional': diasSalasProfissionais.idProfissional,
        'sala': diasSalasProfissionais.sala,
      });
    }
  }

    void remove(String id) async {
      db.collection("dias_salas_profissionais").doc(id).delete()
          .then((value) => print("removeu dias_salas_profissionais $id"));
      diasProfissionais.removeWhere((element) => element.id1.compareTo(id)==0);
      notifyListeners();

    }

}