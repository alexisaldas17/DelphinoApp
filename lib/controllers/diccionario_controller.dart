import 'package:cloud_firestore/cloud_firestore.dart';

class DiccionarioController {
  final CollectionReference _wordsCollection =
      FirebaseFirestore.instance.collection('diccionario');

  Future<List<DocumentSnapshot>> getWords() async {
    try {
      QuerySnapshot snapshot = await _wordsCollection.get();
      return snapshot.docs;
    } catch (e) {
      print('Error obteniendo palabras: $e');
      return [];
    }
  }

  Future<DocumentSnapshot?> getWordById(String wordId) async {
    try {
      DocumentSnapshot snapshot = await _wordsCollection.doc(wordId).get();
      return snapshot.exists ? snapshot : null;
    } catch (e) {
      print('Error obteniendo palabra por ID: $e');
      return null;
    }
  }

  Future<void> addWord(Map<String, dynamic> wordData) async {
    try {
      await _wordsCollection.add(wordData);
    } catch (e) {
      print('Error añadiendo palabra: $e');
    }
  }

  Future<void> updateWord(String wordId, Map<String, dynamic> wordData) async {
    try {
      await _wordsCollection.doc(wordId).update(wordData);
    } catch (e) {
      print('Error actualizando palabra: $e');
    }
  }

  Future<void> deleteWord(String wordId) async {
    try {
      await _wordsCollection.doc(wordId).delete();
    } catch (e) {
      print('Error eliminando palabra: $e');
    }
  }

  Future<List<DocumentSnapshot>> getWordsByCategory(String category) async {
    try {
      QuerySnapshot snapshot =
          await _wordsCollection.where('categoria', isEqualTo: category).get();
      return snapshot.docs;
    } catch (e) {
      print('Error obteniendo palabras por categoría: $e');
      return [];
    }
  }
}
