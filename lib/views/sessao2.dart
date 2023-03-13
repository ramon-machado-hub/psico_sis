import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psico_sis/widgets/app_bar_widget.dart';
import 'package:psico_sis/widgets/list_hours_widget.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/button_widget.dart';
import '../widgets/list_hours_widget.dart';

class Sessao2 extends StatefulWidget {
  const Sessao2({Key? key}) : super(key: key);

  @override
  State<Sessao2> createState() => _Sessao2State();
}

class _Sessao2State extends State<Sessao2> {
  DateTime data = DateTime.now();
  List<int> dias = [2,6];
  //método que retorna o mês corrente.
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

  List <Widget> ListWidgets(context,int dayIn, int day, List<int> dayWork) {
    List <Widget> list = [];
    int cont = 1;
    Color color1 = AppColors.green;
    for (int i = dayIn; i < (dayIn +7); i++) {

      // Color color2 = AppColors.shape;
      if (i<31){
        list.add(Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: (getDayWork(cont,dayWork)) ?
            InkWell(
              onTap: (){
                print("entrou");

                print(color1);
                setState(() {
                  color1 = AppColors.blue; });
                print(color1);
                // Navigator.pushReplacementNamed(context, "/home_assistente");
              },
              child: Container(
                  color: color1,
                  child: Center(child: Text(i.toString()))),
            ):
            Container(
                color:  AppColors.shape ,
                child: Center(child: Text(i.toString())))
            ,
          ),
        ));
      } else {
        list.add(Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(

              ),
            )));
      }
      cont++;
    }
    return list;
  }

  List <Widget> ListHousColumn() {
    List <Widget> list = [];
    String hour = "";
    for (int i = 8; i < 20; i++) {
      if (i<10){
        hour = "0"+i.toString()+":00";
      } else {
        hour = i.toString()+":00";
      }
        list.add(Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListHoursWidget(hour: hour,),

          ),
        ));
    }
    return list;
  }

  bool getDiaTrabalhado(int dia){
    if (dias.contains(dia)){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    int _dia = data.day;
    int _mes = data.month;
    int _ano = data.year;
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
          child: Column(
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
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.shape),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.5),
                            child: Text("1", style: AppTextStyles.subTitleWhite14),
                          ),
                        ),
                        Expanded(child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding:  EdgeInsets.only(left: 6.0, right: 6.0),
                          child:  CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text("2", style: AppTextStyles.subTitleWhite14),
                          ),
                        ),
                        Expanded(child: Divider(
                          color: AppColors.line,
                          height: 3,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.line,
                            child: Text("3"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //container com calendário + horario
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.6,
                        height: size.height * 0.55,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.line,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.shape),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //calendário
                            Column(
                              children: [
                               const Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Text("SELECIONE A DATA DA 1º SESSÃO"),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: size.height * 0.45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: AppColors.line,
                                          width: 1,
                                        ),
                                      ),
                                      color: AppColors.labelWhite),
                                  child: Column(
                                    children: [
                                      //cabeçalho calendario < JANEIRO >
                                      Container(
                                        height: size.height * 0.05,
                                        color: AppColors.shape,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("<",style: AppTextStyles.subTitleBlack16,),
                                            Text(getMes(_mes)+"/"+_ano.toString(), style: AppTextStyles.subTitleBlack16,),
                                            Text(">",style: AppTextStyles.subTitleBlack16,)
                                          ],
                                        ),
                                      ),
                                      //dias da semana
                                      Container(
                                        height: size.height * 0.065,
                                        color: AppColors.shape,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(
                                                backgroundColor: AppColors.line,
                                                child: Text("D",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(

                                                backgroundColor: getDiaTrabalhado(2) ? Colors.green : AppColors.line,
                                                child: Text("S",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(

                                                backgroundColor: getDiaTrabalhado(3) ? Colors.green : AppColors.line,
                                                child: Text("T",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(

                                                backgroundColor: getDiaTrabalhado(4) ? Colors.green : AppColors.line,
                                                child: Text("Q",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(

                                                backgroundColor: getDiaTrabalhado(5) ? Colors.green : AppColors.line,
                                                child: Text("Q",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(
                                                backgroundColor: getDiaTrabalhado(6) ? Colors.green : AppColors.line,
                                                child: Text("S",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                              child: CircleAvatar(
                                                backgroundColor: getDiaTrabalhado(7) ? Colors.green : AppColors.line,
                                                child: Text("S",style: AppTextStyles.subTitleWhite14,),
                                                // color: Colors.red,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      //1 linha dias do mês
                                      Container(
                                        height: size.height * 0.065,
                                          child: Row(
                                            children:
                                            ListWidgets(context, 1, _dia, dias),
                                          )
                                      ),
                                      Container(
                                          height: size.height * 0.065,
                                          child: Row(
                                            children:
                                            ListWidgets(context,8, _dia, dias),
                                          )
                                      ),
                                      Container(
                                          height: size.height * 0.065,
                                          child: Row(
                                            children:
                                            ListWidgets(context,15, _dia, dias),
                                          )
                                        // child: RowDay(15, _dia, dias)
                                      ),
                                      Container(
                                          height: size.height * 0.065,
                                          child: Row(
                                            children:
                                            ListWidgets(context,22, _dia, dias),
                                          )
                                          // child: RowDay(22, _dia, dias)
                                      ),
                                      Container(
                                          height: size.height * 0.065,
                                          child: Row(
                                            children:
                                              ListWidgets(context,29, _dia, dias),
                                          )
                                          // child: RowDay(29, _dia, [2,3])
                                      ),
                                    ],
                                  ),
                                ),
                                Text(DateFormat("'Dia da semana:' EEEE",)
                                    .format(data)),
                              ],
                            ),
                            //horário
                            Column(
                              children: [
                                const Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Text("SELECIONE O HORÁRIO DA 1º SESSÃO"),
                                ),
                                Container(
                                  width: size.width * 0.05,
                                  height: size.height * 0.45,
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
                                      children: ListHousColumn(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),

                      ),

                    ],
                  ),
                ),
              ),
              ButtonWidget(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                label: "Avançar",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/sessao22", );
                },
              ),
            ],
          ),
        ));
  }
}

bool getDayWork(int dia, List<int> dias){
  if (dias.contains(dia)){
    return true;
  } else {
    return false;
  }
}




Widget RowDay(int dayIn, int day, List<int> dayWork){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
          for( int i = dayIn; i < (dayIn +7); i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  color: AppColors.shape,
                    child: Center(child: Text(i.toString()))),
              ),
            )


       ],
    );
}