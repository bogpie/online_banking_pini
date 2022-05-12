import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map map = {};

  @override
  Widget build(BuildContext context) {
    String displayName = '';
    setState(
      () {
        displayName = _auth.currentUser?.displayName ?? '';
      },
    );

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
              FutureBuilder(
                future: getUserMap().then((result) => map = result),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text('Hello ' + displayName),
                          const SizedBox(height: 16),
                          Text('You have ${map['currencies']['RON']} RON'),
                          Text('You have ${map['currencies']['EUR']} EUR'),
                          Text('You have ${map['currencies']['USD']} USD'),

                          const SizedBox(height: 16),
                          ElevatedButton(
                              onPressed: () {
                                _auth.signOut();
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text('Logout')),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Icon(Icons.sync_alt),
              const Icon(Icons.euro),
              const Icon(Icons.support_agent),
            ],
          )),
    );
  }

  Future<Map> getUserMap() async {
    final ref = FirebaseDatabase.instance.ref();
    final DataSnapshot snapshot =
        await ref.child('users/${_auth.currentUser?.uid}').get();
    Map map = jsonDecode(jsonEncode(snapshot.value));
    return map;
  }
}
