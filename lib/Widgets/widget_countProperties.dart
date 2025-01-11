import 'dart:async';

import 'package:flutter/material.dart';

import '../data/db_helper.dart';

class PropertyCounter extends StatefulWidget {
  const PropertyCounter({super.key});

  @override
  _PropertyCounterState createState() => _PropertyCounterState();
}

class _PropertyCounterState extends State<PropertyCounter> {
  int _propertyCount = 0;
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadPropertyCount();
     // Actualisation toutes les 10 secondes
  Timer.periodic(const Duration(seconds: 10), (timer) {
    _loadPropertyCount();
  });
  }

  Future<void> _loadPropertyCount() async {
    final count = await dbHelper.getCountProperties();
    setState(() {
      _propertyCount = count;
    });
  }

  // Optionnel : Ajoutez cette méthode pour recharger les données automatiquement
  Future<void> _refreshCount() async {
    await _loadPropertyCount();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nombre d\'enregistrements : $_propertyCount',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: _refreshCount, // Bouton pour rafraîchir manuellement
            //   child: const Text('Rafraîchir'),
            // ),
          ],
        ),
      ),
    );
  }
}
