import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/agendamento.dart';

class AgendamentoProvider with ChangeNotifier{
  var db = FirebaseFirestore.instance;

  Future<List<Agendamento>> getListAgendamentos() async {
    final querySnapshot = await db.collection('agendamentos').get();
    final allData = querySnapshot.docs.map((e) {
      final agendamento = Agendamento.fromJson(e.data());
      agendamento.id1 = e.id;
      return agendamento;
    }).toList();
    return allData;
  }


  Future<void> put(Agendamento agendamento) async {
    var itemRef = db.collection("agendamentos");
    var doc = itemRef.doc().id;
    db.collection('agendamentos').doc(doc).set({
      'desc_servico': agendamento.descServico,
      'qtd_sessoes': agendamento.qtdSessoes,
      'valor_agendamento': agendamento.valorAgendamento,
      'id_paciente': agendamento.idPaciente,
      'id_profissional': agendamento.idProfissional,
      'status_agendamento': agendamento.statusPagamento,
      'forma_pagamento': agendamento.formaPagamento,
    }).then((value) => print("inseriu agendamento $doc"));
  }
}