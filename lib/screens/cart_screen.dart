import 'package:flutter/material.dart';
import 'package:chic_sphere/services/cart_service.dart'; // Import CartService
import 'package:chic_sphere/screens/widgets/custom_app_bar.dart'; // Import CustomAppBar

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double calculateTotal() {
    // Calcule la somme des prix des articles dans le panier
    return CartService.cartItems.fold(
      0.0,
      (total, item) => total + (item['price'] ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartService.cartItems; // Récupérer les articles du panier

    return Scaffold(
      appBar: const CustomAppBar(title: 'Panier'), // Utilisation de CustomAppBar
      body: Column(
        children: [
          // Liste des articles dans le panier
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text("Votre panier est vide."))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
                              ? Image.network(
                                  item['imageUrl'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                          title: Text(item['title']),
                          subtitle: Text("Taille : ${item['size']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Affichage du prix
                              Text(
                                "\$${item['price']?.toStringAsFixed(2) ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              // Bouton de suppression avec une croix rouge
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red), // Crois rouge
                                onPressed: () {
                                  // Supprimer l'article du panier
                                  CartService.removeItem(index);
                                  setState(() {}); // Recharger l'état pour mettre à jour l'UI
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Article supprimé du panier")),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Affichage du total général
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total général :",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${calculateTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
