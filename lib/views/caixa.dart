import 'dart:convert';
import 'dart:html';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/despesa.dart';
import 'package:psico_sis/model/pagamento_profissional.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/despesa_provider.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/transacao_provider.dart';
import 'package:psico_sis/service/validator_service.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/widgets/app_bar_widget2.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';

import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/categoria_despesa.dart';
import '../model/comissao.dart';
import '../my_flutter_app_icons.dart';
import '../provider/categoria_despesa_provider.dart';
import '../provider/comissao_provider.dart';
import '../provider/pagamento_profissional_provider.dart';
import '../provider/usuario_provider.dart';
import '../service/prefs_service.dart';
import '../themes/app_text_styles.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/menu_icon_label_button_widget.dart';

class Caixa extends StatefulWidget {
  const Caixa({Key? key}) : super(key: key);

  @override
  State<Caixa> createState() => _CaixaState();
}

class _CaixaState extends State<Caixa> {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  String _uid = "";
  String _valorDinheiro = "0,00";
  String _valorCredito = "0,00";
  String _valorDebito = "0,00";
  String _valorPix = "0,00";
  String _valorDespesa = "0,00";
  String _valorPagamento = "0,00";
  String _totalEntrada = "0,00";
  String _totalSaida = "0,00";
  DateTime _dataCorrente = DateTime.now();


  late List<Profissional> _lprofissionais=[];
  late List<TransacaoCaixa> _transacoesDoDia=[];
  late List<Despesa> _despesasDoDia=[];
  late List<PagamentoProfissional> _pagamentoProfissional=[];
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

  void getValues(){
    String novo ="";
    double pix = 0;
    double credito = 0;
    double debito = 0;
    double dinheiro = 0;
    double totalEntrada = 0;
    double totalSaida = 0;
    double despesa = 0;
    double pagamentoComissao = 0;
      for (var item in _transacoesDoDia) {
        novo = item.valorTransacao.replaceAll(',', '.');

        if (item.tpPagamento.compareTo("PIX") == 0) {
          pix +=  NumberFormat().parse(novo);
        } else if (item.tpPagamento.compareTo("À VISTA DINHEIRO") == 0) {
          dinheiro += NumberFormat().parse(novo);
        } else if (item.tpPagamento.compareTo("CARTÃO DE DÉBITO")==0){
          debito += NumberFormat().parse(novo);
        } else {
          credito += NumberFormat().parse(novo);
        }
      }
      for (var item in _despesasDoDia){
        print(item.valor);

        novo = item.valor.replaceAll(',', '.');
        print(NumberFormat().parse(novo));
        despesa +=  NumberFormat().parse(novo);
        print(despesa);
      }
    for (var item in _pagamentoProfissional){
      novo = item.valor.replaceAll(',', '.');
      pagamentoComissao +=  NumberFormat().parse(novo);
    }
    totalEntrada = pix+dinheiro+credito+debito;
    totalSaida = despesa+pagamentoComissao;
    _totalSaida = UtilBrasilFields.obterReal(totalSaida);
    _totalEntrada =  UtilBrasilFields.obterReal(totalEntrada);
    _valorPix = pix.toStringAsFixed(2).replaceAll('.', ',');
    _valorDinheiro = dinheiro.toStringAsFixed(2).replaceAll('.', ',');
    _valorCredito = credito.toStringAsFixed(2).replaceAll('.', ',');
    _valorDebito = debito.toStringAsFixed(2).replaceAll('.', ',');
    _valorDespesa = despesa.toStringAsFixed(2).replaceAll('.', ',');
    _valorPagamento = pagamentoComissao.toStringAsFixed(2).replaceAll('.', ',');
    print("getvalues");
  }

  bool avanca(){
    DateTime hoje = DateTime.now();
    if(_dataCorrente.year<hoje.year){
      return true;
    } else if (_dataCorrente.month<hoje.month){
      return true;
    } else if((_dataCorrente.month==hoje.month)&&(_dataCorrente.day<hoje.day)){
      return true;
    }
    return false;
  }


