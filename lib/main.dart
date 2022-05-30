import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/pages/home_page.dart';
import 'package:online_banking_pini/pages/login_page.dart';
import 'package:online_banking_pini/pages/profile_page.dart';
import 'package:online_banking_pini/pages/register_page.dart';
import 'package:online_banking_pini/pages/select_start_page.dart';
import 'package:online_banking_pini/pages/history_transaction.dart';


import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PINI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const SelectStartPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/history': (context) => const TransactionHistory(),
      },
    );
  }
}
