import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/pages/exchange_page.dart';

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
  Map data = {};

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
          title: Row(
            children: [
              GestureDetector(
                child: const CircleAvatar(child: Icon(Icons.person)),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Text(displayName.toUpperCase()),
            ],
          ),
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
              future: getUserMap().then((result) => data = result),
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
                        const SizedBox(height: 16),

                      ],
                    ),
                  ),
                );
              },
            ),
            const Icon(Icons.sync_alt),
            const ExchangePage(),
            const Icon(Icons.support_agent),
          ],
        ),
      ),
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
