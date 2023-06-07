import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/diccionario.dart';

// class WordPopup extends StatelessWidget {
//   final DocumentSnapshot word;

//   const WordPopup({required this.word});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(word['palabra']),
//       content:  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text('Datos adicionales del diccionario:'),
//           SizedBox(height: 8),
//           Text('Significado: ${word['imagen']}'),
//           Text('Ejemplo: ${word['id']}'),
//           // Agrega más campos adicionales aquí según tu modelo de datos
//         ],
//       ),
//       actions: [
//         ElevatedButton(
//           child: Text('Cerrar'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
// }
class WordPopup extends StatelessWidget {
  final Diccionario word;

  const WordPopup({required this.word});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(word.palabra),
    
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (word.senia.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: Image.network(
                word.senia, // URL de la imagen para cada fruta
                width: 200,
                height: 200,
              ),
            ),
          if (word.imagen.isEmpty) Icon(Icons.image_not_supported),
          if (word.imagen.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: Image.network(
                word.imagen, // URL de la imagen para cada fruta
                width: 100,
                height: 100,
              ),
            ),
          if (word.imagen.isEmpty) Icon(Icons.image_not_supported),
          Text('Ejemplo: ${word.id}'),
          // Agrega más campos adicionales aquí según tu modelo de datos
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
