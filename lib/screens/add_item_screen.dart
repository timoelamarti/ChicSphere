import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite/tflite.dart';
import 'package:chic_sphere/services/ai_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  String _detectedCategory = "Unknown";

  @override
  void initState() {
    super.initState();
    AIService.loadModel(); // Charger le modèle au démarrage
  }

  /// Fonction pour sélectionner et traiter une image
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File image = File(pickedFile.path);

        // Redimensionner l'image
        image = _resizeImage(image);

        // Classifier l'image
        String category = await AIService.classifyImage(image.path);

        // Mettre à jour l'état
        setState(() {
          _selectedImage = image;
          _detectedCategory = category;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image sélectionnée et analysée avec succès !")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Aucune image sélectionnée.")),
        );
      }
    } catch (e) {
      print("Erreur lors de la sélection ou du traitement de l'image : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la sélection de l'image.")),
      );
    }
  }

  /// Fonction pour redimensionner une image
  File _resizeImage(File imageFile) {
    try {
      final image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) throw Exception("Impossible de décoder l'image.");

      final resized = img.copyResize(image, width: 224, height: 224);
      return File(imageFile.path)..writeAsBytesSync(img.encodeJpg(resized));
    } catch (e) {
      print("Erreur lors du redimensionnement de l'image : $e");
      rethrow;
    }
  }

  /// Fonction pour ajouter un vêtement dans Firestore
  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('clothingItems').add({
          'title': _titleController.text,
          'category': _detectedCategory,
          'size': _sizeController.text,
          'brand': _brandController.text,
          'price': double.parse(_priceController.text),
          'imageUrl': '', // Remplacez par la logique de téléchargement d'image
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vêtement ajouté avec succès !")),
        );

        // Réinitialiser le formulaire
        _formKey.currentState!.reset();
        setState(() {
          _selectedImage = null;
          _detectedCategory = "Unknown";
        });
      } catch (e) {
        print("Erreur lors de l'ajout : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'ajout du vêtement.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un vêtement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titre
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
              ),
              const SizedBox(height: 16),

              // Taille
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Taille'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une taille' : null,
              ),
              const SizedBox(height: 16),

              // Marque
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marque'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une marque' : null,
              ),
              const SizedBox(height: 16),

              // Prix
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Veuillez entrer un prix';
                  if (double.tryParse(value) == null) return 'Entrez un prix valide';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bouton pour sélectionner une image
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Sélectionner une image'),
              ),
              const SizedBox(height: 16),

              // Image sélectionnée et catégorie détectée
              if (_selectedImage != null)
                Column(
                  children: [
                    Image.file(_selectedImage!, width: 150, height: 150),
                    Text('Catégorie détectée : $_detectedCategory'),
                  ],
                ),
              const SizedBox(height: 20),

              // Bouton pour valider l'ajout
              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    _titleController.dispose();
    _sizeController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
