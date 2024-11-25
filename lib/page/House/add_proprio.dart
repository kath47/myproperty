import 'package:flutter/material.dart';
import '../../Settings/colors.dart';
import '../../data/db_helper.dart';

class ProprioPage extends StatefulWidget {
  final VoidCallback onSave;

  const ProprioPage({super.key, required this.onSave});

  @override
  _ProprioPageState createState() => _ProprioPageState();
}

class _ProprioPageState extends State<ProprioPage> {
  final dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController civilityController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController typepieceController = TextEditingController();
  final TextEditingController numeropieceController = TextEditingController();

  // Selected values for dropdowns
  String? civility = 'Mr';
  String? nationality = 'Ivoirienne';
  String? typepiece = 'Carte CNI';

  void saveProperty() async {
    if (_formKey.currentState!.validate()) {
      await dbHelper.insertProprio({
        'civility': civilityController.text,
        'name': nameController.text,
        'nationality': nationalityController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'adresse': adresseController.text,
        'typepiece': typepieceController.text,
        'numeropiece': numeropieceController.text,
      });
      widget.onSave();
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    const fieldPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fiche du propriétaire',
          style: TextStyle(color: tWhiteColor),
        ),
        backgroundColor: tPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image placeholder
              Container(
                height: 100,
                width: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              // Civility, Name, and Nationality Row
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: civility,
                      decoration: const InputDecoration(
                        labelText: 'Civilité',
                        border: OutlineInputBorder(),
                        contentPadding: fieldPadding,
                      ),
                      items: ['Mr', 'Ms', 'Mme'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          civility = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom et Prénoms',
                        border: OutlineInputBorder(),
                        contentPadding: fieldPadding,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nom et Prénoms requis';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Nationality Dropdown
              DropdownButtonFormField<String>(
                value: nationality,
                decoration: const InputDecoration(
                  labelText: 'Nationalité',
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                items: [
                  'Ivoirienne',
                  'Burkinabé',
                  'Malienne',
                  'Guinéene',
                  'Nigériane',
                  'Ghanéene'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    nationality = value;
                  });
                },
              ),
              const SizedBox(height: 8),

              // Phone, Email, Address Fields
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Numéro de téléphone requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-mail requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
              ),
              const SizedBox(height: 8),

              // ID Type and Number Fields
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: typepiece,
                      decoration: const InputDecoration(
                        labelText: 'Type pièce',
                        border: OutlineInputBorder(),
                        contentPadding: fieldPadding,
                      ),
                      items: ['Carte CNI', 'Attestation', 'Autres'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          typepiece = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: numeropieceController,
                      decoration: const InputDecoration(
                        labelText: 'N° de pièce',
                        border: OutlineInputBorder(),
                        contentPadding: fieldPadding,
                      ),
                    ),
                  ),
                ],
              ),
              // Buttons
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: saveProperty,
                    icon: const Icon(Icons.check, color: tWhiteColor),
                    label: const Text('Enregistrer', style: TextStyle(color: tWhiteColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
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
      ),
    );
  }

}
