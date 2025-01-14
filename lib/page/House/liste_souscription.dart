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
  setState(() {
    isLoading = true;
  });

  try {
    final dbHelper = DBHelper();
    final data = await dbHelper.getSubscriptions();

    // Créez une nouvelle liste pour stocker les souscriptions modifiables
    final List<Map<String, dynamic>> modifiableSubscriptions = [];

    for (var subscription in data) {
      // Créez une copie modifiable de chaque souscription
      final Map<String, dynamic> modifiableSubscription = Map<String, dynamic>.from(subscription);

      final tenantId = modifiableSubscription['tenantId'] is int
          ? modifiableSubscription['tenantId'] as int
          : int.tryParse(modifiableSubscription['tenantId'].toString());

      final houseId = modifiableSubscription['houseId'] is int
          ? modifiableSubscription['houseId'] as int
          : int.tryParse(modifiableSubscription['houseId'].toString());

      if (tenantId != null) {
        final tenantName = await dbHelper.getTenantNameById(tenantId);
        modifiableSubscription['tenantName'] = tenantName ?? 'Nom inconnu';
      } else {
        modifiableSubscription['tenantName'] = 'ID Locataire manquant';
      }

      if (houseId != null) {
        final houseName = await dbHelper.getHouseNameById(houseId);
        modifiableSubscription['houseName'] = houseName ?? 'Nom inconnu';
      } else {
        modifiableSubscription['houseName'] = 'ID Appartement manquant';
      }

      // Ajoutez la souscription modifiée à la nouvelle liste
      modifiableSubscriptions.add(modifiableSubscription);
    }

    setState(() {
      subscriptions = modifiableSubscriptions;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des données : $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    debugPrint('Erreur lors du chargement des souscriptions : $e');
  }
}



  void _addNewSubscription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SouscriptionForm(
          onSave: () {
            _fetchSubscriptions();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Locataire enregistré avec succès!')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des souscriptions',
          style: TextStyle(color: tWhiteColor),
        ),
        backgroundColor: tPrimaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                      key: ValueKey(subscription['id']),
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Locataire: ${subscription['tenantName'] ?? 'Nom inconnu'}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Maison: ${subscription['houseName'] ?? 'N/A'}'),
                            Text('Loyer: ${subscription['rentCost'] ?? 'N/A'}'),
                            Text('Statut: ${subscription['status'] ?? 'N/A'}'),
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
