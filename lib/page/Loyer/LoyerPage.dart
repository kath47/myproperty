
import 'package:flutter/material.dart';

class RentDetailsPage extends StatelessWidget {
  const RentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des Rentes'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('Informations sur les rentes de ce mois'),
      ),
    );
  }
}