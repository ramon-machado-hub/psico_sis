import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/dias_profissional.dart';

class DiasProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<DiasProfissional> diasProfissional = [];

  Future<List<DiasProfissional>> getListDiasProfissional() async {
    if (diasProfissional.length==0){
      final querySnapshot = await db.collection('dias_profissionais')
          .get();
      final allData = querySnapshot.docs.map((doc) {
        final dia = DiasProfissional.fromJson(doc.data());
        dia.id1 = doc.id;
        return dia;
      } ).toList();
      diasProfissional = allData;
      print("Dias Profissional return alldata");
      return allData;
    } else {
      print("Dias Profissional return diasProfissional");
      return diasProfissional;
    }
  }

  Future<List<DiasProfissional>> getDiasProfissionalByIdProfissional(String id) async {
    List<DiasProfissional> result = [];
    print("getDiasProfissionalByIdProfissional = ${diasProfissional.length}");
    if (diasProfissional.length>0){
      diasProfissional.forEach((element) {
        if(element.idProfissional!.compareTo(id)==0){
             result.add(element);
        }
      });
    }
    if (result.length==0){
      final querySnapshot = await db.collection('dias_profissionais')
          .where("id_profissional", isEqualTo: id)
          .get();
      final allData = querySnapshot.docs.map((doc) {
        final dia = DiasProfissional.fromJson(doc.data());
        dia.id1 = doc.id;
        return dia;
      } ).toList();
      return allData;
    }else {
      return result;
    }
  }



  Future<List<DiasProfissional>> getDiasProfissionalByIdProfDia(String id, String dia) async {

    // if (diasProfissional.length==0){
    final querySnapshot = await db.collection('dias_profissionais')
        .where("id_profissional", isEqualTo: id)
        .where("dia", isEqualTo: dia)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      final dia = DiasProfissional.fromJson(doc.data());
      dia.id1 = doc.id;
      return dia;
    } ).toList();
    // diasProfissional = allData;
    // print("Dias Profissional return alldata");
    return allData;
    // } else {
    //   print("Dias Profissional return diasProfissional");
    //   return diasProfissional;
    // }

  }


  Future<void> put(DiasProfissional dias) async{
    var itemRef = db.collection("dias_profissionais");
    var doc = itemRef.doc().id;
    db.collection('dias_profissionais').doc(doc).set({
      'id_profissional': dias.idProfissional,
      'dia': dias.dia,
    }).then((value) => print("inseriu DiasProfissionais = $doc"));
    dias.id1 = doc;
    diasProfissional.add(dias);
  }

  void remove(String id) async {
    db.collection("dias_profissionais").doc(id).delete()
        .then((value) => print("removeu dias_profissionais $id"));
    diasProfissional.removeWhere((element) => element.id1.compareTo(id)==0);
    notifyListeners();
  }
}