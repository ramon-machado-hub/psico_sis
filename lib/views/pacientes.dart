import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/themes/app_colors.dart';

import '../daows/UsuarioWS.dart';
import '../model/Paciente.dart';
import '../model/Usuario.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({Key? key}) : super(key: key);

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  late List<Paciente> _lp = [];

  Future<List<Paciente>> ReadJsonData() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/pacientes_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    // list.sort((a, b) => a.toString().compareTo(b.toString()));
    // list.
    return list.map((e) => Paciente.fromJson(e)).toList();
  }

  String dropdownValue = 'Consulta Avaliativa';
  bool checkParceiro = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: ReadJsonData(),
        builder: (context, data) {
          if (data.hasError) {
            print("erro ao carregar o json");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            _lp = data.data as List<Paciente>;
            _lp.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
            for (var item in _lp) print(item.nome);
          }
          return SafeArea(
              child: Scaffold(
                  appBar: const PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: AppBarWidget(),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                      radius: 2.0,
                      colors: [
                        AppColors.shape,
                        AppColors.primaryColor,
                      ],
                    )),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Container(
                              width: size.width * 0.45,
                              height: size.height * 0.7,
                              decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: AppColors.line,
                                      width: 1,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.shape),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                                  child: Column(
                                    children: [
                                      for (var item in _lp)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            trailing:  InkWell(
                                                onTap: (){},
                                                child: const Icon(Icons.search_rounded)),
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item.nome.toString()),
                                                Text("Fone: ${item.telefone}", style: AppTextStyles.labelBold16,),
                                              ],
                                            ),

                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ButtonWidget(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                          label: "Cadastrar Paciente",
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, "/cadastro_paciente");
                          },
                        ),
                      ],
                    ),
                  )));
        });
  }
}
