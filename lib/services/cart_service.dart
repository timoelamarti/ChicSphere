class CartService {
  // Liste statique pour stocker les articles du panier
  static final List<Map<String, dynamic>> _cartItems = [];

  // Ajouter un article au panier
  static void addItem(Map<String, dynamic> item) {
    _cartItems.add(item);
  }

  // Supprimer un article du panier par index
  static void removeItem(int index) {
    _cartItems.removeAt(index);
  }

  // Récupérer tous les articles du panier
  static List<Map<String, dynamic>> get cartItems => _cartItems;
}
