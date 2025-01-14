import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../Settings/colors.dart';
import '../../data/data_model.dart';
import '../../data/db_helper.dart';

class PropertyForm extends StatefulWidget {
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

  int proprietaireId = 0;
  List<Proprio> proprietaires = [];
  Proprio? selectedProprietaire;

  @override
  void initState() {
    super.initState();
    _loadProprietaires();
  }

  Future<void> _loadProprietaires() async {
    try {
      final proprietairesFromDb = await dbHelper.getProprietaires();
      setState(() {
        proprietaires = proprietairesFromDb;
        if (proprietaires.isNotEmpty) {
          selectedProprietaire = proprietaires.first;
          proprietaireId = selectedProprietaire!.id;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des propriétaires : $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image : $e')),
      );
    }
  }

void _saveProperty() async {
  if (selectedProprietaire == null || propertyType == null || selectedCity == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
    );
    return;
  }

  // Crée un objet Property sans ID
  final property = {
    'titre': titreController.text,
    'type': propertyType!,
    'ownerId': selectedProprietaire!.id,
    'numberOfRooms': int.tryParse(nbrepieceController.text) ?? 0,
    'rentCost': double.tryParse(priceController.text) ?? 0.0,
    'city': selectedCity!,
    'commune': communeController.text,
    'quartier': quartierController.text,
    'status': statutMaison!,
    'description': descriptionController.text,
    'images': _selectedImage?.path,
  };

  try {
    // Insère la propriété dans la base de données
    await dbHelper.insertProperty(property);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enregistrée avec succès')),
    );
    Navigator.pop(context, true); // Retourne `true` pour indiquer un succès
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
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
              // Image Section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.teal,
                            size: 50,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ajouter une image',
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Form Fields
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nbrepieceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Nombre de pièces',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Coût du loyer',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'Ville',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
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
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: communeController,
                      decoration: const InputDecoration(
                        labelText: 'Commune',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quartierController,
                      decoration: const InputDecoration(
                        labelText: 'Quartier',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
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
              const SizedBox(height: 15),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _saveProperty,
                    icon: const Icon(Icons.check, color: Colors.teal),
                    label: const Text('Enregistrer', style: TextStyle(color: Colors.teal)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.teal),
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