class Comment {
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({required this.id, required this.name, required this.email, required this.body});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}
