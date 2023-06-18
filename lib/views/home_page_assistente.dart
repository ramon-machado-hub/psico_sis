import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psico_sis/provider/sessao_provider.dart';
import 'package:psico_sis/service/prefs_service.dart';
import 'package:psico_sis/themes/app_images.dart';
import 'package:psico_sis/widgets/menu_button_widget.dart';
import '../model/Usuario.dart';
import '../model/sessao.dart';
import '../provider/usuario_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/app_bar_widget2.dart';
import '../widgets/menu_icon_button_widget.dart';


class HomePageAssistente extends StatefulWidget {

  const HomePageAssistente({Key? key}) : super(key: key);

  @override
  State<HomePageAssistente> createState() => _HomePageStateAssitente();
}

class _HomePageStateAssitente extends State<HomePageAssistente> {

  var db = FirebaseFirestore.instance;
  String _uid="";
  late Usuario _usuario = Usuario(
    idUsuario:1,
    senhaUsuario: "",
    loginUsuario: "",
    dataNascimentoUsuario: "",
    telefone: "",
    nomeUsuario: "",
    emailUsuario: "",
    statusUsuario:  "",
    tokenUsuario: "",
  );

  Future<Usuario> getUsuarioByUid(String uid) async {
    print("uid getUsuarioByUid $uid");
    if (uid.isEmpty){
      print("empity");
      String _uidGet ="";
      print("_uidGet $_uidGet");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    } else{
      print(" not empity");
      return Provider.of<UsuarioProvider>(context, listen: false)
          .getUsuarioByUid2(uid);
    }

  }


