import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiasProvider  with ChangeNotifier{
  var db = FirebaseFirestore.instance;


  Stream<DocumentSnapshot<Map<String, dynamic>>> getDiasById(String id) {
    return db.collection('dias').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getListDias() {
    return db.collection('dias').snapshots();
  }

}