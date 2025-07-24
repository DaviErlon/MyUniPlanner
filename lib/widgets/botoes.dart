import 'package:flutter/material.dart';

enum Estado {
  pago,
  psr,  // pode ser cursado
  npsr, // nao pode ser cursado
}

const List<Color> _cores = [
  Color.fromARGB(255, 108, 55, 155),
  Color.fromARGB(255, 112, 101, 178),
  Color.fromARGB(255, 159, 158, 158),
];

class Cadeira extends StatelessWidget {
  
  final String texto;
  final Estado estado;
  final VoidCallback? onPressed;

  const Cadeira({
    super.key,
    required this.texto,
    required this.estado,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _cores[estado.index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black12, // cor do texto (pode ser opcional também)
          ),
          textAlign: TextAlign.center,
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
                child: Icon(widget.icon, color: color, size: 24),
              ),
              if (widget.widthAnimation.value > 100.0)
                Expanded(
                  child: Opacity(
                    opacity: widget.opacityAnimation.value,
                    child: Text(
                      widget.texto,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
