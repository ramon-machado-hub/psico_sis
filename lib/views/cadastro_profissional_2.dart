import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psico_sis/model/Especialidade.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget2.dart';

class CadastroProfissional2 extends StatefulWidget {
  const CadastroProfissional2({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional2> createState() => _CadastroProfissional2State();
}

class _CadastroProfissional2State extends State<CadastroProfissional2> {
  late Especialidade especialidadeSelected;
  late List<String> _dropEspecialidades =[];
  late List<Especialidade> _le = [];
  late String dropdownEspecialidade = 'DERMATOLOGIA';
  List<bool> listDias = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<bool> listPublicoAlvo = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];


  Future<List<Especialidade>> getEspecialidades() async {
    // return await PerfilWs.getInstance().getPerfis(widget.usuarioModel.tokenUsuario);
    final jsondata = await rootBundle.loadString(
        'jsonfile/especialidades_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Especialidade.fromJson(e)).toList();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return FutureBuilder(
        future: getEspecialidades(),
        builder: (context, data) {
          if (data.hasError) {
            print("erro ao carregar o json");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {

            if(_le.isEmpty){
              _le = data.data as List<Especialidade>;
              _le.sort((a, b) =>
                  a.descricao.toString().compareTo(b.descricao.toString()));
              dropdownEspecialidade = _le[0].descricao!;
              especialidadeSelected = _le[0];
              for (var item in _le){
                _dropEspecialidades.add(item.descricao!);
                print(item.descricao);
              }
            }


              // print(item.descricao);
          }
          return SafeArea(child: Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "CADASTRO PROFISSIONAL",
                      style: AppTextStyles.labelBold16,
                    ),
                    //contagem passos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.shape),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 6.0, right: 6.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue.withOpacity(0.5),
                                  child:
                                  Text("1",
                                      style: AppTextStyles.subTitleWhite14),
                                ),
                              ),
                              Expanded(
                                  child: Divider(
                                    color: AppColors.line,
                                    height: 3,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 6.0, right: 6.0),
                                child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text("2",
                                        style: AppTextStyles.subTitleWhite14)),
                              ),
                              Expanded(
                                  child: Divider(
                                    color: AppColors.line,
                                    height: 3,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 6.0, right: 6.0),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.line,
                                  child: Text("3"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    //container informações cadastro
                    Container(
                      width: size.width * 0.45,
                      height: size.height * 0.6,
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: AppColors.line,
                              width: 1,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.shape),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(

                            children: [
                              //text Especialidades
                              Row(
                                children: [
                                  SizedBox(
                                  width:size.width*0.27,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Especialidade",
                                      style: AppTextStyles.subTitleBlack14,
                                    ),
                                  ),
                                ],
                              ),
                              //TextBox + DropBox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  //TextBox CRM
                                  Container(
                                    width:size.width*0.20,
                                    // decoration: BoxDecoration(
                                    //     color: AppColors.red
                                    // ),
                                    child: InputTextWidget2(
                                      label: "NÚMERO DO CADASTRO",
                                      icon: Icons.badge_outlined,
                                      validator: (value) {
                                        if ((value!.isEmpty) || (value == null)) {
                                          return 'Preecha o campo acima';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      obscureText: false,
                                      backgroundColor: AppColors.secondaryColor,
                                      borderColor: AppColors.line,
                                      textStyle: AppTextStyles.subTitleBlack12,
                                      iconColor: AppColors.labelBlack,
                                    ),
                                  ),//TextBox CRM
                                  //Drop Especialidade
                                  Container(
                                    width: size.width*0.15,
                                    height: size.height*0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.secondaryColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: DropdownButton<String>(
                                        // hint:  Text("Especialidades"),

                                        value: dropdownEspecialidade,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                        elevation: 16,
                                        style: TextStyle(
                                            color: AppColors.labelBlack),
                                        underline: Container(
                                          height: 2,
                                          color: AppColors.line,
                                        ),

                                        items: _dropEspecialidades.map<DropdownMenuItem<String>>((
                                            String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          print(newValue.toString()+"aaaaa");
                                          print(dropdownEspecialidade);
                                          setState(() {
                                            dropdownEspecialidade = newValue!;
                                          });
                                          print(dropdownEspecialidade.toString()+"bbbbbbb");
                                        },

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),



                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: size.width*0.023),
                                child: Text("Selecione ao menos um público alvo:", style: AppTextStyles.subTitleBlack14,),
                              ),
                              //TextBox CRM
                              Padding(
                                padding: EdgeInsets.only(left: size.width*0.023, right: size.width*0.023),
                                child: Container(
                                  width:size.width*0.25,
                                  height: size.width*0.11,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    color: AppColors.secondaryColor),
                                  child: Center(
                                    child: Wrap(
                                      // alignment: WrapAlignment.spaceAround,
                                      crossAxisAlignment:  WrapCrossAlignment.start,
                                      spacing: 1.0,
                                      direction: Axis.vertical,
                                      children: [

                                        //Adolescente
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[0],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[0] = value!;
                                                });
                                              },
                                            ),
                                            Text('Adolescente', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),

                                        //adulto
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[1],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[1] = value!;
                                                });
                                              },
                                            ),
                                            Text('Adulto', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),
                                        //casal
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[2],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[2] = value!;
                                                });
                                              },
                                            ),
                                            Text('Casal', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),

                                        //familiar
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[3],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[3] = value!;
                                                });
                                              },
                                            ),
                                            Text('Familiar', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),

                                        //homosexual
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[4],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[4] = value!;
                                                });
                                              },
                                            ),
                                            Text('Homosexual', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),

                                        // idoso
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[5],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[5] = value!;
                                                });
                                              },
                                            ),
                                            Text('Idoso', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),
                                        //infantil
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[6],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[6] = value!;
                                                });
                                              },
                                            ),
                                            Text('Infantil', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),
                                        //TransSexual
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.red,
                                              value: listPublicoAlvo[7],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  listPublicoAlvo[7] = value!;
                                                });
                                              },
                                            ),
                                            Text('Transexual', style: AppTextStyles.labelBold16, ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                ),
                              ),
                            ],
                          ),

                          /*
                          //Dias trabalhados
                          Padding(
                            padding:  EdgeInsets.only(left: size.width*0.03, right: size.width*0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    listDias[0] = true;
                                    Dialogs.AlertHorasTrabalhadas(
                                        context, "Segunda");
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        color: listDias[0]
                                            ? AppColors.line
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Text("SEG", style: AppTextStyles.labelBold16,),
                                        ))),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    listDias[1] = true;
                                    Dialogs.AlertHorasTrabalhadas(
                                        context, "Terça");
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        color: listDias[1]
                                            ? AppColors.line
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Text("TER",style: AppTextStyles.labelBold16,),
                                        ))),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    listDias[2] = true;
                                    Dialogs.AlertHorasTrabalhadas(
                                        context, "Quarta");
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        color: listDias[2]
                                            ? AppColors.line
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Text("QUA",style: AppTextStyles.labelBold16,),
                                        ))),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    listDias[3] = true;
                                    Dialogs.AlertHorasTrabalhadas(
                                        context, "Quinta");
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        color: listDias[3]
                                            ? AppColors.line
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Text("QUI",style: AppTextStyles.labelBold16,),
                                        ))),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    listDias[4] = true;
                                    Dialogs.AlertHorasTrabalhadas(
                                        context, "Sexta");
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        color: listDias[4]
                                            ? AppColors.line
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Text("SEX",style: AppTextStyles.labelBold16,),
                                        ))),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    listDias[5] = true;
                                    Dialogs.AlertHorasTrabalhadas(
                                        context, "Sábado");
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        color: listDias[5]
                                            ? AppColors.line
                                            : AppColors.green,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text("SÁB", style: AppTextStyles.labelBold16,))),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    ButtonWidget(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.2,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.1,
                      label: "AVANÇAR",
                      onTap: () {
                        // Dialogs.AlertDialogProfissional(context);
                        Navigator.pushReplacementNamed(
                            context, "/cadastro_profissional3");
                      },
                    ),
                  ],
                ),
              )),);
        });
  }
}
//
// Widget ListDays(context, String day){
//   return Container(
//     child: InkWell(
//       onTap: () {
//         // listDias[0] = true;
//         Dialogs.AlertHorasTrabalhadas(
//             context, day);
//         setState(() {});
//       },
//       child: Container(
//         height: size.height * 0.05,
//         width: size.width * 0.05,
//         decoration: BoxDecoration(
//             color: listDias[0]
//                 ? AppColors.line
//                 : AppColors.green,
//             borderRadius: BorderRadius.circular(10)),
//         child: Center(child: Text("Segunda")),
//       ),
//     ),
//   )
// }
