import 'package:flutter/material.dart';

class PropertyStatsCard extends StatelessWidget {

  const PropertyStatsCard({super.key, 
  });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Locataire', 3, Icons.account_circle),
                _buildStatColumn('Disponible', 27, Icons.home),
                _buildStatColumn('Occupée', 14, Icons.home_outlined),
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
