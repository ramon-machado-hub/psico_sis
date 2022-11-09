import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/Profissional.dart';

class ProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<Profissional> listProfissional =[];

  void setListProfissional(List<Profissional>list){
    this.listProfissional = list;
  }

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('profissional')
        .get();
    if (_myDoc.docs.isEmpty){
      return 0;
    } else {
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      return _myDocCount.length;
    }
  }

  Future<bool> existByCPF(String cpf) async {
    var documents = await db.collection('profissional').where("cpf", isEqualTo: cpf).get();
    if (documents.size==0){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> existByEmail(String email) async {
    var documents = await db.collection('profissional').where("email", isEqualTo: email).get();
    var documents2 = await db.collection('usuarios').where("emailUsuario", isEqualTo: email).get();
    if ((documents.size==0)&&(documents2.size==0)){
      return false;
    }else{
      return true;
    }
  }


  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfissionalById(String id) {
    return db.collection('profissional').doc(id).snapshots();
  }


  Future<List<Profissional>> getListProfissionais()async {
    final querySnapshot = await db.collection('profissional_teste2').get();
    final allData = querySnapshot.docs.map((doc) {
      final prof = Profissional.fromJson(doc.data());
      prof.id1 = doc.id;
      return prof;
    }).toList();
    print("prof provider list = ${allData.length}");
    return allData;
  }

  Future<List<Profissional>> getListProfissionais2()async {
    final querySnapshot = await db.collection('profissional_teste2').get();
    final allData = querySnapshot.docs.map((doc) {
      final prof = Profissional.fromJson(doc.data());
      prof.id1 = doc.id;
      return prof;
    }).toList();
    print("prof provider list = ${allData.length}");
    return allData;
  }

    Future<List<Profissional>> getListProfissionaisAtivos()async {

    List<Profissional> list = [];
    var documents = await db.collection('profissional').where("status", isEqualTo: "ATIVO").get();
    for(int i =0; i<documents.size; i++){
        list.add(Profissional(
          id: documents.docs[i]['id'],
          nome: documents.docs[i]['nome_profissional'],
          email: documents.docs[i]['email'],
          endereco: documents.docs[i]['endereco'],
          telefone: documents.docs[i]['telefone'],
          status: documents.docs[i]['status'],
          numero: documents.docs[i]['numero'],
          cpf: documents.docs[i]['cpf'],
          dataNascimento: documents.docs[i]['data_nascimento'],
        ));
    }
    return list;
  }

  Future<Profissional?> getProfById(String id)async{
    print("id $id");

    DocumentSnapshot documentSnapshot = await
    db.collection('profissional').doc(id).get();
    // Profissional? profisisonal;
    if (documentSnapshot.exists){
      final Map<String, dynamic>
      doc = documentSnapshot.data() as Map<String, dynamic>;
      return Profissional.fromSnapshot(documentSnapshot.id, doc);
    } else {
      print("retornou nulo getProfById");
      return null;
    }
  }


  String getDataUid()  {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? uid = user?.uid.toString();
    print(uid.toString());
    return uid.toString();
  }

  Future<void> put3(Profissional profissional, String id) async {
    // String uid = getDataUid();
    // print("put 3");
    // var itemRef = db.collection("profissional_teste");
    // var doc = itemRef.doc().id;
    await db.collection('profissional_teste2').doc(id).set({
      'id': profissional.id,
      'nome_profissional': profissional.nome,
      'cpf': profissional.cpf,
      'endereco': profissional.endereco,
      'data_nascimento': profissional.dataNascimento,
      'numero': profissional.numero,
      'telefone': profissional.telefone,
      'status': profissional.status,
      'email': profissional.email,
      'senha': profissional.senha,
    });
    // return doc;
  }


  Future<void> put2(Profissional profissional) async {
    print("put 2");
      db.collection('profissional').doc(profissional.id1.toString()).set({
        'id': profissional.id,
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'endereco': profissional.endereco,
        'data_nascimento': profissional.dataNascimento,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      });
  }

  Future<int?> put(Profissional profissional) async {
    String uid = getDataUid();
    print("put sem int");
    if (profissional.id == null) {
      int id = await getCount();
      // String uid = getDataUid();
      db.collection('profissional').doc((id+1).toString()).set({
        'id': (id + 1).toString(),
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'data_nascimento': profissional.dataNascimento,
        'endereco': profissional.endereco,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      });
      // notifyListeners();
    }else {

      db.collection('profissional').doc(profissional.id.toString()).set({
        'id': profissional.id,
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'endereco': profissional.endereco,
        'data_nascimento': profissional.dataNascimento,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      });
    }
  }

  Future<int> putInt(Profissional profissional) async {
    String uid = getDataUid();
    print(" profissional");
    if (profissional.id == null) {
      int id = await getCount();
     db.collection('profissional').doc((id+1).toString()).set({
        'id': (id + 1).toString(),
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'data_nascimento': profissional.dataNascimento,
        'endereco': profissional.endereco,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      });
      return id+1;
      // notifyListeners();
    }else {
      db.collection('profissional').doc(profissional.id.toString()).set({
        'id': profissional.id,
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'endereco': profissional.endereco,
        'data_nascimento': profissional.dataNascimento,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      });
      return int.parse(profissional.id!);
    }
  }

}