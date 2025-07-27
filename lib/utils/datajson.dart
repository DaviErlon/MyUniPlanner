import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:window_manager/window_manager.dart';

enum Curso {
  cc,
  ncc,
  engp,
}

const List<List<String>> _arquivos = [
  ['assets/data/grcc.json', 'memory/datagrcc.json'],
  ['assets/data/grncc.json', 'memory/datagrncc.json'],
  ['assets/data/grengp.json', 'memory/datagrengp.json']
];

Future<List<Map<int, dynamic>>> carregarCurso({required Curso curso}) async {
  final String assetPath = _arquivos[curso.index][0];
  final String memoryPath = _arquivos[curso.index][1];

  final File file = File(memoryPath);
  String jsonString;

  if (await file.exists()) {
    jsonString = await file.readAsString();

    return (json.decode(jsonString) as List)
        .map<Map<int, dynamic>>((map) {
      final safeMap = Map<String, dynamic>.from(map as Map);
      return {
        for (var entry in safeMap.entries)
          int.parse(entry.key): {
            ...Map<String, dynamic>.from(entry.value as Map),
            "preReq": (Map<String, dynamic>.from(entry.value as Map)["preReq"] as List?)
                    ?.map((e) => e as int)
                    .toList() ??
                <int>[],
            "depen": (Map<String, dynamic>.from(entry.value as Map)["depen"] as List?)
                    ?.map((e) => e as int)
                    .toList() ??
                <int>[],
            "clicado": Map<String, dynamic>.from(entry.value as Map)["clicado"] ?? false,
          }
      };
    }).toList();
  }

  jsonString = await rootBundle.loadString(assetPath);

  final List<Map<int, dynamic>> memoriaExterna = (json.decode(jsonString) as List)
      .map<Map<int, dynamic>>((map) {
    final safeMap = Map<String, dynamic>.from(map as Map);
    return {
      for (var entry in safeMap.entries)
        int.parse(entry.key): {
          ...Map<String, dynamic>.from(entry.value as Map),
          "preReq": (Map<String, dynamic>.from(entry.value as Map)["preReq"] as List?)
                  ?.map((e) => e as int)
                  .toList() ??
              <int>[],
          "depen": <int>[],
          "clicado": Map<String, dynamic>.from(entry.value as Map)["clicado"] ?? false,
        }
    };
  }).toList();

  final Map<int, List<int>> dependencias = {};
  for (var periodo in memoriaExterna) {
    for (var entry in periodo.entries) {
      dependencias[entry.key] = entry.value["depen"] as List<int>;
    }
  }
  for (var periodo in memoriaExterna) {
    for (var entry in periodo.entries) {
      final List<int> preReq = entry.value["preReq"] as List<int>;
      for (var preId in preReq) {
        dependencias[preId]?.add(entry.key);
      }
    }
  }

  await salvarMemoria(dados: memoriaExterna, curso: curso);
  return memoriaExterna;
}

Future<void> salvarMemoria({required List<Map<int, dynamic>> dados, required Curso curso}) async {
  
  final List<Map<String, dynamic>> dadosConvertidos = dados.map((mapInt) {
    return mapInt.map((key, value) => MapEntry(key.toString(), value));
  }).toList();

  final String jsonString = jsonEncode(dadosConvertidos);
  final String caminhoArquivo = _arquivos[curso.index][1];
  final arquivo = File(caminhoArquivo);

  await arquivo.create(recursive: true);
  await arquivo.writeAsString(jsonString);
}

void closeProgram() async {
  await windowManager.close();
}