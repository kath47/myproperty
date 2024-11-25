
import 'package:flutter/material.dart';

class ProfitDetailsPage extends StatelessWidget {
  const ProfitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Détails des Profits', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('Informations sur les profits'),
      ),
    );
  }
}