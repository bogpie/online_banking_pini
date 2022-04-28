import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                onChanged: (value) {
                  email = value.trim();
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
                onChanged: (value) {
                  password = value.trim();
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential credential =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false);
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login failed'),
                          content: Text('${e.message}'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Okay'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
