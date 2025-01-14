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
      'name': name,
      'civility': civility,
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
      name: map['name'],
      civility: map['civility'],
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'nbAppartements': nbAppartements,
      'proprietaireId': proprietaireId,
    };
  }

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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}

class Locataire {
  final int id;
  final String name;
  final String? civility;
  final String? birthDate;
  final String? birthPlace;
  final String? nationality;
  final String? email;
  final String? phone;
  final String? idType;
  final String? idNumber;
  final String? function;
  final String? pet;
  final String? observation;
  final String? profileImage;
  final String? idImage;

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
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Inconnu',
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
  final String? images;

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
      'images': images,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? 0,
      titre: map['titre'] ?? '',
      type: map['type'] ?? '',
      ownerId: map['ownerId'] ?? 0,
      numberOfRooms: map['numberOfRooms'] ?? 0,
      rentCost: map['rentCost'] ?? 0.0,
      city: map['city'] ?? '',
      commune: map['commune'] ?? '',
      quartier: map['quartier'] ?? '',
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      images: map['images'],
    );
  }
}

class Subscription {
  final int id;
  final String houseId;
  final String tenantId;
  final String date;
  final double rentCost;
  final int cautionMonths;
  final double cautionAmount;
  final int advanceMonths;
  final double advanceAmount;
  final String otherFeesLabel;
  final double otherFeesAmount;
  final String entryDate;
  final String paymentStartDate;
  final String status;

  Subscription({
    required this.id,
    required this.houseId,
    required this.tenantId,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'houseId': houseId,
      'tenantName': tenantId,
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

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      houseId: map['houseId'],
      tenantId: map['tenantId'],
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
  final int? id;
  final int locataireId;
  final int propertiesId;
  final DateTime paymentDate;
  final double amountPaid;
  final double amountDue;
  final String month;
  final String year;
  final String status;

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

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      locataireId: map['locataireId'],
      propertiesId: map['propertiesId'],
      paymentDate: DateTime.parse(map['paymentDate']),
      amountPaid: map['amountPaid'],
      amountDue: map['amountDue'],
      month: map['month'],
      year: map['year'],
      status: map['status'],
    );
  }
  
}

class Expense {
  final int? id;
  final String? type;
  final String? subType;
  final double amount;
  final String? description;
  final DateTime date;

  Expense({
    this.id,
    required this.type,
    required this.subType,
    required this.amount,
    required this.description,
    required this.date,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'subType': subType,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      type: map['type'],
      subType:map['subType'],
      amount: map['amount'],
      description: map ['description'],
      date: DateTime.parse(map['date']),
    );
  }
}