import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/Profissional.dart';

class ProfissionalProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('profissionais')
        .get();
    if (_myDoc.docs.isEmpty){
      return 0;
    } else {
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      return _myDocCount.length;
    }
  }

  int count() {
    int count = int.parse(getCount().toString());
    return count;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfissionalById(String id) {
    return db.collection('profissionais').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListProfissionais() {
    return db.collection('profissionais').snapshots();
  }


  Future<void> put(Profissional profissional) async {
    if (profissional.id == null) {
      int id = await getCount();
      db.collection('profissionais').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'data_nascimento': profissional.dataNascimento,
        'endereco': profissional.endereco,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
      });
    }else {
      db.collection('profissionais').doc(profissional.id.toString()).set({
        'nome_profissional': profissional.nome,
        'cpf': profissional.cpf,
        'endereco': profissional.endereco,
        'data_nascimento': profissional.dataNascimento,
        'numero': profissional.numero,
        'telefone': profissional.telefone,
        'status': profissional.status,
      });
    }
  }
}