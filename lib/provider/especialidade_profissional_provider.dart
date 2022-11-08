import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/especialidades_profissional.dart';

import '../model/Especialidade.dart';
import 'especialidade_provider.dart';

class EspecialidadeProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('especialidades_profissional')
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    if (_myDocCount.isEmpty){
      return 0;
    }
    return _myDocCount.length;
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEspecialidadeProfissionalById(String id) {
    return db.collection('especialidades_profissional').doc(id).snapshots();
  }

  // Stream<QuerySnapshot> getListEspecialidades() {
  //   return db.collection('especialidades_profissional').snapshots();
  // }

  Future<List<Especialidade>> getListById(int id) async {
    List<Especialidade> list = [];
    List<EspecialidadeProfissional> listEsoProf = [];
    QuerySnapshot querySnapshot = await db.collection('especialidades_profissional')
        .where('id_profissional', isEqualTo: id.toString()).get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element) {
      print(element);
      print("element)");

      EspecialidadeProfissional especialidade = EspecialidadeProfissional.fromJson1(element);
      listEsoProf.add(especialidade);
    });

    print("ListEsp Prof provider ${listEsoProf.length}");
    listEsoProf.forEach((element) async{
      print("ListEsp Prof provider ${element.idEspecialidade}");

      DocumentSnapshot documentSnapshot2 = await
      db.collection('especialidades').doc(element.idEspecialidade.toString()).get();
      if (documentSnapshot2.exists){
        print("exist");
        final Map<String, dynamic>
        doc = documentSnapshot2.data() as Map<String, dynamic>;
        print("qaaaaaaa");
        Especialidade esp = Especialidade.fromSnapshot(element.idEspecialidade!,doc);
        print(esp.descricao);
        list.add(esp);
      } else {
        print("aamsdlasm");
      }
      // Provider.of<EspecialidadeProvider>(context, listen:false)
      //       .getEspecialidadeByIid2(element.idEspecialidade).then((value) => list.add(value));
    });

    print("list = ${list.length}");

    return list;

  }

  // EspecialidadeProfissional getEspByDesc(String desc, List<EspecialidadeProfissional> listEsp){
  //    // EspecialidadeProfissional EspecialidadeProfissional = EspecialidadeProfissional(id: 0, codigoEspecialidade: "0");
  //
  //   listEsp.forEach((element) {
  //     if (element.descricao.compareTo(desc)==0){
  //       especialidade = element;
  //     }
  //   });
  //   return especialidade;
  // }

  Future<EspecialidadeProfissional> getEspecialidadeProfissionalByIid2(int id) async {
    print("id $id");
    DocumentSnapshot documentSnapshot = await
    db.collection('especialidades_profissional').doc(id.toString()).get();
    if (documentSnapshot.exists){
      final Map<String, dynamic>
      doc = documentSnapshot.data() as Map<String, dynamic>;
      print("qaaaaaaa");
      return EspecialidadeProfissional.fromSnapshot(id,doc);
    } else {
      return EspecialidadeProfissional(
          idEspecialidade: "0",
          codigoEspecialidade: "");
    }
  }

  Future<List<String>> getIdEspecialidadeByIdProfissional(String id) async {
    print("iiiidddd = $id");
    List<String> list = [];
    QuerySnapshot querySnapshot = await db.collection('especialidades_profissional')
        .where('id_profissional', isEqualTo: id)
        .get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData.length);
    allData.forEach((element) {
      print("element");

      print(element);

      EspecialidadeProfissional especialidade = EspecialidadeProfissional.fromJson1(element);
      print("asa");
      print("idesp = ${especialidade.idEspecialidade}");
      list.add(especialidade.idEspecialidade.toString());
    });

    print("listtt = ${list.length}");
    return list;
  }

  Future<List<EspecialidadeProfissional>> getListEspecialidades1(String id) async {
    List<EspecialidadeProfissional> _list = [];
    // Get docs from collection reference

    QuerySnapshot querySnapshot = await db.collection('especialidades_profissional')
        // .where(field)
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element) {
      print(element);
      print("element)");

      EspecialidadeProfissional especialidade = EspecialidadeProfissional.fromJson1(element);
      _list.add(especialidade);
    });
    print("getListEspecialidades1 = _list.length ${_list.length}");
    return _list;
  }

  Future<List<EspecialidadeProfissional>> getListEspecialidades() async {
    final querySnapshot = await db.collection('especialidades_profissional').get();
    final allData = querySnapshot.docs.map((doc) {
      final espProf = EspecialidadeProfissional.fromJson(doc.data());
      espProf.id1 = doc.id;
      return espProf;
    }).toList();
    print("EspProfProvider getListEspecialidades = _list.length ${allData.length}");
    return allData;
  }

  Future<void> put2(EspecialidadeProfissional especialidade) async {
    if (especialidade.id1 != null) {
      db.collection('back_especialidades_profissional').doc((especialidade.id1).toString()).set({
        'id': especialidade.id,
        'id_especialidade': especialidade.idEspecialidade.toString(),
        'id_profissional': especialidade.idProfissional.toString(),
        'codigo_especialidade': especialidade.codigoEspecialidade,
      });
    }
  }

  Future<void> put(EspecialidadeProfissional especialidade) async {
    if (especialidade.id == null) {
      int id = await getCount();
      print("id $id put EspecialidadeProfissional ${especialidade.codigoEspecialidade}");
      db.collection('especialidades_profissional').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'id_especialidade': especialidade.idEspecialidade.toString(),
        'id_profissional': especialidade.idProfissional.toString(),
        'codigo_especialidade': especialidade.codigoEspecialidade,
      });
    }else {
      db.collection('especialidades_profissional').doc(especialidade.idEspecialidade.toString()).set({
        'id': especialidade.id,
        'id_especialidade': especialidade.idEspecialidade.toString(),
        'id_profissional': especialidade.idProfissional.toString(),
        'codigo_especialidade': especialidade.codigoEspecialidade,
      });
    }
  }
}