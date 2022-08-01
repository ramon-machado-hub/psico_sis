import 'package:flutter/material.dart';

import 'list_hours_widget.dart';

class Dialogs {
  static Future<void> showMyDialog(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Title"),
          children: <Widget>[
            SimpleDialogOption(child: Text("Option1"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option2"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option3"), onPressed: () {})
          ],
        );
      },
    );
  }

  static Future<void> AlertDialogProfissional(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Especialidade"),
          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {}
            ),
            SimpleDialogOption(child: Text("Option2"), onPressed: () {}),
            SimpleDialogOption(child: Text("Option3"), onPressed: () {})
          ],
        );
      },
    );
  }

  static Future<void> AlertHorasTrabalhadas(parentContext, String dia) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Selecione os horários ofertados na "+dia),
              Row(
               children: ListHousColumn(),
              )
            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("Salvar"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("Cancelar"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

  static Future<void> AlertConfirmSistema(parentContext, String descricao) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("DESEJA REALMENTE SALVAR O SISTEMA ABAIXO"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(descricao),
              ),
            ],
          ),

          actions: <Widget>[
            SimpleDialogOption(
                child: Text("SIM"),
                onPressed: () {

                  Navigator.pop(context);
                }
            ),
            SimpleDialogOption(child: Text("NÃO"), onPressed: () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

}

List <Widget> ListHousColumn() {
  List <Widget> list = [];
  bool selected = false;
  String hour = "";
  for (int i = 8; i < 20; i++) {
    if (i<10){
      hour = "0"+i.toString()+":00";
    } else {
      hour = i.toString()+":00";
    }
    list.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListHoursWidget(hour: hour,),

      ),
    ));
  }
  return list;
}