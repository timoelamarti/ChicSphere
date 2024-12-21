# ChicSphere

ChicSphere est une application Flutter permettant de gérer un inventaire de vêtements, incluant des fonctionnalités telles que l'ajout d'articles, la gestion d'un panier, et l'affichage détaillé des vêtements. Elle propose également un système d'authentification via Firebase, permettant aux utilisateurs de se connecter et de gérer leur profil.

---
![image](https://github.com/user-attachments/assets/6bd755ed-694a-45c0-98b5-53873fd0faa4)

## Fonctionnalités Principales
Comptes de Test

Deux comptes utilisateurs sont configurés pour tester l'application :

Email : hatim1.elamarti@gmail.com | Mot de passe : TIMO1234

Email : prof@gmail.com | Mot de passe : Prof123

### 1. **Authentification Firebase**
- Connexion des utilisateurs via Firebase Authentication.
- Gestion de session utilisateur.
- Redirection vers la page de connexion si l'utilisateur n'est pas authentifié.

### 2. **Gestion des Vêtements**
- Ajout d'articles avec des attributs tels que :
  - Image
  - Titre
  - Taille
  - Marque
  - Catégorie
  - Prix
- Détection automatique de la catégorie via un modèle d'IA TensorFlow Lite (TFLite).

### 3. **Panier d'Achat**
- Ajout d'articles au panier depuis la page d'accueil ou la page de détail.
- Affichage des articles dans le panier avec les attributs suivants :
  - Image
  - Titre
  - Taille
  - Prix
- Calcul et affichage du total général.
- Suppression d'articles du panier.

### 4. **Profil Utilisateur**
- Affichage et modification des informations personnelles :
  - Email (lecture seule)
  - Mot de passe (modifiable)
  - Anniversaire
  - Adresse
  - Code postal
  - Ville
- Déconnexion depuis la page profil.

---

## Technologies Utilisées

### Frameworks et Langages
- **Flutter** : Framework principal pour la création de l'application mobile.
- **Dart** : Langage de programmation pour Flutter.

### Backend
- **Firebase Authentication** : Pour l'authentification des utilisateurs.
- **Firebase Firestore** : Pour le stockage des données utilisateur et articles.

### Intelligence Artificielle
- **TensorFlow Lite** : Modèle de classification des vêtements basé sur Fashion MNIST, permettant de détecter automatiquement la catégorie d'un article via son image.

---

## Configuration du Projet

### Prérequis
- Flutter SDK installé
- Compte Firebase configuré
- Visual Studio Code ou un IDE compatible Flutter

### Étapes d'Installation
1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/your-repo/chic_sphere.git
   ```
2. Accédez au répertoire du projet :
   ```bash
   cd chic_sphere
   ```
3. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```
4. Configurez Firebase :
   - Créez un projet Firebase.
   - Ajoutez les fichiers `google-services.json` (Android) et `GoogleService-Info.plist` (iOS) dans les dossiers appropriés.
   - Activez Authentication et Firestore.
5. Lancez l'application :
   ```bash
   flutter run
   ```

---

## Architecture du Projet

### Organisation des Fichiers

```
lib/
|-- main.dart                  # Point d'entrée principal
|-- screens/
|   |-- home_screen.dart       # Liste des vêtements
|   |-- add_item_screen.dart   # Ajout d'un vêtement
|   |-- cart_screen.dart       # Gestion du panier
|   |-- profile_screen.dart    # Profil utilisateur
|   |-- detail_screen.dart     # Détails d'un vêtement
|
|-- services/
|   |-- ai_service.dart        # Gestion du modèle IA
|   |-- cart_service.dart      # Gestion du panier
|
|-- firebase_options.dart      # Configuration Firebase
```

---

## Fonctionnement des Écrans

### **1. HomeScreen**
- Liste les articles disponibles avec les attributs minimaux (image, titre, taille, prix).
- Navigation vers l'écran de détail ou ajout au panier.

### **2. DetailScreen**
- Affiche tous les détails d'un vêtement.
- Permet d'ajouter l'article au panier.

### **3. CartScreen**
- Liste les articles du panier.
- Affiche le total général.
- Permet de supprimer des articles.

### **4. ProfileScreen**
- Affiche et permet de modifier les informations utilisateur.
- Permet la déconnexion.

### **5. AddItemScreen**
- Permet d'ajouter un nouvel article avec détection automatique de catégorie via l'IA.

---

## Modèle d'IA

### Formation du Modèle
1. Basé sur **Fashion MNIST** avec les 10 catégories suivantes :
   - T-shirt/haut
   - Pantalon
   - Pull
   - Robe
   - Manteau
   - Sandale
   - Chemise
   - Basket
   - Sac
   - Bottes

2. Le modèle est exporté au format TFLite pour être utilisé dans l'application Flutter.

---

## Améliorations Futures
- Intégration d'un système de recherche pour les vêtements.
- Fonctionnalité d'inscription utilisateur.
- Paiement en ligne pour les articles du panier.
- Intégration d'un système de gestion des stocks.

---

## Auteurs
- **Nom** : Hatim El Amarti
- **Email** : hatim1.elamarti@gmail.com

