import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/data_model.dart';
import '../../data/db_helper.dart'; // Pour la gestion des dates

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs du formulaire
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedExpenseType;
  String? _selectedSubType;

  // Liste des types de dépenses et sous-types
  final Map<String, List<String>> _expenseTypesWithSubTypes = {
    'Réparations': ['Plomberie', 'Électricité', 'Peinture', 'Autres'],
    'Maintenance': ['Jardinage', 'Nettoyage', 'Autres'],
    'Vidange des fosses septiques': [],
    'Assurance': [],
    'Impôts fonciers': [],
    'Autres': [],
  };

  // Méthode pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une Dépense'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Sélecteur du type de dépense
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type de dépense',
                  border: OutlineInputBorder(),
                ),
                value: _selectedExpenseType,
                items: _expenseTypesWithSubTypes.keys
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExpenseType = value;
                    _selectedSubType = null; // Réinitialiser le sous-type
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un type.' : null,
              ),
              const SizedBox(height: 16.0),

              // Sélecteur du sous-type (affiché uniquement si applicable)
              if (_selectedExpenseType != null &&
                  _expenseTypesWithSubTypes[_selectedExpenseType!]!.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sous-type de dépense',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedSubType,
                  items: _expenseTypesWithSubTypes[_selectedExpenseType!]!
                      .map((subType) => DropdownMenuItem(
                            value: subType,
                            child: Text(subType),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubType = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Veuillez sélectionner un sous-type.'
                      : null,
                ),
              const SizedBox(height: 16.0),

              // Champ pour le montant
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant (F CFA)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un montant valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Champ pour la description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (facultatif)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),

              // Sélecteur de date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Aucune date sélectionnée'
                          : 'Date : ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Sélectionner une date'),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Bouton pour soumettre le formulaire
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final expense = Expense(
                      type: _selectedExpenseType,
                      subType: _selectedSubType,
                      amount: double.parse(_amountController.text),
                      description: _descriptionController.text,
                      date: _selectedDate ?? DateTime.now(),
                    );

                    // Enregistrer la dépense dans la base de données
                    final dbHelper = DBHelper();
                    await dbHelper.insertExpense(expense);

                    // Retourner à l'écran précédent
                    Navigator.pop(context, expense);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Ajouter',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
