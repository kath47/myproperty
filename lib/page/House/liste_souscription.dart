import 'package:flutter/material.dart';

import '../../Settings/colors.dart';
import '../../data/db_helper.dart';
import 'add_souscription.dart';

class SubscriptionListScreen extends StatefulWidget {
  const SubscriptionListScreen({super.key});

  @override
  _SubscriptionListScreenState createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  List<Map<String, dynamic>> subscriptions = []; // Liste vide pour commencer
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions(); // Charger les données au démarrage
  }

  Future<void> _fetchSubscriptions() async {
    try {
      final dbHelper = DBHelper(); // Instance du gestionnaire de base de données
      final data = await dbHelper.getSubscriptions(); // Récupérer les souscriptions
      setState(() {
        subscriptions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des données : $e')),
      );
    }
  }

  void _addNewSubscription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SouscriptionForm(),
      ),
    ).then((newSubscription) {
      if (newSubscription != null) {
        _fetchSubscriptions(); // Recharger la liste après ajout
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des souscriptions', style: TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : subscriptions.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune souscription disponible.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscription = subscriptions[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(subscription['tenantName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${subscription['id']}'),
                            Text('Maison: ${subscription['houseId']}'),
                            Text('Loyer: ${subscription['rentCost']}'),
                            Text('Statut: ${subscription['status']}'),
                          ],
                        ),
                        trailing: Icon(
                          subscription['status'] == 'Active'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: subscription['status'] == 'Active'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewSubscription,
        backgroundColor: tPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