  @override
  void initState(){
    super.initState();
    Future.wait([
      PrefsService.isAuth().then((value) async {
        if (value){
          print("usuário autenticado home");
         await PrefsService.getUid().then((value) async {
            _uid = value;
            print("_uid initState home $_uid");
            await getUsuarioByUid(_uid).then((value) {
              _usuario = value;
            }).then((value) {
              if (this.mounted){
                setState((){
                  print("setState home");
                });
              }
            });
          });
        } else {
            print("usuário não conectado initState Home Assistente");
            ///nav
            Navigator.pushReplacementNamed(
                context, "/login");
        }
      }),

    ]);

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
          preferredSize: Size.fromHeight(80),

          child: AppBarWidget2(nomeUsuario: _usuario.nomeUsuario!),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                colors: [
                  AppColors.shape,
                  AppColors.primaryColor,
                ],
              )),
          child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.labelWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: size.width * 0.70,
                height: size.height * 0.7,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: size.width * 0.025,
                  runSpacing: size.height * 0.05,
                  children: [

                    MenuIconButtonWidget(
                        label: "Agenda",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.calendar_month_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/agenda_assistente", );
                        }),


                    MenuIconButtonWidget(
                        label: "Aniversariantes",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.cake_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/aniversariantes");
                        }),


                    MenuIconButtonWidget(
                        label: "Caixa",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.monetization_on,
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/caixa2");
                        }),

                    MenuIconButtonWidget(
                        label: "Cadastro Usuário",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.person_add,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/cadastro_usuario");
                    }),

                    MenuButtonWidget(
                      label: "Sessões",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      image: AppImages.consulta,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/sessao");
                      },
                    ),

                    MenuButtonWidget(
                      label: "Especialidades",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      image: AppImages.experiencia,
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/especialidades", (_) => false);
                        // Navigator.pushReplacementNamed(context, "/especialidades");

                      },
                    ),

                    MenuButtonWidget(
                      label: "Pacientes",
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      image: AppImages.paciente2,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, "/pacientes");
                      },
                    ),

                    MenuIconButtonWidget(
                        label: "Parceiros",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.handshake_rounded,
                        onTap: () async{
                          
                          // ---recuperar serviços profissional
                          // await Provider.of<ServicoProfissionalProvider>(context, listen: false)
                          //     .getListServicosProfissional()
                          //     .then((value) {
                          //     List<ServicosProfissional> list = value;
                          //     list.sort((a,b)=>a.idServico!.compareTo(b.idServico!));
                          //     for (var value1 in list) {
                          //       print("-----------");
                          //       print(value1.id1);
                          //       print(value1.idProfissional);
                          //       print(value1.valor);
                          //       print(value1.idServico);
                          //     }
                          // });

                          //---recuperar serviços
                          // await Provider.of<ServicoProvider>(context,listen: false).getListServicos().then((value) {
                          //
                          //   List<Servico> list = value;
                          //   list.sort((a,b)=>a.descricao!.compareTo(b.descricao!));
                          //   for (var value1 in list) {
                          //     print("-----------");
                          //     print(value1.id1);
                          //     print(value1.descricao);
                          //     // print(value1.valor);
                          //     // print(value1.idServico);
                          //   }
                          // });
                          
                              // await Provider.of<TransacaoProvider>(context, listen: false)
                              //     .getTransacoes().then((value) async {
                              //      List<TransacaoCaixa> list = value;
                              //      for (var value1 in list)  {
                              //        await Provider.of<PagamentoTransacaoProvider>(context,listen: false).putTransacao(PagamentoTransacao(
                              //                 idTransacao: value1.id1,
                              //                 dataPagamento: value1.dataTransacao,
                              //                  descServico: value1.descricaoTransacao,
                              //                  horaPagamento: value1.horaTransacao!,
                              //                  tipoPagamento: value1.tpPagamento,
                              //                  valorPagamento: value1.valorTransacao,
                              //                  valorTotalPagamento: value1.valorTransacao,
                              //        ));
                              //      }
                              // });

                          // ------
                          //   await Provider.of<ComissaoProvider>(context, listen: false)
                          //               .getListComissao2("Fqtj4ICaT7dt7p8E3x5HRsK07B93").then((value) {
                          //               List<Comissao> list = [];
                          //               list = value;
                          //               list.forEach((element) async{
                          //
                          //                 print("---------");
                          //                 print(element.id1);
                          //                 print(element.idProfissional);
                          //                 print(element.dataGerada);
                          //                 print(element.dataPagamento);
                          //                 print(element.situacao);
                          //                 print(element.valor);
                          //               });
                          //           });

                          // SESSÃO SEM SALA
                          await Provider.of<SessaoProvider>(context, listen: false)
                              .getSessoesByTransacaoPacProf(
                              "igLK08hkDL1iszc2ffVC",
                              "ebqwUjfkdCOB5uiEN1mRFYPXlen2",
                              "").then((value) {
                              // .getListSessoesSemSala().then((value) {
                                List<Sessao> list = value;
                                List<String> contSessao = [];
                                List<String> idSessoesAPagar = [];
                                String contSessaoAtual="";
                                list.forEach((element) {
                                  for (int i=8;i<element.descSessao!.length; i++) {
                                    if  (element.descSessao![i].compareTo(" ")!=0) {
                                      contSessaoAtual += element.descSessao![i];
                                    } else{
                                      break;
                                    }
                                  }
                                  if (contSessao.contains(contSessaoAtual)==false){
                                    contSessao.add(contSessaoAtual);
                                    contSessaoAtual = "";
                                  }
                                  print("-------");
                                  print(element.id1);
                                  print(element.idProfissional);
                                  print(element.idPaciente);
                                  print(element.dataSessao);
                                  print(element.horarioSessao);
                                  print(element.descSessao);
                                  print(element.salaSessao);
                                });
                              });



                            // ------
                            // Navigator.pushReplacementNamed(
                            //     context, "/agendamento_geral");
                        }),




                    MenuIconButtonWidget(
                        label: "Profissionais",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.people_alt,
                        onTap: () async{
                          Navigator.pushReplacementNamed(
                              context, "/profissionais");
                          // await Provider.of<ServicoProfissionalProvider>(context,
                          //   listen: false).getListServicosProfissional().then((value)
                          // => );
                          
                        }),

                    MenuIconButtonWidget(
                        label: "Serviços",
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        iconData: Icons.local_pharmacy_rounded,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/servicos");
                        }),
                    //inserindo responsavel em paciente
                  //   MenuIconButtonWidget(
                  //       label: "Alterar Paciente",
                  //       height: size.width * 0.1,
                  //       width: size.width * 0.1,
                  //       iconData: Icons.ac_unit,
                  //       onTap: () async{
                  //         await Provider.of<PacienteProvider>(context, listen: false)
                  //             .getListPacientes().then((value) {
                  //             List<Paciente> list = [];
                  //             list = value;
                  //             list.forEach((element) async{
                  //                await Provider.of<PacienteProvider>(context,
                  //                listen: false).updateNomeResponsavel(element.id1,"NÃO INFORMADO");
                  //             });
                  //         });
                  //         //             .put(ServicosProfissional(
                  // }),

                    // MenuIconButtonWidget(
                    //     label: "TESTE",
                    //     height: size.width * 0.05,
                    //     width: size.width * 0.05,
                    //     iconData: Icons.local_pharmacy_rounded,
                    //     onTap: () async {
                    //       String valor = "90,00";
                    //       String valorFinal = valor.substring(0,valor.length-3);
                    //       String comissao = (double.parse(valorFinal)*0.73).toStringAsFixed(2).replaceAll('.', ',');
                    //           // *0.7;
                    //       print(comissao.toString());
                    //
                    //       print(valorFinal);
                    //       // servicoProfissional!.valor!.substring(0,servicoProfissional!.valor!.length-3);
                    //
                    //     }),

                    //transacoes
                    // MenuIconButtonWidget(
                    //     label: "adicionar  social",
                    //     height: size.width * 0.05,
                    //     width: size.width * 0.05,
                    //     iconData: Icons.local_pharmacy_rounded,
                    //     onTap: () async {
                    //       List<String> list = [
                    //         '4Bfp2wqXtx0m2PYxBaYs',
                    //         '5LGIZZgEMg1sn8GW9sXU',
                    //         'DO7p7P5Nv1ENzr9elV1c',
                    //         'HUv8fznaNZ3RbBlQGSJh',
                    //         'LGVfsVwGAWUnZDte7vHu',
                    //         'O5OlYeX2vhQimmnD0k4S',
                    //         'OJkB60vA35OrZFQD5ChE',
                    //         'PaEdPQ2esQ1D8tCJ0tE7',
                    //         'RZyr2XxEybTixJyc8UFr',
                    //         'SThvIW0MPZdyLQj5m5Gk',
                    //         'SplHY2TM1jBGoDCEXokd',
                    //         'b5rCot5PkIZjUxBtFYgL',
                    //         'beJouyDypPKSCNpoHMCS',
                    //         'iH9KLENKeHr9iZSXLlLZ',
                    //         'kZZQbOA0jBRvsOtfHx7N',
                    //         'pf6OoIATgSGFgMiQBm5O',
                    //         'wKPotxwTM5bbArFLbC5u',
                    //         'wj69tIESkDKxD6nifq4z',
                    //       ];
                    //       for (int i =0; i<list.length;i++){
                    //         await Provider.of<TransacaoProvider>(context, listen: false)
                    //         // .putBack(element);
                    //             .updateBack(list[i]);
                    //       }
                    //         //SALVANDO transacao
                    //         // await Provider.of<TransacaoProvider>(context, listen: false)
                    //         //     .getTransacoes().then((value) {
                    //         //    List<TransacaoCaixa> list = [];
                    //         //    list = value;
                    //         //    list.forEach((element) async {
                    //         //      print(element.id1);
                    //         //      print(element.valorTransacao);
                    //         //
                    //         //      await Provider.of<TransacaoProvider>(context, listen: false)
                    //         //       // .putBack(element);
                    //         //       .updateBack(element.id1);
                    //         //    });
                    //         // });
                    //     }),

                    //inserindo diasProfissional
                    // MenuIconButtonWidget(
                    //     label: "alterando ",
                    //     height: size.width * 0.1,
                    //     width: size.width * 0.1,
                    //     iconData: Icons.local_pharmacy_rounded,
                    //     onTap: () async{
                    //           List<DiasSalasProfissionais> listDSP = [];
                    //           List<DiasProfissional> listDias= [];
                    //           await Provider.of<DiasSalasProfissionaisProvider>
                    //             (context, listen: false).getList().then((value) {
                    //               listDSP = value;
                    //               bool result = false;
                    //               listDSP.forEach((element) {
                    //                 result = true;
                    //                 listDias.forEach((element1) {
                    //                   if ((element.dia!.compareTo(element1.dia!)==0) &&
                    //                       (element.idProfissional!.compareTo(element1.idProfissional!)==0)
                    //                   ) {
                    //                     result= false;
                    //                   }
                    //                 });
                    //                 if (result){
                    //                   print("inseriu");
                    //                   print("idProfissional = ${element.idProfissional}");
                    //                   print("dia ${element.dia}");
                    //                   listDias.add(DiasProfissional(idProfissional: element.idProfissional, dia: element.dia));
                    //                 }
                    //               });
                    //               print(listDSP.length);
                    //               print(listDias.length);
                    //               listDias.forEach((element) async {
                    //                 await Provider.of<DiasProfissionalProvider>(context, listen: false).put(element);
                    //               });
                    //
                    //           });
                    //     }) ,

                    // MenuIconButtonWidget(
                    //     label: "alterando ",
                    //     height: size.width * 0.1,
                    //     width: size.width * 0.1,
                    //     iconData: Icons.local_pharmacy_rounded,
                    //     onTap: () async {
                    //       // List<Paciente> list = [];
                    //       // await Provider.of<PacienteProvider>
                    //       //   (context, listen: false).getListPacientes()
                    //       //     .then((value) {
                    //       //       print("entrou");
                    //       //     list = value;
                    //       //     int count =0;
                    //       //     list.forEach((element)async {
                    //       //       print(count);
                    //       //       count++;
                    //       //       await Provider.of<PacienteProvider>
                    //       //         (context,listen: false).put2(element);
                    //       //       // .then((value1) => print('inseriu ${element.id} = $value1 '));
                    //       //     });
                    //
                    //
                    //           // for (int i =0; i<list.length; i++)
                    //           // {
                    //           //   list.forEach((element)async {
                    //           //     if ((list[i].nome!.trim().compareTo(element.nome!.trim())==0)&&
                    //           //         (list[i].idPaciente!.compareTo(element.idPaciente!)!=0)
                    //           //     ){
                    //           //       print("id1 = ${list[i].idPaciente}");
                    //           //       print("id2 = ${element.idPaciente}");
                    //           //       print(element.nome);
                    //           //       print(element.idPaciente);
                    //           //
                    //           //     }
                    //               // print(element.nome);
                    //               // print(element.idPaciente);
                    //               // print('---------------');
                    //               // await Provider.of<PacienteProvider>
                    //               //   (context,listen: false).put2(element);
                    //               // .then((value1) => print('inseriu ${element.id} = $value1 '));
                    //             // });
                    //           // }
                    //
                    //       // });
                    //
                    //
                    //
                    //
                    //
                    //     }),

                  ],
                ),
              )), // child: Container(
        ),
      ),
    );
  }
}
