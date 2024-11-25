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

  @override
  void initState() {
    super.initState();
    _loadMaisons();
  }

  Future<void> _loadMaisons() async {
    final dbHelper = DBHelper();
    final data = await dbHelper.getmaisons();
    setState(() {
      maisonList = data.map((item) => Property.fromMap(item)).toList();
      isLoading = false;
    });
  }

   // Méthode pour actualiser la page liste après enregistrement
  void _navigateToAddProprioPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyForm(
          onSave: () {
            print("Données enregistrées");
          },
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _loadMaisons();
        isLoading = false;
      });
    }
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
        title: Text(isMultiSelectionEnabled
            ? getSelectedItemCount()
            : "Liste des maisons", style: const TextStyle(color: tWhiteColor)),
            backgroundColor: tPrimaryColor,
        actions: [
          Visibility(
              visible: selectedItem.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  selectedItem.forEach((properties) {
                    maisonList.remove(properties);
                  });
                  selectedItem.clear();
                  setState(() {});
                },
              )),
          Visibility(
              visible: selectedItem.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
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
          :ListView(
        children: maisonList.map((Property properties) {
          return Card(
              elevation: 10,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                height: 70.0,
                child: getListItem(properties),
              ));
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
        ? "${selectedItem.length} item selected"
        : "No item selected";
  }

  void doMultiSelection(Property properties) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(properties)) {
        selectedItem.remove(properties);
      } else {
        selectedItem.add(properties);
      }
      setState(() {});
    } else {
      //Other logic
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
                properties.images.isNotEmpty
                    ? properties.images[0]
                    : 'assets/images/default_image.png',
                height: 80,
                width: 80,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox( height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 18.0,
                      child: Text(properties.type),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 18.0,
                      child: Text(properties.city),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 18.0,
                      child: Text(properties.commune),
                    ),
                  ],
                ),
              )
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
              ))
        ]));
  }
  
}