import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
  PlatformFile _video = PlatformFile(name: '', size: 0);
  File _imagen = File('');

  String? _imageUrl;
  String? _newImageUrl;
  String? _urlImagenBorrar;
  String? _urlVideoBorrar;
  String? _newVideoUrl;
  bool _imageError = false;
  String? _videoUrl;
  bool _videoError = false;
  bool _imagenCambiada = false;
  bool _videoCambiado = false;
  bool _palabraError = false;
  String uid = '';
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    uid = widget.palabra.uid;
    _palabraController = TextEditingController(text: widget.palabra.palabra);
    _descripcionController =
        TextEditingController(text: widget.palabra.descripcion);

    _categoriaController =
        TextEditingController(text: widget.palabra.categoria);
    _imageUrl =
        _isValidUrl(widget.palabra.imagen) ? widget.palabra.imagen : null;
    _videoUrl = _isValidUrl(widget.palabra.senia) ? widget.palabra.senia : null;
  }

//METODO PARA VALIDAR SI LA URL DE UNA IMAGEN O VIDEO ES VALIDA
  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
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
    return WillPopScope(
      onWillPop: () async {
        // Mostrar el diálogo de advertencia antes de la navegación hacia atrás
        bool confirmExit = await showDialog<bool>(
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
        ) ?? false;

        // Retornar true si el usuario confirma la salida, de lo contrario, false
        return confirmExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editar Palabra'),
          actions: [
            IconButton(
              onPressed: () {
                // Lógica para eliminar la palabra
                _eliminarPalabra();
              },
              icon: Icon(Icons.delete),
            ),
          ],
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
                    errorStyle: TextStyle(
                        color: Colors
                            .red), // Estilo del texto de error en color rojo
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
                  controller: TextEditingController(
                      text: widget.palabra.categoria.toUpperCase()),
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
                _imageUrl == null && !_imagenCambiada
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
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              // Manejar el error 404 aquí
                              return Icon(
                                Icons
                                    .image_not_supported, // Icono de imagen no disponible
                                size: 150,
                                color: Colors.grey, // Color del icono
                              );
                            },
                          )
                        : _newImageUrl != null &&
                                _newImageUrl!.isNotEmpty &&
                                File(_newImageUrl!).existsSync() &&
                                _imagenCambiada
                            ? Image.file(
                                File(_newImageUrl!),
                                height: 200,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              )
                            : _newImageUrl != null &&
                                    _newImageUrl!
                                        .isNotEmpty // Agregar esta condición para evitar el error
                                ? Image.asset(
                                    _newImageUrl!, // Cambiar a Image.asset y proporcionar la ruta de la imagen como un recurso en la aplicación
                                    height: 200,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )
                                : SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Cambiar imagen (PNG)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .black54, // Cambia el color de fondo del botón a rojo
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Video Seña:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _videoUrl == null && !_videoCambiado
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
                    : _videoUrl != null &&
                            _videoUrl!.isNotEmpty &&
                            !_videoCambiado
                        ? Image.network(
                            _videoUrl!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : _newVideoUrl != null &&
                                _newVideoUrl!.isNotEmpty &&
                                File(_newVideoUrl!).existsSync() &&
                                _videoCambiado
                            ? Image.file(
                                File(_newVideoUrl!),
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _pickVideo,
                  child: Text('Cambiar Video (GIF)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .black54, // Cambia el color de fondo del botón a rojo
                  ),
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
                              : Text('GUARDAR CAMBIOS'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .green, // Cambia el color de fondo del botón a rojo
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//METODO PARA GUARDAR LA PALABRA
  Future<void> _saveWord() async {
    String palabra = _palabraController.text;
    String descripcion = _descripcionController.text;
    bool isNewImage = _newImageUrl != null && _newImageUrl != _imageUrl;
    bool isNewVideo = _newVideoUrl != null && _newVideoUrl != _videoUrl;
    // Validar si los campos obligatorios están completos
    if (palabra.isEmpty ||
        (_imageUrl == null && _newImageUrl == null) ||
        (_videoUrl == null && _newVideoUrl == null)) {
      setState(() {
        _palabraError = palabra.isEmpty;
        _imageError = _imageUrl == null && _newImageUrl == null;
        _videoError = _videoUrl == null && _newVideoUrl == null;
        // _videoError = _videoUrl!.isEmpty;
        // _videoError = _newVideoUrl!.isEmpty;
        // _imageError = _imageUrl!.isEmpty;
        // _imageError = _newImageUrl!.isEmpty;
        // _newImageUrl = _newImageUrl!.isEmpty as String?;
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
    PalabrasController palabrasController = PalabrasController();
    setState(() {
      _saving = true; // Set saving state to true
    });

    bool ingresado = await palabrasController.actualizarPalabra(
      uid,
      palabra,
      isNewVideo ? _video : PlatformFile(name: '', size: 0),
      isNewImage ? _imagen : File(''),
      descripcion,
    );

    setState(() {
      _saving = false; // Set saving state to false
    });

    // Mostrar un mensaje de éxito
    if (ingresado) {
      if (_urlImagenBorrar != null && _urlImagenBorrar!.isNotEmpty) {
        await palabrasController.eliminarArchivoFirestorage(_urlImagenBorrar);
      }

      if (_urlVideoBorrar != null && _urlVideoBorrar!.isNotEmpty) {
        await palabrasController.eliminarArchivoFirestorage(_urlVideoBorrar);
      }
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

//METODO PARA CARGAR LA NUEVA IMAGEN
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      setState(() {
        _urlImagenBorrar = _imageUrl;
        _imagenCambiada = true;
        _newImageUrl = pickedImage.path;
        _imagen = imageFile;
        _imageUrl = null;
      });
      //_checkImageAvailability();
    }
  }

//METODO PARA CARGAR EL NUEVO VIDEO
  void _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gif'],
    );

    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.first.path!;
      PlatformFile videoFile = result.files.first;
      setState(() {
        _urlVideoBorrar = _videoUrl;
        _videoCambiado = true;
        _newVideoUrl = filePath;
        _video = videoFile;
        _videoUrl = null;
        _videoError = false;
      });
    }
  }

  void _eliminarPalabra() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta palabra?'),
          actions: [
            TextButton(
              onPressed: () {
                // Cerrar el cuadro de diálogo sin eliminar la palabra
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Eliminar la palabra
                // Agrega aquí tu lógica para eliminar la palabra
                PalabrasController palabrasController = PalabrasController();

                bool eliminado = false;
                if (_imageUrl != null && _videoUrl != null) {
                  eliminado = await palabrasController.eliminarPalabra(
                      widget.palabra.uid, _imageUrl!, _videoUrl!);
                }

                if (eliminado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Palabra ' +
                            widget.palabra.palabra +
                            ' eliminada correctamente.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Ocurrió un problema al eliminar la palabra.')),
                  );
                }

                // Cerrar el cuadro de diálogo después de eliminar la palabra
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
