import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import '../models/categoria.dart';

class PalabrasController {
  final CollectionReference palabrasCollection =
      FirebaseFirestore.instance.collection('diccionario');

  //METODO PARA OBTENER LAS CATEGORIAS
  Future<List<Categoria>> obtenerCategorias() async {
    List<Categoria> categorias = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categorias').get();

      snapshot.docs.forEach((doc) {
        Categoria categoria = Categoria(
          id: doc['id'],
          nombre: doc['nombre'],
        );
        categorias.add(categoria);
      });
      categorias.sort((a, b) => a.nombre
          .compareTo(b.nombre)); // Ordenar las categorías alfabéticamente

      return categorias;
    } catch (error) {
      print('Error al obtener las categorías: $error');
      return categorias;
    }
  }

  //METODO PARA VERIFICAR SI LA PALABRA YA SE ENCUENTRA REGISTRADA
  Future<bool> verificarPalabra(String palabra) async {
    try {
      palabra = palabra.substring(0, 1).toUpperCase() + palabra.substring(1);

      QuerySnapshot snapshot = await palabrasCollection
          .where('palabra', isEqualTo: palabra)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar la palabra: $e');
      return false;
    }
  }

  Future<bool> agregarPalabra(String palabra, String categoria,
      PlatformFile videoPath, File imagePath, String descripcion) async {
    try {
      String imagenUrl = await guardarImagen(imagePath);
      String videoUrl = await guardarVideo(videoPath);
      // Convertir la primera letra a mayúscula
      palabra = palabra.substring(0, 1).toUpperCase() + palabra.substring(1);
      // bool palabraNoRepetida = await verificarPalabra(palabra)
      if (imagenUrl.isNotEmpty && videoUrl.isNotEmpty) {
        await palabrasCollection.add({
          'palabra': palabra,
          'categoria': categoria,
          'seña': videoUrl,
          'imagen': imagenUrl,
          'descripcion': descripcion,
        });

        return true;
      }
      return false;
    } catch (e) {
      // Manejo de errores

      print('Error al agregar la palabra: $e');
      //throw e;
      return false;
    }
  }

  Future<String> guardarImagen(File imageFile) async {
    try {
      // Generar un nombre único para la imagen
      String imageName = path.basename(imageFile.path);
      String storagePath = 'imagenes/$imageName';

      // Subir la imagen a Firestorage
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);
      await ref.putFile(imageFile);

      // Obtener la URL de descarga de la imagen
      String imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      // Manejo de errores

      print('Error al guardar la imagen: $e');
      //throw e;
      return '';
    }
  }

  Future<String> guardarVideo(PlatformFile videoFile) async {
    try {
      // Generar un nombre único para el archivo
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Obtener la referencia de almacenamiento en Firestorage
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('videos/$fileName');

      // Subir el archivo al almacenamiento en Firestorage
      await storageRef.putFile(File(videoFile.path!));

      // Obtener la URL del archivo subido
      String downloadURL = await storageRef.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error al subir el video al Firestorage: $e');
      return '';
    }
  }
}
