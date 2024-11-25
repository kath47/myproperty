
import 'package:flutter/material.dart';

class ExpenseDetailsPage extends StatelessWidget {
  const ExpenseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des Dépenses'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('Informations sur les dépenses'),
      ),
    );
  }
}