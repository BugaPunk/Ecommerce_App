class Product {
  final int id;
  final String title;
  final String description;
  final List<String> images;
  final double price;
  final double rating;
  final bool isFavourite;
  final bool isPopular;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.category,
  });
}

// Lista de productos de demostración
List<Product> demoProducts = [
  Product(
    id: 1,
    title: "Samsung Galaxy S21",
    description: "El Samsung Galaxy S21 es un teléfono inteligente Android de gama alta fabricado por Samsung Electronics.",
    images: ["assets/images/product_1.png"],
    price: 799.99,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
    category: "Electrónicos",
  ),
  Product(
    id: 2,
    title: "Nike Air Max 270",
    description: "Las zapatillas Nike Air Max 270 ofrecen un estilo llamativo y una gran comodidad.",
    images: ["assets/images/product_2.png"],
    price: 129.99,
    rating: 4.5,
    isPopular: true,
    category: "Moda",
  ),
  Product(
    id: 3,
    title: "Apple Watch Series 7",
    description: "El Apple Watch Series 7 tiene la pantalla más grande y avanzada hasta ahora.",
    images: ["assets/images/product_3.png"],
    price: 399.99,
    rating: 4.7,
    isFavourite: true,
    category: "Electrónicos",
  ),
  Product(
    id: 4,
    title: "Logitech MX Master 3",
    description: "El ratón inalámbrico avanzado con desplazamiento ultrarrápido.",
    images: ["assets/images/product_4.png"],
    price: 99.99,
    rating: 4.9,
    isPopular: true,
    category: "Accesorios",
  ),
  Product(
    id: 5,
    title: "Sony WH-1000XM4",
    description: "Auriculares inalámbricos con cancelación de ruido líder en la industria.",
    images: ["assets/images/product_5.png"],
    price: 349.99,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
    category: "Electrónicos",
  ),
];

// Productos populares
List<Product> popularProducts = demoProducts.where((product) => product.isPopular).toList();