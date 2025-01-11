import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'House/housePage.dart';
import 'Locataire/LocatairePage.dart';
import 'Loyer/Loyer_Page.dart';
import 'Notification/notification.dart';
import 'Profil/ProfilPage.dart';
import '../../page/SettingsPage.dart';
import '../../page/SearchPage.dart';
import '../data/db_helper.dart';
import 'Profit/ProfitPage.dart';
import 'depense/depensePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DBHelper();
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  List<Map<String, dynamic>> properties = [];
  int index = 2;
  int houseCount= 0;
  double sommeTotal= 0;
  

  @override
  void initState() {
    super.initState();
    _loadPropertyCount();
    Timer.periodic(const Duration(seconds: 5), (timer) {
    _loadPropertyCount();
  });
  }

  Future<void> _loadPropertyCount() async {
    final count = await dbHelper.getCountProperties();
    setState(() {
      houseCount = count;
    });
  }


Future<void>loyermois() async{
  // Calculer la somme des paiements du mois en cours avec le statut "Payé"
  double totalSum = await dbHelper.sumpaidofmonth();
  setState(() {
      sommeTotal = totalSum;
    });
  
}



  List<Widget> get screens => [
    const Center(child: Text('Notifications Page')),
    const SearchPage(),
    HomePageContent(houseCount: houseCount, sommeTotal : sommeTotal), 
    const SettingsPage(),
    const ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.notifications, size: 30),
      const Icon(Icons.search, size: 30),
      const Icon(Icons.home, size: 30),
      const Icon(Icons.settings, size: 30),
      const Icon(Icons.person, size: 30),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('GK-Immobi',style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      body: screens[index], 
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          key: navigationKey,
          color: Colors.teal,
          backgroundColor: Colors.transparent,
          height: 70,
          index: index,
          items: items,
          onTap: (selectedIndex) => setState(() => index = selectedIndex),
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final int houseCount;
  final double sommeTotal;

  const HomePageContent({super.key, required this.houseCount, required this.sommeTotal});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildStatCard(
              'Gestion des apparts.', 
              '${widget.houseCount}', // Affiche le nombre de maisons
              Icons.folder, 
              Colors.orangeAccent, 
              context, 
              const PagesListView()
            ),
            _buildStatCard('Loyer du Mois', '${widget.sommeTotal}', Icons.paid, Colors.green, context, const RentDetailsPage()),
            _buildStatCard('Dépenses', '1200 Fcfa', Icons.money_off, Colors.red, context, const ExpenseDetailsPage()),
            _buildStatCard('Profit', '5000 Fcfa', Icons.trending_up, Colors.purple, context, const ProfitDetailsPage()),
            _buildStatCard('Location', '64', Icons.person_add, Colors.blue, context, const RequestsPage()),
            _buildStatCard('Messages', '8', Icons.message, Colors.brown, context, const MessagesPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, BuildContext context, Widget targetPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
