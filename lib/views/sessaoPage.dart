import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/comissao.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/model/sessao.dart';
import 'package:psico_sis/provider/comissao_provider.dart';
import 'package:psico_sis/provider/dias_profissional_provider.dart';
import 'package:psico_sis/provider/dias_salas_profissionais_provider.dart';
import 'package:psico_sis/provider/especialidade_profissional_provider.dart';
import 'package:psico_sis/provider/pagamento_transacao_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/servico_profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/provider/tipo_pagamento_provider.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import 'package:psico_sis/widgets/button_color_icon_disable_widget.dart';
import 'package:psico_sis/widgets/button_disable_widget.dart';
import 'package:psico_sis/widgets/input_text_widget_mask.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/dias_profissional.dart';
import '../model/dias_salas_profissionais.dart';
import '../model/pagamento_transacao.dart';
import '../model/servico.dart';
import '../model/tipo_pagamento.dart';
import '../model/transacao_caixa.dart';
import '../provider/paciente_provider.dart';
import '../provider/sessao_provider.dart';
import '../provider/transacao_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_text_styles.dart';
import '../widgets/input_text_uper_widget.dart';
import '../widgets/input_text_uper_widget2.dart';

class SessaoPage extends StatefulWidget {
  const SessaoPage({Key? key}) : super(key: key);

  @override
  State<SessaoPage> createState() => _SessaoPageState();
}

class _SessaoPageState extends State<SessaoPage> {

  ScrollController controllerPaciente = ScrollController();
  final _form = GlobalKey<FormState>();
  var txt1 = TextEditingController();
  var txt2 = TextEditingController();
  bool enableClinica = true;
  bool enableProfissional = false;
  bool avancarPagamento = false;
  bool salvarSessao = false;
  bool socialFinalizado = true;
  // String valorSessao = "0,00";
  String valorPendente = "0,00";
  List<bool> listEnable = [];

  List<Paciente> pacientes =[];
  List<Paciente> pacientesFinal = [];
  List<Profissional> profissionais =[];
  List<Profissional> profissionaisFinal = [];
  List<DiasProfissional> diasProfissional = [];
  List<DiasSalasProfissionais> diasSalasProfissional = [];
  List<Servico> servicosFinal = [];
  List<ServicosProfissional> servicosProfissionalFinal = [];
  List<TipoPagamento> tiposPagamento = [];
  List<Sessao> sessoesProfissional = [];
  List<String> listDropdownFirst = [];
  String _parteName = "";
  String _uid = "";
  String _dropdown = "";
  String _valorSessao = "0,00";
  String _comissaoClinica = "0,00";
  String _comissaoProfissional = "0,00";
  String _comissaoFinalClinica = "0,00";
  String _comissaoFinalProfissional = "0,00";
  String _descontoClinica = "0,00";
  String _descontoProfissional = "0,00";
  int _flag = 1;
  int _contador = 1;
  bool _selectPaciente = false;
  bool _selectProfissional = false;
  bool _selectServico = false;
  bool _selectData = false;
  bool _isButtonDisabled = true;
  bool _selectPagamento = false;
  bool _botaoAvancar = false;
  bool _botaoSalvar = true;
  bool _check1 = false;
  bool _check2 = false;
  bool _checkSocial = false;
  bool _checkPagamentoVariado = false;
  List<TextEditingController> listTxtController = [];
  // List<String> listDropdownFirst =  [];
  List<String> listValores = ["0,00"];
  DateTime _dataSelecionada = DateTime.now();
  List<String> _datasSelecionadas = [];
  List<String> _horariosSelecionadas = [];
  List<String> _salasSelecionadas = [];
  late Paciente? pacienteSelecionado = Paciente(
    nome: "",
  );
  late Profissional? profissionalSelecionado = Profissional(
    nome: "",
  );
  late Servico? servicoSelecionado = Servico(
    descricao: "",
    qtd_sessoes: 0,
    qtd_pacientes: 0,
  );
  late ServicosProfissional? servicoProfissional = ServicosProfissional(
    valor: "0,00",
  );
  late Usuario _usuario = Usuario(
    idUsuario: 1,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario: "",
    tokenUsuario: "",
  );

