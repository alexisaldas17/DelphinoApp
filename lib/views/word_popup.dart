import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WordPopup extends StatelessWidget {
  final DocumentSnapshot word;

  const WordPopup({required this.word});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(word['palabra']),
      content:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Datos adicionales del diccionario:'),
          SizedBox(height: 8),
          Text('Significado: ${word['imagen']}'),
          Text('Ejemplo: ${word['id']}'),
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