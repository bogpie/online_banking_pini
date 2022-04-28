import 'package:flutter/material.dart';
import 'package:online_banking_pini/pages/home_page.dart';
import 'package:online_banking_pini/pages/start_page.dart';
import 'package:online_banking_pini/pages/login_page.dart';
import 'package:online_banking_pini/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home' : (context) => const HomePage(),
      },
    );
  }
}

