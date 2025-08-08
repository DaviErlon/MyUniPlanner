import 'package:flutter/material.dart';

enum Estado {
  indisponivel,
  disponivel,
  concluido,
}

const List<Color> _cores = [
  Color.fromARGB(255, 159, 158, 158),
  Color.fromARGB(255, 112, 101, 178),
  Color.fromARGB(255, 108, 55, 155),
];

class Cadeira extends StatelessWidget {
  final int index;
  final String texto;
  final Estado estado;
  final VoidCallback? onPressed;

  const Cadeira({
    super.key,
    required this.index,
    required this.texto,
    required this.estado,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),

      child: SizedBox(
        width: 125,
        height: 75,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0)),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return _cores[estado.index].withAlpha(230);
              }
              return _cores[estado.index];
            }),
            elevation: WidgetStateProperty.all(2),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            shadowColor: WidgetStateProperty.all(Colors.black26),
          ),
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}