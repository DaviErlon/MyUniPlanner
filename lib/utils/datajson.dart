import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myuniplanner/utils/close.dart';
import 'package:myuniplanner/models/grade.dart';

String _searchFile(String curso){
  
  String retorno = 'assets/data/';
  switch(curso){
    case 'cc':
      retorno += 'grcc.json';
      break;
    case 'engp':
      retorno += 'grengp.json';
      break;
    case 'ncc':
      retorno += 'grncc.json';
      break;
    default:
      closeProgram();
      break;
  }

  return retorno;
}

Future<Grade> readData({required String curso}) async {

    String jsonString = await rootBundle.loadString(_searchFile(curso));
    List<dynamic> lista = json.decode(jsonString);
    return Grade(curso, lista);

}