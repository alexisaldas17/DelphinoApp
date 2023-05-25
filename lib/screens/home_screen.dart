import 'package:delphino_app/screens/pantallas/screen_one.dart';
import 'package:delphino_app/screens/pantallas/screen_two.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ScreenOne(),
    ScreenTwo(),
    ScreenThree(),
    ScreenFour(),
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
            icon: Icon(Icons.search),
            label: 'Diccionario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Glosario',
          ),
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

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pantalla tres',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ScreenFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pantalla cuatro',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ScreenFive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pantalla cinco',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}