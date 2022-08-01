import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';

import '../model/Parceiro.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_widget.dart';

class Parceiros extends StatefulWidget {
  const Parceiros({Key? key}) : super(key: key);

  @override
  State<Parceiros> createState() => _ParceirosState();
}

class _ParceirosState extends State<Parceiros> {
  late List<Parceiro> _lp = [];

  Future<List<Parceiro>> ReadJsonData() async{
    final jsondata = await rootBundle.loadString('jsonfile/parceiros_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Parceiro.fromJson(e)).toList();
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
            _lp = data.data as List<Parceiro>;
            for(var item in _lp)
              print(item.razaoSocial);
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
                                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                                  child: Column(
                                    children: [
                                      for (var item in _lp)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            trailing:  InkWell(
                                                onTap: (){},
                                                child: const Icon(Icons.edit)),
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item.razaoSocial.toString()),
                                                Text("${item.desconto}%", style: AppTextStyles.labelBold16,),
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
                          label: "Cadastrar Parceiro",
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/cadastro_parceiro");
                          },
                        ),
                      ],
                    ),
                  )));
    });
  }
}
