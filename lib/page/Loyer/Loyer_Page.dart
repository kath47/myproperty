import 'package:flutter/material.dart';

import 'add_loyer.dart';

class RentDetailsPage extends StatefulWidget {
  const RentDetailsPage({super.key});

  @override
  _RentDetailsPageState createState() => _RentDetailsPageState();
}

class _RentDetailsPageState extends State<RentDetailsPage> {
  String searchQuery = "";
  final Map<int, bool> _selectedRows = {}; // Stocke l'état des cases cochées

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des paiements'),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                hintText: 'Rechercher un locataire...',
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
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
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
                      columnSpacing: 10,
                      columns: const [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Nom locataire',
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
                              'Date',
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
                              'Montant à Payé',
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
                              'Montant Payé',
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
                      rows: List.generate(
                        12, // Remplacez par vos données réelles
                        (index) {
                          final locataire = "Locataire de maison $index";
                          if (searchQuery.isNotEmpty &&
                              !locataire.toLowerCase().contains(searchQuery)) {
                            return null; // Filtrer les résultats
                          }
                          return DataRow(
                            selected: _selectedRows[index] ?? false,
                            onSelectChanged: (value) {
                              setState(() {
                                _selectedRows[index] = value ?? false;
                              });
                            },
                            cells: [
                              DataCell(Center(child: Text(locataire, textAlign: TextAlign.center))),
                              const DataCell(Center(child: Text('2024-11-27', textAlign: TextAlign.center))),
                              const DataCell(Center(child: Text('200 000', textAlign: TextAlign.center))),
                              const DataCell(Center(child: Text('150 000', textAlign: TextAlign.center))),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.teal),
                                      onPressed: () {
                                        // Action pour modifier
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // Action pour supprimer
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ).where((row) => row != null).cast<DataRow>().toList(),
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
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

