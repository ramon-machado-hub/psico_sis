import 'package:intl/intl.dart';

class ValidatorService {

  static bool anoBisexto(int ano){

    return false;
  }

  static String getDiaCorrente(DateTime data) {
    String dia = DateFormat('EEEE').format(data);
    switch (dia) {
      case 'Monday':
        {
          return "SEGUNDA";
        }
      case 'Tuesday':
        {
          return "TERÇA";
        }
      case 'Wednesday':
        {
          return "QUARTA";
        }
      case 'Thursday':
        {
          return "QUINTA";
        }
      case 'Friday':
        {
          return "SEXTA";
        }
      case 'Saturday':
        {
          return "SÁBADO";
        }
      case 'Sunday':
        {
          return "Domingo";
        }
    }
    return "";
  }
  static bool validateAniversariante (String data){
    int dia = DateTime.now().day;
    int mes = DateTime.now().month;
    if ((int.parse(data.substring(0,2))==dia)&&
        (int.parse(data.substring(3,5))==mes)){
      return true;
    }
    return false;
  }

  static bool validateAniversarianteDaSemana (String data){
    print("validateAniversarianteDaSemana");
    String result = data.replaceAll("/", "-");
    result = result.substring(6,10)+"-"+result.substring(3,5)+"-"+result.substring(0,2);
    print("result $result");
    List<String> datasSemana =[];
    DateTime dateInicio = DateTime.now();

    String diaa = DateFormat('EEEE').format(DateTime.now());
    print(diaa);
    switch (diaa) {
      case 'Sunday':
        {
          for (int i =0; i<7; i++){
            datasSemana.add(dateInicio.toString().substring(0,10));
            dateInicio = dateInicio.add(Duration(hours: 24));
            // print(" i = $i ${datasSemana[i]}");
          }
          break;
        }
      case 'Monday':
        {
           dateInicio.subtract(Duration(hours: 24));
           for (int i =0; i<7; i++){
             datasSemana.add(dateInicio.toString().substring(0,10));
             dateInicio = dateInicio.add(Duration(hours: 24));
             // print(" i = $i ${datasSemana[i]}");
           }
           break;
        }
      case 'Tuesday':
        {
          dateInicio.subtract(Duration(hours: 24*2));
          for (int i =0; i<7; i++){
            datasSemana.add(dateInicio.toString().substring(0,10));
            dateInicio = dateInicio.add(Duration(hours: 24));
            // print(" i = $i ${datasSemana[i]}");
          }
          break;
        }
      case 'Wednesday':
        {
          dateInicio = dateInicio.subtract(Duration(hours: 24*3));
          for (int i =0; i<7; i++){
            datasSemana.add(dateInicio.toString().substring(0,10));
            dateInicio = dateInicio.add(Duration(hours: 24));
            // print(" i = $i ${datasSemana[i]}");
          }
          break;
        }
      case 'Thursday':
        {
          dateInicio = dateInicio.subtract(Duration(hours: 24*4));
          for (int i =0; i<7; i++){
            datasSemana.add(dateInicio.toString().substring(0,10));
            dateInicio = dateInicio.add(Duration(hours: 24));
            // print(" i = $i ${datasSemana[i]}");
          }
          break;
        }
      case 'Friday':
        {
          dateInicio.subtract(Duration(hours: 24*5));
          for (int i =0; i<7; i++){
            datasSemana.add(dateInicio.toString().substring(0,10));
            dateInicio = dateInicio.add(Duration(hours: 24));
            // print(" i = $i ${datasSemana[i]}");
          }
          break;
        }
      case 'Saturday':
        {
          dateInicio.subtract(Duration(hours: 24*6));
          for (int i =0; i<7; i++){
            datasSemana.add(dateInicio.toString().substring(0,10));
            dateInicio = dateInicio.add(Duration(hours: 24));
            // print(" i = $i ${datasSemana[i]}");
          }
          break;
        }
    }

    print("validar data");
    for (int i=0; i<7; i++){
      if (result.substring(6,10).compareTo(datasSemana[i].substring(6,10))==0){
        // print("aniver da semana $result}");
        return true;
      }
    }
    return false;
  }

  static bool validarAniversarianteMes(String data){
    DateTime date = DateTime.now();
    int mes = date.month;
    if (int.parse(data.substring(3,5))==mes){
      return true;
    }
    return false;
  }

  static bool validateDate(String data){
    bool result = true;
    int dia = int.parse(data.substring(0, 2));
    int mes = int.parse(data.substring(3, 5));
    int ano = int.parse(data.substring(6, 9));
    List<int> dias = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    print("dia $dia");
    print("mes $mes");
    print("ano $ano");
    if ((mes<1)||(mes>12)){
      return false;
    }

    if ((dia<1)||(dia>31)){
      return false;
    }else {
      if ((ano % 4 == 0) && ((ano %100 ==0) && (ano%400==0))){
        //ano bissexto
        if (dia>29){
          return false;
        }
      } else {
        if (dia>dias[mes-1]){
          return false;
        }
      }
    }
    if (ano>DateTime.now().year){
      return false;
    }
    return result;
  }
}