  @override
  initState() {
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
        } else {
          print("usuário não conectado initState Home Assistente");

          ///nav
          Navigator.pushReplacementNamed(context, "/login");
        }
      }),

    ]);
    if (_pagamentoProfissional.length==0){
      Provider.of<PagamentoProfissionalProvider>(context, listen: false)
          .getListPagamentosProfissionais(UtilData.obterDataDDMMAAAA(_dataCorrente))
          .then((value) {
           if (this.mounted){
             _pagamentoProfissional = value;
             print(_pagamentoProfissional.length.toString()+" pagamentos");

           }
      });
    }

    if(_transacoesDoDia.length==0){
      Provider.of<TransacaoProvider>(context, listen: false).getTransacoesDoDia(_dataCorrente)
          .then((value) {
        _transacoesDoDia = value;
        _transacoesDoDia.sort((a,b) {
          int aHora = int.parse(a.horaTransacao!.substring(0,2));
          int aMin = int.parse(a.horaTransacao!.substring(3,5));
          int bHora = int.parse(b.horaTransacao!.substring(0,2));
          int bMin = int.parse(b.horaTransacao!.substring(3,5));
          if (aHora==bHora){
            return aMin.compareTo(bMin);
          } else {
            return aHora.compareTo(bHora);
          }
        });
        print(_transacoesDoDia.length);
      });
    }

    if(_lprofissionais.length==0){
      Provider.of<ProfissionalProvider>(context, listen: false).getListProfissionaisAtivos()
          .then((value) {
        _lprofissionais = value;
        print(_transacoesDoDia.length);
      });
    }
    if(_despesasDoDia.length==0){
      Provider.of<DespesaProvider>(context, listen:false).getDespesasDoDia(_dataCorrente)
          .then((value) {
            _despesasDoDia = value;
            _despesasDoDia.sort((a,b) {
              int aHora = int.parse(a.hora.substring(0,2));
              int aMin = int.parse(a.hora.substring(3,5));
              int bHora = int.parse(b.hora.substring(0,2));
              int bMin = int.parse(b.hora.substring(3,5));
              if (aHora==bHora){
                return aMin.compareTo(bMin);
              } else {
                return aHora.compareTo(bHora);
              }
            });

            getValues();
            setState((){});
      });
    }
    

  }

  void getvaloresDoDia() async{
    await Provider.of<TransacaoProvider>(context, listen: false).getTransacoesDoDia(_dataCorrente)
        .then((value) {
      // if (this.mounted){
        _transacoesDoDia = value;
        // print(_transacoesDoDia.length.toString()+"transacoes");
      // }
    });

    await Provider.of<PagamentoProfissionalProvider>(context,listen:false)
        .getListPagamentosProfissionais(UtilData.obterDataDDMMAAAA(_dataCorrente))
        .then((value) {
        _pagamentoProfissional = value;
    });
    await Provider.of<DespesaProvider>(context, listen:false).getDespesasDoDia(_dataCorrente)
        .then((value) {

          print(value.length);
        print("_despesasDoDia.length");
      _despesasDoDia = value;
      getValues();
      setState((){});
    });

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBarWidget2(nomeUsuario: _usuario.nomeUsuario!),
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
                padding: EdgeInsets.only(left: size.width*0.015, right: size.width*0.015 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Informações do caixa
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //botões alterar data
                          SizedBox(
                            width: size.width*0.15,
                            height: size.height*0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: size.width*0.03,
                                  height: size.width*0.03,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      _dataCorrente = _dataCorrente.subtract(Duration(days: 1));
                                      getvaloresDoDia();
                                      // setState((){});
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(Icons.arrow_left,
                                      size: 35.0,
                                    ),
                                    shape: CircleBorder(),
                                    splashColor: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width*0.03,
                                  height: size.width*0.03,
                                  child: RawMaterialButton(
                                    onPressed: avanca()?(){
                                      _dataCorrente = _dataCorrente.add(Duration(days: 1));
                                      getvaloresDoDia();
                                    }:null,
                                    elevation: 2.0,
                                    fillColor: avanca()?Colors.white:AppColors.line,
                                    child: Icon(Icons.arrow_right,
                                      size: 35.0,
                                    ),
                                    shape: CircleBorder(),
                                    splashColor: AppColors.primaryColor,

                                  ),
                                ),


                              ],
                            ),
                          ),
                          //imagem caixa
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,bottom: 4.0),
                                child: SizedBox(
                                    height: size.height * 0.1,
                                    width: size.width * 0.05,
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.asset(AppImages.caixa, filterQuality: FilterQuality.high,))),
                              ),
                              Padding(padding: EdgeInsets.only(left: 4.0),
                                child:
                                Container(
                                  color: AppColors.shape,
                                    child:  Column(
                                      children: [

                                        SizedBox(
                                          width: size.width*0.09,
                                          height: size.height*0.06,
                                          child:  FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(UtilData.obterDataDDMMAAAA(_dataCorrente).substring(0,5)),
                                          ),
                                        ),
                                        SizedBox(
                                            width: size.width*0.09,
                                            height: size.height*0.04,
                                            child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(ValidatorService.getDiaCorrente(_dataCorrente))
                                              // (_dataCorrente).substring(0,5)),
                                            )
                                        )
                                      ],
                                    ),


                                )

                              )

                            ],
                          ),

                          //informações valores
                          Container(
                            height: size.height * 0.4,
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
                                      Text("$_valorDinheiro", style: AppTextStyles.labelBlack14FredokaOne,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Pix: ",style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_valorPix",style: AppTextStyles.labelBlack14FredokaOne,),
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
                                      Text("$_valorCredito",style: AppTextStyles.labelBlack14FredokaOne,),
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
                                      Text("$_valorDebito",style: AppTextStyles.labelBlack14FredokaOne,),


                                    ],
                                  ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      height: size.height*0.01,
                                      width: size.width*0.05,
                                      child:  Divider(
                                        thickness: 1,
                                        color: AppColors.labelBlack,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("TOTAL",style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_totalEntrada",style: AppTextStyles.labelBlack14FredokaOne,),
                                    ],

                                  ),

                                  Divider(
                                    thickness: 3,
                                    color: AppColors.labelBlack,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Despesas: ",style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_valorDespesa",style: AppTextStyles.labelRed14FredokaOne,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Text("Comissões: ", style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_valorPagamento", style: AppTextStyles.labelRed14FredokaOne,),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      height: size.height*0.01,
                                      width: size.width*0.05,
                                      child:  Divider(
                                        thickness: 1,
                                        color: AppColors.labelBlack,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("TOTAL",style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_totalSaida",style: AppTextStyles.labelRed14FredokaOne,),
                                    ],

                                  ),

                                ],
                              ),
                            ),
                          ),

                          //botões
                          Padding(
                            padding: EdgeInsets.only(top: size.height*0.01),
                            child: Container(
                              height: size.height * 0.15,
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
                              child: Center(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: size.height*0.12, width: size.width*0.06,
                                  child: MenuIconLabelButtonWidget(
                                      label: "DESPESAS",
                                      height: size.height*0.08, width: size.width*0.05,
                                      iconData: MyFlutterApp.cash_register,
                                      onTap: (){
                                        List<CategoriaDespesa> _listC = [];
                                        Provider.of<CategoriaDespesaProvider>(context, listen:false)
                                            .getListCategorias().then((value) async {
                                          print("entrouu");
                                          print(value.length);
                                          _listC = value;
                                          _listC.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
                                          await Dialogs.AlertCadastrarDespesa(context,_listC);
                                          getvaloresDoDia();
                                          setState((){});
                                        });


                                      }),),

                                  SizedBox(height: size.height*0.12, width: size.width*0.06,
                                    child: MenuButtonWidget(
                                      label: "COMISSÃO",
                                      height: size.height*0.08, width: size.width*0.05,
                                      image: AppImages.comissao,
                                      onTap: () async{
                                        List<Profissional> profPendentes = [];

                                       await Provider.of<ComissaoProvider>(context, listen: false)
                                       .getListIdProfissionaisAReceber().then((value) {
                                         List<String> list = value;
                                         print(list.length);
                                         print("list.length");
                                         for (int i=0; i<list.length; i++) {
                                            Provider.of<ProfissionalProvider>
                                             (context, listen: false).getProfissional(list[i]).then((value1) {
                                             print("pegou prof");
                                             profPendentes.add(value1);
                                             if (i == (list.length-1)){
                                               profPendentes.sort((a,b)=>a.nome!.compareTo(b.nome!));
                                               // Dialogs.AlertPagarProfissional(context, profPendentes);
                                               Dialogs.AlertPagamentoComissao(context, profPendentes);
                                               getvaloresDoDia();
                                             }
                                           });

                                         }
                                       });
                                  }),),
                                ],
                              ),),
                            ),
                          )
                        ],
                      ),



                    //entrada
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        SizedBox(
                          width: size.width * 0.3,
                          height: size.height*0.04,
                          child: Padding(padding: EdgeInsets.only(left: 5.0),
                            child: Text("Entrada", style: AppTextStyles.labelBold16),
                          )
                        ),
                        Container(
                          width: size.width * 0.3,
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
                          child: ListView.builder(
                              controller: scrollController1,
                              itemCount: _transacoesDoDia.length,
                              itemBuilder: (context, index){
                                  return  Card(
                                    elevation: 8,
                                    child: ListTile(
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              _transacoesDoDia[index].descricaoTransacao,
                                              style: AppTextStyles.subTitleBlack,),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Text("PROFISSIONAL: ", style: AppTextStyles.subTitleBlack, ),
                                                FutureBuilder(
                                                    future: Provider.of<ProfissionalProvider>
                                                      (context, listen:false)
                                                        .getProfissional(_transacoesDoDia[index].idProfissional),
                                                    builder: (context, snapshot){
                                                      if (snapshot.hasData){
                                                        Profissional prof = snapshot.data as Profissional;
                                                        return Text(prof.nome!,  style: AppTextStyles.labelBold14,);
                                                      } else {
                                                        return Center(
                                                            child: Text("")
                                                        );
                                                      }
                                                    }),
                                                // Text("ANNE VASCONCELOS", style: AppTextStyles.labelBold16,),
                                                // Text("08:00", style: AppTextStyles.labelBold16,),
                                              ],
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("PACIENTE: ",style: AppTextStyles.subTitleBlack, ),
                                                FutureBuilder(
                                                    future: Provider.of<PacienteProvider>
                                                      (context, listen: false).getPaciente(_transacoesDoDia[index].idPaciente),
                                                    builder: (context, snapshot){
                                                      if (snapshot.hasData){
                                                        Paciente pac = snapshot.data as Paciente;
                                                        return Text(pac.nome!, style: AppTextStyles.labelBold14 );
                                                      } else {
                                                        return Center(child: Text(""),);
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ),

                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("${_transacoesDoDia[index].valorTransacao}   ", style: AppTextStyles.labelBlack14FredokaOne),
                                                    Text(_transacoesDoDia[index].tpPagamento, style: AppTextStyles.subTitleBlack),
                                                  ],
                                                ),
                                                Text(_transacoesDoDia[index].horaTransacao!, style: AppTextStyles.subTitleBlack),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                    ),
                                  );
                          })
                          // Scrollbar(
                          //   controller: scrollController1,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                          //     child: Column(
                          //       children: [
                          //         for (var item in _transacoesDoDia)

                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ),

                      ],
                    ),

                    //despesas
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        SizedBox(
                            width: size.width * 0.2,
                            height: size.height*0.04,
                            child: Padding(padding: EdgeInsets.only(left: 5.0),
                              child: Text("Despesas", style: AppTextStyles.labelBold16),
                            )
                        ),
                        Container(
                          width: size.width * 0.2,
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
                          child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: ListView.builder(
                                  controller: scrollController2,
                                  itemCount: _despesasDoDia.length,
                                  itemBuilder: (context, index){
                                    return  Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Card(
                                          elevation: 8,
                                          child: Container(
                                            width: size.width * 0.2,
                                            height: size.height*0.1,
                                            child: ListTile(
                                              title: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(_despesasDoDia[index].categoria, style: AppTextStyles.subTitleBlack,),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(_despesasDoDia[index].descricao, style: AppTextStyles.labelBold14,),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text("VALOR: ",style: AppTextStyles.subTitleBlack,),
                                                          Text(_despesasDoDia[index].valor,style: AppTextStyles.labelBold14,),
                                                          // Text(item.data,style: AppTextStyles.subTitleBlack,),
                                                        ],
                                                      ),
                                                      Text(_despesasDoDia[index].hora,style: AppTextStyles.subTitleBlack,),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  })
                          ),
                        ),
                      ],
                    ),



                    //comissões pagas
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        SizedBox(
                            width: size.width * 0.2,
                            height: size.height*0.04,
                            child: Padding(padding: EdgeInsets.only(left: 5.0),
                              child: Text("Comissões Pagas", style: AppTextStyles.labelBold16),
                            )
                        ),
                        Container(
                          width: size.width * 0.2,
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
                          child: ListView.builder(
                              itemCount: _pagamentoProfissional.length,
                              itemBuilder: (context, index){
                                  if(_pagamentoProfissional.length>0){
                                    return Card(
                                      elevation: 8,
                                      child: Container(
                                        width: size.width * 0.2,
                                        height: size.height*0.1,
                                        child: ListTile(
                                          title: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [


                                              Text("PROFISSIONAL: ", style: AppTextStyles.subTitleBlack, ),
                                              FutureBuilder(
                                                  future: Provider.of<ProfissionalProvider>
                                                    (context, listen:false)
                                                      .getProfissional(_pagamentoProfissional[index].idProfissional),
                                                  builder: (context, snapshot){
                                                    if (snapshot.hasData){
                                                      Profissional prof = snapshot.data as Profissional;
                                                      return FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(prof.nome!, style: AppTextStyles.labelBold14,),
                                                      );
                                                      // Text(prof.nome!,  style: AppTextStyles.labelBold14,);
                                                    } else {
                                                      return Center(
                                                          child: Text("")
                                                      );
                                                    }
                                                  }),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(_pagamentoProfissional[index].valor, style: AppTextStyles.labelBlack16Lex,),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(_pagamentoProfissional[index].data, style: AppTextStyles.subTitleBlack,),
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                                  //   children: [
                                                  //
                                                  //     SizedBox(width: size.width*0.005,),
                                                  //     FittedBox(
                                                  //       fit: BoxFit.contain,
                                                  //       child: Text(item.hora, style: AppTextStyles.subTitleBlack,),
                                                  //     ),
                                                  //
                                                  //   ],
                                                  // ),

                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    // Scrollbar(
                                    //     child: Padding(
                                    //         padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                    //         child: Column(
                                    //             children: [
                                    //               for (var item in _pagamentoProfissional)
                                    //
                                    //             ]))
                                    // ),
                                  } else {
                                    return Center();
                                  }
                          })

                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
