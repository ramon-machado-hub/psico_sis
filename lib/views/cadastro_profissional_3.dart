import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/input_text_widget.dart';
import '../widgets/input_text_widget2.dart';

class CadastroProfissional3 extends StatefulWidget {
  const CadastroProfissional3({Key? key}) : super(key: key);

  @override
  State<CadastroProfissional3> createState() => _CadastroProfissional3State();
}

class _CadastroProfissional3State extends State<CadastroProfissional3> {
  final _form = GlobalKey<FormState>();
  List<String> _Servicos = [];
  List<String> _Valores = [];
  String dropdownTpConsulta = 'CONSULTA AVALIATIVA';
  String _valor = "";

  @override
  void initState() {
    super.initState();
    _valor = "";
  }
  @override
  void dispose() {
    // limpa o no focus quando o form for liberado.
    // _valor.dispose();
    super.dispose();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    try {
      return double.tryParse(s) != null;
    }catch(Exception){
      return false;
    }
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
                      Text("Adicione os serviços ofertados: "),

                      //Tipo Consulta / PREÇO / ADD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Tipo Consulta
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: size.height * 0.08,
                              width: size.width * 0.16,

                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: kElevationToShadow[4],
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.secondaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DropdownButton<String>(
                                    value: dropdownTpConsulta,
                                    icon:
                                        const Icon(Icons.arrow_drop_down_sharp),
                                    elevation: 16,
                                    style:
                                        TextStyle(color: AppColors.labelBlack),
                                    underline: Container(
                                      height: 2,
                                      color: AppColors.line,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownTpConsulta = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'CONSULTA AVALIATIVA',
                                      'AVALIAÇÃO NUTRICIONAL',
                                      'CONSULTA ON LINE',
                                      'PACOTE 4 SESSÕES',
                                      'SESSÃO ÚNICA',
                                      'TERAPIA DE CASAL',
                                      'AVALIAÇÃO PSICOLÓGICA',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 25,
                          ),

                          //valor
                          Container(
                            width: size.width * 0.12,
                            decoration: BoxDecoration(
                                boxShadow: kElevationToShadow[4],
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.secondaryColor),
                            child: Center(
                              child: InputTextWidget2(

                                label: "VALOR",
                                icon: Icons.monetization_on,
                                validator: (value) {
                                  if ((value!.isEmpty) || (value == null)) {
                                    return 'Por favor insira um texto';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                    _valor = value;
                                },
                                keyboardType: TextInputType.phone,
                                obscureText: false,
                                backgroundColor: AppColors.secondaryColor,
                                borderColor: AppColors.line,
                                textStyle: AppTextStyles.subTitleBlack12,
                                iconColor: AppColors.labelBlack,
                                controller: TextEditingController(),
                                // initalValue: _valor,
                              ),
                            ),
                          ),

                          //botão
                          MaterialButton(
                            height: 20,
                            onPressed: () {
                                if (_form.currentState!.validate()){
                                  print("validou");
                                  print(dropdownTpConsulta);
                                  print(_valor);
                                  setState(() {
                                    _Servicos.add(dropdownTpConsulta);
                                    _Valores.add(_valor);
                                    _valor = "";
                                    print(_Servicos.length);
                                    print("valor = "+_valor);
                                    // dispose();
                                  });
                                }
                            },
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.add,
                              size: 24,
                            ),
                          )
                        ],
                      ),

                      Container(
                        width: size.width * 0.35,
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.secondaryColor),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for(int i =0; i < _Valores.length; i++)...[
                                Card(
                                  elevation: 8,
                                  child: ListTile(
                                    // leading: const Icon(Icons.person),
                                    title: Text(_Servicos[i]),
                                    leading: Padding(
                                      padding: const EdgeInsets.only(right: 18.0),
                                      child: Text("R\$ ${_Valores[i]},00", style: AppTextStyles.labelBlack16,),
                                    ),
                                    trailing: const Icon(Icons.edit),
                                  ),
                                )
                              ]

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "AVANÇAR",
                  onTap: () {
                    // Dialogs.AlertDialogProfissional(context);
                    Navigator.pushReplacementNamed(context, "/cadastro_profissional4");
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
