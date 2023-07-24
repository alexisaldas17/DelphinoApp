import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/diccionario.dart';

class WordPopup extends StatefulWidget {
  final Diccionario word;

  const WordPopup({required this.word});

  @override
  _WordPopupState createState() => _WordPopupState();
}

class _WordPopupState extends State<WordPopup> {
  //bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _loadImage();
  }

  // void _loadImage() async {
  //   // Simular la carga de la imagen con una espera de 1 segundo
  //   await Future.delayed(Duration(seconds: 1));
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.word.palabra.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //_isLoading
          // ? Center(
          //     child: CircularProgressIndicator(),
          //   ):
          widget.word.senia.isNotEmpty
              ? Container( 
                
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: widget.word.senia,
                    width: 200,
                    height: 200,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
