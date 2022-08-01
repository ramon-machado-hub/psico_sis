import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';

import '../model/Paciente.dart';
import '../themes/app_colors.dart';
import '../widgets/button_widget.dart';

class Aniversariantes extends StatefulWidget {
  const Aniversariantes({Key? key}) : super(key: key);

  @override
  State<Aniversariantes> createState() => _AniversariantesState();
}

class _AniversariantesState extends State<Aniversariantes> {

  List<bool> _selected = [true, false, false];

  late List<Paciente> _lp = [];
  Future<List<Paciente>> ReadJsonData() async {
    final jsondata = await rootBundle.loadString('jsonfile/pacientes_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Paciente.fromJson(e)).toList();
  }

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
              for(var item in _lp)
                print(item.nome);
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
                          const SizedBox(
                            height: 20,
                          ),
                          //abas = DO DIA / DA SEMANA / DO MES
                          Container(
                            width: size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      _selected[0]=true;
                                      _selected[1]=false;
                                      _selected[2]=false;
                                      setState((){});
                                    },
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.06,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft:  Radius.circular(3),
                                            topRight:  Radius.circular(3),
                                          ),
                                          color: _selected[0] ? AppColors.secondaryColor : AppColors.line),
                                      child: Center(child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                            child: Text("Do dia", style: AppTextStyles.labelBold16,),
                                          ))),
                                    ),
                                  ),
                                  SizedBox(width: 2,),
                                  InkWell(
                                    onTap: (){
                                      _selected[0]=false;
                                      _selected[1]=true;
                                      _selected[2]=false;
                                      setState((){});
                                    },
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.06,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft:  Radius.circular(3),
                                            topRight:  Radius.circular(3),
                                          ),
                                          color: _selected[1] ? AppColors.secondaryColor : AppColors.line),
                                      child: Center(child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                            child: Text("Da semana", style: AppTextStyles.labelBold16,),
                                          ))),
                                    ),
                                  ),
                                  SizedBox(width: 2,),
                                  InkWell(
                                    onTap: (){
                                      _selected[0]=false;
                                      _selected[1]=false;
                                      _selected[2]=true;
                                      setState((){});
                                    },
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.06,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft:  Radius.circular(3),
                                            topRight:  Radius.circular(3),
                                          ),
                                          color: _selected[2] ? AppColors.secondaryColor : AppColors.line),
                                      child:  Center(child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                            child: Text("Do mês", style: AppTextStyles.labelBold16,),
                                          ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      for (var item in _lp)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            leading: Icon(Icons.person),
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item.nome.toString()),
                                                Text(item.dataNascimento.toString().substring(0,5), style: AppTextStyles.labelBold22,),
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

                        ],
                      ),
                    ))
                );
          }
      );
    }
  }
