<?php
header("Content-Type: application/json");

$host = 'localhost';
$db = 'GestionLocation';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(["error" => "Database connection failed: " . $e->getMessage()]));
}

function respond($data, $status = 200) {
    http_response_code($status);
    echo json_encode($data);
    exit;
}

$requestMethod = $_SERVER['REQUEST_METHOD'];
$endpoint = isset($_GET['endpoint']) ? $_GET['endpoint'] : '';

if ($requestMethod === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    switch ($endpoint) {
        case 'create_utilisateur':
            createUtilisateur($pdo, $input);
            break;
        case 'create_propriete':
            createPropriete($pdo, $input);
            break;
        case 'create_locataire':
            createLocataire($pdo, $input);
            break;
        case 'create_contrat':
            createContrat($pdo, $input);
            break;
        case 'create_paiement':
            createPaiement($pdo, $input);
            break;
        case 'update_utilisateur':
            updateUtilisateur($pdo, $input);
            break;
        case 'update_propriete':
            updatePropriete($pdo, $input);
            break;
        case 'update_locataire':
            updateLocataire($pdo, $input);
            break;
        case 'update_contrat':
            updateContrat($pdo, $input);
            break;
        case 'update_paiement':
            updatePaiement($pdo, $input);
            break;
        default:
            respond(["error" => "Endpoint not found"], 404);
    }
} else {
    respond(["error" => "Invalid request method"], 405);
}

function createUtilisateur($pdo, $input) {
    $query = "INSERT INTO Utilisateurs (nom, email, mot_de_passe, role) VALUES (:nom, :email, :mot_de_passe, :role)";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':nom' => $input['nom'],
        ':email' => $input['email'],
        ':mot_de_passe' => password_hash($input['mot_de_passe'], PASSWORD_DEFAULT),
        ':role' => $input['role'] ?? 'proprietaire'
    ]);

    respond(["message" => "Utilisateur créé avec succès"]);
}

function createPropriete($pdo, $input) {
    $query = "INSERT INTO Proprietes (nom, adresse, ville, code_postal, categorie, prix_loyer, description, utilisateur_id) 
            VALUES (:nom, :adresse, :ville, :code_postal, :categorie, :prix_loyer, :description, :utilisateur_id)";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':nom' => $input['nom'],
        ':adresse' => $input['adresse'],
        ':ville' => $input['ville'],
        ':code_postal' => $input['code_postal'],
        ':categorie' => $input['categorie'] ?? 'appartement',
        ':prix_loyer' => $input['prix_loyer'],
        ':description' => $input['description'] ?? '',
        ':utilisateur_id' => $input['utilisateur_id']
    ]);

    respond(["message" => "Propriété créée avec succès"]);
}

function createLocataire($pdo, $input) {
    $query = "INSERT INTO Locataires (nom, email, telephone, adresse) VALUES (:nom, :email, :telephone, :adresse)";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':nom' => $input['nom'],
        ':email' => $input['email'],
        ':telephone' => $input['telephone'] ?? '',
        ':adresse' => $input['adresse'] ?? ''
    ]);

    respond(["message" => "Locataire créé avec succès"]);
}

function createContrat($pdo, $input) {
    $query = "INSERT INTO Contrats (propriete_id, locataire_id, date_debut, date_fin, loyer_mensuel, status) 
              VALUES (:propriete_id, :locataire_id, :date_debut, :date_fin, :loyer_mensuel, :status)";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':propriete_id' => $input['propriete_id'],
        ':locataire_id' => $input['locataire_id'],
        ':date_debut' => $input['date_debut'],
        ':date_fin' => $input['date_fin'] ?? null,
        ':loyer_mensuel' => $input['loyer_mensuel'],
        ':status' => $input['status'] ?? 'actif'
    ]);

    respond(["message" => "Contrat créé avec succès"]);
}

function createPaiement($pdo, $input) {
    $query = "INSERT INTO Paiements (contrat_id, date_paiement, montant, moyen_paiement, note) 
              VALUES (:contrat_id, :date_paiement, :montant, :moyen_paiement, :note)";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':contrat_id' => $input['contrat_id'],
        ':date_paiement' => $input['date_paiement'],
        ':montant' => $input['montant'],
        ':moyen_paiement' => $input['moyen_paiement'] ?? 'virement',
        ':note' => $input['note'] ?? ''
    ]);

    respond(["message" => "Paiement enregistré avec succès"]);
}

function updateUtilisateur($pdo, $input) {
    $query = "UPDATE Utilisateurs SET nom = :nom, email = :email, role = :role WHERE utilisateur_id = :id";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':nom' => $input['nom'],
        ':email' => $input['email'],
        ':role' => $input['role'],
        ':id' => $input['id']
    ]);

    respond(["message" => "Utilisateur mis à jour avec succès"]);
}

function updatePropriete($pdo, $input) {
    $query = "UPDATE Proprietes SET nom = :nom, adresse = :adresse, ville = :ville, code_postal = :code_postal, categorie = :categorie, prix_loyer = :prix_loyer, description = :description WHERE propriete_id = :id";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':nom' => $input['nom'],
        ':adresse' => $input['adresse'],
        ':ville' => $input['ville'],
        ':code_postal' => $input['code_postal'],
        ':categorie' => $input['categorie'],
        ':prix_loyer' => $input['prix_loyer'],
        ':description' => $input['description'],
        ':id' => $input['id']
    ]);

    respond(["message" => "Propriété mise à jour avec succès"]);
}

function updateLocataire($pdo, $input) {
    $query = "UPDATE Locataires SET nom = :nom, email = :email, telephone = :telephone, adresse = :adresse WHERE locataire_id = :id";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':nom' => $input['nom'],
        ':email' => $input['email'],
        ':telephone' => $input['telephone'],
        ':adresse' => $input['adresse'],
        ':id' => $input['id']
    ]);

    respond(["message" => "Locataire mis à jour avec succès"]);
}

function updateContrat($pdo, $input) {
    $query = "UPDATE Contrats SET propriete_id = :propriete_id, locataire_id = :locataire_id, date_debut = :date_debut, date_fin = :date_fin, loyer_mensuel = :loyer_mensuel, status = :status WHERE contrat_id = :id";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':propriete_id' => $input['propriete_id'],
        ':locataire_id' => $input['locataire_id'],
        ':date_debut' => $input['date_debut'],
        ':date_fin' => $input['date_fin'],
        ':loyer_mensuel' => $input['loyer_mensuel'],
        ':status' => $input['status'],
        ':id' => $input['id']
    ]);

    respond(["message" => "Contrat mis à jour avec succès"]);
}

function updatePaiement($pdo, $input) {
    $query = "UPDATE Paiements SET contrat_id = :contrat_id, date_paiement = :date_paiement, montant = :montant, moyen_paiement = :moyen_paiement, note = :note WHERE paiement_id = :id";
    $stmt = $pdo->prepare($query);

    $stmt->execute([
        ':contrat_id' => $input['contrat_id'],
        ':date_paiement' => $input['date_paiement'],
        ':montant' => $input['montant'],
        ':moyen_paiement' => $input['moyen_paiement'],
        ':note' => $input['note'],
        ':id' => $input['id']
    ]);

    respond(["message" => "Paiement mis à jour avec succès"]);
}
?>
