import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../Settings/colors.dart';
import '../../data/data_model.dart';
import '../../data/db_helper.dart';

class PropertyForm extends StatefulWidget {
  
 // final VoidCallback onSave; // Callback pour notifier l'enregistrement
  const PropertyForm({Key? key}) : super(key: key);

  @override
  _PropertyFormState createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  final dbHelper = DBHelper();
  final List<String> cities = [
    "Abidjan",
    "Yamoussoukro",
    "Bouaké",
    "San-Pédro",
    "Daloa",
    "Korhogo",
    "Man",
    "Gagnoa",
  ];

  String? propertyType = 'Appartement';
  String? statutMaison = 'Disponible';
  File? _selectedImage;
  String? selectedCity;

  TextEditingController titreController = TextEditingController();
  TextEditingController nbrepieceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController communeController = TextEditingController();
  TextEditingController quartierController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Fonction pour choisir une image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery, // Galerie ou camera
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path); // Stocke l'image sélectionnée
      });
    }
  }

  int proprietaireId = 0;
  List<Proprio> proprietaires = [];
  Proprio? selectedProprietaire;

  @override
  void initState() {
    super.initState();
    _loadProprietaires();
    _refreshCounts();
  }

  Future<void> _loadProprietaires() async {
    final dbHelper = DBHelper();
    final proprietairesFromDb = await dbHelper.getProprietaires();

    setState(() {
      proprietaires = proprietairesFromDb;
      if (proprietaires.isNotEmpty) {
        selectedProprietaire = proprietaires.first;
        proprietaireId = selectedProprietaire!.id;
      }
    });
  }

  int totalProperties = 0;
  double totalRent = 0.0;

  Future<void> _refreshCounts() async {
    // Récupérez les données depuis la base de données
    final db = DBHelper();
    final countQuery = await db.countProperty();

    setState(() {
      totalProperties = countQuery;
    });
  }

  void _saveProperty() async {
    if (selectedProprietaire == null || propertyType == null || selectedCity == null) {
      // Vérifiez que tous les champs obligatoires sont remplis
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    // Créez un objet pour représenter la maison
    final property = {
      'titre': titreController.text,
      'type': propertyType!,
      'propioId': selectedProprietaire!.id,
      'numberofrooms': int.tryParse(nbrepieceController.text) ?? 0,
      'rentcost': double.tryParse(priceController.text) ?? 0.0,
      'city': selectedCity!,
      'commune': communeController.text,
      'quartier': quartierController.text,
      'status': statutMaison!,
      'description': descriptionController.text,
      'images': _selectedImage?.path,
    };

    try {
      // Enregistrez la maison dans la base de données
      await dbHelper.insertProperty(property);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enregistrée avec succès')),
      );


      // Retourner à la page précédente (la liste des propriétés)
      Navigator.pop(context, true); // Retourne `true` pour indiquer un succès
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nouvelle maison',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: tPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image Carousel or Default Container
              if (_selectedImage != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                )
              else
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text('Aucune image ajoutée'),
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage,
                label: const Text(
                  'Ajouter une image',
                  style: TextStyle(color: Colors.teal),
                ),
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre de maison',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<Proprio>(
                value: selectedProprietaire,
                decoration: const InputDecoration(
                  labelText: 'Nom du propriétaire',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                items: proprietaires.map((proprio) {
                  return DropdownMenuItem<Proprio>(
                    value: proprio,
                    child: Text(proprio.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProprietaire = value;
                    proprietaireId = value?.id ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Property Type Dropdown
              DropdownButtonFormField<String>(
                value: propertyType,
                decoration: const InputDecoration(
                  labelText: 'Type de construction',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                items: ['Appartement', 'Maison basse', 'Duplex'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    propertyType = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              // Location Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Nombre de pièces',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      controller: nbrepieceController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Coût du loyer',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      controller: priceController,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Ville",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      value: selectedCity,
                      hint: const Text("Choisissez"),
                      items: cities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez sélectionner une ville";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Commune',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      controller: communeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Surface Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Quartier',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      controller: quartierController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: statutMaison,
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      items: ['Disponible', 'Occupée'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          statutMaison = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _saveProperty,
                    icon: const Icon(Icons.check, color: Colors.teal),
                    label: const Text('Enregistrer', style: TextStyle(color: Colors.teal)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Annuler et retourner à la page précédente
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.teal,
                    ),
                    label: const Text('Annuler', style: TextStyle(color: Colors.teal)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}