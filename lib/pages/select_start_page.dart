import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/pages/home_page.dart';
import 'package:online_banking_pini/pages/start_page.dart';

class SelectStartPage extends StatefulWidget {
  const SelectStartPage({Key? key}) : super(key: key);

  @override
  _SelectStartPageState createState() => _SelectStartPageState();
}

class _SelectStartPageState extends State<SelectStartPage> {
  User? user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserState(event));
  }

  updateUserState(event) {
    if (mounted) {
      setState(
        () {
          user = event;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const StartPage();
    } else {
      return const HomePage();
    }
  }
}
