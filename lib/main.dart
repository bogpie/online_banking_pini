import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/pages/home_page.dart';
import 'package:online_banking_pini/pages/login_page.dart';
import 'package:online_banking_pini/pages/register_page.dart';
import 'package:online_banking_pini/pages/start_page.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    const FirebaseOptions options = FirebaseOptions(
        apiKey: "AIzaSyAJvntlBXgh_BMqJp1Rmd4EzZ00kUGWlNs",
        authDomain: "onlinebankingpini.firebaseapp.com",
        projectId: "onlinebankingpini",
        storageBucket: "onlinebankingpini.appspot.com",
        messagingSenderId: "722734900618",
        appId: "1:722734900618:web:c500e37c5ab4fea11c1473",
        measurementId: "G-VVXF8L21ZQ");

    // await Firebase.initializeApp(
    //     options: options);
    await Firebase.initializeApp();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
