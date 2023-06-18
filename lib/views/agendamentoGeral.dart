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

class AgendamentoGeralPage extends StatefulWidget {
  const AgendamentoGeralPage({Key? key}) : super(key: key);

  @override
  State<AgendamentoGeralPage> createState() => _AgendamentoGeralPageState();
}

class _AgendamentoGeralPageState extends State<AgendamentoGeralPage> {

  ScrollController controllerPaciente = ScrollController();
  final _form = GlobalKey<FormState>();
  var txt1 = TextEditingController();
  var txt2 = TextEditingController();

  List<Paciente> pacientes =[];
  List<Paciente> pacientesFinal =[];
  List<Profissional> profissionais =[];
  List<Profissional> profissionaisFinal =[];
  List<DiasProfissional> diasProfissional = [];
  List<DiasSalasProfissionais> diasSalasProfissional = [];
  String _parteName = "";
  String _uid = "";
  String _dropdown = "";
  bool _selectPaciente = false;
  bool _selectProfissional = false;
  bool _isButtonDisabled = true;
  bool _botaoAvancar = false;
  int _flag = 1;


  List<DropdownMenuItem<String>> getDropdownProfissionais(
      List<Profissional> list) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < list.length; i++) {
      var newDropdown = DropdownMenuItem(
        value: list[i].nome.toString(),
        child: Text(list[i].nome.toString()),
      );
      dropDownItems.add(newDropdown);
    }
    return dropDownItems;
  }

  late Paciente? pacienteSelecionado = Paciente(
    nome: "",
  );
  late Profissional? profissionalSelecionado = Profissional(
    nome: "",
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
            if (pacientes.length==0){
              Provider.of<PacienteProvider>(context, listen: false).getListPacientes().then((value) {
                if (this.mounted){
                  pacientes = value;
                  pacientesFinal = value;
                  pacientes.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                  setState((){});
                }
              } );
            }

            if (profissionais.length==0){
              Provider.of<ProfissionalProvider>(context, listen: false).getListProfissionais().then((value) {
                // print("initState Sessão");
                profissionais = value;
                profissionaisFinal = value;
                if (this.mounted){
                  profissionais.sort((a, b) => a.nome.toString().compareTo(b.nome.toString()));
                  _dropdown = profissionais.first.nome!;
                  setState((){});
                }
              } );
            }
          } else {
            print("usuário não conectado initState Home Assistente");

            ///nav
            Navigator.pushReplacementNamed(context, "/login");
          }
        }),

      ]);
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

  bool contemAgendamento(String hora){
    print("Contem $hora");
    // print(sessoesProfissional.length);
    bool result = false;

    // if (sessoesProfissional.length==0){
    //   return false;
    // } else{
    //  sessoesProfissional.forEach((element) {
    //    if (element.horarioSessao!.compareTo(hora)==0){
    //        result = true;
    //        print(element.id1);
    //    }
    //  });
    // }
    print(result);
    return result;
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // _dropdown = profissionais.first.nome!;
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

              //dropDown Profissional
              Container(
                height: size.height*0.1,
                width: size.width*0.3,
                color: AppColors.shape,
                child: DropdownButton<String>(
                  value: _dropdown,
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  elevation: 16,
                  style: TextStyle(color: AppColors.labelBlack),
                  underline: Container(
                    height: 2,
                    width: size.width * 0.2,
                    color: AppColors.line,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdown = newValue!;
                      // items = getDropdownProfissionais(_dropdown);
                      setState((){});
                    });
                  },
                  items: getDropdownProfissionais(profissionais),
                ),

              ),
              Container(
                height: size.height*0.6,
                width: size.width*0.8,
                color: AppColors.shape,


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


                  },
                  isButtonDisabled: _isButtonDisabled,
                ),
              ),
            ],
          ),
        ));
  }
}
