import 'package:responsipraktpm/pages/home_page.dart';
import 'package:responsipraktpm/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Tugas',
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? 'pages/home' : 'pages/login',
      routes: {
        'pages/login': (context) => LoginPage(),
        'pages/home': (context) => HomePage(),
      },
    );
  }
}