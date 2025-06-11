class CartItem {
  final int id;
  final int productId;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get total => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}