import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Profissional.dart';
import 'comissao_provider.dart';

class ProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;
  List<Profissional> profissionais =[];

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



  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfissionalById(String id) {
    return db.collection('profissional').doc(id).snapshots();
  }

  Future<Profissional> getProfissional(String id) async{
    Profissional profissional = Profissional();
    if (profissionais.length>0){
       profissionais.forEach((element) {
          if (element.id1.compareTo(id)==0){
            profissional = element;
          }
       });
    }
    if (profissional.nome!=null){
      return profissional;
    } 
    final querySnapshot = await db.collection('profissional').doc(id).get();
    final prof = Profissional.fromJson1(querySnapshot.data());
    prof.id1=id;
    print(prof.nome);
    return prof;
  }


  Future<List<Profissional>> getListProfissionaisComComissao(
      parentContext, List<Profissional> listProfissional, List<String> listValores) async {

    List<String> idsProfissionaisAReceber = [];
    List<Profissional> listProfissionais = [];
    await Provider.of<ComissaoProvider>(parentContext, listen: false)
        .getListIdProfissionaisAReceber().then((value) async {
        idsProfissionaisAReceber = value;
        for (int i=0; i<idsProfissionaisAReceber.length; i++) {
          final documentSnapshot = await db.collection('profissional').doc(
              idsProfissionaisAReceber[i]).get();
          if (documentSnapshot.exists){
            final Map<String, dynamic>
            doc = documentSnapshot.data() as Map<String, dynamic>;
            listProfissionais.add(Profissional
                .fromSnapshot(documentSnapshot.id, doc)
            );
          } else {
            print("retornou nulo getProfComissao");
            return null;
          }
        }
    });

    return listProfissionais;
    // if (profissionais.length==0){
    //   final querySnapshot = await db.collection('profissional')
    //       .where("status", isEqualTo: "ATIVO")
    //       // .where("status", isEqualTo: "ATIVO")
    //       .get();
    //   final allData = querySnapshot.docs.map((doc) {
    //     final prof = Profissional.fromJson(doc.data());
    //     prof.id1 = doc.id;
    //     return prof;
    //   }).toList();
    //   print("Profissional retornou alldata = ${allData.length}");
    //   return allData;
    // } else {
    //   print("Profissional retornou profissionais");
    //   return profissionais;
    // }

  }

  Future<List<Profissional>> getListProfissionais()async {
    if (profissionais.length==0){
      final querySnapshot = await db.collection('profissional')
          .where("status", isEqualTo: "ATIVO").get();
      final allData = querySnapshot.docs.map((doc) {
        final prof = Profissional.fromJson(doc.data());
        prof.id1 = doc.id;
        return prof;
      }).toList();
      print("Profissional retornou alldata = ${allData.length}");
      return allData;
    } else {
      print("Profissional retornou profissionais");
      return profissionais;
    }

  }

  // Future<List<Profissional>> getListProfissionais2()async {
  //   final querySnapshot = await db.collection('profissional_teste2').get();
  //   final allData = querySnapshot.docs.map((doc) {
  //     final prof = Profissional.fromJson(doc.data());
  //     prof.id1 = doc.id;
  //     return prof;
  //   }).toList();
  //   print("prof provider list = ${allData.length}");
  //   return allData;
  // }

   Future<List<Profissional>> getListProfissionaisAtivos()async {

    final querySnapshot = await db.collection('profissional').where("status", isEqualTo: "ATIVO").get();
    final allData = querySnapshot.docs.map((doc) {
      final prof = Profissional.fromJson(doc.data());
      prof.id1 = doc.id;
      return prof;
    }).toList();
    return allData;
  }

  Future<Profissional?> getProfById(String id)async{
    Profissional profissional = Profissional();
    print("id $id");
    if (profissionais.length>0){
       profissionais.forEach((element) {
          if (element.id1.compareTo(id)==0){
            profissional = element;
          }
       });
    }
    if (profissional!=null){
      return profissional;
    }
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
    print("getDataUid");
    print(uid.toString());
    return uid.toString();
  }

  // Future<void> put3(Profissional profissional, String id) async {
  //
  //   await db.collection('profissional_teste2').doc(id).set({
  //     'id': profissional.id,
  //     'nome_profissional': profissional.nome,
  //     'cpf': profissional.cpf,
  //     'endereco': profissional.endereco,
  //     'data_nascimento': profissional.dataNascimento,
  //     'numero': profissional.numero,
  //     'telefone': profissional.telefone,
  //     'status': profissional.status,
  //     'email': profissional.email,
  //     'senha': profissional.senha,
  //   });
  //   // return doc;
  // }


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
    // String uid = getDataUid();
    // print("put sem int");
    // if (profissional.id == null) {
      // int id = await getCount();
      // String uid = getDataUid();
    var itemRef = db.collection("profissional");
    var doc = itemRef.doc().id;
      db.collection('profissional').doc(doc).set({
        'id': doc,
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'data_nascimento': profissional.dataNascimento,
        'endereco': profissional.endereco,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      }).then((value) => print("inseriu put profissional $doc "));
      // notifyListeners();
    // }else {
    //
    //   db.collection('profissional').doc(profissional.id.toString()).set({
    //     'id': profissional.id,
    //     'nome_profissional': profissional.nome,
    //     'cpf': profissional.cpf,
    //     'endereco': profissional.endereco,
    //     'data_nascimento': profissional.dataNascimento,
    //     'numero': profissional.numero,
    //     'telefone': profissional.telefone,
    //     'status': profissional.status,
    //     'email': profissional.email,
    //     'senha': profissional.senha,
    //   });
    // }
  }

  Future<String> putId(Profissional profissional) async {
    String uid = getDataUid();
    print(" profissional");
    print("uid = $uid");
    if (profissional.id == null) {
      // int id = await getCount();
      //     profissional.id1 = doc;
     db.collection('profissional').doc(uid).set({
        'id': uid,
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'data_nascimento': profissional.dataNascimento,
        'endereco': profissional.endereco,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
        'email': profissional.email,
        'senha': profissional.senha,
      }).then((value) => print("inseriu profissional $uid"));
      return uid;
      // notifyListeners();
    }else {
      db.collection('profissional').doc(profissional.id1).set({
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
      return profissional.id1;
    }
  }

}