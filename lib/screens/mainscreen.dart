import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myuniplanner/widgets/botoes.dart';

class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  int temaSelecionado = 0;

  //adcionar botões de tema
  List<ThemeData> temas = [
    ThemeData(

    ),
    ThemeData(

    ),
    ThemeData(

    ),
  ];

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
        child: Text("Página Planejamento", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent, // Cor transparente para ver o fundo do Scaffold
      child: const Center(
        child: Text("Página Grade", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent, // Cor transparente para ver o fundo do Scaffold
      child: const Center(
        child: Text("Página CCOMP", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent, // Cor transparente para ver o fundo do Scaffold
      child: const Center(
        child: Text("Página (nova) CCOMP", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent, // Cor transparente para ver o fundo do Scaffold
      child: const Center(
        child: Text("Página ENGPROD", style: TextStyle(fontSize: 24, color: Colors.white)),
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
      // cor de fundo para o padding nao ser uma coisa branca feia
      backgroundColor: const Color(0xff181818),
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // CAMADA DE BAIXO: páginas.
          Padding(
            padding: EdgeInsets.only(left: _minWidth + 60.0),
            child: _pages[_selectedIndex],
          ),

          // CAMADA DE CIMA (sobreposição): sidebar.
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: MouseRegion(
              onEnter: _onHoverEnter,
              onExit: _onHoverExit,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
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
                              icon: Icons.home, 
                              texto: "Início",
                              isSelected: 0 == _selectedIndex,
                              acao: (){
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              widthAnimation: _widthAnimation,
                              opacityAnimation: _opacityAnimation
                            ),
                            const Divider(),
                            SideBarItem( 
                              icon: Icons.event, 
                              texto: "Planejar Horários",
                              isSelected: 1 == _selectedIndex,
                              acao: (){
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              widthAnimation: _widthAnimation,
                              opacityAnimation: _opacityAnimation
                            ),
                            SideBarItem(
                              icon: Icons.grid_view, 
                              texto: "Grades",
                              isSelected: 2 == _selectedIndex,
                              acao: (){
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              widthAnimation: _widthAnimation,
                              opacityAnimation: _opacityAnimation
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SideBarItem(
                              icon: FontAwesomeIcons.github, 
                              texto: "Repositório", 
                              acao: () async {
                                final Uri url = Uri.parse('https://github.com/DaviErlon/MyUniPlanner');
                                await launchUrl(url);
                              }, 
                              isSelected: false,
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
            ),
          ),
        ],
      ),
    );
  }
}