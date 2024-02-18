class User {
  final int? id; // Nullable karena akan diisi oleh database saat insert
  final String username;
  final String password;

  User({this.id, required this.username, required this.password});

  // Konversi dari Map (mengambil data dari database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'],
      username: map['username'],
      password: map['password'],
    );
  }

  // Konversi ke Map (untuk menyimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'user_id': id, // Ini akan diabaikan saat insert karena autoincrement
      'username': username,
      'password': password,
    };
  }
}
