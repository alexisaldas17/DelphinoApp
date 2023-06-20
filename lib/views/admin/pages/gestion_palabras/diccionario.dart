import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/views/admin/pages/gestion_palabras/editar_palabra.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/diccionario_controller.dart';
import '../../../../models/diccionario.dart';

class EditarDiccionario extends StatefulWidget {
  @override
  _EditarDiccionarioState createState() => _EditarDiccionarioState();
}

class _EditarDiccionarioState extends State<EditarDiccionario> {
  String palabra = 'Palabra';
  String categoria = 'Categoría';
  String imagen = 'Imagen';
  String senia = 'Seña';
  final DiccionarioController _diccionarioService = DiccionarioController();
  List<Diccionario> _allWords = [];
  List<Diccionario> _filteredWords = [];
  bool _isLoading = true;

  List<String> palabrasFiltradas = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<DocumentSnapshot<Object?>> words =
        await _diccionarioService.getWords();
    setState(() {
      _allWords = words.map((snapshot) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          return Diccionario(
            id: data['id'] ?? '',
            uid: data['uid'] ?? '',
            palabra: data['palabra'] ?? '',
            senia: data['seña'] ?? '',
            imagen: data['imagen'] ?? '',
            categoria: data['categoria'] ?? '',
            descripcion: data['descripcion'] ?? ''
          );
        } else {
          // Handle the case where data is null
          return Diccionario(
            id: '',
            uid: '',
            palabra: '',
            senia: '',
            imagen: '',
            categoria: '',
          );
        }
      }).toList();
      _filteredWords = _allWords;
      _isLoading = false;
    });
  }

  void _searchWords(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _filteredWords = _allWords;
      });
    } else {
      List<Diccionario> filteredWords = _allWords
          .where((word) =>
              word.palabra.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      setState(() {
        _filteredWords = filteredWords;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchWords(value);
              },
              decoration: InputDecoration(
                labelText: 'Buscar una palabra',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _isLoading ? _buildLoadingIndicator() : _buildWordList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildWordList() {
    Map<String, List<Diccionario>> groupedWords =
        _groupWordsByFirstLetter(_filteredWords);
    List<String> letters = groupedWords.keys.toList();
    letters.sort();

    return ListView.separated(
      itemCount: letters.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        String letter = letters[index];
        List<Diccionario> words = groupedWords[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (Diccionario word in words)
              ListTile(
                title: Text(word.palabra),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditarPalabra(palabra: word)),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Map<String, List<Diccionario>> _groupWordsByFirstLetter(
      List<Diccionario> words) {
    Map<String, List<Diccionario>> groupedWords = {};

    for (Diccionario word in words) {
      String firstLetter = word.palabra[0].toUpperCase();

      if (!groupedWords.containsKey(firstLetter)) {
        groupedWords[firstLetter] = [];
      }

      groupedWords[firstLetter]!.add(word);
    }

    return groupedWords;
  }
}
