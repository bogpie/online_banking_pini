import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_data.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistory();
}

class _TransactionHistory extends State<TransactionHistory> {
  Map data = {};
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your transaction history'),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: FutureBuilder(
            future: getUserMap(FirebaseAuth.instance.currentUser!.uid)
                .then((result) => data = result),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: data['transfers']?.length ?? 0,
                itemBuilder: (context, index) {
                  // Print out the items which will be received + 2 buttons
                  if (data['type'] == "received") {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                    title: Text(data['username']),
                                    subtitle: Column(
                                        children: [
                                          Text(
                                              data['transfers'][index]['iban']),
                                          Text(
                                            data['transfers'][index]['currency'] +
                                                ' ' +
                                                data['transfers'][index]['amount']
                                                    .toString(),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    Map currentUserData =
                                    await getUserMap(
                                        FirebaseAuth.instance.currentUser!.uid);
                                  },
                                  icon: const Icon(Icons.check)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.cancel)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  // Print out the items that are sent without buttons
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                    title: Text(data['username']),
                                    subtitle: Column(
                                        children: [
                                          Text(
                                            data['transfers'][index]['iban']),
                                          Text(
                                            data['transfers'][index]['currency'] +
                                                ' ' +
                                            data['transfers'][index]['amount']
                                                .toString(),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
