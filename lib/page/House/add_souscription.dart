import 'package:flutter/material.dart';
import 'package:myproperty/data/data_model.dart';
import 'package:myproperty/data/db_helper.dart';
import 'package:intl/intl.dart';
import '../../Settings/colors.dart';

class SouscriptionForm extends StatefulWidget {
  const SouscriptionForm({super.key});

  @override
  _SouscriptionFormState createState() => _SouscriptionFormState();
}

class _SouscriptionFormState extends State<SouscriptionForm> {
  final _formKey = GlobalKey<FormState>();
    
  // Controllers
  final TextEditingController rentCostController = TextEditingController();
  final TextEditingController monthsCautionController = TextEditingController();
  final TextEditingController cautionAmountController = TextEditingController();
  final TextEditingController monthsAdvanceController = TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController otherFeesLabelController = TextEditingController();
  final TextEditingController otherFeesAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // Dropdown fields
  String status = 'Active';

  DateTime? date;

  int locataireId = 0;
  List<Locataire> locataires = [];
  Locataire? selectedLocataire;

  int propertiesId = 0;
  List<Property> properties = [];
  Property? selectedProperty;

  @override
  void dispose() {
    rentCostController.dispose();
    monthsCautionController.dispose();
    cautionAmountController.dispose();
    monthsAdvanceController.dispose();
    advanceAmountController.dispose();
    otherFeesLabelController.dispose();
    otherFeesAmountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void saveSubscription() async {
    if (selectedLocataire == null ||
        selectedProperty == null ||
        dateController.text.isEmpty ||
        rentCostController.text.isEmpty ||
        monthsCautionController.text.isEmpty ||
        cautionAmountController.text.isEmpty ||
        monthsAdvanceController.text.isEmpty ||
        advanceAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
      );
      return;
    }
    DateTime now = DateTime.now();

    // Formater la date en différents formats
    String shortDate = DateFormat('dd/MM/yyyy').format(now);

    // Création d'un nouvel objet Subscription avec les données du formulaire
    final newSubscription = {
      'houseId': selectedProperty!.id,
      'tenantId': selectedLocataire!.id,
      'date': dateController.text,
      'rentCost': double.tryParse(rentCostController.text) ?? 0.0,
      'cautionMonths': int.tryParse(monthsCautionController.text) ?? 0,
      'cautionAmount': double.tryParse(cautionAmountController.text) ?? 0.0,
      'advanceMonths': int.tryParse(monthsAdvanceController.text) ?? 0,
      'advanceAmount': double.tryParse(advanceAmountController.text) ?? 0.0,
      'otherFeesLabel': otherFeesLabelController.text,
      'otherFeesAmount': double.tryParse(otherFeesAmountController.text) ?? 0.0,
      'entryDate': shortDate,
      'paymentStartDate': shortDate,
      'status': status,
    };

    try {
      final dbHelper = DBHelper();
      await dbHelper.insertSubscription(newSubscription);

      // Notification de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enregistré avec succès.')),
      );

      // Réinitialisation des champs
      setState(() {
        selectedLocataire = null;
        selectedProperty = null;
        dateController.clear();
        rentCostController.clear();
        monthsCautionController.clear();
        cautionAmountController.clear();
        monthsAdvanceController.clear();
        advanceAmountController.clear();
        otherFeesLabelController.clear();
        otherFeesAmountController.clear();
        status = 'Active';
      });

      // Fermer le formulaire
      Navigator.pop(context);
    } catch (e) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

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
        rentCostController.text = selectedProperty!.rentCost.toString(); // Remplir le coût du loyer
      }
    });
  }

  // Méthode pour calculer la caution et l'avance
  void _calculateAmounts() {
    final rentCost = double.tryParse(rentCostController.text) ?? 0.0;
    final cautionMonths = int.tryParse(monthsCautionController.text) ?? 0;
    final advanceMonths = int.tryParse(monthsAdvanceController.text) ?? 0;

    setState(() {
      cautionAmountController.text = (rentCost * cautionMonths).toStringAsFixed(2);
      advanceAmountController.text = (rentCost * advanceMonths).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle souscription', style: TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<Property>(
                  decoration: const InputDecoration(
                    labelText: 'Identifiant Maison *',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
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
                      rentCostController.text = value?.rentCost.toString() ?? '0.0'; // Mettre à jour le coût du loyer
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Locataire>(
                  value: selectedLocataire,
                  decoration: const InputDecoration(
                    labelText: 'Nom du locataire *',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
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
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date *',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        date = pickedDate;
                        dateController.text = pickedDate.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: rentCostController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Coût du loyer *',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  readOnly: true, // Empêche la modification manuelle
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: monthsCautionController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de Mois Caution *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                        onChanged: (value) => _calculateAmounts(), // Recalculer les montants
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: cautionAmountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Montant Caution *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                        readOnly: true, // Empêche la modification manuelle
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: monthsAdvanceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de Mois Avance *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                        onChanged: (value) => _calculateAmounts(), // Recalculer les montants
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: advanceAmountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Montant Avance *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                        readOnly: true, // Empêche la modification manuelle
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: otherFeesLabelController,
                  decoration: const InputDecoration(
                    labelText: 'Libellé Autre Frais',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: otherFeesAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Montant Autre Frais',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  value: status,
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                  ],
                  onChanged: (value) => setState(() {
                    status = value!;
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: saveSubscription,
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