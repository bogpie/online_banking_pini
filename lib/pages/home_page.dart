
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/pages/exchange_page.dart';
import 'package:online_banking_pini/pages/transfer_page.dart';

import '../services/user_data.dart';

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

  Map data = {};

  @override
  Widget build(BuildContext context) {
    String displayName = '';
    setState(
      () {
        displayName = FirebaseAuth.instance.currentUser?.displayName ?? '';
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
              Tab(
                icon: Icon(Icons.home),
                text: kIsWeb ? 'Home' : null,
              ),
              Tab(
                icon: Icon(Icons.sync_alt),
                text: kIsWeb ? 'Transfer' : null,
              ),
              Tab(
                icon: Icon(Icons.euro),
                text: kIsWeb ? 'Exchange' : null,
              ),
              Tab(
                icon: Icon(Icons.support_agent),
                text: kIsWeb ? 'Support' : null,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
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
            ),
            const TransferPage(),
            const ExchangePage(),
            const Icon(Icons.support_agent),
          ],
        ),
      ),
    );
  }
}
