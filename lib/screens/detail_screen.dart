import 'package:flutter/material.dart';
import 'package:chic_sphere/services/cart_service.dart'; // Importez le service du panier

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> clothingItem; // Données du vêtement

  const DetailScreen({super.key, required this.clothingItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(clothingItem['title'] ?? 'Détails')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image agrandie du vêtement
              if (clothingItem['imageUrl'] != null && clothingItem['imageUrl'].isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    clothingItem['imageUrl'],
                    width: double.infinity,
                    height: 300, // Plus grande hauteur
                    fit: BoxFit.cover, // Assure une bonne proportion
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              const SizedBox(height: 16),

              // Titre
              Text(
                clothingItem['title'] ?? 'Titre non disponible',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Divider(),
              const SizedBox(height: 8),

              // Catégorie
              _buildDetailRow('Catégorie', clothingItem['category'] ?? 'Non spécifiée'),
              const Divider(),
              const SizedBox(height: 8),

              // Taille
              _buildDetailRow('Taille', clothingItem['size'] ?? 'Non spécifiée'),
              const Divider(),
              const SizedBox(height: 8),

              // Marque
              _buildDetailRow('Marque', clothingItem['brand'] ?? 'Non spécifiée'),
              const Divider(),
              const SizedBox(height: 8),

              // Prix
              _buildDetailRow(
                'Prix',
                clothingItem['price'] != null
                    ? '\$${clothingItem['price']?.toStringAsFixed(2)}'
                    : 'Non spécifié',
              ),
              const SizedBox(height: 16),

              // Bouton Ajouter au Panier
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    CartService.addItem(clothingItem); // Ajouter au panier
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ajouté au panier !")),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Ajouter au panier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur verte
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton Retour
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Retour'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Génère une ligne pour chaque détail
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
