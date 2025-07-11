import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyUniPlanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _opacityAnimation;

  final double _minWidth = 80.0;
  final double _maxWidth = 250.0;

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(
      color: Colors.transparent, // Cor transparente para ver o fundo do Scaffold
      child: const Center(
        child: Text("Página Início", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent, // Cor transparente para ver o fundo do Scaffold
      child: const Center(
        child: Text("Página Grades", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _widthAnimation = Tween<double>(begin: _minWidth, end: _maxWidth).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter(PointerEvent details) {
    _controller.forward();
  }

  void _onHoverExit(PointerEvent details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Adicionamos uma cor de fundo ao Scaffold para que o padding seja visível
      backgroundColor: const Color(0xff181818),
      body: Stack(
        children: [
          // CAMADA DE BAIXO: O conteúdo da página.
          Padding(
            // O padding da página principal precisa considerar o padding da sidebar também
            padding: EdgeInsets.only(left: _minWidth + 30.0),
            child: _pages[_selectedIndex],
          ),

          // CAMADA DE CIMA: A sidebar animada, agora com padding geral.
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: MouseRegion(
              onEnter: _onHoverEnter,
              onExit: _onHoverExit,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: _widthAnimation.value,
                    clipBehavior: Clip.antiAlias, // Garante que o conteúdo respeite as bordas
                    decoration: BoxDecoration(
                      color: const Color(0xFF22272B),
                      borderRadius: BorderRadius.circular(30.0), // Bordas arredondadas
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),
                        _buildSidebarItem(Icons.home, "Início", 0),
                        const Divider(),
                        _buildSidebarItem(Icons.grid_view, "Grades", 1),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    final bool isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).primaryColorLight : Colors.white70;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      // Desabilitando o splash para um visual mais limpo com o InkWell
      splashColor: Colors.transparent,
      highlightColor: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: _minWidth,
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            if (_widthAnimation.value > _minWidth + 20)
              Expanded(
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}