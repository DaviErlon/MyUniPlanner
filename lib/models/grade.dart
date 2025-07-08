class Grade {

  String curso;
  List<dynamic> dados;
  final int _qntPeriodos;

  Grade(this.curso, this.dados) : _qntPeriodos = dados.length;
}