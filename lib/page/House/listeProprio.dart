import 'dart:async';
import 'package:flutter/material.dart';
import '../../Settings/colors.dart';
import '../../data/db_helper.dart';
import 'add_proprio.dart';
import '../../data/data_model.dart'; // Assurez-vous que le modèle 'Proprio' est bien importé

class ProprioListPage extends StatefulWidget {
  const ProprioListPage({super.key});

  @override
  _ProprioListPageState createState() => _ProprioListPageState();
}

class _ProprioListPageState extends State<ProprioListPage> {
  late Future<List<Proprio>> proprietors;

  @override
  void initState() {
    super.initState();
    _refreshProprietorsList();
  }

  // Méthode pour rafraîchir la liste des propriétaires
  void _refreshProprietorsList() {
    setState(() {
      proprietors = DBHelper().getProprios();
    });
  }

  // Méthode pour naviguer vers la page d'ajout d'un propriétaire
  void _navigateToAddProprioPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProprioPage(
          onSave: () {
            _refreshProprietorsList();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Propriétaire enregistré avec succès!')),
            );
          },
        ),
      ),
    );

    // Si un résultat est retourné, rafraîchir la liste
    if (result != null) {
      _refreshProprietorsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Propriétaires', style: TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
        elevation: 4, // Ajout d'une ombre pour un effet de profondeur
      ),
      body: FutureBuilder<List<Proprio>>(
        future: proprietors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun propriétaire trouvé.', style: TextStyle(color: Colors.grey)));
          }

          final proprios = snapshot.data!;
          return ListView.separated(
            itemCount: proprios.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4,), // Séparateur entre les éléments
            itemBuilder: (context, index) {
              final proprio = proprios[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Marge autour de chaque carte
                elevation: 2, // Effet d'ombre pour chaque carte
                child: ListTile(
                  title: Text(proprio.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(proprio.email, style: const TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Supprimer le propriétaire
                      await DBHelper().deleteProprio(proprio.id);
                      _refreshProprietorsList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Propriétaire supprimé avec succès!')),
                      );
                    },
                  ),
                  onTap: () {
                    // Naviguer vers une page de détails ou d'édition si nécessaire
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProprioPage,
        backgroundColor: tPrimaryColor,
        tooltip: 'Ajouter un propriétaire',
        child: const Icon(Icons.add, color: Colors.white), // Info-bulle pour le bouton
      ),
    );
  }
}