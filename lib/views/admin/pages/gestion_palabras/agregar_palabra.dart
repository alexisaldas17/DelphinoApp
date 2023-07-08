import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delphino_app/controllers/palabras.controller.dart';

import '../../../../models/categoria.dart';

class AgregarPalabra extends StatefulWidget {
  @override
  _AgregarPalabraState createState() => _AgregarPalabraState();
}

class _AgregarPalabraState extends State<AgregarPalabra> {
  String _selectedCategory =
      ''; // Valor predeterminado distinto de cadena vacía
  String _imagePath = '';
  File _imagen = File('');
  String _videoPath = '';
  String _word = '';
  File _video = File('');
  TextEditingController _wordController = TextEditingController();
  PalabrasController palabrasController = PalabrasController();
  TextEditingController _descripcionController = TextEditingController();
  String _description = '';
  bool _palabraError = false;
  bool _categoriaError = false;
  bool _videoError = false; // Added variable
  bool _imageError = false; // Added variable
  bool _saving = false; // Added variable for tracking saving state
  List<Categoria> _categorias = [];

  @override
  void dispose() {
    _wordController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    palabrasController.obtenerCategorias().then((categorias) {
      setState(() {
        _categorias = categorias;
        _selectedCategory = categorias.isNotEmpty ? categorias[0].nombre : '';
      });
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _categoriaError = false;
    });
  }

  // METODO PARA CARGAR LA IMAGEN
  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      setState(() {
        _imagePath = pickedImage.path!;
        _imagen = imageFile;
        _imageError = false;
      });
    }
  }

  // METODO PARA CARGAR EL VIDEO EN FORMATO .gif
  Future<void> _selectVideo() async {
       final ImagePicker _picker = ImagePicker();
    XFile? pickedVideo = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedVideo != null) {
      File videoFile = File(pickedVideo.path);
      setState(() {
        _videoPath = pickedVideo.path!;
        _video = videoFile;
        _videoError = false;
      });
    }

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['gif'],
    // );

    // if (result != null && result.files.isNotEmpty) {
    //   String filePath = result.files.first.path!;
    //   PlatformFile videoFile = result.files.first;
    //   setState(() {
    //     _videoPath = filePath;
    //     _video = videoFile;
    //     _videoError = false;
    //   });
    
  }

  Future<void> _saveWord() async {
    String palabra = _wordController.text;
    String descripcion = _descripcionController.text;
    // Validar si los campos obligatorios están completos
    if (palabra.isEmpty ||
        _selectedCategory.isEmpty ||
        _videoPath.isEmpty 
        // ||
        // _imagePath.isEmpty
        ) {
      setState(() {
        _palabraError = palabra.isEmpty;
        _categoriaError = _selectedCategory.isEmpty;
        _videoError = _videoPath.isEmpty;
        //_imageError = _imagePath.isEmpty;
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

    // Guardar los datos
    // Aquí puedes implementar la lógica para guardar los datos en tu base de datos o realizar otras acciones
    bool ingresado = await palabrasController.agregarPalabra(
      palabra,
      _selectedCategory.toLowerCase(),
      _video,
      _imagePath.isNotEmpty ? _imagen :File(''),
      descripcion,
    );

    setState(() {
      _saving = false; // Set saving state to false
    });

    // Mostrar un mensaje de éxito
    if (ingresado) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('La palabra se guardó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar la ventana actual
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ocurrió un error'),
            content: Text('La palabra no se guardó correctamente.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mostrar el diálogo de advertencia antes de la navegación hacia atrás
        bool confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('¿Estás seguro?'),
              content: Text('¿Deseas salir sin guardar los cambios?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    // Cerrar el diálogo y evitar la navegación hacia atrás
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Salir'),
                  onPressed: () {
                    // Cerrar el diálogo y permitir la navegación hacia atrás
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        // Retornar true si el usuario confirma la salida, de lo contrario, false
        return confirmExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agregar Palabra'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ingresar nueva palabra',
                  errorText: _palabraError ? 'Campo obligatorio' : null,
                ),
                controller: _wordController,
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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  _selectCategory(newValue!);
                },
                items: _categorias.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria.nombre,
                    child: Text(categoria.nombre),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  errorText: _categoriaError ? 'Campo obligatorio' : null,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectVideo,
                child: Text('Cargar Video (GIF)'),
              ),
              SizedBox(height: 16),
              if (_videoError)
                Text(
                  'Error al cargar el video',
                  style: TextStyle(color: Colors.red),
                )
              else if (_videoPath != null &&
                  _videoPath.isNotEmpty &&
                  File(_videoPath).existsSync())
                Image.file(
                  File(_videoPath),
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey,
                  child: Icon(
                    Icons.video_call,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Cargar Imagen (PNG)'),
              ),
              SizedBox(height: 16),
              if (_imageError)
                Text(
                  'Error al cargar la imagen',
                  style: TextStyle(color: Colors.red),
                )
              else if (_imagePath != null &&
                  _imagePath.isNotEmpty &&
                  File(_imagePath).existsSync())
                Image.file(
                  File(_imagePath),
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey,
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              SizedBox(height: 16),
              TextField(
                controller: _descripcionController,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saving
                    ? null
                    : _saveWord, // Disable button if saving is in progress
                child: _saving
                    ? CircularProgressIndicator() // Show progress indicator if saving is in progress
                    : Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
