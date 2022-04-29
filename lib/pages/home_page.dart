import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String displayName = '';
    setState(() {
      displayName = _auth.currentUser?.displayName ?? '';
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text('Hello ' + displayName),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: (){
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              }, child: const Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
