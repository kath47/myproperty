
import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelles location'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text('Informations sur les nouvelles demandes'),
      ),
    );
  }
}