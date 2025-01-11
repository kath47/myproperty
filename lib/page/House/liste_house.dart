import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import '../../Settings/colors.dart';
import '../../data/data_model.dart';
import '../../data/db_helper.dart';
import 'add_house.dart';

class ListeAppartement extends StatefulWidget {
  const ListeAppartement({super.key});

  @override
  State<ListeAppartement> createState() => _ListeAppartement();
}

class _ListeAppartement extends State<ListeAppartement> {
  List<Property> maisonList = [];
  bool isLoading = true;

  HashSet<Property> selectedItem = HashSet();
  bool isMultiSelectionEnabled = false;
  String? localisation;

  @override
  void initState() {
    super.initState();
    _loadMaisons();
  }

  Future<void> _loadMaisons() async {
    final dbHelper = DBHelper();
    try {
      print('Chargement des données...');
      final data = await dbHelper.getmaisons();
      print('Données récupérées : $data');
      setState(() {
        maisonList = data.map((item) => Property.fromMap(item)).toList();
        isLoading = false;
      });
      print('Liste des maisons mise à jour : ${maisonList.length} maisons');
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Méthode pour naviguer vers la page d'ajout d'une propriété
  void _navigateToAddProprioPage() async {
    // Naviguer vers PropertyForm sans passer de callback onSave
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PropertyForm(), // Supprimez l'argument onSave
      ),
    );

    // Recharger les données après le retour de PropertyForm
    _loadMaisons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: isMultiSelectionEnabled ? false : true,
        leading: isMultiSelectionEnabled
            ? IconButton(
                onPressed: () {
                  selectedItem.clear();
                  isMultiSelectionEnabled = false;
                  setState(() {});
                },
                icon: const Icon(Icons.close))
            : null,
        title: Text(
          isMultiSelectionEnabled
              ? getSelectedItemCount()
              : "Liste des maisons",
          style: const TextStyle(color: tWhiteColor),
        ),
        backgroundColor: tPrimaryColor,
        actions: [
          Visibility(
              visible: selectedItem.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    maisonList.removeWhere((property) => selectedItem.contains(property));
                    selectedItem.clear();
                  });
                },
              )),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : maisonList.isEmpty
              ? const Center(
                  child: Text(
                  'Aucune donnée disponible.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ))
              : ListView(
                  children: maisonList.map((Property properties) {
                    return Card(
                      elevation: 10,
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 95.0,
                        child: getListItem(properties),
                      ),
                    );
                  }).toList(),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProprioPage,
        backgroundColor: tPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? "${selectedItem.length} sélectionné(s)"
        : "Aucune sélection";
  }

  void doMultiSelection(Property properties) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(properties)) {
        selectedItem.remove(properties);
      } else {
        selectedItem.add(properties);
      }
      setState(() {});
    }
  }

  InkWell getListItem(Property properties) {
    return InkWell(
      onTap: () {
        doMultiSelection(properties);
      },
      onLongPress: () {
        isMultiSelectionEnabled = true;
        doMultiSelection(properties);
      },
      child: Stack(alignment: Alignment.centerRight, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              properties.images!.isNotEmpty
                  ? properties.images![0]
                  : 'assets/images/default_image.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                    properties.titre,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${properties.city}, ${properties.commune}, ${properties.quartier}'),
                  Text(properties.description),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: isMultiSelectionEnabled,
          child: Icon(
            selectedItem.contains(properties)
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 30,
            color: Colors.red,
          ),
        ),
      ]),
    );
  }
}