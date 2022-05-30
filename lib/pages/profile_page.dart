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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {

                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('Logout')),
            FutureBuilder(
              future: getUserMap(FirebaseAuth.instance.currentUser!.uid)
                  .then((result) => data = result),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
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
                          textScaleFactor: 2,
                        ),
                        Text(
                          'Last Name:  '
                              '${data['lastName']} ',
                          textScaleFactor: 2,
                        ),
                        Text(
                          'You have '
                              '${data['currencies']['RON']} RON',
                          textScaleFactor: 2,
                        ),
                        Text(
                          'You have ${data['currencies']['EUR']} EUR',
                          textScaleFactor: 2,
                        ),
                        Text(
                          'You have ${data['currencies']['USD']} USD',
                          textScaleFactor: 2,
                        ),
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
            )
          ]
          ,
        ),
      ),
    );
  }
}
