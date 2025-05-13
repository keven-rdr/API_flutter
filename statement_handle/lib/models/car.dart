class Car {
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  Car({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  // Construtor a partir de JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: double.tryParse(json['price']) ?? 0.0,
    );
  }
}