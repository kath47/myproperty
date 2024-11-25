import 'package:flutter/material.dart';
import 'package:myproperty/Settings/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

import 'package:myproperty/data/db_helper.dart';

class LocataireForm extends StatefulWidget {
  const LocataireForm({super.key});

  @override
  State<LocataireForm> createState() => _LocataireFormState();
}

class _LocataireFormState extends State<LocataireForm> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();


  DateTime? _selectedDate;
  String? _selectedNationality;
  String? _selectedCivility;
  String? _selectedIDType;
  String? _selectedFunction;
  String? _selectedPet;
  File? _selectedImage;
  File? _selectedImageId;

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
  
  Future<void> _pickImageId() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery, // Galerie ou camera
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImageId = File(pickedImage.path); // Stocke l'image sélectionnée
      });
    }
  }

  Future<void> _saveLocataire() async {
  if (_nameController.text.isEmpty || _selectedCivility == null || _selectedDate == null) {
    // Validation des champs obligatoires
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
    );
    return;
  }

  // Préparation des données sous forme de Map
  Map<String, dynamic> locataire = {
    'name': _nameController.text,
    'civility': _selectedCivility,
    'birthDate': _selectedDate?.toIso8601String(),
    'birthPlace': _birthPlaceController.text,
    'nationality': _selectedNationality,
    'email': _emailController.text,
    'phone': _phoneController.text,
    'idType': _selectedIDType,
    'idNumber': _idNumberController.text,
    'function': _selectedFunction,
    'pet': _selectedPet,
    'observation': _observationController.text,
    'profileImage': _selectedImage?.path, // Chemin de l'image du profil
    'idImage': _selectedImageId?.path, // Chemin de l'image de la pièce d'identité
  };

  try {
    // Appel à la méthode pour insérer les données dans la base de données
    final dbHelper = DBHelper(); // Instance de votre DatabaseHelper
  await dbHelper.insertLocataire(locataire);
    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Locataire enregistré avec succès.')),
    );

    // Réinitialiser les champs du formulaire
    setState(() {
      _nameController.clear();
      _birthPlaceController.clear();
      _emailController.clear();
      _phoneController.clear();
      _idNumberController.clear();
      _observationController.clear();
      _selectedDate = null;
      _selectedNationality = null;
      _selectedIDType = null;
      _selectedFunction = null;
      _selectedPet = null;
      _selectedCivility = null;
      _selectedImage = null;
      _selectedImageId = null;
    });

    // Retourner à l'écran précédent ou effectuer une autre action
    Navigator.pop(context);
  } catch (e) {
    // Gérer les erreurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un locataire', style: TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image placeholder
            Row(
              children: [
                Expanded(
                  flex: 1,
                child: GestureDetector(
                  onTap:
                      _pickImage, // Appelé lorsque l'utilisateur clique sur le conteneur
                  child: Container(
                    height: 120,
                    //width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(
                                  _selectedImage!), // Affiche l'image sélectionnée
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ?  const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey,
                          )
                        : null, // Affiche l'icône uniquement si aucune image n'est sélectionnée
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap:
                        _pickImageId, 
                    child: DottedBorder(
                      color: Colors.grey, 
                      strokeWidth: 1, 
                      dashPattern: const [6,3], 
                      borderType: BorderType.RRect, 
                      radius:
                          const Radius.circular(15), 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15), 
                        child: Container(
                          height: 100,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            image: _selectedImageId != null
                                ? DecorationImage(
                                    image: FileImage(_selectedImageId!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _selectedImageId == null
                              ? const Center(
                                  child: Text(
                                    'Cliquer ici pour ajouter \nla pièce d\'identification',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12,fontStyle: FontStyle.italic,),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Civility and Name Fields
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCivility,
                    decoration: const InputDecoration(
                      labelText: 'Civilité',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    items: ['Mr', 'Mme', 'Mlle'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCivility = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom et Prénoms',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date of Birth and Place of Birth Fields
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                            : 'Sélectionnez une date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _birthPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Lieu de naissance',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Nationality Selection
            DropdownButtonFormField<String>(
              value: _selectedNationality,
              decoration: const InputDecoration(
                labelText: 'Nationalité',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
              items: ['Ivoirienne','Burkinabé','Malienne','Nigériane','Nigérienne','Guinéene','Ghanéene','Togolaise','Libanaise','Mauritaniene','Française', 'Américaine', 'Canadienne', 'Autre'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedNationality = value;
                });
              },
            ),
            const SizedBox(height: 8),

            // Email and Phone Fields
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),

            // ID Type and Number Fields
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedIDType,
                    decoration: const InputDecoration(
                      labelText: 'Type de pièce',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    items: ['Carte d\'identité', 'Passeport', 'Permis de conduire']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedIDType = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _idNumberController,
                    decoration: const InputDecoration(
                      labelText: 'N° de Pièce',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Function and Pet Fields
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFunction,
                    decoration: const InputDecoration(
                      labelText: 'Fonction',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    items: ['Fonctionnaire', 'Indépendant', 'Étudiant', 'Autre'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFunction = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPet,
                    decoration: const InputDecoration(
                      labelText: 'Animal de compagnie',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    items: ['Aucun', 'Chien', 'Chat', 'Autre'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPet = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Observation Field
            TextFormField(
              controller: _observationController,
              decoration: const InputDecoration(
                labelText: 'Observation',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Buttons
            //const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveLocataire,
                  icon: const Icon(Icons.check),
                  label: const Text('Enregistrer'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Cancel logic
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
    );
  }
}
