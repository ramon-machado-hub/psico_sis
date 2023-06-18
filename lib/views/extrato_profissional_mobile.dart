import 'dart:html';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/dialogs/alert_dialog_prof_mobile.dart';
import 'package:psico_sis/model/dias_profissional.dart';
import 'package:psico_sis/model/dias_salas_profissionais.dart';
import 'package:psico_sis/model/pagamento_profissional.dart';
import 'package:psico_sis/model/servicos_profissional.dart';
import 'package:psico_sis/model/transacao_caixa.dart';
import 'package:psico_sis/provider/paciente_provider.dart';
import 'package:psico_sis/provider/pagamento_profissional_provider.dart';
import 'package:psico_sis/provider/pagamento_transacao_provider.dart';
import 'package:psico_sis/provider/profissional_provider.dart';
import 'package:psico_sis/provider/servico_profissional_provider.dart';
import 'package:psico_sis/provider/servico_provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/provider/transacao_provider.dart';
import 'package:psico_sis/service/prefs_service.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/themes/app_text_styles.dart';
import 'package:psico_sis/widgets/app_bar__profissional_widget.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';
import '../model/Paciente.dart';
import '../model/Profissional.dart';
import '../model/Usuario.dart';
import '../model/comissao.dart';
import '../model/login.dart';
import '../model/pagamento_transacao.dart';
import '../model/servico.dart';
import '../model/sessao.dart';
import '../provider/comissao_provider.dart';
import '../provider/dias_profissional_provider.dart';
import '../provider/dias_salas_profissionais_provider.dart';
import '../provider/usuario_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/menu_icon_button_widget.dart';


class ExtratoProfissionalMobile extends StatefulWidget {

  const ExtratoProfissionalMobile({Key? key}) : super(key: key);

  @override
  State<ExtratoProfissionalMobile> createState() => _ExtratoProfissionalMobileState();
}

class _ExtratoProfissionalMobileState extends State<ExtratoProfissionalMobile> {

  String _uid="";
  late Profissional _usuario = Profissional(
    nome: "",cpf: "",dataNascimento: "",email: "",endereco: "",id: "",numero: "",senha: "",status: "",telefone: "",);

  late int mesAtual = DateTime.now().month;
  late int anoAtual = DateTime.now().year;
  late DateTime _dataCorrente = DateTime.now();
  List<Comissao> listComissao = [];
  List<PagamentoProfissional> listPagamentos = [];

  bool opcao1 = true;


