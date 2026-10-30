class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int quantity;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  // Converte o objeto Product num Map para guardar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }

  // Cria um objeto Product a partir de um Map retornado do SQLite
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}