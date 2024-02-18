import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/user_service.dart';
import '../../../data/user_model.dart'; // Pastikan import ini benar

class LoginController extends GetxController {
  final UserService _userService = UserService();

  // Observable variables untuk menyimpan username dan password
  final RxString _username = ''.obs;
  final RxString _password = ''.obs;

  String get username => _username.value;
  set username(String value) => _username.value = value;

  String get password => _password.value;
  set password(String value) => _password.value = value;

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  Future<void> login() async {
    final User? user = await _userService.login(username, password);
    if (user != null) {
      // Login berhasil, simpan sesi dengan user_id dan username
      await _saveSession(user.id!, user.username);
      _isLoggedIn.value = true;
      Get.snackbar('Login Success', 'You have successfully logged in.');
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Login Failed', 'Invalid username or password.');
    }
  }

  Future<void> register(String username, String password) async {
    final success = await _userService
        .addUser(User(username: username, password: password));
    if (success) {
      Get.snackbar('Registration Success',
          'You have successfully registered. Please login.');
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Registration Failed', 'Username already exists.');
    }
  }

  Future<void> _saveSession(int userId, String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('username', username);
  }

  Future<void> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? username = prefs.getString('username');
    if (userId != null && username != null) {
      _isLoggedIn.value = true;
      _username.value = username;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    reset();
    Get.offAllNamed('/login');
  }

  void reset() {
    _username.value = '';
    _password.value = '';
    _isLoggedIn.value = false;
  }
}