  Future<Profissional> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty){
      print("empity");
      String _uidGet ="";
      print("_uidGet $_uidGet");
      return await Provider.of<ProfissionalProvider>(context, listen: false)
          .getProfissional(_uidGet);
    } else{
      print(" not empity $uid");
      return await Provider.of<ProfissionalProvider>(context, listen: false)
          .getProfissional(uid);
    }

  }


  @override
  void initState(){
    _usuario.id1="";
    super.initState();
    Future.wait([
      PrefsService.isAuth().then((value) async {
        if (value){
          print("usuário autenticado ExtratoProfissional");
          await PrefsService.getUid().then((value) async {
            _uid = value;
            print("_uid initState ExtratoProfissional $_uid");
            await getUsuarioByUid(_uid).then((value) {
              _usuario = value;
            }).then((value) {
              if (this.mounted) {
                setState((){
                  print("setState ExtratoProfissional ");
                });
              }
            });
          });
          if (listComissao.length==0){
            await Provider.of<ComissaoProvider>(context,listen: false)
                .getComissoesByProfissional(_uid).then((value) {
              listComissao = value;
              print(value.length);
              // listComissao.sort();
                listComissao.sort((a,b) {

                  DateTime aaa = DateTime(
                      int.parse(a.dataPagamento.substring(6,10)),
                      int.parse(a.dataPagamento.substring(3,5)),
                      int.parse(a.dataPagamento.substring(0,2)),
                  );
                  DateTime bbb = DateTime(
                    int.parse(b.dataPagamento.substring(6,10)),
                    int.parse(b.dataPagamento.substring(3,5)),
                    int.parse(b.dataPagamento.substring(0,2)),
                  );
                  // print("a = ${aaa}");
                  // print("b = ${bbb}");
                  return aaa.compareTo(bbb);
                });
                print(listComissao.first.dataPagamento);
              listComissao = listComissao.reversed.toList();
              print(listComissao.first.dataPagamento);

              setState((){});
            });
          }
          if (listPagamentos.length==0){
             await Provider.of<PagamentoProfissionalProvider>(context, listen: false)
                 .getListPagamentosByIdProfissional(_uid).then((value) {
                   listPagamentos = value;
                   listPagamentos.sort((a,b) {
                     DateTime aaa = DateTime(
                       int.parse(a.data.substring(6,10)),
                       int.parse(a.data.substring(3,5)),
                       int.parse(a.data.substring(0,2)),
                     );
                     DateTime bbb = DateTime(
                       int.parse(b.data.substring(6,10)),
                       int.parse(b.data.substring(3,5)),
                       int.parse(b.data.substring(0,2)),
                     );
                     return aaa.compareTo(bbb);
                   });
                   listPagamentos = listPagamentos.reversed.toList();
                   setState((){});
             });

          }
        } else {
          print("usuário não conectado initState HomeProfissional");
          ///nav
          Navigator.pushReplacementNamed(
              context, "/login");
        }
      }),
    ]);
  }

  Future<String> getNomePacienteByIdTransacao(String id)async{
    String result = "";
    await Provider.of<TransacaoProvider>(context, listen: false)
        .getTransacaoById2(id).then((value) async {
          if (value!.idPaciente.isNotEmpty){
             await Provider.of<PacienteProvider>(context, listen: false).getPaciente(value.idPaciente).then((value) {
                  result = value.nome!;
             });
          }
    });

    return result;

  }

  Future<String> getDescSessaoByIdTransacao(String id)async{
    String result = "";
    await Provider.of<TransacaoProvider>(context, listen: false)
        .getTransacaoById2(id).then((value) async {
      if (value!.idPaciente.isNotEmpty){
        result = value.descricaoTransacao;
      }
    });

    return result;

  }




  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    // print("usuario depois do builder = ${_usuario.nomeUsuario}");
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),

          child: AppBarProfissional(nomeUsuario: _usuario.nome!),
        ),
        // bottomNavigationBar: Container,
        body: (_usuario.id1.compareTo("")==0)?
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.labelWhite,
                  AppColors.shape,
                ],
              )),
        )
            :
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.labelWhite,
                  AppColors.shape,
                ],
              )),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(
                  height: size.height*0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        opcao1 = !opcao1;
                        setState((){});
                      },
                      child: Container(
                          width: size.width*0.425,
                          height: size.height*0.04,
                          decoration: BoxDecoration(
                              color: (opcao1)?AppColors.primaryColor:AppColors.line.withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              )

                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text("DETALHADO", style: (opcao1)?AppTextStyles.labelBlack12Lex:AppTextStyles.labelLine12Lex,),
                          )

                      ),
                    ),
                    InkWell(
                      onTap: (){
                        opcao1 = !opcao1;
                        setState((){});
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: (opcao1)?AppColors.line.withOpacity(0.2):AppColors.primaryColor,
                              // border: ,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              )

                          ),
                          width: size.width*0.425,
                          height: size.height*0.04,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text("GERAL", style: (opcao1)?AppTextStyles.labelLine12Lex:AppTextStyles.labelBlack12Lex,),
                          )

                      ),
                    )
                  ],
                ),
                (opcao1)?
                Container(
                  width: size.width*0.85,
                  height: size.height*0.8,
                  color: AppColors.shape,
                  child: ListView.builder(
                    itemCount: listComissao.length,
                    itemBuilder: (BuildContext, index){
                       return Card(
                         child: Container(
                           width: size.width*0.85,
                           height: size.height*0.06,
                           child: Row(
                             children: [
                               SizedBox(
                                 width: size.width*0.15,
                                 height: size.height*0.06,
                                 child: FittedBox(
                                   fit: BoxFit.scaleDown,
                                   child: Text(listComissao[index].dataPagamento.substring(0,5), style: AppTextStyles.labelBlack12Lex,),
                                 )
                               ),
                               SizedBox(
                                 width: size.width*0.15,
                                 height: size.height*0.06,
                                   child: FittedBox(
                                     fit: BoxFit.scaleDown,
                                     child: Text("R\$ ${listComissao[index].valor}",style: AppTextStyles.labelBlack14Lex,),
                                   )
                               ),
                               SizedBox(
                                 width: size.width*0.53,
                                 height: size.height*0.06,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [

                                      FutureBuilder(
                                          future: getNomePacienteByIdTransacao(listComissao[index].idTransacao),
                                          builder: (context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData){
                                              String result = snapshot.data as String;
                                              return SizedBox(
                                                  width: size.width*0.53,
                                                  height: size.height*0.03,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("  $result",style: AppTextStyles.labelBlack12Lex,),
                                                  )
                                              );
                                            } else {
                                              return Center(
                                                child: SizedBox(
                                                  width: size.height*0.03,
                                                  height: size.height*0.03,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: CircularProgressIndicator(),
                                                  )
                                                ),
                                              );
                                            }
                                          }
                                      ),
                                     FutureBuilder(
                                         future: getDescSessaoByIdTransacao(listComissao[index].idTransacao),
                                         builder: (context, AsyncSnapshot snapshot) {
                                           if (snapshot.hasData){
                                             String result = snapshot.data as String;
                                             return SizedBox(
                                                 width: size.width*0.53,
                                                 height: size.height*0.03,
                                                 child: FittedBox(
                                                   fit: BoxFit.scaleDown,
                                                   alignment: Alignment.centerLeft,
                                                   child: Text("  $result", style: AppTextStyles.labelBlack12Lex,),
                                                 )
                                             );
                                           } else {
                                             return Center(
                                               child: SizedBox(
                                                   width: size.height*0.03,
                                                   height: size.height*0.03,
                                                   child: FittedBox(
                                                     fit: BoxFit.scaleDown,
                                                     child: CircularProgressIndicator(),
                                                   )
                                               ),
                                             );
                                           }
                                         }
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),

                         )
                         // ListTile(
                         //   title:
                         //   subtitle: Text(listComissao[index].valor),
                         // ),
                       );
                    }
                  ),
                )
                    :
                Container(
                  width: size.width*0.85,
                  height: size.height*0.8,
                  color: AppColors.shape,
                  child: ListView.builder(
                      itemCount: listPagamentos.length,
                      itemBuilder: (buildContext, index){
                       return Card(
                         child: Container(
                           width: size.width*0.85,
                           height: size.height*0.06,
                           child: Row(
                             children: [
                               SizedBox(
                                 width: size.width*0.4,
                                 height: size.height*0.06,
                                 child: FittedBox(
                                   fit: BoxFit.scaleDown,
                                   alignment: Alignment.centerRight,
                                   child: Text(listPagamentos[index].data.substring(0,5), style: AppTextStyles.labelLine12Lex,),
                                 ),
                               ),
                               SizedBox(
                                 width: size.width*0.4,
                                 height: size.height*0.06,
                                 child: FittedBox(
                                   fit: BoxFit.scaleDown,
                                   alignment: Alignment.centerLeft,
                                   child: Text(" R\$ ${listPagamentos[index].valor}", style: AppTextStyles.labelBlack16Lex,),

                                 ),
                               ),
                             ],


                           ),
                         )
                       );
                    }
                  ),
                )
              ]
          ), // child: Container(
        ),
      ),
    );
  }
}
