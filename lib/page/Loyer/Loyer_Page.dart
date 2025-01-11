import 'package:flutter/material.dart';

import '../../data/data_model.dart';
import '../../data/db_helper.dart';
import 'add_loyer.dart'; 

class RentDetailsPage extends StatefulWidget {
  const RentDetailsPage({super.key});

  @override
  _RentDetailsPageState createState() => _RentDetailsPageState();
}

class _RentDetailsPageState extends State<RentDetailsPage> {
  String searchQuery = "";
  final Set<int> _selectedRows = {};
  List<Payment> payments = []; 

  @override
  void initState() {
    super.initState();
    _loadPayments(); 
  }

  // Charger les paiements depuis la base de données
  Future<void> _loadPayments() async {
  try {
    final dbHelper = DBHelper();
    final paymentsFromDb = await dbHelper.getAllPayments();
    setState(() {
      payments = paymentsFromDb;
    });
  } catch (e) {
    print("Erreur lors du chargement des paiements: $e");
    // Vous pouvez également afficher un message d'erreur à l'utilisateur
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des loyers'),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                hintText: 'Rechercher une maison...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Tableau
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.teal.withOpacity(0.8),
                      ),
                      columnSpacing: 40,
                      columns: const [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Maison',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Statut',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Actions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                      rows: payments
                          .where((payment) =>
                              payment.propertiesId
                                  .toString()
                                  .contains(searchQuery) ||
                              payment.status
                                  .toLowerCase()
                                  .contains(searchQuery))
                          .map(
                            (payment) => DataRow(
                              selected: _selectedRows.contains(payment.id),
                              onSelectChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    //_selectedRows.add(payment.id);
                                  } else {
                                    _selectedRows.remove(payment.id);
                                  }
                                });
                              },
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      "Maison ${payment.propertiesId}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      payment.status,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: payment.status == "Payé"
                                            ? Colors.green
                                            : payment.status == "Non Payé"
                                                ? Colors.red
                                                : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Bouton de visualisation des détails
                                      IconButton(
                                        icon: const Icon(Icons.visibility, color: Colors.blue),
                                        onPressed: () {
                                          _showPaymentDetails(context, payment);
                                        },
                                      ),
                                      // Bouton de modification
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.teal),
                                        onPressed: () {
                                          _editPayment(payment);
                                        },
                                      ),
                                      // Bouton de suppression
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _deletePayment(payment.id!);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Bouton flottant "Nouveau paiement"
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentFormPage(),
            ),
          ).then((_) {
            _loadPayments(); // Recharger les paiements après ajout
          });
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Fonction pour afficher les détails d'un paiement
  void _showPaymentDetails(BuildContext context, Payment payment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Détails du paiement pour la maison ${payment.propertiesId}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID: ${payment.id}"),
              Text("Locataire ID: ${payment.locataireId}"),
              Text("Maison ID: ${payment.propertiesId}"),
              Text("Date: ${payment.paymentDate}"),
              Text("Montant payé: ${payment.amountPaid}"),
              Text("Montant dû: ${payment.amountDue}"),
              Text("Mois: ${payment.month}"),
              Text("Année: ${payment.year}"),
              Text("Statut: ${payment.status}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour modifier un paiement
  void _editPayment(Payment payment) {
    // Implémentez la logique de modification ici
    print("Modifier le paiement: ${payment.id}");
  }

    // Fonction pour supprimer un paiement
  void _deletePayment(int paymentId) async {
  final db = DBHelper(); // Utilisez une instance de DBHelper
  await db.deletePayment(paymentId); // Supprimez le paiement de la base de données

  setState(() {
    payments.removeWhere((payment) => payment.id == paymentId); // Mettez à jour la liste des paiements
  });

  print("Paiement supprimé: $paymentId");
}

  
}