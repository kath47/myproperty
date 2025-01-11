import 'package:flutter/material.dart';

import '../../data/db_helper.dart';

class PropertyStatsCard extends StatefulWidget {
  const PropertyStatsCard({super.key});

  @override
  _PropertyStatsCardState createState() => _PropertyStatsCardState();
}

class _PropertyStatsCardState extends State<PropertyStatsCard> {
  int totalLocataires = 0;
  int totalMaisonsDisponibles = 0;
  int totalMaisonsOccupees = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPropertyStats();
  }

  // Méthode pour charger les données
  Future<void> _loadPropertyStats() async {
    final dbHelper = DBHelper();

    try {
      final locataires = await dbHelper.getTotalLocataires();
      final maisonsDisponibles = await dbHelper.getTotalMaisonsDisponibles();
      final maisonsOccupees = await dbHelper.getTotalMaisonsOccupees();

      setState(() {
        totalLocataires = locataires;
        totalMaisonsDisponibles = maisonsDisponibles;
        totalMaisonsOccupees = maisonsOccupees;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des données: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title of the card
            const Text(
              'Situation des maisons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Locataire', totalLocataires, Icons.account_circle),
                      _buildStatColumn('Disponible', totalMaisonsDisponibles, Icons.home),
                      _buildStatColumn('Occupée', totalMaisonsOccupees, Icons.home_outlined),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each stat column
  Widget _buildStatColumn(String title, int value, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          icon,
          size: 28,
          color: Colors.grey,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey, // Value in red like the image
          ),
        ),
      ],
    );
  }
}

// Classe fictive pour DBHelper (à remplacer par votre implémentation réelle)
// class DBHelper {
//   Future<int> getTotalLocataires() async {
//     // Simuler une requête asynchrone
//     await Future.delayed(const Duration(seconds: 2));
//     return 10; // Valeur de test
//   }

//   Future<int> getTotalMaisonsDisponibles() async {
//     // Simuler une requête asynchrone
//     await Future.delayed(const Duration(seconds: 2));
//     return 5; // Valeur de test
//   }

//   Future<int> getTotalMaisonsOccupees() async {
//     // Simuler une requête asynchrone
//     await Future.delayed(const Duration(seconds: 2));
//     return 3; // Valeur de test
//   }
// }