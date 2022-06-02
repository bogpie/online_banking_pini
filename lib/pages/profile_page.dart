import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map data = {};
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                future: getUserMap(FirebaseAuth.instance.currentUser!.uid)
                    .then((result) => data = result),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'First Name:  '
                            '${data['firstName']} ',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Last Name:  '
                            '${data['lastName']} ',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Phone Number:  '
                            '${data['phoneNumber']} ',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'PIN:  '
                            '${data['PIN']} ',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'You have '
                            '${data['currencies']['RON']} RON',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'You have ${data['currencies']['EUR']} EUR',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'You have ${data['currencies']['USD']} USD',
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('IBAN RO: ' +
                              data['IBAN']['RON'].toString()),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('IBAN EUR: ' +
                              data['IBAN']['EUR']),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('IBAN USD: ' +
                              data['IBAN']['USD']),
                          const SizedBox(height: 32),
                          IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                    // Navigator.(context);
                    // Navigator.pushNamed(context, '/');
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (Route<dynamic> route) => false);
                  },
                  child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}
