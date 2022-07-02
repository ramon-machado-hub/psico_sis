import 'package:flutter/material.dart';

class AlertDialogConsulta extends StatelessWidget {
  const AlertDialogConsulta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: const [
          Text("Reagendar"),
          Text("Desmarcar"),
        ],
      ),
    );
  }
}
