class ClothingItem {
  final String imageUrl;
  final String title;
  final String category; // Déterminé automatiquement par le modèle IA
  final String size;
  final String brand;
  final double price;

  ClothingItem({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.size,
    required this.brand,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'category': category,
      'size': size,
      'brand': brand,
      'price': price,
    };
  }
}
