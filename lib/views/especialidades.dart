import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/Especialidade.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';

class Especialidades extends StatefulWidget {
  const Especialidades({Key? key}) : super(key: key);

  @override
  State<Especialidades> createState() => _EspecialidadesState();
}

class _EspecialidadesState extends State<Especialidades> {

  late List<Especialidade> _le = [];
  Future<List<Especialidade>> ReadJsonData() async{
    final jsondata = await rootBundle.loadString('jsonfile/especialidades_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Especialidade.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: ReadJsonData(),
        builder: (context, data){
          if (data.hasError) {
            print("erro ao carregar o json");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            _le = data.data as List<Especialidade>;
            for(var item in _le)
              print(item.descricao);
          }
        return SafeArea(
            child: 	Scaffold(
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
                                padding: const EdgeInsets.only(top: 16, left: 16,right: 16),
                                child: Column(
                                  children: [
                                    for (var item in _le)
                                      Card(
                                        elevation: 8,
                                        child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.descricao.toString()),
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
                        label: "Cadastrar Especialidade",
                        onTap: () {
                          // Navigator.pushReplacementNamed(context, "/cadastro_paciente");
                        },
                      ),
                    ],
                  ),
                )));
    });
  }
}
