import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class dashboard extends StatelessWidget {
  final int idUs;

  dashboard({required this.idUs});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(id: idUs,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int id;

  MyHomePage({required this.id});
  @override
  _MyHomePageState createState() => _MyHomePageState(idUs:id);
}

class _MyHomePageState extends State<MyHomePage> {
  int idUs;
  _MyHomePageState({required this.idUs});

  late List<Widget> _children;
  @override
  void initState() {
    super.initState();
    // Inicializar _screens en initState para evitar problemas con StatefulWidget
    _children = [
      //ScreenOne(idUs: idUs),
      //ScreenTwo(),
      //ScreenThree(),
    ];
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}