import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:myuniplanner/providers/navegation.dart';

class Sidebar extends StatefulWidget {
  
  const Sidebar({
    super.key,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  
  final minWidth = 80.0;
  final maxWidth = 250.0;

  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _widthAnimation = Tween<double>(
      begin: minWidth,
      end: maxWidth,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _opacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0
      ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            height: 600,
            width: _widthAnimation.value,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF22272B),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    SideBarItem(
                      id: 0,
                      icon: Icons.home,
                      texto: 'Início',
                      widthAnimation: _widthAnimation,
                      opacityAnimation: _opacityAnimation,
                    ),
                    const Divider(),
                    SideBarItem(
                      id: 1,
                      icon: Icons.event,
                      texto: 'Planejamento',
                      widthAnimation: _widthAnimation,
                      opacityAnimation: _opacityAnimation,
                    ),
                    SideBarItem(
                      id: 2,
                      icon: Icons.grid_view,
                      texto: 'Grades',
                      widthAnimation: _widthAnimation,
                      opacityAnimation: _opacityAnimation,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SideBarItem(
                      action: () async {
                        final Uri url = Uri.parse('https://github.com/DaviErlon/MyUniPlanner');
                        await launchUrl(url);
                      },
                      icon: FontAwesomeIcons.github,
                      texto: 'Repositório',
                      widthAnimation: _widthAnimation,
                      opacityAnimation: _opacityAnimation
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SideBarItem extends StatefulWidget {
  
  final int? id;
  final Function? action;
  final IconData icon;
  final String texto;
  final Animation<double> widthAnimation;
  final Animation<double> opacityAnimation;

  const SideBarItem({
    super.key,
    this.id,
    this.action,
    required this.icon,
    required this.texto,
    required this.widthAnimation,
    required this.opacityAnimation,
  });

  @override
  State<SideBarItem> createState() => _ItemState();
}

class _ItemState extends State<SideBarItem> {
  
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    
    final prov = context.watch<Telas>();
    
    final Color color = prov.indice == widget.id
        ? const Color.fromARGB(255, 108, 55, 155)
        : _hover
            ? const Color.fromARGB(255, 112, 101, 178)
            : const Color.fromARGB(255, 159, 158, 158);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),

      child: InkWell(
        onTap: (){
          widget.action?.call();
          if(widget.id != null){
            prov.setTela(widget.id!);
          }
        },
        onHover: (hovering) {
          setState(() {
            _hover = hovering;
          });
        },
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: 80.0,
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(begin: null, end: color),
                duration: const Duration(milliseconds: 200),
                builder: (context, animColor, child) {
                  return Icon(
                    widget.icon,
                    color: animColor,
                    size: 24,
                  );
                },
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
    );
  }
}