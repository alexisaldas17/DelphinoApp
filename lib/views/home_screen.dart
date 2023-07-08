import 'package:delphino_app/views/user/pages/aprender_pages/aprender_page.dart';
import 'package:delphino_app/views/user/pages/juegos_pages/juegos_page.dart';
import 'package:delphino_app/views/user/pages/perfil_pages/perfil_page.dart';
import 'package:delphino_app/views/user/pages/se%C3%B1as_pages/se%C3%B1as_page.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SeniasPage(),
    AuthControllerProvider(
      child: AprenderPage(),
    ),
    JuegosPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Señas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Aprender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Juegos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
