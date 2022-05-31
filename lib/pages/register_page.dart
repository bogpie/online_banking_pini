import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String userName = '';
  String email = '';
  String password = '';
  String repeatPassword = '';
  String PIN = '';
  String phoneNumber = '';
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register page'),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "First Name"),
                  onChanged: (value) {
                    firstName = value.trim();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Last Name"),
                  onChanged: (value) {
                    lastName = value.trim();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Personal Identification Number"),
                  onChanged: (value) {
                    PIN = value.trim();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Phone Number"),
                  onChanged: (value) {
                    phoneNumber = value.trim();
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "Email"),
                  onChanged: (value) {
                    email = value.trim();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Username"),
                  onChanged: (value) {
                    userName = value.trim();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Password"),
                  obscureText: true,
                  onChanged: (value) {
                    password = value.trim();
                  },
                ),
                if (false)
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Repeat password"),
                    obscureText: true,
                    onChanged: (value) {
                      repeatPassword = value.trim();
                    },
                  ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential credential =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        User? user = credential.user;
                        if (user == null) {
                          throw Exception("Null user");
                        }
                        await user
                            .updateDisplayName(firstName + ' ' + lastName);

                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("users/${credential.user!.uid}");

                        /* Define IBANS when user register */
                        String ibanCode =
                            FirebaseAuth.instance.currentUser?.uid.substring(0, 4) ?? '';

                        String ibanRO = "RO" +
                            "00 " +
                            ibanCode +
                            '0123 4567 '
                                '8901 2345';
                        String ibanEU = "EU" +
                            "00 " +
                            ibanCode +
                            '0123 4567 '
                                '8901 2345';
                        String ibanUS = "US" +
                            "00 " +
                            ibanCode +
                            '0123 4567 '
                                '8901 2345';

                        await ref.set(
                          {
                            "firstName": firstName,
                            "lastName": lastName,
                            // "username": user.displayName?.replaceAll(" ", "_"),
                            "username": userName,
                            "phoneNumber": phoneNumber,
                            "email": email,
                            "PIN": PIN,
                            "IBAN": {
                              "RON": ibanRO,
                              "EUR": ibanEU,
                              "USD": ibanUS,
                            },
                            "transfers": [],
                            "currencies": {
                              "EUR": 0,
                              "RON": 0,
                              "USD": 0
                            },
                            "pending": 1,
                          },
                        );
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration completed'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text('Okay'),
                              )
                            ],
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration failed'),
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
      ),
    );
  }
}
