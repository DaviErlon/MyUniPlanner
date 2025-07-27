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

class SideBarItem extends StatefulWidget {
  final IconData icon;
  final String texto;
  final void Function() acao;
  final bool isSelected;
  final Animation<double> widthAnimation;
  final Animation<double> opacityAnimation;

  const SideBarItem({
    super.key,
    required this.icon,
    required this.texto,
    required this.acao,
    required this.isSelected,
    required this.widthAnimation,
    required this.opacityAnimation,
  });

  @override
  State<SideBarItem> createState() => _ItemState();
}

class _ItemState extends State<SideBarItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final Color color = widget.isSelected
        ? const Color.fromARGB(255, 108, 55, 155)
        : hover
            ? const Color.fromARGB(255, 112, 101, 178)
            : const Color.fromARGB(255, 159, 158, 158);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onEnter: (_) {
          if (!widget.isSelected) {
            setState(() => hover = true);
          }
        },
        onExit: (_) {
          if(!widget.isSelected){
            setState(() => hover = false);
          } else {
            hover = false;
          }
        },
        child: InkWell(
          onTap: (){
            widget.acao();
          },
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 80.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(widget.icon, color: color, size: 24),
                ),
              ),
              if (widget.widthAnimation.value > 100.0)
                Expanded(
                  child: Opacity(
                    opacity: widget.opacityAnimation.value,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
                      child: Text(
                        widget.texto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
