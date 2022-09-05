import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/widgets/menu_icon_button_widget.dart';

import '../model/Profissional.dart';
import '../my_flutter_app_icons.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/menu_icon_label_button_widget.dart';

class Caixa extends StatefulWidget {
  const Caixa({Key? key}) : super(key: key);

  @override
  State<Caixa> createState() => _CaixaState();
}

class _CaixaState extends State<Caixa> {

  late List<Profissional> _lprofissionais;

  Future<void> readJsonProfissionais() async {
    final jsondata =
    await rootBundle.loadString('jsonfile/profissionais_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lprofissionais = list.map((e) => Profissional.fromJson(e)).toList();
    });
  }

  @override
  initState() {
    super.initState();
    readJsonProfissionais();
    // readJsonPacientes();
    // readJsonDiasSalasProfissionais();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [



              Padding(
                padding: EdgeInsets.only(left: size.width*0.1, right: size.width*0.1 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Informações do caixa
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //imagem caixa
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,bottom: 4.0),
                            child: SizedBox(
                                height: size.height * 0.1,
                                width: size.height * 0.1,
                                child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.asset(AppImages.caixa, filterQuality: FilterQuality.high,))),
                          ),
                          Container(
                            height: size.height * 0.3,
                            width: size.width*0.15,
                            decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: AppColors.line,
                                    width: 1,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.shape),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Text("Dinheiro: ", style: AppTextStyles.labelBlack16Lex,),
                                      Text("+ 0,00", style: AppTextStyles.labelBlackBold20,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Pix: ",style: AppTextStyles.labelBlack16Lex,),
                                      Text("+ 0,00",style: AppTextStyles.labelBlackBold20,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: size.width*0.09,
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text("Cartão Crédito: ",style: AppTextStyles.labelBlack16Lex,))),
                                      Text("+ 0,00",style: AppTextStyles.labelBlackBold20,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: size.width*0.09,
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text("Cartão Débito: ",style: AppTextStyles.labelBlack16Lex,))),
                                      Text("+ 0,00",style: AppTextStyles.labelBlackBold20,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Despesas: ",style: AppTextStyles.labelBlack16Lex,),
                                      Text("- 0,00",style: AppTextStyles.labelBlackBold20,),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 3,
                                    color: AppColors.labelBlack,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("SALDO",style: AppTextStyles.labelBlack20,),
                                      Text("= 0,00",style: AppTextStyles.labelBlackBold20,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),


                    //transações
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                            child: Column(
                              children: [
                                // for (var item in _lp)
                                  Card(
                                    elevation: 8,
                                    child: ListTile(
                                      trailing:  InkWell(
                                          onTap: (){},
                                          child: const Icon(Icons.edit_calendar)),
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("TRANSAÇÃO"),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text("SESSÃO 03"),
                                              Text("RAFAELA FRANÇA DIAS"),
                                              Text("RS 200,00"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("PROFISSIONAL", ),
                                              Text("ANNE VASCONCELOS", style: AppTextStyles.labelBold16,),
                                              Text("08:00", style: AppTextStyles.labelBold16,),
                                            ],
                                          ),
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

                    //menu
                    Container(
                      width: size.width * 0.08,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MenuIconLabelButtonWidget(
                              label: "DESPESAS",
                              height: size.height*0.08, width: size.width*0.05,
                              iconData: MyFlutterApp.cash_register,
                              onTap: (){
                                Dialogs.AlertCadastrarDespesa(context);
                              }),

                          MenuIconLabelButtonWidget(
                              label: "PAGAR COMISSÃO",
                              height: size.height*0.08, width: size.width*0.05,
                              iconData: MyFlutterApp.access_alarm, onTap: (){
                                Dialogs.AlertPagarProfissional(context, _lprofissionais);
                          }),
                          MenuIconLabelButtonWidget(
                              label: "RECEBÍVEIS",
                              height: size.height*0.08, width: size.width*0.05,
                              iconData: Icons.add, onTap: (){
                                Dialogs.AlertFecharCaixa(context);
                          }),
                          // SvgPicture.asset(
                          //     'images/icons/despesas2.svg',
                          //     height: 100, width: 50,
                          //
                          //     // fit: BoxFit.contain
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),




            ],
          ),
        ));
  }
}
