import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/diccionario.service.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  final DiccionarioService _diccionarioService = DiccionarioService();
  List<DocumentSnapshot> _allWords = [];
  List<DocumentSnapshot> _filteredWords = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<DocumentSnapshot> words = await _diccionarioService.getWords();
    setState(() {
      _allWords = words;
      _filteredWords = words;
      _isLoading = false;
    });
  }

  void _searchWords(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _filteredWords = _allWords;
      });
    } else {
      List<DocumentSnapshot> filteredWords = _allWords
          .where((word) =>
              word['palabra'].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      setState(() {
        _filteredWords = filteredWords;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diccionario'),
      ),
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
                labelText: 'Buscar',
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
    Map<String, List<DocumentSnapshot>> groupedWords =
        _groupWordsByFirstLetter(_filteredWords);
    List<String> letters = groupedWords.keys.toList();
    letters.sort();

    return ListView.separated(
      itemCount: letters.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        String letter = letters[index];
        List<DocumentSnapshot> words = groupedWords[letter]!;

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
            for (DocumentSnapshot word in words)
              ListTile(
                title: Text(word['palabra']),
                // Aquí puedes mostrar los datos adicionales del diccionario
              ),
          ],
        );
      },
    );
  }

  Map<String, List<DocumentSnapshot>> _groupWordsByFirstLetter(
      List<DocumentSnapshot> words) {
    Map<String, List<DocumentSnapshot>> groupedWords = {};

    for (DocumentSnapshot word in words) {
      String firstLetter = word['palabra'][0].toUpperCase();

      if (!groupedWords.containsKey(firstLetter)) {
        groupedWords[firstLetter] = [];
      }

      groupedWords[firstLetter]!.add(word);
    }

    return groupedWords;
  }
}
