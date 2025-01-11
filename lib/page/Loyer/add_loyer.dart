import 'package:flutter/material.dart';

import '../../data/data_model.dart';
import '../../data/db_helper.dart';

class PaymentFormPage extends StatefulWidget {
  const PaymentFormPage({super.key});

  @override
  State<PaymentFormPage> createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedHouseId;
  String? selectedMonth;
  String? selectedYear;
  String? selectedStatus;
  DateTime? selectedDate;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController rentCostController = TextEditingController();
  final TextEditingController rentDuController = TextEditingController();

  int locataireId = 0;
  List<Locataire> locataires = [];
  Locataire? selectedLocataire;

  int propertiesId = 0;
  List<Property> properties = [];
  Property? selectedProperty;

  @override
  void initState() {
    super.initState();
    _loadLocataires();
    _loadProperties();
  }

  Future<void> _loadLocataires() async {
    final dbHelper = DBHelper();
    final locataireFromDb = await dbHelper.getAllLocataires();
    setState(() {
      locataires = locataireFromDb;
      if (locataires.isNotEmpty) {
        selectedLocataire = locataires.first;
        locataireId = selectedLocataire!.id;
      }
    });
  }

  Future<void> _loadProperties() async {
    final dbHelper = DBHelper();
    final propertiesFromDb = await dbHelper.getAllProperties();
    setState(() {
      properties = propertiesFromDb;
      if (properties.isNotEmpty) {
        selectedProperty = properties.first;
        propertiesId = selectedProperty!.id;
        rentCostController.text = selectedProperty!.rentCost.toString();
      }
    });
  }

  void savepayment() async {
    if (_formKey.currentState?.validate() == true) {
      final dbHelper = DBHelper();

      final payment = Payment(
        locataireId: locataireId,
        propertiesId: propertiesId,
        paymentDate: selectedDate!,
        amountPaid: double.parse(rentCostController.text),
        amountDue: double.parse(rentDuController.text), 
        month: selectedMonth!,
        year: selectedYear!,
        status: selectedStatus!,
      );

      await dbHelper.insertPayment(payment);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paiement enregistré avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paiement du Loyer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Identifiant Maison',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Property>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  hint: const Text('Sélectionnez une maison'),
                  value: selectedProperty,
                  items: properties.map((property) {
                    return DropdownMenuItem<Property>(
                      value: property,
                      child: Text(property.titre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProperty = value;
                      propertiesId = value?.id ?? 0;
                      rentCostController.text = value?.rentCost.toString() ?? '0.0';
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner une maison';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Locataire',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Locataire>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Entrez le nom du locataire',
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  value: selectedLocataire,
                  items: locataires.map((locataire) {
                    return DropdownMenuItem<Locataire>(
                      value: locataire,
                      child: Text(locataire.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocataire = value;
                      locataireId = value?.id ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un locataire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Date de Paiement',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Sélectionnez une date',
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Montant à Payer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: rentCostController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Entrez le montant à payer',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                            readOnly: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champ est obligatoire';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Montant Payé',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: rentDuController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Entrez le montant payé',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champ est obligatoire';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mois Concerné',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                            hint: const Text('Mois'),
                            value: selectedMonth,
                            items: [
                              'Janvier',
                              'Février',
                              'Mars',
                              'Avril',
                              'Mai',
                              'Juin',
                              'Juillet',
                              'Août',
                              'Septembre',
                              'Octobre',
                              'Novembre',
                              'Décembre',
                            ].map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(month),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Veuillez sélectionner un mois';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Année Concernée',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                            hint: const Text('Année'),
                            value: selectedYear,
                            items: [
                              '2023',
                              '2024',
                              '2025',
                            ].map((year) {
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Veuillez sélectionner une année';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Statut',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  hint: const Text('Sélectionnez un statut'),
                  value: selectedStatus,
                  items: [
                    'Payé',
                    'Non Payé',
                    'Partiellement Payé',
                  ].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un statut';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: savepayment,
                      icon: const Icon(Icons.check),
                      label: const Text('Enregistrer'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Annuler'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}