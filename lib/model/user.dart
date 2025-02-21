class User {
  final int id;
  final String username;
  final String password;
  final String role;
  final bool? isActive;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Default to 0 if null
      username: json['username'] ?? 'Unknown', // Default to 'Unknown' if null
      password: json['password'] ?? 'Unknown', // Default to 'Unknown' if null
      isActive: json['isActive'] ?? true, // Default to true if null
      role: json['role'] ?? 'User', // Default to 'User' if null
    );
  }
}
