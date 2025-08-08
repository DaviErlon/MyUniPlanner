import 'package:flutter/material.dart';
import 'package:myuniplanner/pages/grid.dart';
import 'package:myuniplanner/utils/datajson.dart';
import 'package:myuniplanner/widgets/widgets.dart';
import 'package:myuniplanner/providers/providers.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'MyUniPlanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(                             // ======= cuidar das cores e temas
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

  // paginas
  final List<Widget> _pages = [
    Container(
      color: Colors.transparent,
      child: const Center(
        child: Text("Página Início", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent,
      child: const Center(
        child: Text("Página Planejamento", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent, // Teste para a grade de CC
      child: const Center(
        child: Grade(curso: Curso.cc),
      ),
    ),
    Container(
      color: Colors.transparent,
      child: const Center(
        child: Text("Página CCOMP", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent,
      child: const Center(
        child: Text("Página (nova) CCOMP", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
    Container(
      color: Colors.transparent,
      child: const Center(
        child: Text("Página ENGPROD", style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {

    final prov = context.watch<Telas>();

    return Scaffold(
      // cor de fundo para o padding nao ser uma coisa branca feia
      backgroundColor: const Color(0xff181818),
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // CAMADA DE BAIXO: páginas.
          Padding(
            padding: EdgeInsets.only(left: 120.0),
            child: IndexedStack( // IndexedStack é de extrema importancia para otimização da mémoria das páginas
              index: prov.indice,
              children: _pages,
            ),
          ),

          // CAMADA DE CIMA (sobreposição): sidebar.
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Sidebar(),
          ),
        ],
      ),
    );
  }
}