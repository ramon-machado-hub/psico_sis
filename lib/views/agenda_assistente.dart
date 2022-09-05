import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';

import '../daows/UsuarioWS.dart';
import '../model/Usuario.dart';
import '../model/Profissional.dart';

class AgendaAssistente extends StatefulWidget {
  const AgendaAssistente({Key? key}) : super(key: key);

  @override
  State<AgendaAssistente> createState() => _AgendaAssistenteState();
}

class _AgendaAssistenteState extends State<AgendaAssistente> {

  late List<Usuario> _ls = [];
  late List<Profissional> _lp = [];
  late List<Profissional> _lpacientes = [];

  Future<void> carregarUsuarios() async {
    _ls = await UsuarioWS.getInstance().getAll("");
    _ls.forEach((element) {
      print(element.nomeUsuario);
    });
  }

  void loadUsuario() async {
    print("aqui");
    _ls = await UsuarioWS.getInstance().getAll("");
    print(_ls.length);
    _ls.forEach((element) {
      print(element.emailUsuario);
    });
  }

  Future<void> getAtivos() async {
    _ls = await UsuarioWS.getInstance().getAtivos("");
    _ls.forEach((element) {
      print(element.emailUsuario);
    });
  }

  void carregaProfissionais() async {
    setState((){});
  }

  Future<List<Profissional>> ReadJsonData() async {
    final jsondata = await rootBundle.loadString('jsonfile/profissionais_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Profissional.fromJson(e)).toList();
  }


  @override
  Widget build(BuildContext context) {
    // carregarUsuarios().then((value) => setState(() {
    //
    // }));
    //     print("entrou");
    loadUsuario();
    return FutureBuilder(
        future: ReadJsonData(),
        builder: (context, data) {
          if (data.hasError) {
            print("erro ao carregar o json");
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            print("entrou");
            _lp = data.data as List<Profissional>;
            // carregaProfissionais();
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
                    child: Center(
                      child: Row(
                        children: [
                          //Profissionais
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: BoxDecoration(
                                color: AppColors.labelWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [

                                      for(var item in _lp)
                                        Card(
                                          elevation: 8,
                                          child: ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text(item.nome.toString()),
                                            subtitle: Text(item.especialidade.toString()),

                                          ),
                                        )

                                    ],
                                  ),
                                ),
                              ),

                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),

                          //agenda
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.height * 0.70,
                              decoration: BoxDecoration(
                                color: AppColors.labelWhite,
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //coluna horário
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      decoration: BoxDecoration(
                                        color: AppColors.labelBlack.withOpacity(0.3),
                                      ),
                                      child: columnHorario(context)),
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      decoration: BoxDecoration(
                                        color: AppColors.labelBlack.withOpacity(0.3),
                                      ),
                                      child:
                                      columnProfissional(context, "Anne Vasconcelos"))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
          );
        }

    );

  }
}

//agenda do profissional
Widget columnProfissional(context, String name) {
  return Column(
    children: [
      //Cabeçalho profissional
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Chip(
            avatar: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Text(
                "A",
                style: AppTextStyles.labelBlack12,
              ),
            ),
            label: FittedBox(fit: BoxFit.contain, child: Text(name)),
          ),
        ),
      ),
      CardVago(context, AppColors.blue, AppColors.red, "INDISPONÍVEL"),
      CardVago(context, AppColors.shape, AppColors.green, "DISPONÍVEL"),
      CardAgenda(context, AppColors.blue, AppColors.yelow, "Mateus Carvalho",
          "5 sessão"),
      CardAgenda(context, AppColors.shape, AppColors.yelow, "Talita Santos",
          "Consulta Avaliativa"),
      CardVago(context, AppColors.blue, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.shape, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.blue, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.shape, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.blue, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.shape, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.blue, AppColors.green, "DISPONÍVEL"),
      CardVago(context, AppColors.shape, AppColors.green, "DISPONÍVEL"),
    ],
  );
}

Widget CardVago(context, Color color1, Color color2, String label) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.05,
    width: MediaQuery.of(context).size.width * 0.1,
    color: color1,
    child: Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 4.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color2,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyles.subTitleBlack,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: IconButton(
                      onPressed: () {
                        showAlertDialog(
                          context,
                          "RAMON LUIZ ALVES MACHADO",
                          "08:00",
                          "ANNE VASCONCELOS",
                        );
                      },
                      icon: Icon(Icons.edit)),
                ),
              ),
            ],
          ))),
    ),
  );
}

//Disponível
Widget CardAgenda2(
    context, Color color1, Color color2, String nome, String sessao) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.05,
    width: MediaQuery.of(context).size.width * 0.1,
    color: color1,
    child: Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 5.0, bottom: 4.0, top: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "INDISPONÍVEL",
                          style: AppTextStyles.labelWhite20,
                        ))),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
                fit: BoxFit.contain,
                child: IconButton(
                    onPressed: () {
                      showAlertDialog(
                        context,
                        "Ramon",
                        "Rafaela",
                        "Sessao 4",
                      );
                    },
                    icon: const Icon(Icons.edit))),
          ),
        ],
      ),
    ),
  );
}

