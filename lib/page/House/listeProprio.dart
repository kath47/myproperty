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
    proprietors = DBHelper().getProprios();
  }

  // Method to open the form page to add a new owner
  void _navigateToAddProprioPage() async {
    // Navigate to a new page for adding a new Proprio (owner)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProprioPage(
          onSave: () {
            // Votre logique après l'enregistrement des données
            // Par exemple, vous pouvez afficher un message ou mettre à jour l'état de l'écran précédent.
            print("Données enregistrées");
          },
        ),
      ),
    );

    // If a result (new owner) is returned, update the list
    if (result != null) {
      setState(() {
        proprietors = DBHelper().getProprios();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Propriétaires', style: TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
      ),
      body: FutureBuilder<List<Proprio>>(
        future: proprietors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun propriétaire trouvé.'));
          }

          final proprios = snapshot.data!;
          return ListView.builder(
            itemCount: proprios.length,
            itemBuilder: (context, index) {
              final proprio = proprios[index];
              return ListTile(
                title: Text(proprio.name),
                subtitle: Text(proprio.email),
                onTap: () {
                  // Handle item tap if necessary (e.g., show details)
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProprioPage,
        backgroundColor: tPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        
      ),
    );
  }
}
