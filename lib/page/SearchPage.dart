import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final dbHelper = DBHelper();
  final searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchProperties(''); // Load all properties initially
  }

  Future<void> searchProperties(String query) async {
    final results = await dbHelper.searchProperties(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      //appBar: AppBar(title: const Text('Recherche de Propriétés')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                searchProperties(value);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('Aucune propriété trouvée'))
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final property = searchResults[index];
                        return ListTile(
                          title: Text(property['name']),
                          subtitle: Text('Catégorie: ${property['category']}'),
                          trailing: Text('Loyer: ${property['rent']} €'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
