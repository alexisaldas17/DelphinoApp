import 'package:flutter/material.dart';

import 'hangman_game.dart';
import 'sopaseñas_game.dart';

class JuegosPage extends StatefulWidget {
  @override
  State<JuegosPage> createState() => _JuegosPageState();
}

class _JuegosPageState extends State<JuegosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juegos'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildGameButton(
            'https://firebasestorage.googleapis.com/v0/b/delphinoapp.appspot.com/o/hangman_icono.png?alt=media&token=c4304520-3be6-407c-b2a9-32169c8d9573&_gl=1*1bqogza*_ga*MTA5OTAxNTkwNS4xNjg0NjE2MTE4*_ga_CW55HF8NVT*MTY4NTk4Nzc4Mi4yNi4xLjE2ODU5ODgyMzMuMC4wLjA.',
            'Ahorcado',
            () {
              // Navegar a la nueva página
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HangmanGame()),
              );
            },
          ),
          _buildGameButton(
            'https://firebasestorage.googleapis.com/v0/b/delphinoapp.appspot.com/o/game2.png?alt=media&token=b90755ae-73b8-4d3e-ad87-e55bb478d5ec&_gl=1*zh2e8q*_ga*MTA5OTAxNTkwNS4xNjg0NjE2MTE4*_ga_CW55HF8NVT*MTY4NTk4Nzc4Mi4yNi4xLjE2ODU5ODgwMTcuMC4wLjA.',
            'Sopa de Señas',
            () {
              // Navegar a la nueva página
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SopaDeSenasPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGameButton(String imageUrl, String gameName, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed, // Asignar la función onPressed al evento onTap
        child: Column(
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 8),
            Text(gameName),
          ],
        ),
      ),
    );
  }
}

// Nueva página AhorcadoPage
class AhorcadoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ahorcado'),
      ),
      // Contenido de la página AhorcadoPage
      body: Center(
        child: Text('Contenido de la página Ahorcado'),
      ),
    );
  }
}

