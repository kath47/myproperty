import 'dart:async';

import 'package:flutter/material.dart';
import '../../Settings/colors.dart';
import '../../data/db_helper.dart';
import 'dashWidget.dart';
import 'listeProprio.dart';
import 'liste_house.dart';
import 'liste_locataire.dart';
import 'liste_souscription.dart';

class PagesListView extends StatefulWidget {
  const PagesListView({super.key});

  @override
  _PagesListViewState createState() => _PagesListViewState();
}

class _PagesListViewState extends State<PagesListView> {
  int totalLocataires = 0;
  int totalSouscription = 0;
  int totalProprietaires = 0;
  int totalMaisons = 0;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadTotalProprietaires();
    _loadTotalLocataires();
    _loadTotalMaisons();
    _loadTotalSubcription();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
    _loadTotalMaisons();
    _loadTotalProprietaires();
    _loadTotalLocataires();
    _loadTotalSubcription();
    });
      }
  });
  }

  Future<void> _loadTotalLocataires() async {
    final dbHelper = DBHelper();
    final count = await dbHelper.countLocataires();
    setState(() {
      totalLocataires = count;
      isLoading = false;
    });
  }

  Future<void> _loadTotalProprietaires() async {
    final dbHelper = DBHelper();
    final count = await dbHelper.countProprietaires();
    setState(() {
      totalProprietaires = count;
      isLoading = false;
    });
  }

  Future<void> _loadTotalMaisons() async {
    final dbHelper = DBHelper();
    final count = await dbHelper.countProperty();
    setState(() {
      totalMaisons = count;
      isLoading = false;
    });
  }
  Future<void> _loadTotalSubcription() async {
    final dbHelper = DBHelper();
    final count = await dbHelper.countSouscription();
    setState(() {
      totalSouscription = count;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maisons', style: TextStyle(color: tWhiteColor),),
        backgroundColor: tPrimaryColor,
      ),
      body: ListView(
        children: [
          const PropertyStatsCard(),
          _buildListTile(
            context,
            'Propriétaire',
            totalProprietaires, // Le nombre d'enregistrements
            Icons.person,
            Colors.teal,
            () {
              // Naviguer vers la page Propriétaire
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProprioListPage(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            'Maisons',
            totalMaisons, // Le nombre d'enregistrements
            Icons.house,
            Colors.teal,
            () {
              // Naviguer vers la page Maison
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListeAppartement()),
              );
            },
          ),
          _buildListTile(
            context,
            'Locataires',
             totalLocataires, // Le nombre d'enregistrements
            Icons.account_circle,
            Colors.teal,
            () {
              // Naviguer vers la page Locataire
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListeLocataire()),
              );
            },
          ),
          _buildListTile(
            context,
            'Souscription',
             totalSouscription, // Le nombre d'enregistrements
            Icons.credit_card,
            Colors.teal,
            () {
              // Naviguer vers la page Locataire
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubscriptionListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    int recordCount,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: Icon(icon, color: iconColor, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$recordCount enregistré(s)'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}


