import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/especialidades_profissional.dart';
import '../model/Especialidade.dart';

class EspecialidadeProfissionalProvider  with ChangeNotifier{

  List<EspecialidadeProfissional> especialidadesProfissional = [];
  var db = FirebaseFirestore.instance;


  Stream<DocumentSnapshot<Map<String, dynamic>>> getEspecialidadeProfissionalById(String id) {
    return db.collection('especialidades_profissional').doc(id).snapshots();
  }


  // Future<List<Especialidade>> getListById(int id) async {
  //   List<Especialidade> list = [];
  //   List<EspecialidadeProfissional> listEsoProf = [];
  //   QuerySnapshot querySnapshot = await db.collection('especialidades_profissional')
  //       .where('id_profissional', isEqualTo: id.toString()).get();
  //
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   allData.forEach((element) {
  //     print(element);
  //     print("element)");
  //
  //     EspecialidadeProfissional especialidade = EspecialidadeProfissional.fromJson1(element);
  //     listEsoProf.add(especialidade);
  //   });
  //
  //   print("ListEsp Prof provider ${listEsoProf.length}");
  //   listEsoProf.forEach((element) async{
  //     print("ListEsp Prof provider ${element.idEspecialidade}");
  //
  //     DocumentSnapshot documentSnapshot2 = await
  //     db.collection('especialidades').doc(element.idEspecialidade.toString()).get();
  //     if (documentSnapshot2.exists){
  //       print("exist");
  //       final Map<String, dynamic>
  //       doc = documentSnapshot2.data() as Map<String, dynamic>;
  //       print("qaaaaaaa");
  //       Especialidade esp = Especialidade.fromSnapshot(element.idEspecialidade!,doc);
  //       print(esp.descricao);
  //       list.add(esp);
  //     } else {
  //       print("aamsdlasm");
  //     }
  //     // Provider.of<EspecialidadeProvider>(context, listen:false)
  //     //       .getEspecialidadeByIid2(element.idEspecialidade).then((value) => list.add(value));
  //   });
  //
  //   print("list = ${list.length}");
  //
  //   return list;
  //
  // }



  // Future<EspecialidadeProfissional> getEspecialidadeProfissionalByIid2(String id) async {
  //   print("id $id");
  //   DocumentSnapshot documentSnapshot = await
  //   db.collection('especialidades_profissional').doc(id.toString()).get();
  //   if (documentSnapshot.exists){
  //     final Map<String, dynamic>
  //     doc = documentSnapshot.data() as Map<String, dynamic>;
  //     print("qaaaaaaa");
  //     return EspecialidadeProfissional.fromSnapshot(id,doc);
  //   } else {
  //     return EspecialidadeProfissional(
  //         idEspecialidade: "0",
  //         codigoEspecialidade: "");
  //   }
  // }

  Future<List<String>> getEspecialidadeProfissional(String id) async {
    List<String> list = [];
    if (especialidadesProfissional.length>0){
      especialidadesProfissional.forEach((element) {
        if (element.idProfissional!.compareTo(id)==0){
          list.add(element.idEspecialidade!);

        }
      });
      return getDescEspProf(list);
    }
    final querySnapshot = await db.collection('especialidades_profissional')
    .where("id_profissional", isEqualTo: id)
        .get().then((value) {
      final allData = value.docs.map((doc) async {
        final esp = EspecialidadeProfissional.fromJson(doc.data());
        esp.id1 = doc.id;
        list.add(esp.idEspecialidade!);
      }).toList();
    });
    return getDescEspProf(list);
  }

  Future<List<String>> getDescEspProf(List<String> idList)async{
    List<String> list = [];
    for (int i =0; i<idList.length; i++){
      final documentSnapshot = await db.collection('especialidades')
          .doc(idList[i]).get().then((value) {
              if (value.exists){
                final Map<String, dynamic>
                doc = value.data() as Map<String, dynamic>;
                final esp = Especialidade.fromSnapshot(value.id, doc);
                list.add(esp.descricao!);
              }else{
                print('não possui elementos especialidades EspProf');
              }
      });
    }
    // print("return getDescEspProf ${list.length}");
    return list;
  }

  // Future<List<String>> getIdEspecialidadeByIdProfissional(String id) async {
  //   print("iiiidddd = $id");
  //   List<String> list = [];
  //   QuerySnapshot querySnapshot = await db.collection('especialidades_profissional')
  //       .where('id_profissional', isEqualTo: id)
  //       .get();
  //
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData.length);
  //   allData.forEach((element) {
  //     print("element");
  //
  //     print(element);
  //
  //     EspecialidadeProfissional especialidade = EspecialidadeProfissional.fromJson1(element);
  //     print("asa");
  //     print("idesp = ${especialidade.idEspecialidade}");
  //     list.add(especialidade.idEspecialidade.toString());
  //   });
  //
  //   print("listtt = ${list.length}");
  //   return list;
  // }

  // Future<List<EspecialidadeProfissional>> getListEspecialidades1(String id) async {
  //   List<EspecialidadeProfissional> _list = [];
  //   // Get docs from collection reference
  //
  //   QuerySnapshot querySnapshot = await db.collection('especialidades_profissional')
  //       // .where(field)
  //       .get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   allData.forEach((element) {
  //     print(element);
  //     print("element)");
  //
  //     EspecialidadeProfissional especialidade = EspecialidadeProfissional.fromJson1(element);
  //     _list.add(especialidade);
  //   });
  //   print("getListEspecialidades1 = _list.length ${_list.length}");
  //   return _list;
  // }

  // Future<void> updateIdProf(EspecialidadeProfissional especialidadeProfissional) async {
  //   db.collection('especialidades_profissional').doc(especialidadeProfissional.id.toString())
  //       .update({
  //     'id_profissional': especialidadeProfissional.idProfissional.toString(),
  //   });
  // }

  Future<List<EspecialidadeProfissional>> getListEspecialidades() async {
    if(especialidadesProfissional.length==0){
      final querySnapshot = await db.collection('especialidades_profissional')
          .snapshots().listen((event) {
           especialidadesProfissional.clear();
           for (var doc in event.docs){
             final data = doc.data();
             final esp = EspecialidadeProfissional.fromJson(data);
             esp.id1 = doc.id;
             especialidadesProfissional.add(esp);
           }
      });
      print("EspecProf retornou allData = ${especialidadesProfissional.length}");

      return especialidadesProfissional;

      // final querySnapshot = await db.collection('especialidades_profissional').get();
      // final allData = querySnapshot.docs.map((doc) {
      //   final espProf = EspecialidadeProfissional.fromJson(doc.data());
      //   // print('id = ${espProf.idProfissional}');
      //   espProf.id1 = doc.id;
      //   return espProf;
      // }).toList();
      // print("EspecialidadeProfissional retornou alldata ${allData.length}");
      // especialidadesProfissional = allData;
      // return allData;
    } else {
      print("EspecialidadeProfissional retornou EspecialidadesProfissional "
          "${especialidadesProfissional.length}");
      return especialidadesProfissional;
    }

  }

  // Future<List<EspecialidadeProfissional>> getListEspecialidade22() async {
  //   final querySnapshot = await db.collection('especialidades_profissional2').get();
  //   final allData = querySnapshot.docs.map((doc) {
  //     final espProf = EspecialidadeProfissional.fromJson(doc.data());
  //     print(espProf.idProfissional);
  //     espProf.id1 = doc.id;
  //     return espProf;
  //   }).toList();
  //   print("backEspProfProvider getListEspecialidades = _list.length ${allData.length}");
  //   return allData;
  // }

  // Future<String> put2(EspecialidadeProfissional especialidade) async {
  //   String result = "";
  //   if (especialidade.id1 != null) {
  //     // var itemRef = db.collection("especialidades_profissional");
  //     // var doc = itemRef.doc().id;
  //     db.collection('especialidades_profissional').doc(especialidade.id1).set({
  //       // 'id': especialidade.id.toString(),
  //       'id_especialidade': especialidade.idEspecialidade.toString(),
  //       'id_profissional': especialidade.idProfissional.toString(),
  //       'codigo_especialidade': especialidade.codigoEspecialidade,
  //     });
  //     result = especialidade.id1;
  //   } else {
  //     print('bugou');
  //   }
  //   // especialidade.id1 = doc;
  //   // result = doc;
  //   // }else {
  //   //   db.collection('especialidades_profissional').doc(especialidade.id1).set({
  //   //     'id': especialidade.id.toString(),
  //   //     'id_especialidade': especialidade.idEspecialidade.toString(),
  //   //     'id_profissional': especialidade.idProfissional.toString(),
  //   //     'codigo_especialidade': especialidade.codigoEspecialidade,
  //   //   });
  //   // }
  //   return result;
  // }

  Future<void> put(EspecialidadeProfissional especialidade) async {
    var itemRef = db.collection("especialidades_profissional");
    var doc = itemRef.doc().id;
    if (especialidade.id == null) {

      // int id = await getCount();
      print("id $doc put EspecialidadeProfissional ${especialidade.codigoEspecialidade}");
      db.collection('especialidades_profissional').doc(doc).set({
        // 'id': doc,
        'id_especialidade': especialidade.idEspecialidade.toString(),
        'id_profissional': especialidade.idProfissional.toString(),
        'codigo_especialidade': especialidade.codigoEspecialidade,
      }).then((value) => print("inseriu Especialidade = $doc"));
      especialidade.id1 = doc;
      especialidadesProfissional.add(especialidade);
    }else {
      db.collection('especialidades_profissional').doc(especialidade.id).set({
        // 'id': especialidade.id,
        'id_especialidade': especialidade.idEspecialidade.toString(),
        'id_profissional': especialidade.idProfissional.toString(),
        'codigo_especialidade': especialidade.codigoEspecialidade,
      });
    }
  }
}