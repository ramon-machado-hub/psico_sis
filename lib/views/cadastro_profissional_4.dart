import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';
import '../widgets/input_text_widget2.dart';

class CadastroProfissional4 extends StatefulWidget {
  const CadastroProfissional4({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional4> createState() => _CadastroProfissional4State();
}

class _CadastroProfissional4State extends State<CadastroProfissional4> {
  final _form = GlobalKey<FormState>();

  //HORARIO FUNCIONAMENTO CLINICA
  final List<String> _listHoras = [
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00"
  ];

  List<bool> _listDias = [
    true,
    false,
    false,
    false,
    false,
    false,
  ];

  List<bool> _listSalas = [
    true,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          child: Form(
            key: _form,
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
                              child: Text("1",
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
                                backgroundColor: Colors.blue.withOpacity(0.5),
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
                              backgroundColor: Colors.blue,
                              child: Text(
                                "3",
                                style: AppTextStyles.subTitleWhite14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                //container informações cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Dias
                    Container(
                      width: size.width * 0.08,
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
                      child: SizedBox(
                        width: size.width * 0.06,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            getDay("SEG", () {
                              //zerar_listdias
                              for(int i=0; i< _listDias.length; i++){
                                _listDias[i] = false;
                              }
                              _listDias[0] = true;
                              setState(() {


                              });
                            }, size, _listDias[0]),
                            getDay("TER", () {
                              for(int i=0; i< _listDias.length; i++){
                                _listDias[i] = false;
                              }
                              _listDias[1] = true;
                              // _listDias[1] = !_listDias[1];
                              setState(() {});
                            }, size, _listDias[1]),
                            getDay("QUA", () {
                              for(int i=0; i< _listDias.length; i++){
                                _listDias[i] = false;
                              }
                              _listDias[2] = true;
                              setState(() {});
                            }, size, _listDias[2]),
                            getDay("QUI", () {
                              for(int i=0; i< _listDias.length; i++){
                                _listDias[i] = false;
                              }
                              _listDias[3] = true;

                              setState(() {});
                            }, size, _listDias[3]),
                            getDay("SEX", () {
                              for(int i=0; i< _listDias.length; i++){
                                _listDias[i] = false;
                              }
                              _listDias[4] = true;
                              setState(() {});
                            }, size, _listDias[4]),
                            getDay("SAB", () {
                              for(int i=0; i< _listDias.length; i++){
                                _listDias[i] = false;
                              }
                              _listDias[5] = true;

                              setState(() {});
                            }, size, _listDias[5]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    //salas disponíveis
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
                        children: [
                          //salas
                          Container(
                            height: size.height * 0.06,
                            color: AppColors.blue,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: size.width * 0.09,
                                    color: AppColors.shape,
                                    // color: _listSalas[index] ? AppColors.line : AppColors.shape,
                                    //    selected ? AppColors.line : AppColors.green,

                                    child: InkWell(
                                      onTap: (){
                                        if (_listSalas[index]==false){

                                          // zerar _listsalas
                                          for (int i =0; i< _listSalas.length; i++){
                                            _listSalas[i] = false;
                                          }
                                          _listSalas[index]=true;
                                          setState((){});
                                        }
                                      },
                                      child: Card(
                                          elevation: 8,
                                          color: _listSalas[index] ?AppColors.line : AppColors.green ,

                                          // color: AppColors.labelWhite,
                                          child: SizedBox(
                                              height: size.height * 0.04,
                                              width: size.width * 0.07,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .door_back_door_outlined,
                                                    color: AppColors
                                                        .labelBlack,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            left: 6.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: Text(
                                                        "SALA ${index + 1}",
                                                        style: AppTextStyles
                                                            .subTitleBlack14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            height: size.height * 0.535,
                            width: size.width * 0.46,
                            color: AppColors.line,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index){
                                  return SizedBox(
                                    width: size.width * 0.09,
                                    child: ListView.builder(
                                        itemCount: 13,
                                        itemBuilder: (context, index1){
                                          return SizedBox(
                                            height: size.height * 0.041,
                                            width: size.width * 0.09,
                                            child: Card(
                                              elevation: 8,
                                              color: AppColors.shape,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: size.width * 0.025,
                                                      child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(_listHoras[index1]))),
                                                  SizedBox(
                                                    width: size.width * 0.005,
                                                    child: VerticalDivider(
                                                      color: AppColors.line,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: size.width * 0.035,
                                                      child: const FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text("LIVRE"))),
                                                  SizedBox(
                                                      width: size.width * 0.015,
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: Checkbox(
                                                        value: false,
                                                        checkColor: AppColors.green,
                                                        onChanged: (value){

                                                        },
                                                      ),
                                                      // child: IconButton(onPressed: (){},
                                                      //
                                                      //     icon: Icon(
                                                      //       Icons.assignment_turned_in_rounded,
                                                      //       color: AppColors.labelBlack,
                                                      //     ),),
                                                    )
                                                  )

                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "AVANÇAR",
                  onTap: () {
                    // Dialogs.AlertDialogProfissional(context);
                    // Navigator.pushReplacementNamed(context, "/home_assistente");
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

Widget getDay(String dia, Function() onTap, Size size, bool selected) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: size.height * 0.06,
      width: size.width * 0.05,
      decoration: BoxDecoration(
          color: selected ? AppColors.line : AppColors.green,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  dia,
                  style: AppTextStyles.labelBold16,
                ),
              ))),
    ),
  );
}
