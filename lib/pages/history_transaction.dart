import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/utils/iban.dart';

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
                  if (data['transfers'][index]['type'] == "received") {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
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
                                        /* Delete the transactions from database of
                                        * both users -> sender and receiver */

                                        /* Delete the current user transaction */
                                        List<dynamic>? currentTransfers = data["transfers"];
                                        if (currentTransfers != null) {
                                          String transfer_id = "";

                                          /* Grab the common transfer_id */
                                          transfer_id =
                                          data["transfers"][index]["transfer_id"];
                                          currentTransfers.removeAt(index);


                                          /* Get instance of db of the current user*/
                                          DatabaseReference currentRef = FirebaseDatabase
                                              .instance.ref(
                                            "users/${FirebaseAuth.instance
                                                .currentUser?.uid ?? 'null_'
                                                'uid'}",
                                          );

                                          /* Update the new transfer list */
                                          currentRef.update(
                                              {"transfers": currentTransfers});

                                          // Get the Sender Data and remove his transfer
                                          /* Get the sender Iban to match with the uid */
                                          String senderIbanCode =
                                          data['transfers'][index]['iban'];

                                          String senderUID = await
                                          ibanCodeToUid(
                                              senderIbanCode.substring(5, 9));

                                          // /* Get the sender data */
                                          Map senderData = await getUserMap(
                                              senderUID);
                                          //
                                          List<dynamic>? senderTransfers = senderData["transfers"];
                                          // if (senderTransfers != null && currentTransfers != null) {
                                          //     /* Grab the specific transfer with common transfer_id */
                                          //     if (transfer_id != "") {
                                          //       print(transfer_id);
                                          //       int indexRemove = senderTransfers
                                          //           .indexOf(
                                          //           transfer_id);
                                          //
                                          //       print(indexRemove);
                                          //
                                          //       if (indexRemove != -1) {
                                          //         senderTransfers.removeAt(
                                          //             indexRemove);
                                          //       }
                                          //     }
                                          // }

                                          /* Get the sender instance from database */
                                          DatabaseReference senderRef =
                                          FirebaseDatabase.instance.ref(
                                              "users/$senderUID");
                                        }
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
                          IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      )
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
