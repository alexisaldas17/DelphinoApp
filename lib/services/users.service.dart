import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('usuarios');

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

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      print('Error eliminando usuario: $e');
    }
  }
}
