import 'package:get/get.dart';
import '../../database_manager.dart';
import './user_model.dart'; // Pastikan untuk mengimpor model User yang benar

class UserService extends GetxController {
  // Fungsi untuk menambahkan pengguna baru
  Future<bool> addUser(User user) async {
    final db = await DatabaseManager().database;
    final List<Map<String, dynamic>> existingUsers = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [user.username],
    );

    // Cek jika username sudah ada
    if (existingUsers.isNotEmpty) {
      return false; // Username sudah digunakan
    }

    await db.insert('users', user.toMap());
    return true; // Pengguna berhasil ditambahkan
  }

  // Modifikasi fungsi login untuk mengembalikan user_id dan username jika sukses
  Future<User?> login(String username, String password) async {
    final db = await DatabaseManager().database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (users.isNotEmpty) {
      // Mengembalikan User dari Map jika login berhasil
      return User.fromMap(users.first);
    }
    return null; // Kembali null jika login gagal
  }

  // Fungsi untuk mendapatkan informasi pengguna
  Future<User?> getUserInfo(String username) async {
    final db = await DatabaseManager().database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (users.isNotEmpty) {
      return User.fromMap(users.first); // Mengembalikan User dari Map
    }
    return null; // Pengguna tidak ditemukan
  }
}
