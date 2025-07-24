import 'package:flutter/widgets.dart';
import 'package:myuniplanner/utils/datajson.dart';

class Grade extends StatefulWidget {

  final Data curso;

  const Grade({super.key, required this.curso});
  
  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
  
  late List<dynamic> dadosgrade;
  late List<dynamic> grade;
  late final int qntPeriodos;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    grade = await lerDados(curso: widget.curso);
    
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        // adionar a barra interativa
        Row(
          children: [],  // criar a grade dinamiamente,
        )
      ],
    );
  }

  // buscar dados para a cosntrução
  // salvar os dados
}