//Profissional
Widget CardAgenda(
    context, Color color1, Color color2, String nome, String sessao) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.05,
    width: MediaQuery.of(context).size.width * 0.1,
    color: color1,
    child: Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 5.0, bottom: 4.0, top: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color2,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nome,
                                style: AppTextStyles.labelBlack16,
                                textAlign: TextAlign.start),
                            Text(
                              sessao,
                              style: AppTextStyles.subTitleBlack16,
                            ),
                          ],
                        ),
                        Text(
                          "R\$ 250,00",
                          style: AppTextStyles.labelWhite20,
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
                fit: BoxFit.contain,
                child: IconButton(
                    onPressed: () {
                      showAlertDialog(
                        context,
                        "MATEUS CARVALHO",
                        "ANNE VASCONCELOS",
                        "CARTÃO DE CRÉDITO (VENCIMENTO)",
                      );
                    },
                    icon: const Icon(Icons.edit))),
          ),
        ],
      ),
    ),
  );
}

String getAddDay() {
 return DateFormat('EEEE').format(DateTime.now().add(const Duration(days: 3)));

}

Widget columnHorario(context) {
  // String day = DateFormat('EEEE').format(DateTime.now());
  String day = DateFormat('EEEE').format(DateTime.now());
  return Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.1,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.025,
              child: IconButton(
                  onPressed: () {

                      day = getAddDay();
                      print(day);
                      // setState(() {});
                  },
                  icon: Icon(
                    Icons.keyboard_double_arrow_left,
                    color: AppColors.labelWhite,
                  )),
            ),



            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  day,
                  style: AppTextStyles.labelBold16,
                  // textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.025,
              child: IconButton(
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.keyboard_double_arrow_right,
                    color: AppColors.labelWhite,
                  )),
            ),
            // GestureDetector(
            //     onTap: (){Navigator.of(context).pop();},
            //     child: Text(" >> ", style: AppTextStyles.labelBold16,)),
          ],
        ),
      ),
      linhaAgenda(context, "08:00", AppColors.blue,
          AppColors.labelWhite.withOpacity(0.7)),
      linhaAgenda(context, "09:00", AppColors.shape,
          AppColors.labelWhite.withOpacity(0.3)),
      linhaAgenda(context, "10:00", AppColors.blue,
          AppColors.labelWhite.withOpacity(0.7)),
      linhaAgenda(context, "11:00", AppColors.shape,
          AppColors.labelWhite.withOpacity(0.3)),
      linhaAgenda(context, "12:00", AppColors.blue,
          AppColors.labelWhite.withOpacity(0.7)),
      linhaAgenda(context, "13:00", AppColors.shape,
          AppColors.labelWhite.withOpacity(0.3)),
      linhaAgenda(context, "14:00", AppColors.blue,
          AppColors.labelWhite.withOpacity(0.7)),
      linhaAgenda(context, "15:00", AppColors.shape,
          AppColors.labelWhite.withOpacity(0.3)),
      linhaAgenda(context, "16:00", AppColors.blue,
          AppColors.labelWhite.withOpacity(0.7)),
      linhaAgenda(context, "17:00", AppColors.shape,
          AppColors.labelWhite.withOpacity(0.3)),
      linhaAgenda(context, "18:00", AppColors.blue,
          AppColors.labelWhite.withOpacity(0.7)),
      linhaAgenda(context, "19:00", AppColors.shape,
          AppColors.labelWhite.withOpacity(0.3)),
    ],
  );
}

Widget linhaAgenda(context, String text, Color color1, Color color2) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.05,
    width: MediaQuery.of(context).size.width * 0.1,
    color: color1,
    child: Center(
      child: Center(
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                text,
                style: AppTextStyles.labelClock22,
                textAlign: TextAlign.center,
              ))),
    ),
  );
}

showAlertDialog(
    BuildContext context, String paciente, String hora, String profissional) {
  bool _check1 = false;
  bool _check2 = false;
  bool _check3 = false;
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  Widget cancelarButton = ElevatedButton(
    child: Text("CANCELAR"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Paciente: " ),
            Text(paciente, style: AppTextStyles.labelBold16,),          ],
        ),
        Row(
          children: [
            Text("Profissional: " ),
            Text(profissional, style: AppTextStyles.labelBold16,),
          ],
        ),
        Row(
          children: [
            Text("Horario: "),
            Text(hora, style: AppTextStyles.labelBold16,),
          ],
        ),
        Row(
          children: [
            Text("Tipo Pagamento: "),
            Text("À VISTA (DINHEIRO)", style: AppTextStyles.labelBold16,),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(
            color: AppColors.line,
            height: 5,
            thickness: 1,
          ),
        ),
        Row(
          children: [
            Checkbox(
                checkColor: Colors.white,
                value: _check1,
                onChanged: (bool? value) {
                  // setState(() {
                  _check1 = value!;
                  // });
                }),
            Text("REAGENDAR"),
          ],
        ),
        Row(
          children: [
            Checkbox(
                checkColor: Colors.white,
                value: _check3,
                onChanged: (bool? value) {
                  _check3 = value!;
                }),
            Text("EDITAR"),
          ],
        ),
        Row(
          children: [
            Checkbox(
                checkColor: Colors.white,
                value: _check3,
                onChanged: (bool? value) {
                  _check3 = value!;
                }),
            Text("PACIENTE NÃO COMPARECEU"),
          ],
        ),
        Row(
          children: [
            Checkbox(
                checkColor: Colors.white,
                value: _check3,
                onChanged: (bool? value) {
                  _check3 = value!;
                }),
            Text("FINALIZAR CONSULTA"),
          ],
        ),
      ],
    ),
    content: Text("Selecione a opção desejada."),
    actions: [
      okButton,
      cancelarButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
