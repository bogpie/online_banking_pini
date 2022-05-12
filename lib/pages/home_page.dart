import 'package:cloud_firestore/cloud_firestore.dart';
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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Home page'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.sync_alt)),
                Tab(icon: Icon(Icons.euro)),
                Tab(icon: Icon(Icons.support_agent)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text('Hello ' + displayName),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            _auth.signOut();
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Text('Logout')),
                      ElevatedButton(
                          onPressed: () {
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              return;
                            }
                            DocumentReference<Map<String, dynamic>> userData =
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user.uid);

                            final data1 = <String, dynamic>{
                              "phone": "0000000000",
                            };
                            userData.set(data1);
                          },
                          child: const Text('test'))
                    ],
                  ),
                ),
              ),
              const Icon(Icons.sync_alt),
              const Icon(Icons.euro),
              const Icon(Icons.support_agent),
            ],
          )),
    );
  }
}
