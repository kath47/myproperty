

class Proprio {
  final int id;
  final String name;
  final String civility;
  final String nationality;
  final String phone;
  final String email;
  final String adresse;
  final String typepiece;
  final String numeropiece;

  Proprio({
    required this.id, 
    required this.name, 
    required this.civility, 
    required this.nationality, 
    required this.phone,
    required this.email,
    required this.adresse,
    required this.typepiece,
    required this.numeropiece,
    });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'civility': civility,
      'name': name,
      'nationality': nationality,
      'phone': phone,
      'email': email,
      'adresse': adresse,
      'typepiece': typepiece,
      'numeropiece': numeropiece,
    };
  }

  factory Proprio.fromMap(Map<String, dynamic> map) {
    return Proprio(
      id: map['id'],
      civility: map['civility'],
      name: map['name'],
      nationality: map['nationality'],
      phone: map['phone'],
      email: map['email'],
      adresse: map['adresse'],
      typepiece: map['typepiece'],
      numeropiece: map['numeropiece'],
    );
  }
}

class Immeuble {
  final int id;
  final String nom;
  final String adresse;
  final int nbAppartements;
  final int proprietaireId;

  Immeuble({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.nbAppartements,
    required this.proprietaireId,
  });

  // Méthode pour convertir un objet Immeuble en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'nbAppartements': nbAppartements,
      'proprietaireId': proprietaireId,
    };
  }

  // Méthode pour créer un objet Immeuble à partir d'un Map
  factory Immeuble.fromMap(Map<String, dynamic> map) {
    return Immeuble(
      id: map['id'],
      nom: map['nom'],
      adresse: map['adresse'],
      nbAppartements: map['nbAppartements'],
      proprietaireId: map['proprietaireId'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;

  User({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.phone, 
    required this.password,
    });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

class Locataire {
  final int id;
  final String name;
  final String? civility;
  final String? birthDate;
  final String? birthPlace;
  final String? nationality;
  final String? email; // Rendre nullable
  final String? phone; // Rendre nullable
  final String? idType;
  final String? idNumber; // Rendre nullable
  final String? function;
  final String? pet;
  final String? observation;
  final String? profileImage; // Rendre nullable
  final String? idImage; // Rendre nullable

  Locataire({
    required this.id,
    required this.name,
    this.civility,
    this.birthDate,
    this.birthPlace,
    this.nationality,
    this.email,
    this.phone,
    this.idType,
    this.idNumber,
    this.function,
    this.pet,
    this.observation,
    this.profileImage,
    this.idImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'civility': civility,
      'birthDate': birthDate,
      'birthPlace': birthPlace,
      'nationality': nationality,
      'email': email,
      'phone': phone,
      'idType': idType,
      'idNumber': idNumber,
      'function': function,
      'pet': pet,
      'observation': observation,
      'profileImage': profileImage,
      'idImage': idImage,
    };
  }

  factory Locataire.fromMap(Map<String, dynamic> map) {
    return Locataire(
      id: map['id'] ?? 0, // Valeur par défaut si null
      name: map['name'] ?? 'Inconnu', // Valeur par défaut si null
      civility: map['civility'],
      birthDate: map['birthDate'],
      birthPlace: map['birthPlace'],
      nationality: map['nationality'],
      email: map['email'],
      phone: map['phone'],
      idType: map['idType'],
      idNumber: map['idNumber'],
      function: map['function'],
      pet: map['pet'],
      observation: map['observation'],
      profileImage: map['profileImage'],
      idImage: map['idImage'],
    );
  }
}

class Property {
  final int id;
  final String titre;
  final String type;
  final int ownerId;
  final int numberOfRooms;
  final double rentCost;
  final String city;
  final String commune;
  final String quartier;
  final String status;
  final String description;
  final List<String>? images;

  Property({
    required this.id,
    required this.titre,
    required this.type,
    required this.ownerId,
    required this.numberOfRooms,
    required this.rentCost,
    required this.city,
    required this.commune,
    required this.quartier,
    required this.status,
    required this.description,
      this.images,
  });

  // Convert object to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'type': type,
      'ownerId': ownerId,
      'numberOfRooms': numberOfRooms,
      'rentCost': rentCost,
      'city': city,
      'commune': commune,
      'quartier': quartier,
      'status': status,
      'description': description,
      'images': images?.join(','), 
    };
  }

// Convert Map to object
factory Property.fromMap(Map<String, dynamic> map) {
  return Property(
    id: map['id'],
    titre: map['titre'],
    type: map['type'],
    ownerId: map['ownerId'],
    numberOfRooms: map['numberOfRooms'],
    rentCost: map['rentCost'],
    city: map['city'],
    commune: map['commune'],
    quartier: map['quartier'],
    status: map['status'],
    description: map['description'],
    images: map['images'] != null && map['images'].isNotEmpty
        ? (map['images'] as String).split(',')
        : [], 
  );
}
}

class Subscription {
  int id;
  String houseId;
  String tenantName;
  String date;
  double rentCost;
  int cautionMonths;
  double cautionAmount;
  int advanceMonths;
  double advanceAmount;
  String otherFeesLabel;
  double otherFeesAmount;
  String entryDate;
  String paymentStartDate;
  String status;

  Subscription({
    required this.id,
    required this.houseId,
    required this.tenantName,
    required this.date,
    required this.rentCost,
    required this.cautionMonths,
    required this.cautionAmount,
    required this.advanceMonths,
    required this.advanceAmount,
    required this.otherFeesLabel,
    required this.otherFeesAmount,
    required this.entryDate,
    required this.paymentStartDate,
    required this.status,
  });

  // Convert a Subscription object to a Map for saving to SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'houseId': houseId,
      'tenantName': tenantName,
      'date': date,
      'rentCost': rentCost,
      'cautionMonths': cautionMonths,
      'cautionAmount': cautionAmount,
      'advanceMonths': advanceMonths,
      'advanceAmount': advanceAmount,
      'otherFeesLabel': otherFeesLabel,
      'otherFeesAmount': otherFeesAmount,
      'entryDate': entryDate,
      'paymentStartDate': paymentStartDate,
      'status': status,
    };
  }

  // Create a Subscription object from a Map (retrieved from SQLite)
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      houseId: map['houseId'],
      tenantName: map['tenantName'],
      date: map['date'],
      rentCost: map['rentCost'],
      cautionMonths: map['cautionMonths'],
      cautionAmount: map['cautionAmount'],
      advanceMonths: map['advanceMonths'],
      advanceAmount: map['advanceAmount'],
      otherFeesLabel: map['otherFeesLabel'],
      otherFeesAmount: map['otherFeesAmount'],
      entryDate: map['entryDate'],
      paymentStartDate: map['paymentStartDate'],
      status: map['status'],
    );
  }
}

class Payment {
  int? id;
  int locataireId;
  int propertiesId;
  DateTime paymentDate;
  double amountPaid;
  double amountDue;
  String month;
  String year;
  String status;

  Payment({
    this.id,
    required this.locataireId,
    required this.propertiesId,
    required this.paymentDate,
    required this.amountPaid,
    required this.amountDue,
    required this.month,
    required this.year,
    required this.status,
  });

  // Transforme une Map en objet Payment
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int?,
      locataireId: map['locataireId'] as int,
      propertiesId: map['propertiesId'] as int,
      paymentDate: DateTime.parse(map['paymentDate'] as String),
      amountPaid: map['amountPaid'] as double,
      amountDue: map['amountDue'] as double,
      month: map['month'] as String,
      year: map['year'] as String,
      status: map['status'] as String,
    );
  }

  // Transforme un objet Payment en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locataireId': locataireId,
      'propertiesId': propertiesId,
      'paymentDate': paymentDate.toIso8601String(),
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'month': month,
      'year': year,
      'status': status,
    };
  }
}







