import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psico_sis/model/Especialidade.dart';

class EspecialidadeProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('especialidades')
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEspecialidadeById(String id) {
    return db.collection('especialidades').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListEspecialidades() {
    return db.collection('especialidades').snapshots();
  }

  Especialidade getEspByDesc(String desc, List<Especialidade> listEsp){
    Especialidade especialidade = Especialidade(idEspecialidade: "", descricao: "");
    listEsp.forEach((element) {
      if (element.descricao!.compareTo(desc)==0){
        especialidade = element;
      }
    });
    return especialidade;
  }

  Future<Especialidade> getEspecialidadeByIid2(String id) async {
    print("id $id");
    DocumentSnapshot documentSnapshot = await
    db.collection('especialidades').doc(id.toString()).get();
    if (documentSnapshot.exists){
      final Map<String, dynamic>
      doc = documentSnapshot.data() as Map<String, dynamic>;
      print("qaaaaaaa");
      return Especialidade.fromSnapshot(id,doc);
    } else {
      return Especialidade(
          idEspecialidade: "0",
          descricao: "");
    }
  }
  //Future<List<Usuario>> getUsuarios() async {
  //     final querySnapshot = await db.collection('usuarios').get();
  //     final login = querySnapshot.docs.map((e) {
  //       final user = Usuario.fromJson(e.data());
  //       user.id1 = e.id;
  //       return user;
  //     }).toList();
  //     return login;
  //   }
  Future<List<Especialidade>> getListEspecialidades1() async {
    List<Especialidade> _list = [];
    final querySnapshot = await db.collection('especialidades').get();
    final allData = querySnapshot.docs.map((e) {
      final json = e.data();
      final espec = Especialidade.fromJson(e.data());
      espec.id1 = e.id;
      return espec;
    }).toList();
    print("_list.l especialidade ${_list.length}");
    return allData;
  }
  //método antigo
  // Future<List<Especialidade>> getListEspecialidades1() async {
  //   List<Especialidade> _list = [];
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await db.collection('especialidades').get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   allData.forEach((element) {
  //     Especialidade especialidade = Especialidade.fromJson1(element);
  //
  //     _list.add(especialidade);
  //   });
  //   print("_list.l especialidade ${_list.length}");
  //   return _list;
  // }

  Future<void> put(Especialidade especialidade) async {
    if (especialidade.idEspecialidade == null) {
      int id = await getCount();
      print("id $id put Especialidade");
      db.collection('especialidades').doc((id + 1).toString()).set({
        'id': id+1,
        'descricao': especialidade.descricao,
      });
    }else {
      db.collection('especialidades').doc(especialidade.idEspecialidade.toString()).set({
        'descricao': especialidade.descricao,
      });
    }
  }


  Future<void> put2(Especialidade especialidade) async {
    if (especialidade.id1 == null) {
      // int id = await getCount();
      // print("id $id put Especialidade");
      db.collection('back_especialidades').doc().set({
        // 'id': document.referrer,
        'descricao': especialidade.descricao,
      }).then((value) => print('deu certo'));
    }else {
      db.collection('back_especialidades').doc(especialidade.id1.toString()).set({
        'descricao': especialidade.descricao,
      });
    }
  }

  void remove(String id) async {
    db.collection("especialidades").doc(id).delete().then((value) => print('removeu com sucesso'));
    // notifyListeners();
  }
}