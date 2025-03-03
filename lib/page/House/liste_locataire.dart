import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproperty/page/House/add_locataire.dart';
import '../../Settings/colors.dart';
import '../../data/data_model.dart';
import '../../data/db_helper.dart';

class ListeLocataire extends StatefulWidget {
  const ListeLocataire({super.key});

  @override
  State<ListeLocataire> createState() => _ListeLocataire();
}

class _ListeLocataire extends State<ListeLocataire> {
  List<Locataire> locataireList = [];
  bool isLoading = true;

  HashSet<Locataire> selectedItem = HashSet();
  bool isMultiSelectionEnabled = false;

  Future<void>? _loadLocatairesFuture;

  @override
  void initState() {
    super.initState();
    _loadLocatairesFuture = _loadLocataires();
  }

  @override
  void dispose() {
    _loadLocatairesFuture?.ignore(); // Annulez le Future si le widget est retiré
    super.dispose();
  }

  Future<void> _loadLocataires() async {
    final dbHelper = DBHelper();
    final data = await dbHelper.getLocataires();

    if (mounted) { // Vérifiez si le widget est toujours monté
      setState(() {
        locataireList = data.map((item) => Locataire.fromMap(item)).toList();
        isLoading = false;
      });
    }
  }

  void _navigateToAddLocatairePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  LocataireForm(
          onSave: () {
            _loadLocataires();
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Locataire enregistré avec succès!')),
            );
          },
        ),
      ),
    );

    if (result == true && mounted) {
      // Rechargez les données si l'enregistrement a réussi
      await _loadLocataires();
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
            : "Liste des locataires", style: const TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
        actions: [
          Visibility(
              visible: selectedItem.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  selectedItem.forEach((locataire) {
                    locataireList.remove(locataire);
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
          : locataireList.isEmpty
              ? const Center(
                  child: Text(
                  'Aucune donnée disponible.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
              ))
              : ListView(
                  children: locataireList.map((Locataire locataire) {
                    return Card(
                        elevation: 10,
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          height: 70.0,
                          child: getListItem(locataire),
                        ));
                  }).toList(),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddLocatairePage,
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

  void doMultiSelection(Locataire locataire) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(locataire)) {
        selectedItem.remove(locataire);
      } else {
        selectedItem.add(locataire);
      }
      setState(() {});
    } else {
      // Autre logique
    }
  }

  InkWell getListItem(Locataire locataire) {
  return InkWell(
    onTap: () {
      doMultiSelection(locataire);
    },
    onLongPress: () {
      isMultiSelectionEnabled = true;
      doMultiSelection(locataire);
    },
    child: Stack(
      alignment: Alignment.centerRight,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: locataire.profileImage != null && locataire.profileImage!.isNotEmpty
                  ? Image.file(
                      File(locataire.profileImage!), // Utilisez Image.file pour les fichiers locaux
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Affichez une image par défaut en cas d'erreur
                        return Image.asset(
                          'assets/images/default_image.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/default_image.png', // Image par défaut
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 18.0,
                    child: Text(locataire.name),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 18.0,
                    child: Text(locataire.email ?? 'Aucun email'),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 16.0,
                    child: Text(locataire.phone ?? 'Aucun téléphone'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: isMultiSelectionEnabled,
          child: Icon(
            selectedItem.contains(locataire)
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 30,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}
}