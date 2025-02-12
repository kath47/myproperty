import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> _initDB() async {
    if (_database != null) return _database!;
    String dbpath = join(await getDatabasesPath(), 'gkimmobi.db');

    // await deleteDatabase(dbpath);
    // print('Old database deleted');

  _database = await openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Proprio (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    civility TEXT,
    nationality TEXT,
    phone TEXT,
    email TEXT,
    adresse TEXT,
    typepiece TEXT,
    numeropiece TEXT
  )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS profile (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT,
    phone TEXT,
    password TEXT
  )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS User (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    password TEXT NOT NULL
  )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS Locataire (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    civility TEXT,
    birthDate TEXT,
    birthPlace TEXT,
    nationality TEXT,
    email TEXT,
    phone TEXT,
    idType TEXT,
    idNumber TEXT,
    function TEXT,
    pet TEXT,
    observation TEXT,
    profileImage TEXT,
    idImage TEXT
  )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS Immeuble (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    adresse TEXT NOT NULL,
    nbAppartements INTEGER NOT NULL,
    proprietaireId INTEGER,
    FOREIGN KEY (proprietaireId) REFERENCES Proprio(id)
  )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS Property (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titre TEXT NOT NULL,
    type TEXT NOT NULL,
    ownerId INTEGER NOT NULL,
    numberOfRooms INTEGER NOT NULL,
    rentCost REAL NOT NULL,
    city TEXT NOT NULL,
    commune TEXT NOT NULL,
    quartier TEXT NOT NULL,
    status TEXT NOT NULL,
    description TEXT NOT NULL,
    images TEXT,
    FOREIGN KEY (ownerId) REFERENCES Proprio(id)
    )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Subscription (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        houseId TEXT NOT NULL,
        tenantId INTEGER NOT NULL,
        date TEXT NOT NULL,
        rentCost REAL NOT NULL,
        cautionMonths INTEGER NOT NULL,
        cautionAmount REAL NOT NULL,
        advanceMonths INTEGER NOT NULL,
        advanceAmount REAL NOT NULL,
        otherFeesLabel TEXT,
        otherFeesAmount REAL,
        entryDate TEXT NOT NULL,
        paymentStartDate TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (houseId) REFERENCES Property(id),
        FOREIGN KEY (tenantId) REFERENCES Locataire(id)
      )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS Payment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    locataireId INTEGER NOT NULL,
    propertiesId INTEGER NOT NULL,
    paymentDate TEXT NOT NULL,
    amountPaid REAL NOT NULL,
    amountDue REAL NOT NULL,
    month TEXT NOT NULL,
    year TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (locataireId) REFERENCES Locataire(id),
    FOREIGN KEY (propertiesId) REFERENCES Property(id)
    )

    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS expenses(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    subType TEXT,
    amount REAL,
    description TEXT,
    date TEXT
    )
    ''');

    },
  );
  return _database!;
}
  
// Les méthodes d'insertion et de recupération des proprio enregistrés

  Future<void> insertProprio(Map<String, dynamic> data) async {
    final db = await _initDB();
    await db.insert(
      'proprio', 
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getProperties() async {
    final db = await _initDB();
    return await db.query('Property');
  }

  Future<List<Property>> getAllProperties() async {
  final db = await _initDB(); 
  final List<Map<String, dynamic>> maps = await db.query('Property');
  return List.generate(maps.length, (i) {
    return Property(
      id: maps[i]['id'],
      titre: maps[i]['titre'],
      type: maps[i]['type'],
      ownerId: maps[i]['ownerId'],
      numberOfRooms: maps[i]['numberOfRooms'],
      rentCost: maps[i]['rentCost'],
      city: maps[i]['city'],
      commune: maps[i]['commune'],
      quartier: maps[i]['quartier'],
      status: maps[i]['status'],
      description: maps[i]['description'],
      images: (maps[i]['images']),
    );
  });
}

  Future<List<Proprio>> getProprietaires() async {
  final db = await _initDB(); // Assurez-vous que cette méthode initialise votre base de données.
  final List<Map<String, dynamic>> maps = await db.query('proprio');
  return List.generate(maps.length, (i) {
    return Proprio(
      id: maps[i]['id'],
      civility: maps[i]['civility'],
      name: maps[i]['name'],
      nationality: maps[i]['nationality'],
      phone: maps[i]['phone'],
      email: maps[i]['email'],
      adresse: maps[i]['adresse'],
      typepiece: maps[i]['typepiece'],
      numeropiece: maps[i]['numeropiece'],
    );
  });
}

  Future<List<Locataire>> getAllLocataires() async {
  final db = await _initDB(); 
  final List<Map<String, dynamic>> maps = await db.query('locataire');
  return List.generate(maps.length, (i) {
    return Locataire(
      id: maps[i]['id'],
      name: maps[i]['name'],
      civility: maps[i]['civility'],
      birthDate: maps[i]['birthDate'],
      birthPlace: maps[i]['birthPlace'],
      nationality: maps[i]['nationality'], 
      email: maps[i]['email'],
      phone: maps[i]['phone'],
      idType: maps[i]['idType'],
      idNumber: maps[i]['idNumber'],
      function: maps[i]['function'],
      pet: maps[i]['pet'],
      observation: maps[i]['observation'],
      profileImage: maps[i]['profileImage'],
      idImage: maps[i]['idImage'],
    );
  });
}


  Future<List<Proprio>> getProprios() async {
  final db = await _initDB();
  final List<Map<String, dynamic>> maps = await db.query('proprio');

  // Convertir la liste de Map en une liste de Proprio
  return List.generate(maps.length, (i) {
    return Proprio.fromMap(maps[i]);
  });
}


// Insertion d'un utilisateurs et récupération

  Future<void> insertOrUpdateUser(User user) async {
    final db = await _initDB();
    await db.insert('profile', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserProfile() async {
    final db = await _initDB();
    final List<Map<String, dynamic>> result = await db.query('profile');
    if (result.isNotEmpty) {
      return User(
        id: result.first['id'],
        name: result.first['name'],
        email: result.first['email'],
        phone: result.first['phone'],
        password: result.first['password'],
      );
    }
    return null;
  }

  Future<int> insertPayment(Payment payment) async {
    final db = await _initDB();
    return await db.insert('payment', payment.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Méthode de recherche d'un proprio

  Future<List<Map<String, dynamic>>> searchProperties(String query) async {
    final db = await _initDB();
    return await db.query(
      'Property',
      where: 'titre LIKE ? OR quartier LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
  }

  // Ajouter un locataire
Future<void> insertLocataire(Map<String, dynamic> locataire) async {
    final db = await _initDB();
    await db.insert('locataire', locataire, conflictAlgorithm: ConflictAlgorithm.replace);
  }



  Future<List<Map<String, dynamic>>> getLocataires() async {
  final db = await _initDB();
  final result = await db.query('locataire'); // Remplacez 'locataires' par le nom de votre table
  return result;
}
  
  // Récupérer tous les locataires
Future<List<Map<String, dynamic>>> getmaisons() async {
  try {
    final db = await _initDB();
    final List<Map<String, dynamic>> maps = await db.query('Property');
    return maps;
  } catch (e) {
    print('Erreur lors de la récupération des données : $e');
    return [];
  }
}
//// la table des dépenses
Future<int> insertExpense(Expense expense) async {
    final db = await _initDB();
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
  final db = await _initDB();
  final List<Map<String, dynamic>> maps = await db.query('expenses');
  return List.generate(maps.length, (i) {
    return Expense.fromMap(maps[i]);
  });
}

Future<int> deleteExpense(int id) async {
  final db = await _initDB();
  return await db.delete(
    'expenses',
    where: 'id = ?',
    whereArgs: [id],
  );
}
  

  // Méthode pour calculer la somme totale des dépenses
  Future<double> getTotalExpenses() async {
    final db = await _initDB();
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    print('Résultat de la requête : $result');
    final total = result.first['total'] as double?;
    return total ?? 0.0; // Retourne 0.0 si aucune dépense n'est trouvée
  }

  Future<bool> hasExpenses() async {
  final db = await _initDB();
  final result = await db.rawQuery('SELECT COUNT(*) as count FROM expenses');
  final count = result.first['count'] as int;
  return count > 0;
}


  //compter tous les locataires enregistré
  Future<int> countLocataires() async {
  final db = await _initDB(); 
  final countQuery = await db.rawQuery('SELECT COUNT(*) as total FROM locataire');
  return Sqflite.firstIntValue(countQuery) ?? 0;
}

  //compter tous les propriétaires enregistré
  Future<int> countProprietaires() async {
  final db = await _initDB(); 
  final countQuery = await db.rawQuery('SELECT COUNT(*) as total FROM proprio');
  return Sqflite.firstIntValue(countQuery) ?? 0;
}

  //compter tous les maisons enregistré
  Future<int> countProperty() async {
  final db = await _initDB(); 
  final countQuery = await db.rawQuery('SELECT COUNT(*) as total FROM Property');
  return Sqflite.firstIntValue(countQuery) ?? 0;
}

  //compter tous les location enregistré
  Future<int> countSouscription() async {
  final db = await _initDB(); 
  final countQuery = await db.rawQuery('SELECT COUNT(*) as total FROM subscription');
  return Sqflite.firstIntValue(countQuery) ?? 0;
}


  Future<void> deleteLocataire(int id) async {
    final db = await _initDB();
    await db.delete('locataire', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertImmeuble(Map<String, dynamic> immeuble) async {
    final db = await _initDB();
    return await db.insert('tableImmeuble',immeuble,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Immeuble>> getImmeubles() async {
  final db = await _initDB();
  final List<Map<String, dynamic>> maps = await db.query('tableImmeuble');

  return List.generate(maps.length, (i) {
    return Immeuble(
      id: maps[i]['id'],
      nom: maps[i]['nom'],
      adresse: maps[i]['adresse'],
      nbAppartements: maps[i]['nbAppartements'],
      proprietaireId: maps[i]['proprietaireId'],
    );
  });
}

Future<void> insertProperty(Map<String, dynamic> property) async {
  final db = await _initDB();
  await db.insert(
    'Property', 
    property,
    conflictAlgorithm: ConflictAlgorithm.replace, 
  );
}


 // Insert a new subscription
  Future<void> insertSubscription(Map<String, dynamic> subscription) async {
    final db = await _initDB();
    await db.insert('subscription', 
    subscription,
    conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<List<Map<String, dynamic>>> getSubscriptions() async {
    final db = await _initDB();
    return await db.query('subscription'); 
  }

  // Update a subscription
  Future<int> updateSubscription(Subscription subscription) async {
    final db = await _initDB();
    return await db.update(
      'subscription',
      subscription.toMap(),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  // Delete a subscription
  Future<int> deleteSubscription(int id) async {
    final db = await _initDB();
    return await db.delete(
      'subscription',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
Future<int> getCountProperties() async {
    final db = await _initDB();
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM Property'),
    );
    return count ?? 0;
  }


  // Supprime une propriété de la base de données
  Future<void> deleteProperty(int id) async {
    final db = await _initDB();
    try {
      await db.delete(
        'Property',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Propriété avec ID $id supprimée avec succès');
    } catch (e) {
      print('Erreur lors de la suppression de la propriété : $e');
      throw Exception('Erreur lors de la suppression de la propriété');
    }
  }



Future<int> deleteProprio(int id) async {
    final db = await _initDB();
    return await db.delete(
      'proprio',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Méthode pour récupérer le nombre total de locataires
  Future<int> getTotalLocataires() async {
    final db = await _initDB();
    final result = await db.rawQuery('SELECT COUNT(*) FROM locataire');
    await Future.delayed(const Duration(seconds: 2));
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Méthode pour récupérer le nombre total de maisons disponibles
  Future<int> getTotalMaisonsDisponibles() async {
    final db = await _initDB();
    final result = await db.rawQuery(
      "SELECT COUNT(*) FROM Property WHERE status = 'Disponible'",
    );
    await Future.delayed(const Duration(seconds: 2));
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Méthode pour récupérer le nombre total de maisons occupées
  Future<int> getTotalMaisonsOccupees() async {
    final db = await _initDB();
    final result = await db.rawQuery(
      "SELECT COUNT(*) FROM Property WHERE status = 'Occupée'",
    );
    await Future.delayed(const Duration(seconds: 2));
    return Sqflite.firstIntValue(result) ?? 0;
  }


// Méthode pour supprimer un paiement
  Future<int> deletePayment(int paymentId) async {
    final db = await _initDB();
    return await db.delete(
      'Payment',
      where: 'id = ?',
      whereArgs: [paymentId],
    );
  }

  // Méthode pour récupérer tous les paiements
  Future<List<Payment>> getAllPayments() async {
    final db = await _initDB();

    final result = await db.query('Payment'); // Récupère toutes les lignes de la table Payment

    return result.map((json) => Payment.fromMap(json)).toList();
  }



  // Méthode pour récupérer les paiements du mois en cours avec un statut "Payé"
Future<double> sumpaidofmonth() async {
  final db = await _initDB();

  // Obtenir le premier et le dernier jour du mois en cours
  final now = DateTime.now();
  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  // Requête pour calculer la somme des loyers payés ce mois-ci
  final result = await db.rawQuery('''
    SELECT SUM(amountPaid) as total 
    FROM payment 
    WHERE status = 'Payé' 
    AND paymentDate >= ? 
    AND paymentDate <= ?
  ''', [firstDayOfMonth.toIso8601String(), lastDayOfMonth.toIso8601String()]);
  print('Résultat de la requête sumpaidofmonth : $result'); // Log pour déboguer

  final total = result.first['total'] as double?;
  return total ?? 0.0;
}

// Méthode pour convertir le numéro du mois en nom de mois
// String _getMonthName(int month) {
//   const List<String> monthNames = [
//     "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
//     "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
//   ];

//   // Vérifier si le mois est valide (1 à 12)
//   if (month < 1 || month > 12) {
//     return ""; // Retourner une chaîne vide pour un mois invalide
//   }

//   return monthNames[month - 1]; // Accéder au nom du mois (index 0 pour Janvier)
// }


Future<String?> getTenantNameById(int tenantId) async {
  final db = await _initDB();

  // Requête SQL pour récupérer le nom du locataire en fonction de tenantId
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT Locataire.name AS tenantName
    FROM Subscription
    INNER JOIN Locataire ON Subscription.tenantId = Locataire.id
    WHERE Subscription.tenantId = ?
  ''', [tenantId]);

  // Retourner le nom s'il existe, sinon null
  if (result.isNotEmpty) {
    return result.first['tenantName'] as String?;
  }
  return null;
}

