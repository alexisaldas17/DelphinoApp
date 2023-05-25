import 'package:flutter/material.dart';

class ScreenOne extends StatefulWidget {
  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<String> _dictionary = [
    'Apple',
    'Banana',
    'Carrot',
    'Dog',
    'Elephant',
    'Fish',
    'Giraffe',
    'Horse',
    'Ice cream',
    'Juice',
    'Kangaroo',
    'Lemon',
    'Monkey',
    'Noodle',
    'Orange',
    'Pineapple',
    'Quail',
    'Rabbit',
    'Strawberry',
    'Tiger',
    'Umbrella',
    'Vegetable',
    'Watermelon',
    'Xylophone',
    'Yogurt',
    'Zebra',
  ];
  List<String> _filteredWords = [];

  TextEditingController _searchController = TextEditingController();

  void _searchWords(String keyword) {
    setState(() {
      _filteredWords = _dictionary
          .where((word) => word.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
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
            child: ListView.builder(
              itemCount: _filteredWords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredWords[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
