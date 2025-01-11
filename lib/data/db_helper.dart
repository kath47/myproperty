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
        CREATE TABLE IF NOT EXISTS proprio (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
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
          CREATE TABLE IF NOT EXISTS locataire (
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

        db.execute('''
          CREATE TABLE IF NOT EXISTS tableImmeuble (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            adresse TEXT NOT NULL,
            nbAppartements INTEGER NOT NULL,
            proprioId INTEGER NOT NULL,
            FOREIGN KEY (proprioId) REFERENCES proprio(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS properties (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT,
            type TEXT,
            proprioId INTEGER,
            numberOfRooms INTEGER,
            rentCost REAL,
            city TEXT,
            commune TEXT,
            quartier TEXT,
            status TEXT,
            description TEXT,
            images TEXT,
            FOREIGN KEY (proprioId) REFERENCES proprio(id)
          );
        ''');

        await db.execute('''
      CREATE TABLE IF NOT EXISTS subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        houseId TEXT NOT NULL,
        tenantId TEXT NOT NULL,
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
        FOREIGN KEY (houseId) REFERENCES proprietaires(id)
        FOREIGN KEY (tenantId) REFERENCES locataire(id)
      )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS payment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    locataireId INTEGER NOT NULL,
    propertiesId INTEGER NOT NULL,
    paymentDate TEXT NOT NULL,
    amountPaid REAL NOT NULL,
    amountDue REAL NOT NULL,
    month TEXT NOT NULL,
    year TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (locataireId) REFERENCES locataire(id),
    FOREIGN KEY (propertiesId) REFERENCES Properties(id)
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
    return await db.query('properties');
  }

  Future<List<Property>> getAllProperties() async {
  final db = await _initDB(); 
  final List<Map<String, dynamic>> maps = await db.query('properties');
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
      'proprio',
      where: 'name LIKE ? OR adresse LIKE ?',
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
    final List<Map<String, dynamic>> maps = await db.query('properties');
    return maps;
  } catch (e) {
    print('Erreur lors de la récupération des données : $e');
    return [];
  }
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
  final countQuery = await db.rawQuery('SELECT COUNT(*) as total FROM properties');
  return Sqflite.firstIntValue(countQuery) ?? 0;
}

  //compter tous les location enregistré
  Future<int> countSouscription() async {
  final db = await _initDB(); 
  final countQuery = await db.rawQuery('SELECT COUNT(*) as total FROM souscription');
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
    'properties', 
    property,
    conflictAlgorithm: ConflictAlgorithm.replace, 
  );
}


 // Insert a new subscription
  Future<void> insertSubscription(Map<String, dynamic> subscription) async {
    final db = await _initDB();
    await db.insert('subscriptions', 
    subscription,
    conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all subscriptions
  // Future<List<Subscription>> getSubscriptions() async {
  //   final db = await _initDB();
  //   final List<Map<String, dynamic>> maps = await db.query('subscriptions');
  //   return List.generate(maps.length, (i) => Subscription.fromMap(maps[i]));
  // }

  Future<List<Map<String, dynamic>>> getSubscriptions() async {
    final db = await _initDB();
    return await db.query('subscriptions'); 
  }

  // Update a subscription
  Future<int> updateSubscription(Subscription subscription) async {
    final db = await _initDB();
    return await db.update(
      'subscriptions',
      subscription.toMap(),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  // Delete a subscription
  Future<int> deleteSubscription(int id) async {
    final db = await _initDB();
    return await db.delete(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
Future<int> getCountProperties() async {
    final db = await _initDB();
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM properties'),
    );
    return count ?? 0;
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
      "SELECT COUNT(*) FROM properties WHERE status = 'disponible'",
    );
    await Future.delayed(const Duration(seconds: 2));
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Méthode pour récupérer le nombre total de maisons occupées
  Future<int> getTotalMaisonsOccupees() async {
    final db = await _initDB();
    final result = await db.rawQuery(
      "SELECT COUNT(*) FROM properties WHERE status = 'occupée'",
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

    // Obtenir le mois et l'année actuels
    final now = DateTime.now();
    final currentMonth = _getMonthName(now.month); // Convertir le mois en nom (ex: "Octobre")
    final currentYear = now.year;

    // Requête SQL pour récupérer les paiements du mois en cours avec un statut "Payé"
    final result = await db.rawQuery('''
      SELECT SUM(amountPaid) as total
      FROM payments
      WHERE month = ? AND year = ? AND status = ?
    ''', [currentMonth, currentYear, "Payé"]);

    // Récupérer la somme totale
    final totalSum = result.first['total'] as double? ?? 0.0;

    return totalSum;
  }

  // Méthode pour convertir le numéro du mois en nom de mois
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "Janvier";
      case 2:
        return "Février";
      case 3:
        return "Mars";
      case 4:
        return "Avril";
      case 5:
        return "Mai";
      case 6:
        return "Juin";
      case 7:
        return "Juillet";
      case 8:
        return "Août";
      case 9:
        return "Septembre";
      case 10:
        return "Octobre";
      case 11:
        return "Novembre";
      case 12:
        return "Décembre";
      default:
        return "";
    }
  }


}