Future<String?> getHouseNameById(int houseId) async {
  final db = await _initDB();

  // Requête SQL pour récupérer le nom du locataire en fonction de tenantId
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT Property.titre AS houseName
    FROM Subscription
    INNER JOIN Property ON Subscription.houseId = Property.id
    WHERE Subscription.houseId = ?
  ''', [houseId]);

  // Retourner le nom s'il existe, sinon null
  if (result.isNotEmpty) {
    return result.first['houseName'] as String?;
  }
  return null;
}


Future<String> getPropertyTitleById(int propertiesId) async {
    final db = await _initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'Property',
      columns: ['titre'],
      where: 'id = ?',
      whereArgs: [propertiesId],
    );

    if (maps.isNotEmpty) {
      return maps.first['titre'];
    } else {
      throw Exception('Property not found');
    }
  }

  Future<List<Payment>> getAllPaymentsWithPropertyTitle() async {
    final db = await _initDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT Payment.*, Property.titre as propertyTitle
      FROM Payment
      INNER JOIN Property ON Payment.propertiesId = Property.id
    ''');

    return List.generate(maps.length, (i) {
      return Payment(
        id: maps[i]['id'],
        locataireId: maps[i]['locataireId'],
        propertiesId: maps[i]['propertiesId'],
        paymentDate: maps[i]['paymentDate'],
        amountPaid: maps[i]['amountPaid'],
        amountDue: maps[i]['amountDue'],
        month: maps[i]['month'],
        year: maps[i]['year'],
        status: maps[i]['status'],
      );
    });
  }

}


