import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chic_sphere/services/cart_service.dart';
import 'detail_screen.dart'; // Import DetailScreen
import 'package:chic_sphere/screens/widgets/custom_app_bar.dart'; // Import CustomAppBar
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Liste des vêtements'), // Utilisation de CustomAppBar
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('clothingItems') // Firestore collection
            .orderBy('timestamp', descending: true) // Most recent items first
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Une erreur s\'est produite'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Pas de vêtements disponibles'));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    // Naviguer vers la page de détail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(clothingItem: item),
                      ),
                    );
                  },
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Taille : ${item['size']}"),
                      Text("Prix : ${item['price']}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                    onPressed: () {
                      CartService.addItem(item); // Ajouter l'article au panier
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ajouté au panier !")),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
