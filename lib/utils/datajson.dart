import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myuniplanner/utils/close.dart';
import 'package:myuniplanner/models/grid.dart';

String _searchFile(String curso){
  
  String retorno = 'assets/data/';
  switch(curso){
    case 'CC':
      retorno += 'grcc.json';
      break;
    case 'ENGP':
      retorno += 'grengp.json';
      break;
    case 'NCC':
      retorno += 'grncc.json';
      break;
    default:
      closeProgram();
      break;
  }

  return retorno;
}

//metodo assincrono pois ler arquivos é uma função bloqueante
Future<Grade> readData({required String curso}) async {

    String jsonString = await rootBundle.loadString(_searchFile(curso));
    List<dynamic> lista = json.decode(jsonString);
    return Grade(curso, lista);

}