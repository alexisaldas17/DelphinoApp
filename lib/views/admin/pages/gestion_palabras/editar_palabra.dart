import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controllers/palabras.controller.dart';
import '../../../../models/diccionario.dart';

class EditarPalabra extends StatefulWidget {
  final Diccionario palabra;

  const EditarPalabra({required this.palabra});

  @override
  State<EditarPalabra> createState() => _EditarPalabraState();
}

class _EditarPalabraState extends State<EditarPalabra> {
  late TextEditingController _palabraController;
  late TextEditingController _categoriaController;
  late TextEditingController _descripcionController;
  String? _imageUrl;
  String? _newImageUrl;
  bool _imageError = false;
  String? _videoUrl;
  bool _videoError = false;
  bool _imagenCambiada = false;
  bool _palabraError = false;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    _palabraController = TextEditingController(text: widget.palabra.palabra);
    _descripcionController =
        TextEditingController(text: widget.palabra.descripcion);

    _categoriaController =
        TextEditingController(text: widget.palabra.categoria);
    _imageUrl = widget.palabra.imagen;
    _videoUrl = widget.palabra.senia;

    // Verificar si la URL de la imagen es válida
    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      // Comprobar si la imagen está disponible
      _checkImageAvailability();
    }

    // Verificar si la URL del video es válida
    if (_videoUrl != null && _videoUrl!.isNotEmpty) {
      // Comprobar si el video está disponible
      _checkVideoAvailability();
    }
  }

  // Verificar si la imagen está disponible
  void _checkImageAvailability() async {
    try {
      final response = await NetworkAssetBundle(Uri.parse(_imageUrl!)).load('');
      setState(() {
        _imageError = false;
      });
    } catch (error) {
      setState(() {
        _imageError = true;
      });
      print('Error al cargar la imagen: $error');
    }
  }

  @override
  void dispose() {
    _palabraController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Palabra'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField(
              //   controller: _palabraController,
              //   decoration: InputDecoration(hintText: 'Ingrese palabra'),
              // ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Palabra',
                  errorText: _palabraError ? 'Campo obligatorio' : null,
                ),
                controller: _palabraController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z]')), // Solo permite letras
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    // Convierte la primera letra en mayúscula y las demás en minúscula
                    if (newValue.text.isNotEmpty) {
                      return TextEditingValue(
                        text: newValue.text.substring(0, 1).toUpperCase() +
                            newValue.text.substring(1).toLowerCase(),
                        selection: newValue.selection,
                      );
                    }
                    return newValue;
                  }),
                ],
              ),
              SizedBox(height: 16),
              // Text(
              //   'Categoría:',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              TextField(
                controller:
                    TextEditingController(text: widget.palabra.categoria.toUpperCase()),
                decoration: InputDecoration(
                  labelText: 'Categoría',
                ),
                enabled: false,
              ),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Imagen:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _imageError
                  ? Container(
                      height: 200,
                      width: 200,
                      color: Colors
                          .grey, // Color de fondo para la imagen por defecto
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 100,
                          ),
                          Text(
                            'Imagen no disponible',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _imageUrl != null
                      ? Image.network(
                          _imageUrl!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          alignment: Alignment
                              .center, // Añadimos la propiedad alignment para centrar la imagen
                        )
                      : _newImageUrl != null &&
                              _newImageUrl!.isNotEmpty &&
                              File(_newImageUrl!).existsSync() &&
                              _imagenCambiada
                          ? Image.file(
                              File(_newImageUrl!),
                              height: 200,
                              fit: BoxFit.cover,
                              alignment: Alignment
                                  .center, // Añadimos la propiedad alignment para centrar la imagen
                            )
                          : SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Cambiar imagen (PNG)'),
              ),
              SizedBox(height: 16),
              Text(
                'Video Seña:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _videoError
                  ? Container(
                      height: 200,
                      width: 200,
                      color: Colors
                          .grey, // Color de fondo para la imagen por defecto
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_call,
                            color: Colors.white,
                            size: 100,
                          ),
                          Text(
                            'Video no disponible',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _videoUrl != null && _videoUrl!.isNotEmpty
                      ? Image.network(
                          _videoUrl!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          width: 200,
                          color: Colors
                              .grey, // Color de fondo para la imagen por defecto
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_call,
                                color: Colors.white,
                                size: 100,
                              ),
                              Text(
                                'Video no disponible',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Cambiar Video (GIF)'),
              ),
              SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saving
                            ? null
                            : _saveWord, // Disable button if saving is in progress
                        child: _saving
                            ? CircularProgressIndicator() // Show progress indicator if saving is in progress
                            : Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveWord() async {
    String palabra = _palabraController.text;
    // Validar si los campos obligatorios están completos
    if (palabra.isEmpty || _videoUrl!.isEmpty || _imageUrl!.isEmpty) {
      setState(() {
        _palabraError = palabra.isEmpty;
        _videoError = _videoUrl!.isEmpty;
        _imageError = _imageUrl!.isEmpty;
        _newImageUrl = _newImageUrl!.isEmpty as String?;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Debes completar los campos obligatorios.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _saving = true; // Set saving state to true
    });

    PalabrasController palabrasController = PalabrasController();

    if (await palabrasController.verificarPalabra(palabra)) {
      setState(() {
        _saving = false; // Set saving state to false
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('La palabra ' + palabra + ' ya se encuentra registrada!'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagenCambiada = true;
        _newImageUrl = pickedImage.path;
        _imageUrl = null;
      });
      //_checkImageAvailability();
    }
  }

  Future<void> _checkVideoAvailability() async {
    try {
      final response = await NetworkAssetBundle(Uri.parse(_videoUrl!)).load('');
      setState(() {
        _videoError = false;
      });
    } catch (error) {
      setState(() {
        _videoError = true;
      });
      print('Error al cargar el video: $error');
    }
  }

  void _pickVideo() {}
}
