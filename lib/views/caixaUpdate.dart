import 'dart:convert';
import 'dart:html';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/model/despesa.dart';
import 'package:psico_sis/model/pagamento_profissional.dart';
import 'package:psico_sis/model/pagamento_transacao.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/model/sessao.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/despesa_provider.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/pagamento_transacao_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/servico_profissional_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/provider/transacao_provider.dart';
import 'package:psico_sis/service/validator_service.dart';
import 'package:psico_sis/themes/app_colors.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/views/pacientes.dart';
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

class CaixaUpdate extends StatefulWidget {
  const CaixaUpdate({Key? key}) : super(key: key);

  @override
  State<CaixaUpdate> createState() => _CaixaUpdateState();
}

class _CaixaUpdateState extends State<CaixaUpdate> {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  String _uid = "";
  String _valorDinheiro = "0,00";
  String _valorCredito = "0,00";
  String _valorDebito = "0,00";
  String _valorPix = "0,00";
  String _valorDespesaCaixa = "0,00";
  String _valorDespesaConta = "0,00";
  String _valorPagamento = "0,00";
  String _totalEntrada = "0,00";
  String _totalSaida = "0,00";
  String _saldo = "0,00";
  DateTime _dataCorrente = DateTime.now();


  late List<Paciente> _lpacientes=[];
  late List<Profissional> _lprofissionais=[];
  late List<PagamentoTransacao> _transacoesDoDia=[];
  late List<TransacaoCaixa> _transacoesCaixaDoDia=[];
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
    double despesaCaixa = 0;
    double despesaConta = 0;
    double pagamentoComissao = 0;
    double saldo = 0;
      for (var item in _transacoesDoDia) {
        novo = item.valorPagamento.replaceAll(',', '.');

        if (item.tipoPagamento.compareTo("PIX") == 0) {
          pix +=  NumberFormat().parse(novo);
        } else if (item.tipoPagamento.compareTo("DINHEIRO") == 0) {
          dinheiro += NumberFormat().parse(novo);
        } else if (item.tipoPagamento.compareTo("CARTÃO DE DÉBITO")==0){
          debito += NumberFormat().parse(novo);
        } else {
          credito += NumberFormat().parse(novo);
        }
      }
      for (var item in _despesasDoDia){
        print(item.valor);

        novo = item.valor.replaceAll(',', '.');
        print(NumberFormat().parse(novo));
        if(item.retirada.compareTo("CAIXA")==0){
          despesaCaixa +=  NumberFormat().parse(novo);

        } else {
          despesaConta +=  NumberFormat().parse(novo);

        }
        print(despesaCaixa);
        print(despesaConta);
      }
    for (var item in _pagamentoProfissional){
      novo = item.valor.replaceAll(',', '.');
      pagamentoComissao +=  NumberFormat().parse(novo);
    }
    totalEntrada = pix+dinheiro+credito+debito;
    totalSaida = despesaCaixa+despesaConta+pagamentoComissao;
    saldo = dinheiro-despesaCaixa;
    _totalSaida = UtilBrasilFields.obterReal(totalSaida);
    _totalEntrada =  UtilBrasilFields.obterReal(totalEntrada);
    _valorPix = pix.toStringAsFixed(2).replaceAll('.', ',');
    _valorDinheiro = dinheiro.toStringAsFixed(2).replaceAll('.', ',');
    _valorCredito = credito.toStringAsFixed(2).replaceAll('.', ',');
    _valorDebito = debito.toStringAsFixed(2).replaceAll('.', ',');
    _valorDespesaCaixa = despesaCaixa.toStringAsFixed(2).replaceAll('.', ',');
    _valorDespesaConta = despesaConta.toStringAsFixed(2).replaceAll('.', ',');
    _valorPagamento = pagamentoComissao.toStringAsFixed(2).replaceAll('.', ',');
    _saldo = saldo.toStringAsFixed(2).replaceAll('.', ',');
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
    if (_lpacientes.length==0){

      Provider.of<PacienteProvider>(context, listen: false).getListPacientes().then((value) {
        if (this.mounted){
          _lpacientes = value;

        }
      });

    }
    if (_transacoesCaixaDoDia.length==0){
        Provider.of<TransacaoProvider>(context, listen: false).getTransacoesDoDia(_dataCorrente)
            .then((value) {
          _transacoesCaixaDoDia = value;
          _transacoesCaixaDoDia.sort((a,b) {
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
          print("------");
          _transacoesDoDia.forEach((element) {
            print(element.id1);

          });
          print("------");
          print(_transacoesDoDia.length);
        });

    }

    if(_transacoesDoDia.length==0){
      Provider.of<PagamentoTransacaoProvider>(context, listen: false).getPagamentoTransacoesDoDia(_dataCorrente)
          .then((value) {
        _transacoesDoDia = value;
        _transacoesDoDia.sort((a,b) {
          int aHora = int.parse(a.horaPagamento.substring(0,2));
          int aMin = int.parse(a.horaPagamento.substring(3,5));
          int bHora = int.parse(b.horaPagamento.substring(0,2));
          int bMin = int.parse(b.horaPagamento.substring(3,5));
          if (aHora==bHora){
            return aMin.compareTo(bMin);
          } else {
            return aHora.compareTo(bHora);
          }
        });
        print("------");
        _transacoesDoDia.forEach((element) {
          print(element.id1);

        });
        print("------");
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
    await Provider.of<PagamentoTransacaoProvider>(context, listen: false).getPagamentoTransacoesDoDia(_dataCorrente)
        .then((value) {
      // if (this.mounted){
        _transacoesDoDia = value;
        _transacoesDoDia.sort((a,b) {
          int aHora = int.parse(a.horaPagamento.substring(0,2));
          int aMin = int.parse(a.horaPagamento.substring(3,5));
          int bHora = int.parse(b.horaPagamento.substring(0,2));
          int bMin = int.parse(b.horaPagamento.substring(3,5));
          if (aHora==bHora){
            return aMin.compareTo(bMin);
          } else {
            return aHora.compareTo(bHora);
          }
        });
        _transacoesDoDia.forEach((element) {
          print(element.id1);

        });
        // print(_transacoesDoDia.length.toString()+"transacoes");
      // }
    });

    await Provider.of<PagamentoProfissionalProvider>(context,listen:false)
        .getListPagamentosProfissionais(UtilData.obterDataDDMMAAAA(_dataCorrente))
        .then((value) {
        _pagamentoProfissional = value;
        _pagamentoProfissional.sort((a,b) {
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

  // Profissional getProfissionalByIdTransacao(String idTransacao){
  //
  // }
  Future<Profissional> getProfissionalByTransacao(String id)async{
    Profissional prof = Profissional();
    await Provider.of<PagamentoTransacaoProvider>(context,listen: false).getPagamentoTransacaoById2(id).then((value) async{
      String idTransacao = value!.idTransacao;
      await Provider.of<TransacaoProvider>(context,listen: false).getTransacaoById2(idTransacao).then((value1) {
        String idProf = value1!.idProfissional;
        print("idProf = $idProf");
        prof = _lprofissionais.firstWhere((element) => element.id1.compareTo(idProf)==0);
        return prof;
      });

    });
    return prof;
  }

  Future<Paciente> getPacienteByTransacao(String id)async{
    Paciente prof = Paciente();
    await Provider.of<PagamentoTransacaoProvider>(context,listen: false).getPagamentoTransacaoById2(id).then((value) async{
      String idTransacao = value!.idTransacao;
      await Provider.of<TransacaoProvider>(context,listen: false).getTransacaoById2(idTransacao).then((value1) {
        String idPac = value1!.idPaciente;
        print("idPac = $idPac");
        prof = _lpacientes.firstWhere((element) => element.id1.compareTo(idPac)==0);
        return prof;
      });

    });
    return prof;
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
                          
                          //imagem caixa + INFORMAÇÕES
                          Row(
                            children: [
                              //imagem
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,bottom: 4.0),
                                child: SizedBox(
                                    height: size.height * 0.1,
                                    width: size.width * 0.05,
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.asset(AppImages.caixa, filterQuality: FilterQuality.high,))),
                              ),
                              //data+dia
                              Padding(padding: EdgeInsets.only(left: 4.0),
                                child:
                                Container(
                                  color: AppColors.shape,
                                    child:  Column(
                                      children: [

                                        SizedBox(
                                          width: size.width*0.09,
                                          height: size.height*0.06,
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: size.width*0.017,
                                                height: size.height*0.06,
                                                child:  InkWell(
                                                    onTap: () {
                                                      _dataCorrente = _dataCorrente.subtract(Duration(days: 1));
                                                      getvaloresDoDia();
                                                      // setState((){});
                                                    },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: size.width*0.017,
                                                    height: size.height*0.06,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.primaryColor,
                                                        shape: BoxShape.circle
                                                    ),
                                                    child: Icon(Icons.arrow_left_outlined,
                                                      size: size.height*0.04,
                                                      color: AppColors.labelBlack,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width*0.048,
                                                height: size.height*0.06,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(UtilData.obterDataDDMMAAAA(_dataCorrente).substring(0,5)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width*0.017,
                                                height: size.height*0.06,
                                                child: InkWell(
                                                  onTap: avanca()?(){
                                                    _dataCorrente = _dataCorrente.add(Duration(days: 1));
                                                    getvaloresDoDia();
                                                  }:null,

                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: size.width*0.018,
                                                    height: size.height*0.06,
                                                    decoration: BoxDecoration(
                                                        color: avanca()?AppColors.primaryColor:AppColors.line,
                                                        shape: BoxShape.circle
                                                    ),
                                                    child: Icon(Icons.arrow_right,
                                                      size: size.height*0.04,
                                                      color: AppColors.labelBlack,
                                                    ),
                                                  )
                                                ),

                                              ),

                                            ],
                                          )
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
                            height: size.height * 0.46,
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
                                  //DINHEIRO
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Text("Dinheiro: ", style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_valorDinheiro", style: AppTextStyles.labelBlack14FredokaOne,),
                                    ],
                                  ),
                                  //PIX
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Pix: ",style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_valorPix",style: AppTextStyles.labelBlack14FredokaOne,),
                                    ],
                                  ),
                                  //CARTÃO
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
                                      SizedBox(
                                        width: size.width*0.08,
                                        height: size.height*0.04,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text("Retirada Caixa: ",style: AppTextStyles.labelBlack16Lex,),

                                        )
                                      ),
                                      SizedBox(
                                          width: size.width*0.05,
                                          height: size.height*0.04,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerRight,
                                            child: Text("$_valorDespesaCaixa",style: AppTextStyles.labelRed14FredokaOne,),
                                          )
                                      ),
                                      // Text("Retirada Caixa: ",style: AppTextStyles.labelBlack16Lex,),
                                      // Text("$_valorDespesa",style: AppTextStyles.labelRed14FredokaOne,),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: size.width*0.08,
                                          height: size.height*0.04,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text("Transação Bancária: ",style: AppTextStyles.labelBlack16Lex,),

                                          )
                                      ),
                                      SizedBox(
                                          width: size.width*0.05,
                                          height: size.height*0.04,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerRight,
                                            child: Text("$_valorDespesaConta",style: AppTextStyles.labelRed14FredokaOne,),
                                          )
                                      ),


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
                                  Divider(
                                    thickness: 3,
                                    color: AppColors.labelBlack,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("SALDO",style: AppTextStyles.labelBlack16Lex,),
                                      Text("$_saldo",style: AppTextStyles.labelBlack14FredokaOne,),
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
                              height: size.height * 0.25,
                              width: size.width*0.18,
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
                                child: Wrap(
                                  // crossAxisAlignment: WrapCrossAlignment.center,
                                  // alignment: WrapAlignment.center,
                                  spacing: size.width*0.02,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height*0.12, width: size.width*0.05,
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
                                  SizedBox(
                                    height: size.height*0.12, width: size.width*0.05,
                                    child: MenuIconLabelButtonWidget(
                                        label: "INADIMPLENTES",
                                        height: size.height*0.08, width: size.width*0.05,
                                        iconData: Icons.monetization_on,
                                        onTap: ()async{
                                          List<Sessao> listInadimplentes = [];
                                          List<ServicosProfissional> listServicoProfissional = [];
                                          // List<Sessao> listInadimplentes = [];
                                          String getNomePaciente(String idPaciente){
                                            String result = "";
                                            _lpacientes.forEach((element) {
                                              if(element.id1.compareTo(idPaciente)==0){
                                                result=element.nome!;
                                              }
                                            });
                                            return result;
                                          }
                                          String getNomeProfissional(String idProfissional){
                                            print(idProfissional);
                                            String result = "";
                                            _lprofissionais.forEach((element) {
                                               if(element.id1.compareTo(idProfissional)==0){
                                                 result=element.nome!;
                                               }

                                            });
                                            return result;
                                          }
                                          await Provider.of<SessaoProvider>(context, listen: false).getListPendentes().then((value) async{
                                            listInadimplentes = value;
                                            print("inad = ${listInadimplentes.length}");
                                            // var seen = Set<String>();
                                            // listInadimplentes = list.where((element) => seen.add(element.idPaciente!)).toList();
                                            // print("${list.length} = ${listInadimplentes.length}");
                                            listInadimplentes.sort((a, b) {
                                              int intNome = getNomePaciente(a.idPaciente!).compareTo(getNomePaciente(b.idPaciente!));
                                              if (intNome==0){
                                                 // a.idPaciente.toString().compareTo(b.idPaciente.toString());
                                                return a.descSessao!.compareTo(b.descSessao!);
                                              }
                                              return intNome;
                                            } );
                                            print("ordenou");
                                            // listInadimplentes.sort((a, b) => a.idPaciente.toString().compareTo(b.idPaciente.toString()));

                                            await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                                                .getListServicosProfissional().then((value) async{
                                                listServicoProfissional = value;

                                            //    _listC.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
                                            });

                                            Dialogs.AlertInadimplentes(context,_uid,listInadimplentes, _lprofissionais, listServicoProfissional);

                                          });
                                          getvaloresDoDia();
                                          setState((){});
                                          // List<CategoriaDespesa> _listC = [];
                                          // Provider.of<CategoriaDespesaProvider>(context, listen:false)
                                          //     .getListCategorias().then((value) async {
                                          //   print("entrouu");
                                          //   print(value.length);
                                          //   _listC = value;
                                          //   _listC.sort((a, b) => a.descricao.toString().compareTo(b.descricao.toString()));
                                          //   await Dialogs.AlertCadastrarDespesa(context,_listC);
                                          //   getvaloresDoDia();
                                          //   setState((){});
                                          // });


                                        }),),
                                  SizedBox(
                                    height: size.height*0.12, width: size.width*0.05,
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
                                  SizedBox(
                                    height: size.height*0.12, width: size.width*0.05,
                                    child: MenuButtonWidget(
                                        label: "ATENDIMENTOS",
                                        height: size.height*0.08, width: size.width*0.05,
                                        image: AppImages.consulta,
                                        onTap: () async{
                                          List<Sessao> sessoesDoDia = [];
                                          List<Comissao> listComissao = [];

                                          await  Provider.of<SessaoProvider>(context, listen: false)
                                                .getListSessoesDoDia(UtilData.obterDataDDMMAAAA(_dataCorrente)).then((value)async {
                                              sessoesDoDia = value;
                                              await Provider.of<ComissaoProvider>(context, listen:false)
                                                  .getComissaoDoDia(UtilData.obterDataDDMMAAAA(_dataCorrente)).then((value) {
                                                  listComissao = value;
                                                  print(listComissao.length.toString()+"!!!");
                                                  Dialogs.AlertDialogExtrato(context,listComissao,_lprofissionais, _lpacientes, _transacoesCaixaDoDia, sessoesDoDia,_dataCorrente);

                                              });

                                          });
                                        }
                                    ),
                                  ),
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
                                  return (_transacoesDoDia.length>0)? Card(
                                    elevation: 8,
                                    child: ListTile(
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: size.width * 0.22,
                                                  height: size.height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment: Alignment.centerLeft,
                                                    child:  Text(
                                                      _transacoesDoDia[index].descServico,
                                                      style: AppTextStyles.subTitleBlack,),
                                                  )
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02,
                                                  height: size.height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment: Alignment.centerRight,
                                                    child:  Text(
                                                      _transacoesDoDia[index].id1.substring(0,4),
                                                      style: AppTextStyles.subTitleBlack,),
                                                  )
                                              ),

                                            ],
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Text("PROFISSIONAL: ", style: AppTextStyles.subTitleBlack, ),
                                                FutureBuilder(
                                                    future: getProfissionalByTransacao(_transacoesDoDia[index].id1),
                                                    builder: (context,snapshot){
                                                      print(_transacoesDoDia[index].id1);
                                                      if (snapshot.hasData){
                                                        print("encontrou");

                                                        Profissional prof = snapshot.data as Profissional;
                                                        return Text(prof.nome!,  style: AppTextStyles.labelBold14,);
                                                      } else {
                                                        print("não encontrou");
                                                        return Center(
                                                            child: Text("")
                                                        );
                                                      }
                                                    }),
                                                // FutureBuilder(
                                                //     future: Provider.of<ProfissionalProvider>
                                                //       (context, listen:false)
                                                //         .getProfissional(_transacoesDoDia[index].idProfissional),
                                                //     builder: (context, snapshot){
                                                //       if (snapshot.hasData){
                                                //         Profissional prof = snapshot.data as Profissional;
                                                //         return Text(prof.nome!,  style: AppTextStyles.labelBold14,);
                                                //       } else {
                                                //         return Center(
                                                //             child: Text("")
                                                //         );
                                                //       }
                                                //     }),
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
                                                    future: getPacienteByTransacao(_transacoesDoDia[index].id1),
                                                    builder: (context,snapshot){
                                                      print(_transacoesDoDia[index].id1);
                                                      if (snapshot.hasData){
                                                        // print("encontrou");
                                                        Paciente pac = snapshot.data as Paciente;
                                                        return Text(pac.nome!,  style: AppTextStyles.labelBold14,);
                                                      } else {
                                                        // print("não encontrou");
                                                        return Center(
                                                            child: Text("")
                                                        );
                                                      }
                                                    }),
                                                // FutureBuilder(
                                                //     future: Provider.of<PacienteProvider>
                                                //       (context, listen: false).getPaciente(_transacoesDoDia[index].idPaciente),
                                                //     builder: (context, snapshot){
                                                //       if (snapshot.hasData){
                                                //         Paciente pac = snapshot.data as Paciente;
                                                //         return Text(pac.nome!, style: AppTextStyles.labelBold14 );
                                                //       } else {
                                                //         return Center(child: Text(""),);
                                                //       }
                                                //     }),
                                              ],
                                            ),
                                          ),

                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("${_transacoesDoDia[index].valorPagamento}   ", style: AppTextStyles.labelBlack14FredokaOne),
                                                Text(_transacoesDoDia[index].tipoPagamento, style: AppTextStyles.subTitleBlack),
                                                Text("  "+_transacoesDoDia[index].horaPagamento, style: AppTextStyles.subTitleBlack),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                    ),
                                  ):Center();
                          })
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
                                            height: size.height*0.13,
                                            child: ListTile(
                                              title: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: size.width * 0.1,
                                                        height: size.height*0.03,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(_despesasDoDia[index].categoria, style: AppTextStyles.subTitleBlack,),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.05,
                                                        height: size.height*0.02,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          alignment: Alignment.centerRight,
                                                          child: Text(_despesasDoDia[index].id1.substring(0,4), style: AppTextStyles.subTitleBlack,),
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(_despesasDoDia[index].descricao, style: AppTextStyles.labelBold14,),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text("Retirada ${_despesasDoDia[index].retirada}", style: AppTextStyles.labelBlack14Lex,),
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
                                      child: InkWell(
                                        onTap: ()async{           
                                          // getProfissionalByTransacao(id)
                                          Profissional prof = Profissional();
                                          List<Comissao> listComissao = [];
                                          List<Paciente> listPaciente = [];
                                         await Provider.of<ProfissionalProvider>(context,listen: false)
                                              .getProfissional(_pagamentoProfissional[index].idProfissional).then((value) async {
                                                prof = value;
                                                await Provider.of<ComissaoProvider>(context,listen: false)
                                                    .getComissaoByPagamento(_pagamentoProfissional[index].idProfissional,_pagamentoProfissional[index].id1)
                                                    .then((value) async {
                                                    listComissao = value;
                                                    print("listComissao");
                                                    print(listComissao.length);


                                                    await Dialogs.AlertDetalhesPagamentoProfissional(context,prof,_pagamentoProfissional[index], listComissao);

                                                });
                                          });

                                        },
                                        child: Container(
                                          width: size.width * 0.2,
                                          height: size.height*0.1,
                                          child: ListTile(
                                            title: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.13,
                                                      height: size.height * 0.03,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        alignment: Alignment.centerLeft,
                                                        child: Text("PROFISSIONAL: ", style: AppTextStyles.subTitleBlack, ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: size.width * 0.03,
                                                      height: size.height * 0.02,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        alignment: Alignment.centerRight,
                                                        child: Text(_pagamentoProfissional[index].id1.substring(0,4), style: AppTextStyles.subTitleBlack, ),

                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                      )
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
