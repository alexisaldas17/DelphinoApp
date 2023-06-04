import 'package:delphino_app/pages/aprender_page.dart';
import 'package:delphino_app/pages/perfil_page.dart';
import 'package:delphino_app/pages/se%C3%B1as_pages/se%C3%B1as_page.dart';
// import 'package:delphino_app/screens/pantallas_menu/juegos_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ScreenOne(),
    AprenderPage(),
    // HangmanGame(),
    ScreenFive(),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.book),
          //   label: 'Glosario',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Aprender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Juegos y más',
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

// class ScreenTwo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Pantalla dos',
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   }
// }






