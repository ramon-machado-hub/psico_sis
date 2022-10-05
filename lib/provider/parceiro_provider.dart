import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/Parceiro.dart';

class ParceiroProvider  with ChangeNotifier{

  var db = FirebaseFirestore.instance;

  Future<int> getCount() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('parceiros')
        .get();

    if(_myDoc.docs.isEmpty){
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getParceiroById(String id) {
    return db.collection('parceiros').doc(id).snapshots();
  }

  Future<Parceiro?> getParceiroById2(String id, List<Parceiro> list) async{
    Parceiro? result;
    list.forEach((element) {
      // if (element.id?.compareTo(int.parse)==0){
      if (element.id == int.parse(id)){
        result = element;
      }
    });
    return result;
  }

  int getIdByRazao(String razao, List<Parceiro> list){
    int result =0;
    list.forEach((element) {
      if (element.razaoSocial?.compareTo(razao)==0){
        result = element.id!;
      }
    });
    print("result $result");
    return result;
  }


  Future<List<Parceiro>> getListParceiros() async {
    List<Parceiro> _list = [];
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await db.collection('parceiros').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element) {
      // print(element);
      // print(element['id']);
      Parceiro parceiro = Parceiro.fromJson1(element);
      _list.add(parceiro);
    });
    print("_list.l ${_list.length}");
    return _list;
  }

  // Stream<QuerySnapshot> getListParceiros() {
  //   return db.collection('parceiros').snapshots();
  // }

  Future<void> put(Parceiro parceiro) async {
    print("put ${parceiro.id}");
    if (parceiro.id == null) {
      int id = await getCount();
      db.collection('parceiros').doc((id + 1).toString()).set({
        'id': (id + 1).toString(),
        'razaoSocial': parceiro.razaoSocial,
        'cnpj': parceiro.cnpj,
        'endereco': parceiro.endereco,
        'telefone': parceiro.telefone,
        'email': parceiro.email,
        'desconto': parceiro.desconto,
        'numero': parceiro.numero,
        'status': parceiro.status,
      });
    }else {
      db.collection('parceiros').doc("${parceiro.id}").set({
        'id': parceiro.id.toString(),
        'razaoSocial': parceiro.razaoSocial,
        'cnpj': parceiro.cnpj,
        'endereco': parceiro.endereco,
        'telefone': parceiro.telefone,
        'email': parceiro.email,
        'desconto': parceiro.desconto,
        'numero': parceiro.numero,
        'status': parceiro.status,
      });
    }
  }


}