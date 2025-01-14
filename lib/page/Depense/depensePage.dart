import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../data/data_model.dart';
import '../../data/db_helper.dart';
import '../Depense/add_depense.dart';


class ExpenseDetailsPage extends StatefulWidget {
  const ExpenseDetailsPage({super.key});

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Expense> _expenses = [];
  Map<String, List<Expense>> _expensesByMonth = {};

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  // Charger les dépenses depuis la base de données
  Future<void> _loadExpenses() async {
  try {
    final expenses = await _dbHelper.getExpenses();
    setState(() {
      _expenses = expenses;
      _organizeExpensesByMonth();
    });
  } catch (e) {
    print('Erreur lors du chargement des dépenses : $e');
    // Affichez un message d'erreur à l'utilisateur si nécessaire
  }
}

  // Organiser les dépenses par mois
  void _organizeExpensesByMonth() {
    _expensesByMonth.clear();
    for (var expense in _expenses) {
      final monthYear = DateFormat('MMMM yyyy').format(expense.date);
      if (_expensesByMonth.containsKey(monthYear)) {
        _expensesByMonth[monthYear]!.add(expense);
      } else {
        _expensesByMonth[monthYear] = [expense];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Dépenses', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liste des dépenses par mois',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _expensesByMonth.isEmpty
                  ? const Center(child: Text('Aucune dépense enregistrée.'))
                  : ListView.builder(
                      itemCount: _expensesByMonth.length,
                      itemBuilder: (context, index) {
                        final monthYear = _expensesByMonth.keys.elementAt(index);
                        final expensesForMonth = _expensesByMonth[monthYear]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                monthYear,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            ...expensesForMonth.map((expense) {
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4.0),
                                child: ListTile(
                                  leading: const Icon(Icons.receipt, color: Colors.teal),
                                  title: Text(expense.type ?? 'Type inconnu'),
                                  subtitle: Text(
                                    'Montant : ${expense.amount} F CFA\nDate : ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await _dbHelper.deleteExpense(expense.id!);
                                      _loadExpenses(); // Recharger les données après suppression
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExpensePage()),
                );
                if (result != null) {
                  _loadExpenses(); // Recharger les données après ajout
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: const Center(
                child: Text(
                  'Ajouter une Dépense',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}