  void showSnackBar(String message) {
    SnackBar snack = SnackBar(
      backgroundColor: AppColors.secondaryColor,
      content: Text(
        message,
        style: AppTextStyles.labelWhite16Lex,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
  
  Future<Usuario> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty) {
      print("empity");
      String _uidGet = "";
      print("_uidGet $_uidGet");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    } else {
      print(" not empity");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    }
  }

  @override
  void initState(){
    super.initState();
    listEnable.add(true);
    // controllerPaciente.addListener(() {
    //
    //   if (controllerPaciente.position.atEdge) {
    //     bool isTop = controllerPaciente.position.pixels == 0;
    //     if (isTop) {
    //       print('At the top');
    //     } else {
    //       print('At the bottom');
    //       if (_parteName.length==0){
    //         print("_parteName = 0");
    //         Provider.of<PacienteProvider>(context, listen: false).getListPacientes().then((value) {
    //           print("add");
    //           pacientes = value;
    //           pacientesFinal = value;
    //           setState((){});
    //         } );
    //       }
    //
    //     }
    //   }
    // });

    if (pacientes.length==0){
      Provider.of<PacienteProvider>(context, listen: false).getListPacientes().then((value) {
        // print("initStatePacientes");
        // if (this.mounted) {
        //   pacientes = value;
        //   pacientesFinal = value;
        // }
        if (this.mounted){
          pacientes = value;
          pacientes.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
          pacientesFinal = pacientes;
          setState((){});
        }
      } );
    }

    if (profissionais.length==0){
      Provider.of<ProfissionalProvider>(context, listen: false).getListProfissionais().then((value) {
        // print("initState Sessão");
        profissionais = value;
        if (this.mounted){
          profissionais.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
          profissionaisFinal = profissionais;
          setState((){});
        }
      } );
    }
    if (tiposPagamento.length==0){
      Provider.of<TipoPagamentoProvider>(context, listen: false)
            .getTiposPagamentos().then((value) {
          tiposPagamento = value;
          if (this.mounted){
            tiposPagamento.sort((a,b)=>a.descricao.toLowerCase().replaceAll("à", "a").compareTo(b.descricao.toLowerCase().replaceAll("à", "a")));
            _dropdown = tiposPagamento.first.descricao;
            listDropdownFirst.add(tiposPagamento.first.descricao);
            setState((){});
          }
      });
    }

      Future.wait([
        PrefsService.isAuth().then((value) {
          if (value) {
            print("usuário autenticado");
            PrefsService.getUid().then((value) {
              _uid = value;
              print("_uid initState $_uid");
              getUsuarioByUid(_uid).then((value) {
                _usuario = value;

              }).then((value) {
                if (this.mounted){
                  setState((){
                    print("setState Sessao");
                  });
                }
              });
            });
          } else {
            print("usuário não conectado initState Home Assistente");

            ///nav
            Navigator.pushReplacementNamed(context, "/login");
          }
        }),

      ]);
    }

  List<Profissional> getProfParteName(String parteName){
    List<Profissional> list = [];
    print("parteName = ${parteName.length}");
    print("prof final = ${profissionaisFinal.length}");

    if (parteName.length==0){
      list = profissionaisFinal;
      // return list;
    } else {
      profissionaisFinal.forEach((element) {
        if (element.nome?.substring(0,parteName.length).compareTo(parteName)==0)
          list.add(element);
      });
    }

    print("list = ${list.length}");
    return list;
  }

  List<Paciente> getPaciParteName(String parteName){
    List<Paciente> list = [];
    print("parteName = ${parteName.length}");
    print("_lpFinal = ${pacientesFinal.length}");

    if (parteName.length==0){
      list = pacientesFinal;
      // return list;
    } else {
      pacientesFinal.forEach((element) {
        if (element.nome?.substring(0,parteName.length).compareTo(parteName)==0)
          list.add(element);
      });
    }

    print("list = ${list.length}");
    return list;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<Servico> getServicoSelecionado(String id)async{
    Servico servico = Servico(qtd_pacientes: 0, qtd_sessoes: 0);
    await Provider.of<ServicoProvider>(context, listen: false)
        .getServicoById(id).then((value) {
      servico = value;
    });
    return servico;
  }

  Future<String> getDescServico(String id)async{
    String result = "";
    await Provider.of<ServicoProvider>(context, listen: false)
        .getServicoById(id).then((value) => result = value.descricao! );
    return result;
  }

  Future<List<String>> getEspecialidadeProfissional (String idProf) async{
    List<String> result = [];
    await Provider.of<EspecialidadeProfissionalProvider>(context, listen: false)
        .getEspecialidadeProfissional(idProf).then((value) => result = value);
    print("result $result");
    return result;
  }
  
  String getIdadePaciente (String data){
    // print(data);
    int dia = int.parse(data.substring(0,2));
    int mes = int.parse(data.substring(3,5));
    int ano = int.parse(data.substring(6,10));
    DateTime nascimento = DateTime(ano,mes,dia);
    DateTime hoje = DateTime.now();

    int idade = hoje.year - nascimento.year;
    int meses = 0;
    if (hoje.month<nascimento.month)
      idade--;
    else if (hoje.month==nascimento.month){
      if (hoje.day<nascimento.day)
        idade--;
    }
    if (idade==0){
       meses = hoje.month-nascimento.month;
       return "$meses meses";
    } else if(idade==1){
      return idade.toString()+" ano";
    }
    return idade.toString()+" anos";
  }

  String getValorComDesconto (){
    print(_comissaoFinalProfissional);
    print(_comissaoFinalClinica);
    String comissaoP = _comissaoFinalProfissional.replaceAll(',', '.');
    String comissaoC = _comissaoFinalClinica.replaceAll(',', '.');
    print(comissaoP);
    print(comissaoC);
    double comissaoProf = double.parse(comissaoP);
    double comissaoClin = double.parse(comissaoC);
    double result = comissaoProf+comissaoClin;
    String retorno = (result).toStringAsFixed(2).replaceAll('.', ',');

    return retorno;
  }

  Widget selectProfissional(Size size, ){
    print("selectProfissional");
    print(_parteName);
    _parteName = "";
    print(_parteName);
    return Container(
      height: size.height*0.7,
      width: size.width*0.3,
      color: AppColors.shape,
      child: Column(
        children: [
          SizedBox(
            height: size.height*0.05,
            width: size.width*0.3,
            child: Center(child: Text("Selecione o PROFISSIONAL",
              style: AppTextStyles.subTitleBlack16,)),
          ),
          SizedBox(
            width: size.width * 0.3,
            height: size.height * 0.08,
            child: InputTextUperWidget2(
              label: "Pesquisar por Nome",
              icon: Icons.search_rounded,
              keyboardType: TextInputType.text,
              obscureText: false,
              initalValue: _parteName,
              onChanged: (value) async{
                print("------------------------");
                _parteName = value;
                // print("_parteName $_parteName length ${_parteName.length}");
                // print("_lpFinal length ${pacientesFinal.length}");
                if(_parteName.length==0){
                  print("parteName = 0 $_parteName");
                  // items.clear();
                  print("items = getPaciParteName($_parteName)");
                  profissionais = getProfParteName(_parteName);
                  print(profissionais.length.toString()+"aaa");
                } else {
                  print("getPaciParteName");
                  print("items = getPaciParteName($_parteName)");
                  profissionais = getProfParteName(_parteName);
                  // print("items.length "+pacientes.length.toString()+" aaa");
                }
                setState((){});
              },
              backgroundColor: AppColors.labelWhite,
              borderColor: AppColors.line,
              textStyle:  AppTextStyles.subTitleBlack12,
              iconColor: AppColors.labelBlack,),
          ),
          (profissionais.length>0)?
          Container(
            height: size.height*0.57,
            width: size.width*0.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var items in profissionais)
                    Card(
                      child: ListTile(
                        onTap: (){
                          profissionalSelecionado = items;
                          _selectProfissional = true;
                          _botaoAvancar=true;
                          // _parteName = "";
                          print(_selectProfissional);
                          setState((){});
                        },
                        title: Text(items.nome!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Especialidade: "),
                            FutureBuilder(
                                future: getEspecialidadeProfissional(items.id1),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<String> _lp = snapshot.data as List<String>;
                                    for (var listString in _lp)
                                      return Text(listString);
                                  }else {
                                    return Center(
                                        child: Text("")
                                    );
                                  }
                                  return Text("Especialidade não encontrada");
                                }
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ) :
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget selectPaciente(Size size){

    return Container(
      height: size.height*0.7,
      width: size.width*0.3,
      color: AppColors.shape,
      child: Column(
          children: [
            SizedBox(
              height: size.height*0.05,
              width: size.width*0.3,
              child: Center(child: Text("Selecione o PACIENTE", style: AppTextStyles.subTitleBlack16,)),
            ),
            //serch paciente
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.08,
              child: InputTextUperWidget(
                label: "Pesquisar por nome", icon: Icons.search_rounded,
                initalValue: _parteName,
                keyboardType: TextInputType.text,
                obscureText: false,
                onChanged: (value) async{
                  print("------------------------");
                  _parteName = value;
                  print("_parteName $_parteName length ${_parteName.length}");
                  print("_lpFinal length ${pacientesFinal.length}");
                  if(_parteName.length==0){
                    print("_parteName.length ${_parteName.length}");
                    print("parteName = $_parteName)");
                    pacientes = pacientesFinal;
                    print(pacientes.length.toString()+"pac.length");
                  } else {
                    await Provider.of<PacienteProvider>(context,listen: false)
                        .getListByParteOfName(_parteName).then((value) {
                      pacientes = value;
                    });
                  }
                  setState((){});
                },
                backgroundColor: AppColors.labelWhite,
                borderColor: AppColors.labelBlack,
                textStyle:  AppTextStyles.subTitleBlack12,
                iconColor: AppColors.labelBlack,),
            ),
            (pacientes.length>0)?
            Container(
              height: size.height*0.57,
              width: size.width*0.3,
              child: ListView.builder(
                   itemCount: pacientes.length,
                  controller: controllerPaciente,
                  itemBuilder: (context, index){
                    return Card(
                              child: ListTile(
                                     onTap: (){
                                       pacienteSelecionado = pacientes[index];
                                       _selectPaciente = true;
                                       _botaoAvancar=true;
                                       _parteName = "";
                                       print(_selectPaciente);
                                       print(_parteName);
                                       setState((){});
                                     },
                                     title: Text(pacientes[index].nome!),
                                     subtitle: Text("Idade: ${getIdadePaciente(pacientes[index].dataNascimento!)}"),
                                   ),
                               );
                  })


            )
                :
            Container(
                height: size.height*0.57,
                width: size.width*0.3,
                child: Center(child: CircularProgressIndicator())),

          ]
      ),
    );
  }

  Widget botaoAvancar(Size size){
    bool _enableButton = true;
    return  SizedBox(
      // color: AppColors.blue,
      height: size.height*0.15,
      width: size.width*0.07,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            SizedBox(
              width: size.height*0.08,
              height: size.height*0.08,
              child: (_botaoAvancar)?
              InkWell(
                onTap: ()async {
                  if (_enableButton){
                    _enableButton = false;
                    setState((){});

                    if (_flag==1){
                      print("zerou partName");
                      _parteName="";
                      setState((){});
                    }

                    if(_flag!=_contador){
                      _flag=_contador;
                    }

                    _botaoAvancar = false;
                    if (_flag==2){
                      await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          .getListServicosByIdProfissional(profissionalSelecionado!.id1)
                          .then((value) {
                        servicosProfissionalFinal=value;
                        setState((){});
                      });
                    }
                    if (_flag==3){
                      await Provider.of<DiasProfissionalProvider>
                        (context, listen: false)
                          .getDiasProfissionalByIdProfissional(profissionalSelecionado!.id1).then((value) => diasProfissional=value);
                      setState((){});
                    }
                    if(_flag<5){
                      _flag++;
                      _contador++;
                    }
                  }
                  _enableButton = true;
                  setState((){});
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Container(
                    color: AppColors.primaryColor,

                    child:Icon(
                      Icons.arrow_right_alt,
                      color: AppColors.labelWhite,
                    ),),
                ),
              ) :
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  color: AppColors.labelBlack.withOpacity(0.6),
                  child: Icon(
                    Icons.arrow_right_alt,
                    color: AppColors.labelWhite,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width*0.07,
              height: size.height*0.04,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("Avançar", style: AppTextStyles.subTitleBlack,)
              ),
            ),
          ],
        ),
    );
  }






  String getMes(int mes){
    switch(mes){
      case 1:
        return "JANEIRO";
      case 2:
        return "FEVEREIRO";
      case 3:
        return "MARÇO";
      case 4:
        return "ABRIL";
      case 5:
        return "MAIO";
      case 6:
        return "JUNHO";
      case 7:
        return "JULHO";
      case 8:
        return "AGOSTO";
      case 9:
        return "SETEMBRO";
      case 10:
        return "OUTUBRO";
      case 11:
        return "NOVEMBRO";
      case 12:
        return "DEZEMBRO";
    }
    return "";
  }

  String getDiaSemana(DateTime data) {
    String dia = DateFormat('EEEE').format(data);
    switch (dia) {
      case 'Monday':
        {
          return "Segunda";
        }
      case 'Tuesday':
        {
          return "Terça";
        }
      case 'Wednesday':
        {
          return "Quarta";
        }
      case 'Thursday':
        {
          return "Quinta";
        }
      case 'Friday':
        {
          return "Sexta";
        }
      case 'Saturday':
        {
          return "Sábado";
        }
      case 'Sunday':
        {
          return "Domingo";
        }
    }
    return "";
  }

  int getIndex(String dia){
    switch (dia) {
      case 'Segunda':
        {
          return 1;
        }
      case 'Terça':
        {
          return 2;
        }
      case 'Quarta':
        {
          return 3;
        }
      case 'Quinta':
        {
          return 4;
        }
      case 'Sexta':
        {
          return 5;
        }
      case 'Sábado':
        {
          return 6;
        }
      case 'Domingo':
        {
          return 0;
        }
    }
    return 7;
  }

  DateTime getDayIn(DateTime date){
    String diaSemana = getDiaSemana(date);
    int indexDia = getIndex(diaSemana);
    DateTime diaInicio = date.subtract(Duration(days: indexDia));
    return diaInicio;
  }

  bool getDataValida(DateTime data){
    DateTime hoje = DateTime.now();
    if (data.year>hoje.year) {
      return true;
    } else{
      if (data.month>hoje.month) {
        return true;
      } else{
        if ((data.month==hoje.month)&&(data.day>=hoje.day)){
            return true;
        }
      }
    }
    print(data.month.toString()+" "+hoje.month.toString());
    print(data.day.toString()+" "+hoje.day.toString());
    print("---");
    return false;
  }

  List<Widget> listCalendario(double width, double heigth, DateTime dataAtual){
    List<String> diasProf = [];
    print("diasProfissional.length ${diasProfissional.length}");
    diasProfissional.forEach((element) {
      print(element.dia!);
      diasProf.add(element.dia!);
    });
    DateTime diaInicio = getDayIn(dataAtual);

    List<Widget> result = [];
    for (int j=0;j<6;j++) {
      for (int i = 0; i < 7; i++) {
        result.add(
            (diasProf.contains(
                getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)))
                    .toUpperCase())
                && (getDataValida(diaInicio.add(Duration(days: (7 * j) + i))))
            ) ?
            //dia de trabalho do profissional
            InkWell(
              onTap: () async {
                await Provider.of<DiasSalasProfissionaisProvider>
                  (context, listen: false).getHorariosDoDiaByProfissional
                  (profissionalSelecionado!.id1,
                    getDiaSemana(diaInicio.add(Duration(days: (7 * j) + i)))
                        .toUpperCase())
                    .then((value) async {
                  if (servicoSelecionado!.qtd_sessoes ==
                      _datasSelecionadas.length) {
                    showSnackBar("Sessões cadastradas.");
                  } else {
                    diasSalasProfissional = value;
                    diasSalasProfissional.sort((a, b) =>
                        a.hora!.compareTo(b.hora!));
                    _dataSelecionada =
                        diaInicio.add(Duration(days: (7 * j) + i));
                    await Provider.of<SessaoProvider>(context, listen: false)
                        .getListSessoesDoDiaByProfissional(
                          UtilData.obterDataDDMMAAAA(_dataSelecionada),
                          profissionalSelecionado!.id1)
                        .then((value) {
                        sessoesProfissional = value;
                    });
                    _selectData = true;
                    // _botaoAvancar=true;
                    setState(() {});
                  }
                });
              },
              child: Card(
                child:

                Container(
                    height: heigth,
                    width: width,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(4.0)
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: heigth/2,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(diaInicio
                              .add(Duration(days: (7 * j) + i))
                              .day
                              .toString(),style: AppTextStyles.subTitleWhite16),
                          ),
                        ),
                        SizedBox(
                          height: heigth/2,
                          width: width,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(getMes(diaInicio
                              .add(Duration(days: (7 * j) + i))
                              .month).substring(0, 3),style: AppTextStyles.subTitleWhite16),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            )
                :
            Card(
              child: Container(
                  height: heigth,
                  width: width,
                  decoration: BoxDecoration(
                    color: (getDataValida(
                        diaInicio.add(Duration(days: (7 * j) + i)))) ?
                    AppColors.labelWhite.withOpacity(0.6) : AppColors.line.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4.0)
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: heigth*0.4,
                        width: width*0.4,
                        child:
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(diaInicio
                              .add(Duration(days: (7 * j) + i))
                              .day
                              .toString()),
                        )
                      ),
                      SizedBox(
                          height: heigth*0.4,
                          width: width*0.4,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(getMes(diaInicio
                                .add(Duration(days: (7 * j) + i))
                                .month).substring(0, 3)),
                          ),
                      )
                    ],
                  )
              ),
            )

        );
      }
    }
    return result;
  }

  Widget selectDataSessao(Size size)  {
    List<String> dias = [
      "DOMINGO",
      "SEGUNDA",
      "TERÇA",
      "QUARTA",
      "QUINTA",
      "SEXTA",
      "SÁBADO"
    ];
    DateTime dataAtual = DateTime.now();
    late int mesAtual = DateTime
        .now()
        .month;
    late int anoAtual = DateTime
        .now()
        .year;
    List<Widget> widgets = listCalendario(
        size.width * 0.035, size.height * 0.05, dataAtual);
    return Container(
        height: size.height * 0.7,
        width: size.width * 0.3,
        color: AppColors.shape,
        child: Column(
          children: [
            StatefulBuilder(builder: (parentContext, setState) {
              return Column(
                children: [
                  //mes + icones 0.05
                  SizedBox(
                      height: size.height * 0.05,
                      width: size.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(padding: EdgeInsets.only(left: 4.0),
                            child: Text("${getMes(mesAtual)}/${anoAtual}"),

                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (anoAtual > DateTime.now().year) {
                                    if (mesAtual == 1) {
                                      mesAtual = 12;
                                      anoAtual--;
                                    } else {
                                      mesAtual--;
                                    }
                                  } else {
                                    if (mesAtual > DateTime.now().month) {
                                      mesAtual--;
                                    }
                                  }
                                  print(mesAtual);
                                  print(anoAtual);
                                  dataAtual = DateTime(anoAtual, mesAtual, 1);
                                  widgets = listCalendario(
                                      size.width * 0.035, size.height * 0.05,
                                      dataAtual);
                                  setState(() {});
                                },
                                child:Container(
                                  width: size.width*0.04,
                                  height: size.height*0.03,
                                  alignment: Alignment.center,
                                  // margin: EdgeInsets.all(100.0),
                                  decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle
                                  ),
                                  child: Icon(
                                      size: size.height*0.03,
                                      Icons.arrow_left_outlined),
                              ),),
                              InkWell(
                                onTap: () {
                                  if (mesAtual == 12) {
                                    mesAtual = 1;
                                    anoAtual++;
                                  } else {
                                    mesAtual++;
                                  }
                                  print(mesAtual);
                                  print(anoAtual);
                                  dataAtual = DateTime(anoAtual, mesAtual, 1);
                                  widgets = listCalendario(
                                      size.width * 0.035, size.height * 0.05,
                                      dataAtual);
                                  setState(() {});
                                },
                                child: Container(
                                  width: size.width*0.04,
                                  height: size.height*0.03,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle
                                  ),
                                  child: Icon(
                                      size:  size.height*0.03,
                                      Icons.arrow_right_outlined),
                              ),),

                            ],
                          )
                          // })
                        ],
                      )
                  ),
                  //Dias da semana 0.07
                  SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var items in dias)
                          Card(
                            elevation: 8,
                            color: AppColors.green,
                            child: Container(
                              height: size.height * 0.05,
                              width: size.width * 0.035,
                              color: AppColors.secondaryColor,
                              child: Center(
                                child: Text(items.substring(0, 3),
                                  style: AppTextStyles.labelBlack16Lex,),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //calendário 0.4
                  SizedBox(
                      height: size.height * 0.4,
                      width: size.width * 0.3,
                      child: Column(
                          children: [
                            for (int j = 0; j < 6; j++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  for (int i = 0; i < 7; i++)
                                    widgets[(j * 7) + i],
                                ],)
                          ]
                      )
                  ),
                ],
              );
            }),

            //horários 0.2
            (_selectData) ?
            SizedBox(
                height: size.height * 0.2,
                width: size.width * 0.3,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 10),
                      child: Text("Data: ${UtilData.obterDataDDMMAAAA(
                          _dataSelecionada)}"),
                    ),
                    //horarios
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        for(var items in diasSalasProfissional)
                          (contemAgendamento(items.hora!))?
                          Container(
                              height: size.height * 0.05,
                              width: size.width * 0.045,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: AppColors.labelWhite,
                                border: Border.all(color: AppColors.line)

                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Text(items.hora!),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                    child: FittedBox(fit: BoxFit.contain,
                                      child: Text("OCUPADO"),

                                    )
                                  )
                                ],
                              )
                          )
                              :
                          InkWell(
                            onTap: () async {
                                bool result = false;
                                if (_datasSelecionadas.contains(
                                    UtilData.obterDataDDMMAAAA(
                                        _dataSelecionada))) {
                                  result = true;
                                  showSnackBar(
                                      "Já existe uma sessão cadastrada nesta data.");
                                }
                                await Provider.of<SessaoProvider>(context, listen: false)
                                    .existeSessaoByData(UtilData.obterDataDDMMAAAA(
                                    _dataSelecionada), pacienteSelecionado!.id1,items.hora!).then((value) {

                                      print("provider value = ${items.hora!}");
                                      print("provider value = $value");
                                      result= value;
                                });
                                if (result == true){
                                  showSnackBar(
                                      "Já existe uma sessão agendada para este paciente "
                                          "nesta data e hora com outro profissional."
                                          " Tente um novo horário.");
                                } else if (servicoSelecionado!.qtd_sessoes! >
                                    _datasSelecionadas.length)
                                {
                                  _horariosSelecionadas.add(items.hora!);
                                  _salasSelecionadas.add(items.sala!);
                                  _datasSelecionadas.add(
                                      UtilData.obterDataDDMMAAAA(
                                          _dataSelecionada));
                                  //data inserida é maior que a ultima data?
                                  if (_datasSelecionadas.length>1){
                                    int diaAtual =0;
                                    int diaProximo = int.parse(_datasSelecionadas[_datasSelecionadas.length-1].substring(0,2));
                                    int mesAtual=0;
                                    int mesProximo = int.parse(_datasSelecionadas[_datasSelecionadas.length-1].substring(3,5));
                                    String auxData, auxHora = "";
                                    for (int i =0; i<_datasSelecionadas.length-1;i++){
                                      diaAtual = int.parse(_datasSelecionadas[i].substring(0,2));
                                      mesAtual = int.parse(_datasSelecionadas[i].substring(3,5));
                                      // diaProximo = int.parse(_datasSelecionadas[i+1].substring(0,2));
                                      // mesProximo = int.parse(_datasSelecionadas[i+1].substring(3,5));
                                      if ( (mesProximo<mesAtual) || ( (mesProximo==mesAtual)&&(diaProximo<diaAtual) ) ){
                                          print("trocou $i");
                                          auxData = _datasSelecionadas[_datasSelecionadas.length-1];
                                          auxHora = _horariosSelecionadas[_datasSelecionadas.length-1];
                                          for (int j = _datasSelecionadas.length-1; j>i ; j--){
                                            print("$j ${ _datasSelecionadas[j]} = ${j-1} ${ _datasSelecionadas[j-1]}");
                                            _datasSelecionadas[j]=_datasSelecionadas[j-1];
                                            _horariosSelecionadas[j]=_horariosSelecionadas[j-1];
                                          }
                                          _datasSelecionadas[i]=auxData;
                                          _horariosSelecionadas[1]=auxHora;
                                          break;
                                      }else {
                                        print("não trocou");
                                        print("diaProximo $diaProximo diaatual $diaAtual");
                                      }
                                    }

                                    // int dia1 = int.parse(_datasSelecionadas[_datasSelecionadas.length-1].substring(0,2));
                                    // int dia0 = int.parse(_datasSelecionadas[_datasSelecionadas.length-2].substring(0,2));
                                    // int mes1 = int.parse(_datasSelecionadas[_datasSelecionadas.length-1].substring(3,5));
                                    // int mes0 = int.parse(_datasSelecionadas[_datasSelecionadas.length-2].substring(3,5));
                                    // print(dia1);
                                    // print(mes1);
                                    // if ( (mes1<mes0) || ( (mes1==mes0)&&(dia1<dia0) ) ){
                                    //   String auxData = _datasSelecionadas[_datasSelecionadas.length-2];
                                    //   String auxHora = _horariosSelecionadas[_datasSelecionadas.length-2];
                                    //   _datasSelecionadas[_datasSelecionadas.length-2]= _datasSelecionadas[_datasSelecionadas.length-1];
                                    //   _datasSelecionadas[_datasSelecionadas.length-1]= auxData;
                                    //   _horariosSelecionadas[_datasSelecionadas.length-2]= _horariosSelecionadas[_datasSelecionadas.length-1];
                                    //   _horariosSelecionadas[_datasSelecionadas.length-1]= auxHora;
                                    // }

                                  }

                                  _selectData = false;
                                }
                                if (_datasSelecionadas.length==servicoSelecionado!.qtd_sessoes){
                                  _botaoAvancar = true;
                                }
                                print('setstate');
                                setState(() {});
                            },
                            child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.045,
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor2, 
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(color: AppColors.line)
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(items.hora!),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                      child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(items.sala!),
                                    )
                                    ),
                                  ],
                                )
                            ),
                          ),
                      ],
                    ),
                  ],
                )
            )
                :
            (servicoSelecionado!.qtd_sessoes == _datasSelecionadas.length) ?
            SizedBox(
              height: size.height * 0.2,
              width: size.width * 0.28,
              child: Text("Clique em AVANÇAR para prosseguir"),
            ):
            SizedBox(
              height: size.height * 0.2,
              width: size.width * 0.28,
              child: Text("Selecione a data da ${_datasSelecionadas.length+1}° sessão"),
            ),
          ],
        )
    );
  }

  bool contemAgendamento(String hora){
    print("Contem $hora");
    print(sessoesProfissional.length);
    bool result = false;

    if (sessoesProfissional.length==0){
      return false;
    } else{
     sessoesProfissional.forEach((element) {
       if (element.horarioSessao!.compareTo(hora)==0){
           result = true;
           print(element.id1);
       }
     });
    }
    print(result);
    return result;
  }

  Widget selectServico(Size size) {
    return (servicosProfissionalFinal.length==0)?
    Container(
      height: size.height*0.7,
      width: size.width*0.3,
      color: AppColors.shape,
      child: Center(
        child: Text("Não possui Serviço cadastrado"))
    ):
    Container(
      height: size.height*0.7,
      width: size.width*0.3,
      color: AppColors.shape,
      child: Column(
            children: [

              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.08,
                child: Center(
                  child: Text("Selecione o SERVIÇO", style: AppTextStyles.subTitleBlack16,),
                ),
              ),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.48,
                 child: SingleChildScrollView(

                    child: Column(
                      children: [
                        for (var items in servicosProfissionalFinal)
                          Card(
                            child: ListTile(
                              onTap: ()async{
                                // pacienteSelecionado = items;
                                servicoProfissional = items;
                                _valorSessao = items.valor!;
                                valorPendente = _valorSessao;
                                String valorSessao = _valorSessao.substring(0,_valorSessao.length-3);
                                _comissaoProfissional = (double.parse(valorSessao)*0.7).toStringAsFixed(2).replaceAll('.', ',');
                                _comissaoClinica = (double.parse(valorSessao)*0.3).toStringAsFixed(2).replaceAll('.', ',');
                                servicoSelecionado = await getServicoSelecionado(items.idServico!);
                                _selectServico = true;
                                _botaoAvancar=true;
                                print(_selectServico);
                                setState((){});
                              },
                              title: FutureBuilder(
                                  future: getDescServico(items.idServico!),
                                  builder: (BuildContext parentContext, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data);
                                    }else {
                                      return Center(
                                          child: Text("")
                                      );
                                    }

                                }
                              ),
                              // title: Text("${getDescServico(items.idServico!)}"),
                              subtitle: Text("Valor: ${items.valor}"),
                            ),
                          )
                      ],
                    ),
                  ),
              ),
              //botão avançar
              // SizedBox(
              //   height: size.height*0.08,
              //   width: size.width*0.28,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         (_selectServico)?
              //         InkWell(
              //           onTap: () async{
              //             _flag++;
              //             await Provider.of<DiasProfissionalProvider>
              //               (context, listen: false)
              //                 .getDiasProfissionalByIdProfissional(profissionalSelecionado!.id1).then((value) => diasProfissional=value);
              //             setState((){});
              //           },
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(6.0),
              //             child: Container(
              //               color: AppColors.primaryColor,
              //
              //               child:Icon(
              //                 Icons.arrow_right_alt,
              //                 color: AppColors.labelWhite,
              //               ),),
              //           ),
              //         ) :
              //         ClipRRect(
              //           borderRadius: BorderRadius.circular(6.0),
              //           child: Container(
              //             color: AppColors.labelBlack.withOpacity(0.6),
              //             child: Icon(
              //               Icons.arrow_right_alt,
              //               color: AppColors.labelWhite,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        );
  }

  Widget selectFormaPagamento( Size size){


    List<DropdownMenuItem<String>> getDropdownTiposPagamento(
        List<TipoPagamento> list) {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (int i = 0; i < list.length; i++) {
        var newDropdown = DropdownMenuItem(
          value: list[i].descricao.toString(),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(list[i].descricao.toString()),
          )
        );
        dropDownItems.add(newDropdown);
      }
      return dropDownItems;
    }
    bool _avancar = false;
    // String
    String _valorAtual = "0,00";


    // List<String> listFormaPagamentos = [];
    List<TipoPagamento> list = tiposPagamento;
    // List<List<TipoPagamento>> listTipos = [];
    // listTipos.add(tiposPagamento);
    // listValores.add("0,00");
    listTxtController.add(TextEditingController());

    bool EMaiorIgual(String a, String b){
      if (double.parse(a.replaceAll(',','.'))>=double.parse(b.replaceAll(',','.'))){
        return true;
      }
      return false;
    }
    bool EMaior(String a, String b){
      if (double.parse(a.replaceAll(',','.'))>double.parse(b.replaceAll(',','.'))){
        return true;
      }
      return false;
    }
    return Container(
      height: size.height*0.7,
      width: size.width*0.3,
      color: AppColors.shape,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatefulBuilder(
                builder: (context,set){
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width*0.05),
                    child: Row(
                      children: [
                        Checkbox(
                            value: _check2,
                            onChanged: (bool? value){
                              _check1 = false;
                              _check2 = !_check2;
                              if (_check1|_check2){
                                _isButtonDisabled = false;
                              } else {
                                _isButtonDisabled = true;
                              }
                              print(_isButtonDisabled);
                              print("check2 aaa $_check2");
                              setState((){});
                            }),
                        Text("Efetuar pagamento no dia da sessão."),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width*0.05),
                    child:
                        Row(
                          children: [
                            Checkbox(
                              value: _check1,
                              onChanged: (bool? value){
                                  print("value = ${value!}");
                                  _check1=!_check1;
                                  _check2=false;
                                  if (_check1|_check2){
                                    _isButtonDisabled = false;
                                  }  else {
                                    _isButtonDisabled = true;
                                  }
                                  print(_isButtonDisabled);
                                  print("check1 bbb $_check1");
                                setState((){});
                            }),
                            Text("Efetuar pagamento agora."),
                          ],
                        ),
                  ),
                ],
              );
            }),
            (_check1)?
              Column(
                children: [
                  //checkbox tipo de pagamento
                  Row(
                    children: [
                      SizedBox(
                        width: size.width*0.13,
                        height: size.height*0.065,
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width*0.02,
                              height: size.height*0.065,
                              child: Checkbox(
                                  value: !_checkSocial,
                                  onChanged:(!avancarPagamento)? (bool? value){
                                    if(_checkSocial) {
                                      print("entrou");
                                      socialFinalizado=true;
                                      _isButtonDisabled = false;

                                    } else {
                                      socialFinalizado=false;
                                      _isButtonDisabled = true;

                                    }

                                    _checkSocial = !value!;
                                    setState((){});
                                  }:null),
                            ),
                            SizedBox(
                                width: size.width*0.11,
                                height: size.height*0.065,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("SEM desconto social."),
                                )
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width*0.13,
                        height: size.height*0.065,
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width*0.02,
                              height: size.height*0.065,
                              child: Checkbox(

                                  value: _checkSocial,
                                  onChanged: (!avancarPagamento)?
                                      (bool? value){
                                    _checkSocial = !_checkSocial;
                                    socialFinalizado = false;
                                    if (_checkSocial){
                                      print("entrou111");
                                      _isButtonDisabled = true;
                                    } else {
                                      _isButtonDisabled = false;
                                      socialFinalizado = true;
                                    }

                                    setState((){});
                                  }:null),

                            ),
                            SizedBox(
                              width: size.width*0.11,
                              height: size.height*0.065,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                  child: Text("COM desconto social."),
                              )
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                  (_checkSocial )?
                      Container(
                      // color: AppColors.red,
                      height: size.height*0.2,
                      width: size.width*0.3,
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            //clínica
                            SizedBox(
                              // color: AppColors.blue,
                                height: size.height*0.1,
                                width: size.width*0.3,
                                child:  Row(
                                  children: [
                                    //comissão clínica
                                    Container(
                                        height: size.height*0.06,
                                        width: size.width*0.074,
                                        decoration: BoxDecoration(
                                            color: AppColors.shape,
                                            borderRadius: BorderRadius.circular(6.0)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(" CLÍNICA ", style: AppTextStyles.labelBlack14Lex,),
                                              ),
                                              Text("R\$ "+_comissaoClinica, style: AppTextStyles.labelBlack14Lex,),

                                            ],
                                          ),
                                        )
                                    ),
                                    //desconto clínica
                                    Container(
                                      height: size.height*0.1,
                                      width: size.width*0.15,
                                      child: InputTextWidgetMask(
                                        enable: enableClinica,
                                        label: "DESCONTO CLINICA",
                                        icon: Icons.business_outlined,
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        backgroundColor: (enableClinica)?AppColors.labelWhite:AppColors.secondaryColor,
                                        borderColor: AppColors.line,
                                        textStyle: AppTextStyles.subTitleBlack12,
                                        iconColor: AppColors.labelBlack,
                                        input: CentavosInputFormatter(),
                                        controller: txt1,

                                        validator: (value) {
                                          if ((value!.isEmpty) || (value == null)) {
                                            return 'Insira um VALOR';
                                          }
                                          if (value.length<4){
                                            return 'VALOR inválido';

                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.length>_comissaoClinica.length){
                                            txt1.text = "0,00";
                                            _comissaoFinalClinica = _comissaoClinica;
                                            _descontoClinica = "0,00";
                                          } else {
                                            if (value.length>0){
                                              String result = value;
                                              double valorInput = double.parse(result.replaceAll(',','.'));
                                              double comissaoClinica = double.parse(_comissaoClinica.replaceAll(',','.'));
                                              if (comissaoClinica < valorInput){
                                                txt1.text = "0,00";
                                                _comissaoFinalClinica = _comissaoClinica;
                                              } else {
                                                _descontoClinica = double.parse(result.replaceAll(',', '.')).toString();
                                                _comissaoFinalClinica = (double.parse(_comissaoClinica.replaceAll(',', '.'))-double.parse(_descontoClinica)).toStringAsFixed(2).replaceAll('.', ',');
                                                _descontoClinica = double.parse(result.replaceAll(',', '.')).toStringAsFixed(2).replaceAll('.', ',');
                                                // ;;;
                                              }

                                              setState((){});
                                            }
                                          }


                                        },
                                      ),
                                    ),
                                    //comissao final Clínica
                                    (enableClinica)?
                                    Container(
                                      height: size.height*0.6,
                                      width: size.width*0.075,
                                      child: Center(
                                        child: IconButton(
                                          onPressed:(){
                                            if (_descontoClinica.compareTo("0,00")==0){
                                               txt1.text="0,00";
                                               _comissaoFinalClinica = _comissaoClinica;
                                            }
                                            enableClinica=false;
                                            enableProfissional=true;
                                            setState((){});
                                          },
                                          icon: Icon(Icons.add_circle),
                                        ),
                                      ),
                                    )
                                        :
                                    Container(
                                        height: size.height*0.6,
                                        width: size.width*0.075,

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(" COMISSÃO FINAL ", style: AppTextStyles.labelBlack14Lex,),
                                            ),
                                            Text("R\$ "+_comissaoFinalClinica, style: AppTextStyles.labelBlack14Lex,),

                                          ],
                                        )
                                    ),
                                  ],
                                )
                            ),
                            //profissional
                            SizedBox(
                              // color: AppColors.red,
                                height: size.height*0.1,
                                width: size.width*0.3,
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //comissão profissional
                                    Container(
                                        height: size.height*0.06,
                                        width: size.width*0.074,
                                        decoration: BoxDecoration(
                                            color: AppColors.shape,
                                            borderRadius: BorderRadius.circular(6.0)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                          child: Column(
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("PROFISSIONAL", style: AppTextStyles.labelBlack14Lex,),
                                                ),
                                                Text("R\$ "+_comissaoProfissional, style: AppTextStyles.labelBlack14Lex,),
                                              ]
                                          ),
                                        )
                                    ),
                                    //desconto profissional
                                    SizedBox(
                                      height: size.height*0.1,
                                      width: size.width*0.15,
                                      child: InputTextWidgetMask(
                                        enable: enableProfissional,
                                        label: "DESCONTO PROFISSIONAL",
                                        icon: Icons.person_pin,
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        backgroundColor: enableProfissional?AppColors.labelWhite:AppColors.secondaryColor,
                                        borderColor: AppColors.line,
                                        textStyle: AppTextStyles.subTitleBlack12,
                                        iconColor: AppColors.labelBlack,
                                        input: CentavosInputFormatter(),
                                        controller: txt2,
                                        validator: (value) {
                                          if ((value!.isEmpty) || (value == null)) {
                                            return 'Insira um VALOR';
                                          }
                                          if (value.length<4){
                                            return 'VALOR inválido';

                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.length>_comissaoProfissional.length){
                                            txt2.text = "0,00";
                                            _comissaoFinalProfissional = _comissaoProfissional;
                                            _descontoProfissional = "0,00";
                                          }  else {
                                            if (value.length>0){
                                              String result = value;
                                              double valorInput = double.parse(result.replaceAll(',','.'));
                                              double comissaoProfissional = double.parse(_comissaoProfissional.replaceAll(',','.'));
                                              if (comissaoProfissional < valorInput){
                                                print("ultrapassou $comissaoProfissional $valorInput");
                                                txt2.text = "0,00";
                                                _comissaoFinalProfissional = _comissaoProfissional;
                                              } else {
                                                print("permitido $comissaoProfissional $valorInput");

                                                _descontoProfissional = double.parse(result.replaceAll(',', '.')).toString();
                                                _comissaoFinalProfissional = (double.parse(_comissaoProfissional.replaceAll(',', '.'))
                                                    -double.parse(_descontoProfissional)).toStringAsFixed(2).replaceAll('.', ',');
                                                _descontoProfissional = double.parse(result.replaceAll(',', '.')).toStringAsFixed(2).replaceAll('.', ',');

                                              }

                                              setState((){});
                                            }
                                          }


                                        },
                                      ),
                                    ),
                                    //comissão final Profissional
                                    (enableProfissional)?
                                    SizedBox(
                                      height: size.height*0.6,
                                      width: size.width*0.075,
                                      child: IconButton(
                                        onPressed: (){
                                          // if (_descontoClinica.length)
                                          if (_descontoProfissional.compareTo("0,00")==0){
                                            txt2.text="0,00";
                                            _comissaoFinalProfissional = _comissaoProfissional;
                                          }
                                          enableProfissional=false;
                                          socialFinalizado=true;
                                          avancarPagamento=true;
                                          _isButtonDisabled = false;
                                          setState((){});
                                        },
                                        icon: Icon(Icons.add_circle),
                                      ),
                                    ):
                                    SizedBox(
                                        height: size.height*0.6,
                                        width: size.width*0.075,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:[
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("COMISSÃO FINAL", style: AppTextStyles.labelBlack14Lex,),
                                              ),
                                              Text("R\$ "+_comissaoFinalProfissional, style: AppTextStyles.labelBlack14Lex,),

                                            ]
                                        )
                                    ),

                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  )
                      :
                      Container(
                        // color: AppColors.green,
                        height: size.height*0.2,
                        width: size.width*0.3,),
                  //check desconto
                  (socialFinalizado)?
                  Row(
                    children: [
                      //UNICO
                      SizedBox(
                        height: size.height*0.06,
                        width: size.width*0.15,
                        child: Row(
                          children: [
                            Checkbox(
                                value: !_checkPagamentoVariado,
                                onChanged: (bool? value){
                                  print("check = ${_checkPagamentoVariado}");
                                  if (_checkPagamentoVariado){
                                    _isButtonDisabled = true;
                                    print("removeu");
                                    listTxtController.clear();
                                    listDropdownFirst.clear();
                                    listDropdownFirst.add(list.first.descricao);
                                    listEnable.clear();
                                    listValores.clear();
                                    listValores.add("0,00");
                                    listTxtController.add(TextEditingController());
                                    listEnable.add(true);
                                    print(listTxtController.length);
                                    _checkPagamentoVariado  = !value!;
                                    // avancarPagamento=false;
                                    print(_checkPagamentoVariado);
                                  } else {
                                    print(listEnable.length);
                                    if (listEnable.length==1){
                                      print("adicionou");
                                      avancarPagamento=true;

                                      listEnable.add(false);

                                      listDropdownFirst.add(list.first.descricao);

                                      print("adicionou ${listEnable.length}");
                                      listTxtController.add(TextEditingController());
                                      print(listTxtController.length);
                                      _checkPagamentoVariado  = !value!;
                                      print(_checkPagamentoVariado);

                                      setState((){});
                                    }
                                  }
                                  // _checkPagamentoVariado = !value!;
                                  setState((){});
                                }),
                            Text("PAGAMENTO ÚNICO"),
                          ],
                        )
                      ),
                      //VARIADO
                      SizedBox(
                          height: size.height*0.06,
                          width: size.width*0.15,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: _checkPagamentoVariado,
                                  onChanged: (bool? value){
                                    //se estiver selecionado remove
                                    print("check = ${_checkPagamentoVariado}");
                                    if (_checkSocial){
                                      valorPendente = getValorComDesconto();
                                    } else {
                                      valorPendente = _valorSessao;
                                    }
                                    print(valorPendente);
                                    if (_checkPagamentoVariado){
                                      _isButtonDisabled = false;
                                      print("removeu");
                                      listTxtController.clear();
                                      listEnable.clear();
                                      listValores.clear();
                                      listValores.add("0,00");
                                      listDropdownFirst.clear();
                                      listDropdownFirst.add(list.first.descricao);
                                      listTxtController.add(TextEditingController());
                                      listEnable.add(true);
                                      print(listTxtController.length);
                                      _checkPagamentoVariado  = value!;
                                      // avancarPagamento=false;
                                      print(_checkPagamentoVariado);

                                      setState((){});

                                    }else {
                                      _isButtonDisabled = true;

                                      print(listEnable.length);
                                      print(listDropdownFirst.length);
                                      if (listEnable.length==1){

                                        print("adicionou");
                                        avancarPagamento=true;
                                        listEnable.add(false);
                                        listDropdownFirst.add(list.first.descricao);

                                        print("adicionou ${listEnable.length}");
                                        listTxtController.add(TextEditingController());
                                        print(listTxtController.length);
                                        _checkPagamentoVariado  = value!;
                                        print(_checkPagamentoVariado);

                                        setState((){});
                                      }


                                    }



                                  }),
                              Text("PAGAMENTO VARIADO"),
                            ],
                          )
                      ),

                    ],
                  ):
                  SizedBox(
                    height: size.height*0.06,
                    width: size.width*0.3,
                  ),
                  
                  ((_checkPagamentoVariado)&& (socialFinalizado))?
                  Container(
                    // color: AppColors.green,
                    height: size.height*0.24,
                    width: size.width*0.3,
                    child: ListView.builder(
                        itemCount: listEnable.length,
                        itemBuilder: (BuildContext, index){
                          print("listVier ${listEnable.length} $index");
                          print("listDropdownFirst ${listDropdownFirst.length} $index");
                          print(listDropdownFirst[index]);
                          return SizedBox(
                            height: size.height*0.06,
                            width: size.width*0.3,
                            child: (listEnable[index])?
                            Row(
                              children: [
                                //dropDownBox
                                (listEnable[index])?
                                Container(
                                    // color: AppColors.primaryColor,
                                    height: size.height*0.06,
                                    width: size.width*0.13,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: size.width*0.001),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: DropdownButton<String>(
                                          value: listDropdownFirst[index],
                                          icon: const Icon(Icons.arrow_drop_down_sharp),
                                          elevation: 8,
                                          style: TextStyle(color: AppColors.labelBlack),
                                          underline: Container(
                                            height: 2,
                                            color: AppColors.line,
                                          ),
                                          onChanged:(listEnable[index])? (String? newValue) {
                                            setState(() {
                                              listDropdownFirst[index] = newValue!;
                                              print(listDropdownFirst[index]);
                                              print(index);


                                              // _dropdown = newValue!;
                                            });
                                          }: null,
                                          items: getDropdownTiposPagamento(list),
                                        ),
                                      ),
                                    )
                                )
                                    :
                                SizedBox(
                                  height: size.height*0.06,
                                  width: size.width*0.13,
                                  child: Text(listDropdownFirst[index]),
                                ),
                                //valor
                                Container(
                                  // color: AppColors.secondaryColor,
                                  height: size.height*0.06,
                                  width: size.width*0.14,
                                  child: InputTextWidgetMask(
                                    // key: Key(_valorAtual.toString()),
                                    enable: listEnable[index],
                                    // enable: true,
                                    label: "VALOR",
                                    icon: Icons.monetization_on_outlined,
                                    validator: (value) {
                                      if ((value!.isEmpty) || (value == null)) {
                                        return 'Insira um valor';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {

                                      if (value.compareTo("0,00")==0) {
                                        print ("entrou");
                                        setState((){
                                          print("setStat");
                                          _valorAtual = value;
                                        });
                                      } else {
                                        print(value);
                                        print("listValores ${listValores.length}");
                                        print(index);
                                      }
                                      listValores[index]=value;
                                      _valorAtual = value;
                                      if (_checkSocial) {
                                        print("desconto social");
                                        String valorComDesconto ="";
                                        if (index==0){
                                          valorComDesconto = getValorComDesconto();
                                          // valorComDesconto = (double.parse(_valorSessao.replaceAll(',', '.'))-(double.parse(_descontoProfissional.replaceAll(',', '.'))+double.parse(_descontoClinica.replaceAll(',', '.'))) ).toStringAsFixed(2).replaceAll('.',',');
                                          if ((value.length>valorComDesconto.length)
                                            ///fazer comparação
                                            ||(EMaiorIgual(value,valorPendente)))
                                          {
                                            listValores[index]="0,00";
                                            listTxtController[index].text = "0,00";
                                            setState((){});
                                          }else{
                                            if (value.length>0){
                                              String result = value;
                                              double valorInput = double.parse(result.replaceAll(',','.'));
                                              double sessao1 = double.parse(valorComDesconto.replaceAll(',','.'));
                                              if (sessao1<valorInput){
                                                print("ultrapassou $sessao1 < $valorInput");
                                                listTxtController[index].text = "0,00";
                                                listValores[index]="0,00";
                                                _comissaoFinalClinica = _comissaoClinica;
                                              }   else {
                                                print("não ultrapassou $sessao1 > $valorInput");
                                              }
                                            }
                                          }
                                        } else {
                                          valorComDesconto = getValorComDesconto();
                                          // valorComDesconto = (double.parse(valorPendente.replaceAll(',', '.'))-(double.parse(_descontoProfissional.replaceAll(',', '.'))+double.parse(_descontoClinica.replaceAll(',', '.'))) ).toStringAsFixed(2).replaceAll('.',',');
                                          if ((value.length>valorComDesconto.length)
                                              ///fazer comparação
                                              ||(EMaior(value,valorPendente)))
                                          {
                                            listValores[index]="0,00";
                                            listTxtController[index].text = "0,00";
                                            setState((){});
                                          }else{
                                            if (value.length>0){
                                              String result = value;
                                              double valorInput = double.parse(result.replaceAll(',','.'));
                                              double sessao1 = double.parse(valorComDesconto.replaceAll(',','.'));
                                              if (sessao1<valorInput){
                                                print("ultrapassou $sessao1 < $valorInput");
                                                listTxtController[index].text = "0,00";
                                                listValores[index]="0,00";
                                                _comissaoFinalClinica = _comissaoClinica;
                                              }   else {
                                                print("não ultrapassou $sessao1 > $valorInput");
                                              }
                                            }
                                          }
                                        }


                                      }
                                      else{
                                        print("sem desconto social");
                                        print(_valorSessao);
                                        print(valorPendente);
                                        print("index $index");
                                        print("listValores ${listValores.length}");

                                        if (index==0){
                                          print("primeiro");
                                          if ((value.length>_valorSessao.length)
                                          ///fazer comparação
                                             ||(EMaiorIgual(value,valorPendente)))
                                          {
                                            print("EMaior");
                                            listValores[index]="0,00";
                                            listTxtController[index].text = "0,00";
                                            setState((){});
                                          } else {
                                            if (value.length>0){
                                              String result = value;
                                              double valorInput = double.parse(result.replaceAll(',','.'));
                                              double sessao = double.parse(_valorSessao.replaceAll(',','.'));
                                              if (sessao < valorInput){
                                                print("ultrapassssssou $sessao $valorInput");
                                                listTxtController[index].text = "0,00";
                                                listValores[index]="0,00";
                                                _comissaoFinalClinica = _comissaoClinica;
                                              }
                                            }
                                          }
                                        }
                                        else {
                                          print("segundo");
                                          if ((value.length>_valorSessao.length)
                                            ///fazer comparação
                                              ||(EMaior(value,valorPendente)))
                                          {
                                            print("EMaior");
                                            listValores[index]="0,00";
                                            listTxtController[index].text = "0,00";
                                            setState((){});
                                          }
                                          else {
                                            print("Emenor = $value");
                                            if (value.length>0){
                                              String result = value;
                                              double valorInput = double.parse(result.replaceAll(',','.'));
                                              double sessao = double.parse(_valorSessao.replaceAll(',','.'));
                                              if (sessao < valorInput){
                                                print("ultrapassssssou $sessao $valorInput");
                                                listTxtController[index].text = "0,00";
                                                listValores[index]="0,00";
                                                _comissaoFinalClinica = _comissaoClinica;
                                              }
                                            }
                                          }
                                        }

                                      }

                                    },
                                    controller:  listTxtController[index],
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                    backgroundColor: listEnable[index]?AppColors.shape : AppColors.secondaryColor,
                                    borderColor: AppColors.line,
                                    textStyle: AppTextStyles.subTitleBlack10,
                                    iconColor: AppColors.labelBlack,
                                    input: CentavosInputFormatter(),
                                    // initalValue: listValores[index],
                                  ),

                                ),
                                //botão
                                Container(
                                  // color: AppColors.yelow,
                                  height: size.height*0.06,
                                  width: size.width*0.03,
                                  child:
                                  (listEnable[index])?
                                  IconButton(
                                    onPressed: () {
                                      if (index<(listEnable.length-1)){
                                        print("index < listEnable.length");
                                        print(index);
                                        print(listEnable.length);
                                        if (listValores[index].compareTo("0,00")!=0){
                                          listEnable[index]=false;
                                          listEnable[index+1]=true;
                                          listTxtController.add(TextEditingController());
                                          if (listDropdownFirst[index].compareTo("DINHEIRO")==0){
                                            list.removeWhere((element) => element.descricao.compareTo("DINHEIRO")==0);
                                            print("removeu ${list.length}");
                                          }
                                          valorPendente  = ((double.parse(valorPendente.replaceAll(',','.')) - double.parse(listValores[index].replaceAll(',','.')))).toStringAsFixed(2).replaceAll('.',',');
                                          print("ListValores ${listValores.length}");
                                          listValores.add("0,00");
                                          print("ListValores ${listValores.length}");
                                          print("passa a vez");
                                          setState((){});

                                        } else {
                                          print("valor = 0,00");
                                        }

                                      } else {
                                        print("index > listEnable.length");
                                        if (valorPendente.compareTo(listValores[index])==0){
                                          print("valor pendente over");
                                          valorPendente = "0,00";
                                          listEnable[index]= false;
                                          _isButtonDisabled = false;
                                          setState((){});

                                        } else {
                                          print("valor pendente ${valorPendente} != ${listValores[index]}");

                                          print(listEnable.length);
                                          listEnable[index]=false;
                                          listEnable.add(true);
                                          listTxtController.add(TextEditingController());
                                          listValores.add("0,00");
                                          if (listDropdownFirst[index].compareTo("DINHEIRO")==0){
                                            list.removeWhere((element) => element.descricao.compareTo("DINHEIRO")==0);
                                            print("removeu ${list.length}");

                                          }
                                          listDropdownFirst.add(list.first.descricao);
                                          valorPendente  = ((double.parse(valorPendente.replaceAll(',','.')) - double.parse(listValores[index].replaceAll(',','.')))).toStringAsFixed(2).replaceAll('.',',');
                                          print("adiciona");
                                          print(listEnable.length);
                                          setState((){});
                                        }

                                      }



                                    },
                                    icon: Icon(Icons.add_circle),
                                  )
                                      :
                                  Icon(Icons.check_circle_rounded),
                                ),
                              ],
                            )
                                :
                            (index<=listValores.length-1)?
                            Row(
                               children: [
                                 SizedBox(
                                   height: size.height*0.06,
                                   width: size.width*0.13,
                                   child: FittedBox(
                                     fit: BoxFit.scaleDown,
                                     child: Text(listDropdownFirst[index],style: AppTextStyles.labelBlack14,),)
                                 ),
                                 SizedBox(
                                   height: size.height*0.06,
                                   width: size.width*0.14,
                                   child:  Center(
                                     child: Text(listValores[index], style: AppTextStyles.labelBlack14,),
                                   )
                                 ),
                                 SizedBox(
                                     height: size.height*0.06,
                                     width: size.width*0.03,
                                   child: Icon(Icons.check_circle_rounded)
                                 ),
                               ],
                            ):Center(),
                          );

                        }),
                  )
                      :
                  //pagamengto unico
                  (socialFinalizado)?
                  Container(
                    // color: AppColors.blue,
                    height: size.height*0.24,
                    width: size.width*0.3,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: size.height*0.06,
                        width: size.width*0.13,
                        child: Padding(
                          padding: EdgeInsets.only(left: size.width*0.001),
                          child: FittedBox(
                            // alignment: Alignment.topLeft,
                            fit: BoxFit.scaleDown,
                            child: DropdownButton<String>(
                              value: _dropdown,
                              icon: const Icon(Icons.arrow_drop_down_sharp),
                              elevation: 8,
                              style: TextStyle(color: AppColors.labelBlack),
                              underline: Container(
                                height: 2,
                                color: AppColors.line,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _dropdown = newValue!;
                                  print(_dropdown);
                                  // listDropdownFirst[index] = newValue!;
                                });
                              },
                              items: getDropdownTiposPagamento(tiposPagamento),
                            ),
                          ),
                        )
                      ),
                    )


                  ):
                  SizedBox(
                    height: size.height*0.24,
                    width: size.width*0.3,),
                ],
              ):
                Center(),
                //
                //               //descontos
                //
                //                   :
                //               Center(),

          ],
        )
    );
  }

  Widget searchWidget(int flag, Size size){
    switch (flag) {
      case 1:
        return selectPaciente(size);
      case 2:
        return selectProfissional(size);
      case 3:
        return selectServico(size);
      case 4:
        return selectDataSessao(size);
      case 5:
        return selectFormaPagamento(size);
    }
    return Center();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBarWidget2(nomeUsuario: _usuario.nomeUsuario!),
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
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  searchWidget(_flag, size),
                  Row(
                    children: [
                      //menu
                      SizedBox(
                        width: size.width*0.1,
                        height: size.height*0.7,
                        // color: AppColors.shape,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            // 1
                            InkWell(
                              onTap:
                              // (_flag>1)?(){
                              //   _flag=1;
                              //   print(_flag);
                              //   setState((){});
                              // }:
                              null,
                              child: Container(
                                  height: size.height*0.06,
                                  width: size.height*0.06,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                      border: Border.fromBorderSide(
                                          BorderSide(
                                            color: (_flag==1)?AppColors.primaryColor:AppColors.secondaryColor,
                                            width: 3,
                                          ),
                                      ),
                                  ),
                                  child: Center(child:Text("1", style: AppTextStyles.labelBold14,),)
                              ),
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(90 / 360),
                              child: new Text("-  -  -",style: AppTextStyles.labelBold14,),
                            ),
                            // Text("-  -  -",style: AppTextStyles.labelBold14,),
                            // 2
                            InkWell(
                              onTap:
                              // (_flag>2)?(){
                              //   _flag=2;
                              //   print(_flag);
                              //   setState((){});
                              // }:
                              null,
                              child: Container(
                                  height: size.height*0.06,
                                  width: size.height*0.06,
                                  decoration: BoxDecoration(
                                      color: (_flag==2)?AppColors.secondaryColor
                                          : (_flag<2)?AppColors.line:AppColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.fromBorderSide(
                                          BorderSide(
                                            color: (_flag==2)?AppColors.primaryColor:
                                            (_flag<2)?
                                            AppColors.line:AppColors.secondaryColor,
                                            width: 3,
                                          ),
                                      ),
                                  ),
                                  child: Center(child:Text("2", style: AppTextStyles.labelBold14,),)
                              ),
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(90 / 360),
                              child: new Text("-  -  -",style: AppTextStyles.labelBold14,),
                            ),
                            // 3
                            InkWell(
                              onTap:
                              // (_flag>3)?(){
                              //   _flag=3;
                              //   print(_flag);
                              //   setState((){});
                              // }:
                              null,
                              child: Container(
                                  height: size.height*0.06,
                                  width: size.height*0.06,
                                  decoration: BoxDecoration(
                                    color: (_flag==3)?AppColors.secondaryColor
                                        : (_flag<3)?AppColors.line:AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color: (_flag==3)?AppColors.primaryColor:
                                        (_flag<3)?
                                        AppColors.line:AppColors.secondaryColor,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Center(child:Text("3", style: AppTextStyles.labelBold14,),)
                              ),
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(90 / 360),
                              child: new Text("-  -  -",style: AppTextStyles.labelBold14,),
                            ),
                            // 4
                            InkWell(
                              onTap:
                              // (_flag>4)?(){
                              //   _flag=4;
                              //   print(_flag);
                              //   setState((){});
                              // }:
                              null,
                              child: Container(
                                  height: size.height*0.06,
                                  width: size.height*0.06,
                                  decoration: BoxDecoration(
                                    color: (_flag==4)?AppColors.secondaryColor
                                        : (_flag<4)?AppColors.line:AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color: (_flag==4)?AppColors.primaryColor:
                                        (_flag<4)?
                                        AppColors.line:AppColors.secondaryColor,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Center(child:Text("4", style: AppTextStyles.labelBold14,),)
                              ),
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(90 / 360),
                              child: new Text("-  -  -",style: AppTextStyles.labelBold14,),
                            ),
                            // 5
                            InkWell(
                              onTap:
                              // (_flag>5)?(){
                              //   _flag=5;
                              //   print(_flag);
                              //   setState((){});
                              // }:
                              null,
                              child: Container(
                                  height: size.height*0.06,
                                  width: size.height*0.06,
                                  decoration: BoxDecoration(
                                    color: (_flag==5)?AppColors.secondaryColor
                                        : (_flag<5)?AppColors.line:AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color: (_flag==5)?AppColors.primaryColor:
                                        (_flag<5)?
                                        AppColors.line:AppColors.secondaryColor,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Center(child:Text("5", style: AppTextStyles.labelBold14,),)
                              ),
                            ),
                            (_flag<5)?
                            botaoAvancar(size):Text(""),
                          ],
                        ),
                      ),

                      // (_flag<6)?
                      // botaoAvancar(size)
                      //     :
                       //salvar
                      // SizedBox(
                      //   height: size.height*0.15,
                      //   width: size.width*0.07,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //
                      //       SizedBox(
                      //         width: size.height*0.08,
                      //         height: size.height*0.08,
                      //         child: (_botaoAvancar)?
                      //         InkWell(
                      //           onTap: () async {
                      //             String idTransacao = "";
                      //             //inserindo transação
                      //             if (_check1){
                      //               await Provider.of<TransacaoProvider>(context, listen:false)
                      //                   .put(
                      //                   TransacaoCaixa(
                      //                     dataTransacao: UtilData.obterDataDDMMAAAA(DateTime.now()),
                      //                     descricaoTransacao: servicoSelecionado!.descricao!,
                      //                     tpPagamento: (_check1)?_dropdown:"Não informado",
                      //                     tpTransacao: (_check1)?"PAGAMENTO EFETUADO":"AGUARDANDO PAGAMENTO",
                      //                     valorTransacao: servicoProfissional!.valor!,
                      //                     idPaciente: pacienteSelecionado!.id1,
                      //                     idProfissional: profissionalSelecionado!.id1,
                      //                   )).then((value) {
                      //                 idTransacao = value;
                      //                 print(value);
                      //
                      //               });
                      //               //item.valorTransacao.replaceAll(',', '.');
                      //               //convertendo comissao
                      //               String valor = servicoProfissional!.valor!.replaceAll(',', '.');
                      //               double comissao = NumberFormat().parse(valor)*0.7;
                      //               //inserindo comissão
                      //               await Provider.of<ComissaoProvider>(context, listen: false)
                      //                   .put(Comissao(
                      //                   idProfissional: profissionalSelecionado!.id1,
                      //                   idTransacao: idTransacao,
                      //                   idPagamento: "",
                      //                   dataGerada: UtilData.obterDataDDMMAAAA(DateTime.now()),
                      //                   dataPagamento: "",
                      //                   valor: comissao.toString()+",00",
                      //                   situacao: "PENDENTE"));
                      //
                      //               //INSERINDO SESSÕES
                      //               for(int i =0; i<_datasSelecionadas.length; i++) {
                      //                 await Provider.of<SessaoProvider>(context, listen: false)
                      //                     .put(Sessao(
                      //                   idProfissional: profissionalSelecionado!.id1,
                      //                   idPaciente: pacienteSelecionado!.id1,
                      //                   idTransacao: idTransacao,
                      //                   dataSessao: _datasSelecionadas[i],
                      //                   horarioSessao: _horariosSelecionadas[i],
                      //                   descSessao: "Sessão ${i+1}/${_datasSelecionadas.length}"
                      //                       " ${servicoSelecionado!.descricao}",
                      //                   salaSessao: _salasSelecionadas[i],
                      //                   statusSessao: "AGENDADA",
                      //                   tipoSessao: "PRESENCIAL",
                      //                   situacaoSessao: (_check1) ?
                      //                   "PAGO":
                      //                   "AGUARDANDO PAGAMENTO",
                      //                 ));
                      //               }
                      //             } else {
                      //               //INSERINDO SESSÕES
                      //               for(int i =0; i<_datasSelecionadas.length; i++) {
                      //                 await Provider.of<SessaoProvider>(context, listen: false)
                      //                     .put(Sessao(
                      //                   idProfissional: profissionalSelecionado!.id1,
                      //                   idPaciente: pacienteSelecionado!.id1,
                      //                   idTransacao: "",
                      //                   dataSessao: _datasSelecionadas[i],
                      //                   horarioSessao: _horariosSelecionadas[i],
                      //                   descSessao: "Sessão ${i+1}/${_datasSelecionadas.length}"
                      //                       " ${servicoSelecionado!.descricao}",
                      //                   salaSessao: _salasSelecionadas[i],
                      //                   statusSessao: "AGENDADA",
                      //                   tipoSessao: "PRESENCIAL",
                      //                   situacaoSessao: (_check1) ?
                      //                   "PAGO":
                      //                   "AGUARDANDO PAGAMENTO",
                      //                 ));
                      //               }
                      //             }
                      //
                      //
                      //             Navigator.pushReplacementNamed(context, "/home_assistente");
                      //           },
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(6.0),
                      //             child: Container(
                      //               color: AppColors.primaryColor,
                      //
                      //               child:Icon(
                      //                 Icons.arrow_right_alt,
                      //                 color: AppColors.labelWhite,
                      //               ),),
                      //           ),
                      //         ) :
                      //         ClipRRect(
                      //           borderRadius: BorderRadius.circular(6.0),
                      //           child: Container(
                      //             color: AppColors.labelBlack.withOpacity(0.6),
                      //             child: Icon(
                      //               Icons.check,
                      //               color: AppColors.labelWhite,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: size.width*0.07,
                      //         height: size.height*0.04,
                      //         child: FittedBox(
                      //             fit: BoxFit.scaleDown,
                      //             child: Text("Salvar", style: AppTextStyles.subTitleBlack,)
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                  //container com dados da consulta
                  Container(
                    height: size.height*0.7,
                    width: size.width*0.3,
                    color: AppColors.shape,
                    child: Column(
                      children: [
                        Container(
                            height: size.height*0.05,
                            width: size.width*0.3,
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit_calendar_outlined),
                                    Text(" AGENDAMENTO SESSÃO"),
                                  ],
                                ))
                        ),
                        Divider(),
                        SizedBox(
                          height: size.height*0.6,
                          width: size.width*0.28,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("PACIENTE: ", style: AppTextStyles.subTitleBlack14,),
                                    (pacienteSelecionado!=null)?
                                    Text("${pacienteSelecionado?.nome!}",
                                      style: AppTextStyles.labelBold16,) :
                                    Text("")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("PROFISSIONAL: ", style: AppTextStyles.subTitleBlack14,),
                                    (profissionalSelecionado!= null)?
                                    Text(profissionalSelecionado!.nome.toString(),
                                      style: AppTextStyles.labelBold16,):
                                    Text("")
                                  ],
                                ),
                              ),
                              Text("SERVIÇO: ", style: AppTextStyles.subTitleBlack14,),
                              Text(servicoSelecionado!.descricao!, style: AppTextStyles.labelBold14),

                              Padding(padding: EdgeInsets.only(top: 5, bottom: 10),
                                  child:
                                  (servicoProfissional!.valor!.compareTo("0,00")==0)?
                                  Row(
                                    children: [
                                      Text("VALOR: ", style: AppTextStyles.subTitleBlack14,),
                                      // Text("${servicoProfissional!.valor}", style: AppTextStyles.labelBold14,)
                                      Text("${servicoProfissional!.valor}", style: AppTextStyles.labelBold14,)
                                    ],
                                  )
                                      :
                                  Row(
                                    children: [
                                      Text("VALOR: ", style: AppTextStyles.subTitleBlack14,),
                                      // Text("${servicoProfissional!.valor}", style: AppTextStyles.labelBold14,)
                                      // Text("${getValorComDesconto()}", style: AppTextStyles.labelBold14,)
                                      (_checkSocial)?
                                      Text("${getValorComDesconto()}", style: AppTextStyles.labelBold14,):
                                      Text("${servicoProfissional!.valor}", style: AppTextStyles.labelBold14,),

                                    ],
                                  )

                              ),


                              (servicoSelecionado!.qtd_sessoes!<=1)?
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // (_datasSelecionadas.length>1)?
                                  // Text("AGENDAMENTOS: ", style: AppTextStyles.subTitleBlack14,):
                                  Text("AGENDAMENTO: ", style: AppTextStyles.subTitleBlack14,),
                                  (_datasSelecionadas.length==0)?
                                  Text("", style: AppTextStyles.subTitleBlack14,)
                                      :
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Sessão 1: ",
                                        style: AppTextStyles.subTitleBlack14,
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("${_datasSelecionadas[0]}",
                                            style: AppTextStyles.labelBold14,
                                          ),
                                          Text("${_horariosSelecionadas[0]}",
                                            style: AppTextStyles.labelBold14,
                                          ),
                                          Text("${_salasSelecionadas[0]}",
                                            style: AppTextStyles.labelBold14,
                                          ),
                                          (_flag==4)?
                                          InkWell(
                                              onTap: (){
                                                _datasSelecionadas.removeAt(0);
                                                _salasSelecionadas.removeAt(0);
                                                _horariosSelecionadas.removeAt(0);
                                                setState((){});
                                              },
                                              child: Icon(Icons.delete_forever_outlined)
                                          ):
                                          Center(),
                                        ],
                                      ),


                                    ],
                                  )

                                ],
                              )
                                  :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("AGENDAMENTOS: ", style: AppTextStyles.subTitleBlack14,),
                                  for(int i =0; i<_datasSelecionadas.length; i++)
                                    (_datasSelecionadas.length==0)?
                                    Row(
                                      children: [
                                        Text("Sessão ${i+1}: ", style: AppTextStyles.labelBold14,),

                                        (_flag==4)?
                                        InkWell(
                                          onTap: (){

                                          },
                                          child: Icon(Icons.delete_forever_outlined),

                                        ):
                                            Center()
                                      ],
                                    )
                                        :
                                    Row(
                                      children: [
                                        Text("Sessão ${i+1}: ",
                                          style: AppTextStyles.subTitleBlack14,
                                        ),
                                        Row(
                                          children: [
                                            Text("${_datasSelecionadas[i]}, ${_salasSelecionadas[i]} às ${_horariosSelecionadas[i]}",
                                              style: AppTextStyles.labelBold14,
                                            ),
                                          ],
                                        ),
                                        (_flag==4)?
                                        InkWell(
                                          onTap: (){
                                            _datasSelecionadas.removeAt(i);
                                            _salasSelecionadas.removeAt(i);
                                            _horariosSelecionadas.removeAt(i);
                                            setState((){});
                                          },
                                          child: Icon(Icons.delete_forever_outlined),
                                        ) :
                                            Center()
                                      ],
                                    )
                                ],
                              )
                            ],
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


              Center(
                child: ButtonDisableWidget(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.1,
                  label: "Salvar",

                  onTap: () async {
                    _isButtonDisabled = true;
                    setState((){});
                    if(_checkSocial){
                      //POSSUI DESCONTO SOCIAL CLÍNICA / PROFISSIONAL
                      if (_form.currentState!.validate()) {
                        String idTransacao = "";
                        // efetuou pagamento
                        // inserindo transação
                        if (_check1){
                          // String valorTransacaoFinal= (double.parse(servicoProfissional!.valor!.replaceAll(",", "."))-((double.parse(_descontoProfissional.replaceAll(",", ".")))+(double.parse(_descontoClinica.replaceAll(",", "."))))).toStringAsFixed(2).replaceAll('.', ',');
                          String valorTransacaoFinal = getValorComDesconto();
                          await Provider.of<TransacaoProvider>(context, listen:false)
                              .put(
                              TransacaoCaixa(
                                dataTransacao: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                descricaoTransacao: servicoSelecionado!.descricao!,
                                tpPagamento: (_check1)?_dropdown:"Não informado",
                                tpTransacao: (_check1)?"PAGAMENTO EFETUADO":"AGUARDANDO PAGAMENTO",
                                valorTransacao: valorTransacaoFinal,
                                idPaciente: pacienteSelecionado!.id1,
                                idProfissional: profissionalSelecionado!.id1,
                                descontoProfissional:  _descontoProfissional,
                                descontoClinica: _descontoClinica,
                              )).then((value) async{
                            idTransacao = value;
                            print(value);
                            if (_checkPagamentoVariado){
                              //inserindo pagamentos transações
                              for (int i =0; i<listDropdownFirst.length;i++) {
                                await Provider.of<PagamentoTransacaoProvider>
                                  (context,listen: false).putTransacao(PagamentoTransacao(
                                    dataPagamento: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                    horaPagamento: UtilData.obterHoraHHMM(DateTime.now()),
                                    valorPagamento: listValores[i],
                                    valorTotalPagamento: valorTransacaoFinal,
                                    tipoPagamento: listDropdownFirst[i],
                                    descServico: servicoSelecionado!.descricao!,
                                    idTransacao: idTransacao)
                                );
                              }

                            } else{
                              //inserindo pagamento transação
                              await Provider.of<PagamentoTransacaoProvider>
                                (context,listen: false).putTransacao(PagamentoTransacao(
                                  dataPagamento: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                  horaPagamento: UtilData.obterHoraHHMM(DateTime.now()),
                                  valorPagamento: valorTransacaoFinal,
                                  valorTotalPagamento: valorTransacaoFinal,
                                  tipoPagamento: _dropdown,
                                  descServico: servicoSelecionado!.descricao!,
                                  idTransacao: idTransacao)
                              );
                            }
                          });
                          String valor = valorTransacaoFinal;
                          // String valorFinal = valor.substring(0,valor.length-3);
                          // String comissao = ((double.parse(valorFinal)*0.7)-(double.parse(_descontoProfissional))).toStringAsFixed(2).replaceAll('.', ',');

                          String valorFinal = valor.replaceAll(',', '.');
                          String comissao = _comissaoFinalProfissional;

                          //inserindo comissão
                          await Provider.of<ComissaoProvider>(context, listen: false)
                              .put(Comissao(
                              idProfissional: profissionalSelecionado!.id1,
                              idTransacao: idTransacao,
                              idPagamento: "",
                              dataGerada: UtilData.obterDataDDMMAAAA(DateTime.now()),
                              dataPagamento: "",
                              valor: comissao,
                              situacao: "PENDENTE"));

                          //INSERINDO SESSÕES
                          for(int i =0; i<_datasSelecionadas.length; i++) {
                            await Provider.of<SessaoProvider>(context, listen: false)
                                .put(Sessao(
                              idProfissional: profissionalSelecionado!.id1,
                              idPaciente: pacienteSelecionado!.id1,
                              idTransacao: idTransacao,
                              dataSessao: _datasSelecionadas[i],
                              horarioSessao: _horariosSelecionadas[i],
                              descSessao: "Sessão ${i+1}/${_datasSelecionadas.length}"
                                  " ${servicoSelecionado!.descricao}",
                              salaSessao: _salasSelecionadas[i],
                              statusSessao: "AGENDADA",
                              tipoSessao: "PRESENCIAL",
                              situacaoSessao: (_check1) ?
                              "PAGO":
                              "AGUARDANDO PAGAMENTO",
                            ));
                          }
                        }
                        else {
                          //NÃO INSERI TRANSAÇÃO
                          //INSERINDO SESSÕES
                          for(int i =0; i<_datasSelecionadas.length; i++) {
                            await Provider.of<SessaoProvider>(context, listen: false)
                                .put(Sessao(
                              idProfissional: profissionalSelecionado!.id1,
                              idPaciente: pacienteSelecionado!.id1,
                              idTransacao: "",
                              dataSessao: _datasSelecionadas[i],
                              horarioSessao: _horariosSelecionadas[i],
                              descSessao: "Sessão ${i+1}/${_datasSelecionadas.length}"
                                  " ${servicoSelecionado!.descricao}",
                              salaSessao: _salasSelecionadas[i],
                              statusSessao: "AGENDADA",
                              tipoSessao: "PRESENCIAL",
                              situacaoSessao: (_check1) ?
                              "PAGO":
                              "AGUARDANDO PAGAMENTO",
                            ));
                          }
                        }
                        Navigator.pushReplacementNamed(context, "/home_assistente");
                      }
                    } else {
                      //NÃO POSSUI DESCONTO SOCIAL CLÍNICA / PROFISSIONAL
                      print("não possui desconto social");
                      print(_check1);
                      String idTransacao = "";
                      //inserindo transação
                      if (_check1){
                        await Provider.of<TransacaoProvider>(context, listen:false)
                            .put(
                            TransacaoCaixa(
                              dataTransacao: UtilData.obterDataDDMMAAAA(DateTime.now()),
                              descricaoTransacao: servicoSelecionado!.descricao!,
                              tpPagamento: (_check1)?_dropdown:"Não informado",
                              tpTransacao: (_check1)?"PAGAMENTO EFETUADO":"AGUARDANDO PAGAMENTO",
                              valorTransacao: servicoProfissional!.valor!,
                              idPaciente: pacienteSelecionado!.id1,
                              idProfissional: profissionalSelecionado!.id1,
                              descontoProfissional: "0,00",
                              descontoClinica: "0,00",
                            )).then((value) async{
                          idTransacao = value;
                          print(value);
                          String valorTransacaoFinal = _valorSessao;
                          if (_checkPagamentoVariado){
                            //inserindo pagamentos transações
                            for (int i =0; i<listDropdownFirst.length;i++) {
                              await Provider.of<PagamentoTransacaoProvider>
                                (context,listen: false).putTransacao(PagamentoTransacao(
                                  dataPagamento: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                  horaPagamento: UtilData.obterHoraHHMM(DateTime.now()),
                                  valorPagamento: listValores[i],
                                  valorTotalPagamento: valorTransacaoFinal,
                                  tipoPagamento: listDropdownFirst[i],
                                  descServico: servicoSelecionado!.descricao!,
                                  idTransacao: idTransacao)
                              );
                            }

                          } else{
                            //inserindo pagamento único transação
                            await Provider.of<PagamentoTransacaoProvider>
                              (context,listen: false).putTransacao(PagamentoTransacao(
                                dataPagamento: UtilData.obterDataDDMMAAAA(DateTime.now()),
                                horaPagamento: UtilData.obterHoraHHMM(DateTime.now()),
                                valorPagamento: valorTransacaoFinal,
                                valorTotalPagamento: valorTransacaoFinal,
                                tipoPagamento: _dropdown,
                                descServico: servicoSelecionado!.descricao!,
                                idTransacao: idTransacao)
                            );
                          }
                        });
                        String valor = servicoProfissional!.valor!;
                        String valorFinal = valor.substring(0,valor.length-3);
                        String comissao = (double.parse(valorFinal)*0.7).toStringAsFixed(2).replaceAll('.', ',');

                        //inserindo comissão
                        await Provider.of<ComissaoProvider>(context, listen: false)
                            .put(Comissao(
                            idProfissional: profissionalSelecionado!.id1,
                            idTransacao: idTransacao,
                            idPagamento: "",
                            dataGerada: UtilData.obterDataDDMMAAAA(DateTime.now()),
                            dataPagamento: "",
                            valor: comissao,
                            situacao: "PENDENTE"));

                        //INSERINDO SESSÕES
                        for(int i =0; i<_datasSelecionadas.length; i++) {
                          await Provider.of<SessaoProvider>(context, listen: false)
                              .put(Sessao(
                            idProfissional: profissionalSelecionado!.id1,
                            idPaciente: pacienteSelecionado!.id1,
                            idTransacao: idTransacao,
                            dataSessao: _datasSelecionadas[i],
                            horarioSessao: _horariosSelecionadas[i],
                            descSessao: "Sessão ${i+1}/${_datasSelecionadas.length}"
                                " ${servicoSelecionado!.descricao}",
                            salaSessao: _salasSelecionadas[i],
                            statusSessao: "AGENDADA",
                            tipoSessao: "PRESENCIAL",
                            situacaoSessao: (_check1) ?
                            "PAGO":
                            "AGUARDANDO PAGAMENTO",
                          ));
                        }
                      }
                      else {
                        //NÃO INSERE TRANSAÇÕES
                        //INSERINDO SESSÕES
                        for(int i =0; i<_datasSelecionadas.length; i++) {
                          await Provider.of<SessaoProvider>(context, listen: false)
                              .put(Sessao(
                            idProfissional: profissionalSelecionado!.id1,
                            idPaciente: pacienteSelecionado!.id1,
                            idTransacao: "",
                            dataSessao: _datasSelecionadas[i],
                            horarioSessao: _horariosSelecionadas[i],
                            descSessao: "Sessão ${i+1}/${_datasSelecionadas.length}"
                                " ${servicoSelecionado!.descricao}",
                            salaSessao: _salasSelecionadas[i],
                            statusSessao: "AGENDADA",
                            tipoSessao: "PRESENCIAL",
                            situacaoSessao: (_check1) ?
                            "PAGO":
                            "AGUARDANDO PAGAMENTO",
                          ));
                        }
                      }
                      Navigator.pushReplacementNamed(context, "/home_assistente");
                    }


                  },
                  isButtonDisabled: _isButtonDisabled,
                ),
              ),
            ],
          ),
        ));
  }
}
