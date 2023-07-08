import 'package:flutter/material.dart';

import '../../../../models/palabra.dart';

class CategoriaPopup extends StatelessWidget {
  final Palabra palabra;

  const CategoriaPopup({required this.palabra});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        palabra.palabra.toUpperCase(),
        textAlign: TextAlign.center, // Alinea el texto al centro
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          palabra.senia.isNotEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Image.network(
                    palabra.senia,
                    width: 200,
                    height: 200,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.videocam_off,
                    size: 200,
                  ),
                ),
        ],
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue), // Color de fondo del botón
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white), // Color del texto del botón
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'REGRESAR',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
