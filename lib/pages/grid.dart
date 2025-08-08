import 'dart:async';
import 'package:myuniplanner/widgets/botoes.dart';
import 'package:myuniplanner/utils/datajson.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class Grade extends StatefulWidget {

  final Curso curso;

  const Grade({super.key, required this.curso});
  
  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> with WindowListener {
  
  late List<Map<int, dynamic>> memoriaExterna;
  late final int qntPeriodos;
  bool _carregando = true;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _iniciarAutoSave();
    _carregarDados();
  }

  @override
  void dispose() {
    _cancelarAutoSave();
    windowManager.removeListener(this);
    super.dispose();
  }

  void _iniciarAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _salvarDados();
    });
  }

  void _cancelarAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }

  @override
  void onWindowBlur() {
    _salvarDados();
  }

  @override
  void onWindowMinimize() {
    _salvarDados();
  }

  Future<void> _carregarDados() async {
    memoriaExterna = await carregarCurso(curso: widget.curso);
    setState(() {
      _carregando = false;
    });
  }

  Future<void> _salvarDados() async {
    await salvarMemoria(dados: memoriaExterna, curso: widget.curso);
  }

  bool _verificarDisponibilidade(int id) {
    bool retorno = true;

    outerLoop: for (var map in memoriaExterna) {
      if (map.containsKey(id)) {
        List<int>? prerrequisitos = map[id]["preReq"];
        if (prerrequisitos != null) {
          for (var idx in prerrequisitos) {
            for (var m in memoriaExterna) {
              if (m.containsKey(idx)) {
                retorno = retorno && (m[idx]["clicado"] as bool);
                if (!retorno) break outerLoop;
              }
            }
          }
        }
        break;
      }
    }
    return retorno;
  }

  void atualizarEstrutura(int id) {
    final cadeiraMap = _buscarCadeiraMap(id);
    if (cadeiraMap == null) return;

    final cadeira = cadeiraMap[id] as Map<String, dynamic>;
    bool clicado = cadeira["clicado"] as bool? ?? false;

    if (!clicado) {
      ativarRecursivamente(id);
    } else {
      desativarRecursivamente(id);
    }
  }

  Map<int, dynamic>? _buscarCadeiraMap(int id) {
    for (var map in memoriaExterna) {
      if (map.containsKey(id)) return map;
    }
    return null;
  }

  void ativarRecursivamente(int id) {
    final cadeiraMap = _buscarCadeiraMap(id);
    if (cadeiraMap == null) return;

    final cadeira = cadeiraMap[id] as Map<String, dynamic>;
    bool clicado = cadeira["clicado"] as bool? ?? false;

    if (clicado) return;

    cadeira["clicado"] = true;

    final List<int> preReq = (cadeira["preReq"] as List?)?.cast<int>() ?? [];
    for (var preId in preReq) {
      ativarRecursivamente(preId);
    }
  }

  void desativarRecursivamente(int id) {
    final cadeiraMap = _buscarCadeiraMap(id);
    if (cadeiraMap == null) return;

    final cadeira = cadeiraMap[id] as Map<String, dynamic>;
    bool clicado = cadeira["clicado"] as bool? ?? false;

    if (!clicado) return;

    cadeira["clicado"] = false;

    final List<int> depen = (cadeira["depen"] as List?)?.cast<int>() ?? [];
    for (var depId in depen) {
      desativarRecursivamente(depId);
    }
  }

  List<Widget> _buildGrade() {
  return memoriaExterna.map((periodo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: periodo.entries.map((entry) {
        
        final int id = entry.key;
        final dynamic dados = entry.value;

        Estado estado;

        if (dados["clicado"] as bool) {
          estado = Estado.concluido;
        } else if (_verificarDisponibilidade(id)) {
          estado = Estado.disponivel;
        } else {
          estado = Estado.indisponivel;
        }

        return Cadeira(
          index: id,
          texto: dados["nome"],
          estado: estado,
          onPressed: (){
            setState(() {
              atualizarEstrutura(id);
            });
          },
        );
      }).toList(),
    );
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildGrade(),
          ),
        ],
      ),
    ),
    );
  }
}