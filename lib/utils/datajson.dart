import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:window_manager/window_manager.dart';

enum Data {
  cc,
  ncc,
  engp,
  dcc,
  dncc,
  dengp
}

void closeProgram() async {
  await windowManager.close();
}

String _encontrarArquivos(Data curso){
  return switch (curso) {
    Data.cc => 'assets/data/grcc.json',
    Data.ncc => 'assets/data/grncc.json',
    Data.engp => 'assets/data/grengp.json',
    Data.dcc => 'memory/datagrcc.json',
    Data.dncc => 'memory/datagrncc.json',
    Data.dengp => 'memory/datagrengp.json',
  };
}

Future<List<dynamic>> lerDados({required Data curso}) async {
  String jsonString = await rootBundle.loadString(_encontrarArquivos(curso));
  List<dynamic> lista = json.decode(jsonString);
  return lista;
}

void salvarDados({required List<dynamic> arquivo}){

}
