import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:psico_sis/arguments/sessao2_arguments.dart';
import 'package:psico_sis/arguments/sessao3_arguments.dart';
import 'package:psico_sis/model/dias_profissional.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/slot_horas.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/button_widget.dart';
import '../model/consulta.dart';
import '../model/servico.dart';
import '../themes/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';

class Sessao22 extends StatefulWidget {
  final Sessao2Arguments arguments;

  const Sessao22({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Sessao22> createState() => _Sessao22State();
}

class _Sessao22State extends State<Sessao22> {
  late int _mesSelecionado = DateTime.now().month;
  late int _anoSelecionado = DateTime.now().year;
  late int _indexDataHora = 0;
  late List<DiasProfissional> _lDiasProfissional = [];
  late List<SlotHoras> _lSlotHoras = [];
  late List<String> _lSlotHorasOfertadas = [];
  late List<Servico> _lServicos = [];
  late List<Consulta> _lConsulta = [];
  late List<DiasSalasProfissionais> _lDiasSalasProfissionais = [];
  late List<String> _lDias = [];
  late List<String> _lDatasSelecionadas = [];
  late List<String> _lHorasSelecionadas = [];
  bool _selecionou = false;
  late DateTime _selectData;
  DateTime _dataAtual = DateTime.now();
  DateTime _primeiraDataCalendario = DateTime.now();

  Future<void> readJsonProfissionais() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/dias_profissionais.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lDiasProfissional =
          list.map((e) => DiasProfissional.fromJson(e)).toList();
      _lDiasProfissional.forEach((element) {
        if (element.idProfissional == widget.arguments.profissional.id) {
          _lDias.add(element.descricao.toString());
        }
      });
    });
  }

  Future<void> readJsonConsultas() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/consultas_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lConsulta = list.map((e) => Consulta.fromJson(e)).toList();
    });
  }

  Future<void> readJsonServicos() async {
    final jsondata = await rootBundle.loadString('jsonfile/servicos_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lServicos = list.map((e) => Servico.fromJson(e)).toList();
    });
  }

  Future<void> readJsonSlotHoras() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/slot_horas_empresa_json.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lSlotHoras = list.map((e) => SlotHoras.fromJson(e)).toList();
      if (_lSlotHoras.isNotEmpty) {
        print("entrou readJsonSlotHoras");
      } else {
        print("saiu readJsonSlotHoras");
      }
      _lSlotHoras.forEach((element) {
        if (element.idEmpresa == 1) {
          print("adicionou hora");
          _lSlotHorasOfertadas.add(element.horario.toString());
        }
      });
    });
  }

  Future<void> readJsonDiasSalasProfissionais() async {
    final jsondata =
        await rootBundle.loadString('jsonfile/dias_salas_profissionais.json');
    final list = json.decode(jsondata) as List<dynamic>;
    setState(() {
      _lDiasSalasProfissionais =
          list.map((e) => DiasSalasProfissionais.fromJson(e)).toList();
    });
  }

  String getDescServicoById(int? id) {
    String value = "ID Serviço não encontrado";
    print("${_lServicos.length} getDescServicoById");
    _lServicos.forEach((element) {
      if (element.id == id) {
        value = element.descricao.toString();
      }
    });
    return value;
  }

  int getQtdPacientesServicoById(int? id) {
    int value = 0;
    print("${_lServicos.length} getDescServicoById");
    _lServicos.forEach((element) {
      if (element.id == id) {
        value = element.qtd_pacientes!;
      }
    });
    print("value" +value.toString());
    return value;
  }

  bool getDiaOfertado(String dia, List<String> list) {
    bool result = false;
    list.forEach((element) {
      if (element.toLowerCase() == dia.toLowerCase()) {
        result = true;
      }
    });
    return result;
  }

  Widget diaCalendario(
      double height, double width, String label, bool isPresent) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: AppColors.labelBlack),
          borderRadius: BorderRadius.circular(6),
          color: isPresent
              ? AppColors.labelBlack.withOpacity(0.4)
              : AppColors.labelBlack.withOpacity(0.1),
        ),
        child: Center(
          child: Text(label),
        ),
      ),
    );
  }

  DateTime getPrimeiroDiaCalendario(DateTime data) {
    DateTime diaPrimeiroMes = data.subtract(Duration(days: data.day - 1));
    int indice = getIndicePrimeiroDiaDoMes(diaPrimeiroMes);
    switch (indice) {
      case 0:
        return diaPrimeiroMes;
      case 1:
        return diaPrimeiroMes.subtract(const Duration(days: 1));
      case 2:
        return diaPrimeiroMes.subtract(const Duration(days: 2));
      case 3:
        return diaPrimeiroMes.subtract(const Duration(days: 3));
      case 4:
        return diaPrimeiroMes.subtract(const Duration(days: 4));
      case 5:
        return diaPrimeiroMes.subtract(const Duration(days: 5));
      case 6:
        return diaPrimeiroMes.subtract(const Duration(days: 6));
    }
    print("não entrou");
    return data;
  }

  //retorna o indice do
  int getIndicePrimeiroDiaDoMes(DateTime data) {
    int diaSubtrai = data.day - 1;
    String dia = getDescDia(DateFormat(
      "EEEE",
    ).format(data.subtract(Duration(days: diaSubtrai))));
    print("getIndicePrimeiroDiaDoMes" + dia);
    switch (dia) {
      case "SEGUNDA":
        return 1;
      case "TERÇA":
        return 2;
      case "QUARTA":
        return 3;
      case "QUINTA":
        return 4;
      case "SEXTA":
        return 5;
      case "SÁBADO":
        return 6;
      case "DOMINGO":
        return 0;
    }
    return 8;
  }

  //retorna o String data {dd/mm/yyyy}
  String getData(DateTime data) {
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;
    String diaS = "";
    String mesS = "";
    if (dia < 10) {
      diaS = "0$dia";
    } else {
      diaS = "$dia";
    }

    if (mes < 10) {
      mesS = "0$mes";
    } else {
      mesS = "$mes";
    }
    return "$diaS/$mesS/$ano";
  }

  //traduz o dia {DateFormat("EEEE",).format(_dataAtual);}
  String getDescDia(String dia) {
    // String dia = DateFormat("EEEE",).format(_dataAtual);
    switch (dia) {
      case "Monday":
        return "SEGUNDA";
      case "Tuesday":
        return "TERÇA";
      case "Wednesday":
        return "QUARTA";
      case "Thursday":
        return "QUINTA";
      case "Friday":
        return "SEXTA";
      case "Saturday":
        return "SÁBADO";
      case "Sunday":
        return "DOMINGO";
    }
    return "";
  }

  //retorna descrição do mes
  String getDescMes(int mes) {
    switch (mes) {
      case 1:
        return "Janeiro";
      case 2:
        return "Fevereiro";
      case 3:
        return "Março";
      case 4:
        return "Abril";
      case 5:
        return "Maio";
      case 6:
        return "Junho";
      case 7:
        return "Julho";
      case 8:
        return "Agosto";
      case 9:
        return "Setembro";
      case 10:
        return "Outubro";
      case 11:
        return "Novembro";
      case 12:
        return "Dezembro";
    }
    return "";
  }

  //checa se aquele profissional está disponivel pra determinado horário
  bool getHoraOfertadaProfissional(String dia, String hora, int? id) {
    bool value = false;
    _lDiasSalasProfissionais.forEach((element) {
      if ((element.descDia == dia) &&
          (element.hora == hora) &&
          (element.idProfissional == id)) {
        value = true;
      }
    });
    return value;
  }

  //retorna o card com informações dos horários da data selecionada
  Widget getHoraResult(
      int? id_profissional, String hora, String data, Size size) {
    String diaSemana = getDescDia(DateFormat(
      "EEEE",
    ).format(_selectData));
    String diaSemana1 = getData(_selectData);
    bool validou = false;
    if (_lConsulta.isNotEmpty) {
      Consulta consulta = _lConsulta[0];
      //pesquisa se contem sessão com aquele profissional
      // naquela hora e naquela data
      _lConsulta.forEach((element) {
        if ((element.idProfissional == id_profissional) &&
            (element.horarioConsulta == hora) &&
            (element.dataConsulta == diaSemana1)) {
          consulta = element;
          validou = true;
          return;
        }
      });
      if (validou) {
        print("Encontro");
        return Card(
            color: AppColors.labelBlack.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: size.width * 0.03, child: Text(hora)),
                  SizedBox(
                    width: size.width * 0.12,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(consulta.descConsulta.toString())),
                  ),
                  SizedBox(
                      height: size.height * 0.02,
                      width: size.width * 0.01,
                      child: const FittedBox(
                          fit: BoxFit.contain, child: Icon(Icons.edit))),
                ],
              ),
            ));
      } else {
        // print("Não encontrou");
        //pesquisa se o profissional trabalha naquele horario
        // e naquele dia da semana
        if (getHoraOfertadaProfissional(
            diaSemana, hora, widget.arguments.profissional.id)) {
          return Card(
              color: AppColors.primaryColor.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(hora),
                    Text("LIVRE"),
                    //adicionar horário
                    InkWell(
                        onTap: () {
                          // widget.arguments.datasSessoes = "";      // _indice = 1;
                          bool result = false;
                          _lDatasSelecionadas.forEach((element) {
                            if (element==diaSemana1){
                              result = true;
                              return;
                            }
                          });
                          if (result == false){
                            _lDatasSelecionadas.insert(
                                _indexDataHora, diaSemana1);
                            _lHorasSelecionadas.insert(_indexDataHora, hora);
                            _indexDataHora++;
                            setState(() {});
                          } else {
                            //aviso que a data ja foi inserida
                          }

                        },
                        child: const FittedBox(
                            fit: BoxFit.contain, child: Icon(Icons.add)))
                  ],
                ),
              ));
        } else {
          return Card(
              color: AppColors.labelBlack.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(fit: BoxFit.contain, child: Text(hora)),
                    const FittedBox(
                        fit: BoxFit.contain, child: Text("INDISPONÍVEL")),
                  ],
                ),
              ));
        }
      }
    } else {
      return Card(
          color: AppColors.labelBlack.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(hora), Text("LIVRE")],
            ),
          ));
    }
  }

  Widget getListHoras(Size size) {
    if (_selecionou) {
      if (_selectData != null) {
        print("horas ${_lSlotHorasOfertadas.length}");
        return Center(
          child: Container(
            width: size.width * 0.2,
            height: size.height * 0.52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: AppColors.green),
            child: ListView.builder(
                itemCount: _lSlotHorasOfertadas.length,
                itemBuilder: (BuildContext, index) {
                  return Container(
                    width: size.width * 0.08,
                    height: size.height * 0.04,
                    color: AppColors.shape,
                    child: getHoraResult(
                        widget.arguments.profissional.id,
                        _lSlotHorasOfertadas[index],
                        DateFormat(
                          "EEEE",
                        ).format(_selectData),
                        size),
                  );
                }),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget getSelectDia() {
    if (_selecionou) {
      if (_selectData != null) {
        String diaSemana = getDescDia(DateFormat(
          "EEEE",
        ).format(_selectData));
        String diaSemana1 = getData(_selectData);
        String data1 = getData(_selectData);
        print(data1 + "data1");
        //$diaSemana
        return FittedBox(fit: BoxFit.contain, child: Text("$diaSemana $data1"));
      } else {
        return const FittedBox(
            fit: BoxFit.contain, child: Text("Selecione uma data"));
      }
    } else {
      return const FittedBox(
          fit: BoxFit.contain, child: Text("Selecione uma data"));
    }
  }

  //retorna o widget com o dia do calendário
  Widget getWidgetDia(DateTime dia, Size size) {
    String diaSemana = getDescDia(DateFormat(
      "EEEE",
    ).format(dia));
    // print(dia);
    // print(dia.difference(DateTime.now()).inDays );
    if ((_lDias.contains(diaSemana)) &&
        (dia.difference(DateTime.now()).inDays >= 0)) {
      // print("entrou datetime");
      return InkWell(
        onTap: () {
          _selecionou = true;
          _selectData = dia;
          setState(() {});
        },
        child: Container(
          height: size.height * 0.04,
          width: size.width * 0.024,
          decoration: BoxDecoration(
            // color: AppColors.primaryColor,
            color: AppColors.labelBlack.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
              child: Text(
            dia.day.toString(),
            style: AppTextStyles.labelBlack16Lex,
          )),
        ),
      );
    } else {
      // print("não entrou datetime");
      return Container(
        height: size.height * 0.04,
        width: size.width * 0.024,
        decoration: BoxDecoration(
          // color: AppColors.primaryColor,
          color: AppColors.labelBlack.withOpacity(0.1),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(child: Text(dia.day.toString())),
      );
    }
  }

  @override
  initState() {
    super.initState();
    readJsonProfissionais();
    readJsonServicos();
    readJsonDiasSalasProfissionais();
    readJsonSlotHoras();
    readJsonConsultas();

    _primeiraDataCalendario = getPrimeiroDiaCalendario(_dataAtual);
    //carrega datas
    for (int i = 0; i < widget.arguments.datasSessoes.length; i++) {
      _lHorasSelecionadas.add(widget.arguments.horarioSessoes[i]);
      _lDatasSelecionadas.add(widget.arguments.datasSessoes[i]);
    }
    int i = getIndicePrimeiroDiaDoMes(_dataAtual);
    print(i);
    print(_primeiraDataCalendario.day.toString() + " +dia");
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
          width: size.width,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            radius: 2.0,
            colors: [
              AppColors.shape,
              AppColors.primaryColor,
            ],
          )),
          child: Row(
            children: [
              //informações ficha sessão
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.01, right: size.width * 0.01),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Container(
                      height: size.height * 0.6,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: AppColors.labelWhite,
                      ),
                      child: Column(
                        children: [
                          //nome profissional
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0,right: 4.0),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "PROFISSIONAL:",
                                        style: AppTextStyles.labelBlack14Lex,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  widget.arguments.profissional.nome.toString(),
                                  style: AppTextStyles.labelBlack14Lex,
                                ),
                              ),
                            ],
                          ),
                          //tipo serviço
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "TIPO SERVIÇO: ",
                                        style: AppTextStyles.labelBlack14Lex,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${getDescServicoById(widget.arguments.servico.idServico)}",
                                    style: AppTextStyles.labelBlack14Lex,
                                  )),
                            ],
                          ),
                          //divider
                          Padding(
                            padding: EdgeInsets.only(bottom: size.height * 0.02),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.labelBlack,
                            ),
                          ),
                          //sessões
                          for (int i = 0;
                              i < widget.arguments.sessoes.length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.13,
                                    height: size.height * 0.03,
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(widget.arguments.sessoes[i],
                                          style: AppTextStyles.labelBlack12Lex,))),
                                  SizedBox(
                                    width: size.width * 0.06,
                                    height: size.height * 0.03,
                                    child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(_lHorasSelecionadas[i],
                                            style: AppTextStyles.labelBlack12Lex,))),
                                  SizedBox(
                                    width: size.width * 0.06,
                                      height: size.height * 0.03,
                                    child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(_lDatasSelecionadas[i],
                                            style: AppTextStyles.labelBlack12Lex,))),
                                  SizedBox(
                                    width: size.width * 0.03,
                                    height: size.height * 0.03,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "${widget.arguments.valorSessoes[i].toString()},00",
                                        style: AppTextStyles.labelBlack14Lex,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          //divider
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.02),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.labelBlack,
                            ),
                          ),
                          //valor total
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      "Valor Total: ",
                                      style: AppTextStyles.labelBlack12Lex,
                                      textAlign: TextAlign.right,
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${widget.arguments.servico.valor},00",
                                    style: AppTextStyles.labelBlack14Lex,
                                    textAlign: TextAlign.right,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //container com indicadores dos passos
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
                                backgroundColor: AppColors.secondaryColor,
                                child: Text("1",
                                    style: AppTextStyles.labelBlack16Lex),
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
                                backgroundColor: AppColors.secondaryColor,
                                child: Text("2",
                                    style: AppTextStyles.labelBlack16Lex),
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
                                backgroundColor: AppColors.line,
                                child: Text("3",
                                    style: AppTextStyles.labelBlack16Lex),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //container com as informações da agenda
                  Center(
                    child: Container(
                      width: size.width * 0.45,
                      height: size.height * 0.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.shape),
                      //calendário
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //calendário
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "Selecione a data da ${_indexDataHora + 1} SESSÃO"),
                                  //container calendário
                                  Container(
                                    height: size.height * 0.03,
                                    width: size.width * 0.21,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${getDescMes(_mesSelecionado)} de $_anoSelecionado"),
                                        SizedBox(
                                          width: size.width * 0.04,
                                          height: size.height * 0.03,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //mes antecessor
                                              InkWell(
                                                  onTap: () {
                                                    print("apertou");

                                                    //se o mes selecionado for maior que o mes atual retroceder mes
                                                    if ((_mesSelecionado >
                                                        DateTime.now().month)||(_anoSelecionado>DateTime.now().year)){
                                                      if (_mesSelecionado ==
                                                          1) {
                                                        _mesSelecionado = 12;
                                                        _anoSelecionado--;
                                                      } else {
                                                        _mesSelecionado--;
                                                      }
                                                      DateTime novaData =
                                                          DateTime(
                                                              _anoSelecionado,
                                                              _mesSelecionado,
                                                              1);

                                                      _primeiraDataCalendario =
                                                          getPrimeiroDiaCalendario(
                                                              novaData);
                                                      print("alterou mês");
                                                      setState(() {});
                                                    } else {
                                                      print(_mesSelecionado);
                                                      print(
                                                          DateTime.now().month);
                                                    }
                                                  },
                                                  child: Icon(Icons
                                                      .keyboard_arrow_up_outlined)),
                                              //mês sucessor
                                              InkWell(
                                                  onTap: () {
                                                    //se a data atual for maior que a data selecionada
                                                    if (_mesSelecionado ==
                                                        12) {
                                                      _mesSelecionado = 1;
                                                      _anoSelecionado++;
                                                    } else {
                                                      _mesSelecionado++;
                                                    }
                                                    DateTime novaData =
                                                    DateTime(
                                                        _anoSelecionado,
                                                        _mesSelecionado,
                                                        1);
                                                    _primeiraDataCalendario =
                                                        getPrimeiroDiaCalendario(
                                                            novaData);
                                                    setState((){});
                                                  },
                                                  child: Icon(Icons
                                                      .keyboard_arrow_down_outlined))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //calendário
                                  Container(
                                      width: size.width * 0.21,
                                      height: size.height * 0.365,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: AppColors.labelWhite,
                                          border: Border.all(
                                              width: 0.5,
                                              color: AppColors.labelBlack)),
                                      //linhas com os dias trabalhados do profissional
                                      child: Column(
                                        children: [
                                          //dias da semana
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "D",
                                                        getDiaOfertado(
                                                            "Domingo",
                                                            _lDias))),
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "S",
                                                        getDiaOfertado(
                                                            "Segunda",
                                                            _lDias))),
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "T",
                                                        getDiaOfertado(
                                                            "Terça", _lDias))),
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "Q",
                                                        getDiaOfertado(
                                                            "Quarta", _lDias))),
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "Q",
                                                        getDiaOfertado(
                                                            "Quinta", _lDias))),
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "S",
                                                        getDiaOfertado(
                                                            "Sexta", _lDias))),
                                                SizedBox(
                                                    width: size.width * 0.029,
                                                    child: diaCalendario(
                                                        size.height * 0.05,
                                                        size.width * 0.024,
                                                        "S",
                                                        getDiaOfertado(
                                                            "Sábado", _lDias))),
                                              ],
                                            ),
                                          ),
                                          //listView com as linhas dos dias
                                          Container(
                                            width: size.width * 0.21,
                                            height: size.height * 0.3,
                                            child: ListView.builder(
                                                itemCount: 6,
                                                itemBuilder:
                                                    (BuildContext, index) {
                                                  return Container(
                                                    width: size.width * 0.21,
                                                    height: size.height * 0.05,
                                                    color: AppColors.shape,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: 7,
                                                        itemBuilder:
                                                            (BuildContext,
                                                                index1) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: size.height *
                                                                  0.005,
                                                              bottom:
                                                                  size.height *
                                                                      0.005,
                                                              left: size.width *
                                                                  0.003,
                                                              right:
                                                                  size.width *
                                                                      0.003,
                                                            ),
                                                            //getWidgetDia
                                                            child: getWidgetDia(
                                                                _primeiraDataCalendario
                                                                    .add(Duration(
                                                                        days: index *
                                                                                7 +
                                                                            index1)),
                                                                size),
                                                            /*
                                                          child: Container(
                                                            //size.height*0.05,size.width*0.024
                                                            height: size.height * 0.04,
                                                            width: size.width * 0.024,
                                                            decoration: BoxDecoration(
                                                                // color: AppColors.primaryColor,
                                                                color: AppColors.labelBlack.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(3)
                                                            ),
                                                            child: Center(child: Text(_primeiraDataCalendario.add(Duration(days: index*7+index1)).day.toString())),
                                                          ),*/
                                                          );
                                                        }),
                                                  );
                                                }),
                                          )
                                          /*
                                        */
                                        ],
                                      )),
                                ],
                              ),
                              //detalhes do dia selecionado
                              Column(
                                children: [
                                  Container(
                                    width: size.width * 0.09,
                                    height: size.height * 0.03,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(2),
                                            topRight: Radius.circular(2)),
                                        color: AppColors.labelWhite,
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.labelBlack)),
                                    child: getSelectDia(),
                                    //getSelectDay
                                  ),
                                  Container(
                                    width: size.width * 0.21,
                                    height: size.height * 0.52,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: AppColors.line),
                                    //getHorarios
                                    child: getListHoras(size),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  //botão avançar
                  Center(
                    child: ButtonWidget(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.1,
                      label: "AVANÇAR >>",
                      onTap: () {
                        int qtd = getQtdPacientesServicoById(widget.arguments.servico.idServico);
                        print(qtd.toString()+" aaaa ");
                       Sessao3Arguments arguments3 = Sessao3Arguments(widget.arguments.profissional,
                            widget.arguments.servico, qtd, widget.arguments.sessoes,
                            widget.arguments.valorSessoes, _lDatasSelecionadas, _lHorasSelecionadas);

                        Navigator.pushReplacementNamed(context, "/sessao3", arguments: arguments3);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
