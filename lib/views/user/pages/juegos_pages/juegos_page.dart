import 'package:flutter/material.dart';

import 'hangman_game.dart';
import 'sopaseñas_game.dart';
import 'memorama_game.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGameButton(
            'https://firebasestorage.googleapis.com/v0/b/delphinoapp.appspot.com/o/hangman_icono.png?alt=media&token=c4304520-3be6-407c-b2a9-32169c8d9573&_gl=1*1bqogza*_ga*MTA5OTAxNTkwNS4xNjg0NjE2MTE4*_ga_CW55HF8NVT*MTY4NTk4Nzc4Mi4yNi4xLjE2ODU5ODgyMzMuMC4wLjA.',
            'AHORCADO',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HangmanGame()),
              );
            },
          ),
          SizedBox(height: 100),
          _buildGameButton(
            'https://firebasestorage.googleapis.com/v0/b/delphinoapp.appspot.com/o/imagenes%2FmemoryGame.png?alt=media&token=3d57c635-4b87-4535-8d5f-e718fb51f26a',
            'MEMORAMA',
            () {
              // Navegar a la nueva página
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MemoryCardsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

Widget _buildGameButton(String imageUrl, String gameName, VoidCallback onPressed) {
  return Container(
    alignment: Alignment.center, // Centra el contenido vertical y horizontalmente
    child: InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: 110,
            height: 110,
          ),
          SizedBox(height: 8),
          Text(
            gameName.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}


}

