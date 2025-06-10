class Post {
  final int id;
  final String title;
  final String body;
  final String image;
  final double price;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.price,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'image': image,
      'price': price,
    };
  }

  @override
  String toString() {
    return "Título: $title\nTexto: $body\nPreço: R\$ ${price.toStringAsFixed(2)}\n";
  }
}
