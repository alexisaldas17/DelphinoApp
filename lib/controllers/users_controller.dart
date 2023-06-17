import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/models/subniveles.dart';

import '../models/lecciones.dart';
import '../models/usuario.dart';

class UserController {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('usuarios');

  Future<List<DocumentSnapshot>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs;
    } catch (e) {
      print('Error obteniendo usuarios: $e');
      return [];
    }
  }

  Future<DocumentSnapshot?> getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot = await _usersCollection.doc(userId).get();
      return snapshot.exists ? snapshot : null;
    } catch (e) {
      print('Error obteniendo usuario por ID: $e');
      return null;
    }
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      await _usersCollection.add(userData);
    } catch (e) {
      print('Error añadiendo usuario: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(userId).update(userData);
    } catch (e) {
      print('Error actualizando usuario: $e');
    }
  }

  Future<void> actualizarLeccionesCompletadas(
      String uid, Leccion leccion) async {
    try {
      final userId = uid; // ID del usuario

      final progresoSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('progreso')
          .get();

      if (progresoSnapshot.docs.isNotEmpty) {
        final progresoDocument = progresoSnapshot.docs.first;
        final progresoData = progresoDocument.data();

        List<Leccion> leccionesCompletadas = [];
        if (progresoData['leccionesAprobadas'] != null) {
          leccionesCompletadas =
              (progresoData['leccionesAprobadas'] as List<dynamic>)
                  .map((leccionData) => Leccion(
                      nombre: leccionData['nombre'],
                      preguntas: [],
                      id: leccionData['id'],
                      identificador: leccionData['identificador']))
                  .toList();
        }

       
          if (!leccionesCompletadas.any((leccionCompletada) =>
              leccionCompletada.identificador == leccion.identificador)) {
            leccionesCompletadas.add(leccion);
          }
        

        await progresoDocument.reference.update({
          'leccionesAprobadas':
              leccionesCompletadas.map((leccion) => leccion.toMap()).toList(),
        });

        print('Lecciones completadas actualizadas correctamente.');
      } else {
        print('No se encontró el documento de progreso del usuario.');
      }
    } catch (error) {
      print('Error al actualizar el progreso: $error');
    }
  }


  //METODO PARA ACTUALIZAR LOS SUBNIVELES COMPLETADOS
  Future<void> actualizarSubnivelesCompletados(
      String uid, Subnivel subnivel) async {
    try {
      final userId = uid; // ID del usuario

      final progresoSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('progreso')
          .get();

      if (progresoSnapshot.docs.isNotEmpty) {
        final progresoDocument = progresoSnapshot.docs.first;
        final progresoData = progresoDocument.data();

        List<Subnivel> subnivelesCompletados = [];
        if (progresoData['subnivelesAprobados'] != null) {
          subnivelesCompletados =
              (progresoData['subnivelesAprobados'] as List<dynamic>)
                  .map((subnivelData) => Subnivel(id: subnivelData['id'], 
                  lecciones: [], urlImage: '',
                  nombre: subnivelData['nombre']))
                  .toList();
        }

       
          if (!subnivelesCompletados.any((subnivelCompletado) =>
              subnivelCompletado.nombre == subnivel.nombre)) {
            subnivelesCompletados.add(subnivel);
          }
        

        await progresoDocument.reference.update({
          'subnivelesAprobados':
              subnivelesCompletados.map((subnivel) => subnivel.toMap()).toList(),
        });

        print('Subniveles completados actualizados correctamente.');
      } else {
        print('No se encontró el documento de progreso del usuario.');
      }
    } catch (error) {
      print('Error al actualizar el progreso: $error');
    }
  }


  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      print('Error eliminando usuario: $e');
    }
  }
}
