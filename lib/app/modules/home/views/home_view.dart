import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/home_controller.dart';
import '../../login/controllers/login_controller.dart'; // Pastikan untuk mengimpor LoginController

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<
        LoginController>(); // Mendapatkan instance dari LoginController

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueGrey[50]!, Colors.blueGrey[300]!],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'DAY REMINDER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() => Text(
                            controller.currentTime.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          )),
                      SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 20,
                        childAspectRatio: 2, // Sesuaikan aspect ratio
                        shrinkWrap:
                            true, // Penting untuk GridView di dalam SingleChildScrollView
                        physics:
                            NeverScrollableScrollPhysics(), // Agar tidak dapat scroll sendiri
                        children: <Widget>[
                          _buildCard(
                            title: 'List Notes',
                            icon: FontAwesomeIcons.clipboardList,
                            onTap: () {
                              Get.toNamed('/note');
                            },
                          ),
                          _buildCard(
                            title: 'Create Notes',
                            icon: FontAwesomeIcons.penFancy,
                            onTap: () {
                              Get.toNamed('/add');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Tombol Logout
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  await loginController.logout(); // Memanggil fungsi logout
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade300, Colors.deepPurple],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(icon, size: 60, color: Colors.white),
              SizedBox(height: 10),
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
