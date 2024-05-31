class User {
  final int id; // Nicht erforderlich beim Erstellen eines neuen Benutzers
  final String username;
  final String password;
  final String email;
  final DateTime createdAt;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.createdAt,
    this.id = 0, // Standardwert 0, wird vom Server zugewiesen
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}