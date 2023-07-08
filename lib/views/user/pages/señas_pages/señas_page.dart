import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/views/word_popup.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/diccionario_controller.dart';
import '../../../../models/diccionario.dart';
import 'glosario_page.dart';

class SeniasPage extends StatefulWidget {
  @override
  _SeniasPageState createState() => _SeniasPageState();
}

class _SeniasPageState extends State<SeniasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DiccionarioController _diccionarioService = DiccionarioController();
  List<Diccionario> _allWords = [];
  List<Diccionario> _filteredWords = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              descripcion: data['descripcion'] ?? '');
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
    if (_tabController == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 10,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Diccionario'),
              Tab(text: 'Glosario'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDiccionario(),
            GlosarioPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiccionario() {
    return Column(
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
                  _showPopup(context, word);
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

  void _showPopup(BuildContext context, Diccionario word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<void>(
          future: _loadImage(word.imagen),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return WordPopup(word: word);
            }
          },
        );
      },
    );
  }

  // Future<void> _loadImage(String imageUrl) async {
  //   // Simular la carga de la imagen con un delay de 0 segundos
  //   await Future.delayed(Duration(seconds: 1));
  // }
  Future<ImageProvider> _loadImage(String imageUrl) async {
    return CachedNetworkImageProvider(imageUrl);
  }
}
