import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<bool> eliminarPalabra(
      String uid, String imagenUrl, String videoUrl) async {
    try {
      if(imagenUrl != null && imagenUrl.isNotEmpty)
      eliminarArchivoFirestorage(imagenUrl);
      if(videoUrl != null && videoUrl.isNotEmpty)
      eliminarArchivoFirestorage(videoUrl);
      await palabrasCollection.doc(uid).delete();
      return true;
    } catch (error) {
      print('Error al eliminar la palabra: $error');
      return false;
    }
  }

  Future<bool> actualizarPalabra(String uid, String palabra,
      File videoPath, File imagePath, String descripcion) async {
    String imagenUrl = '';
    String videoUrl = '';

    if (imagePath.path != null && imagePath.path.isNotEmpty) {
      imagenUrl = await guardarImagen(imagePath);
    }

    if (videoPath.path != null && videoPath.path!.isNotEmpty) {
      videoUrl = await guardarVideo(videoPath);
    }

    try {
      final docRef = palabrasCollection.doc(uid);
      if (imagenUrl.isNotEmpty && videoUrl.isNotEmpty) {
        await docRef.update({
          'palabra': palabra,
          'seña': videoUrl,
          'imagen': imagenUrl,
          'descripcion': descripcion,
        });
      } else if (imagenUrl.isNotEmpty) {
        await docRef.update({
          'palabra': palabra,
          'imagen': imagenUrl,
          'descripcion': descripcion,
        });
      } else if (videoUrl.isNotEmpty) {
        await docRef.update({
          'palabra': palabra,
          'seña': videoUrl,
          'descripcion': descripcion,
        });
      } else {
        await docRef.update({
          'palabra': palabra,
          'descripcion': descripcion,
        });
        // Si no se cambió ni la imagen ni el video, retorna false
      }

      return true;
    } catch (error) {
      // Si ocurre algún error durante la actualización, puedes manejarlo aquí
      print('Error al actualizar la palabra: $error');
      return false;
    }
  }

  Future<void> eliminarArchivoFirestorage(String? url) async {
    Reference ref = FirebaseStorage.instance.refFromURL(url!);
    try {
      await ref.delete();
      print('Imagen eliminada exitosamente.');
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }

  Future<bool> agregarPalabra(String palabra, String categoria,
      File videoPath, File imagePath, String descripcion) async {
    try {
      String imagenUrl = await guardarImagen(imagePath);
      String videoUrl = await guardarVideo(videoPath);
      // Convertir la primera letra a mayúscula
      palabra = palabra.substring(0, 1).toUpperCase() + palabra.substring(1);
      // bool palabraNoRepetida = await verificarPalabra(palabra)
      if (imagenUrl.isNotEmpty && videoUrl.isNotEmpty) {
        final docRef = await palabrasCollection.add({
          'palabra': palabra,
          'categoria': categoria,
          'seña': videoUrl,
          'imagen': imagenUrl,
          'descripcion': descripcion,
          'uid': null, // Placeholder para el UID, se actualizará a continuación
        });

        final uid = docRef.id; // Obtener el UID del documento creado

        // Actualizar el campo "uid" con el valor correspondiente
        await docRef.update({'uid': uid});

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

  Future<String> guardarVideo(File videoFile) async {
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
