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
  late final Future<Map> dataFuture;
  Map data = {};

  @override
  void initState() {
    String? uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    dataFuture = getUserMap(uid);
    super.initState();
  }

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
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError || snapshot.hasData == false) {
                return const Center(child: CircularProgressIndicator());
              }
              data = snapshot.data as Map;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
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
                                                subtitle: Column(children: [
                                                  Text(data['transfers'][index]
                                                      ['iban']),
                                                  Text(
                                                    data['transfers'][index]
                                                            ['currency'] +
                                                        ' ' +
                                                        data['transfers'][index]
                                                                ['amount']
                                                            .toString(),
                                                  ),
                                                ])),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                /* Delete the current user transaction */
                                                String senderIbanCode =
                                                    data['transfers'][index]
                                                        ['iban'];

                                                String currency =
                                                    data['transfers'][index]
                                                        ['currency'];

                                                double amount =
                                                    data['transfers'][index]
                                                        ['amount'];

                                                String transferID = "";
                                                List<dynamic>?
                                                    currentTransfers =
                                                    data["transfers"];
                                                Map dataSend = await getUserMap(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid);
                                                Map currenciesSend =
                                                    dataSend["currencies"];

                                                if (currentTransfers != null) {
                                                  /* Grab the common transfer_id */
                                                  transferID = data["transfers"]
                                                      [index]["transfer_id"];

                                                  /* Modify the currency and type
                                                  of transfer */
                                                  currentTransfers[index]
                                                      ["type"] = "sent";
                                                  currenciesSend[currency] +=
                                                      amount;

                                                  /* Get instance of db of the current user*/
                                                  DatabaseReference currentRef =
                                                      FirebaseDatabase.instance
                                                          .ref(
                                                    "users/${FirebaseAuth.instance.currentUser?.uid ?? 'null_'
                                                        'uid'}",
                                                  );

                                                  /* Update the new transfer list */
                                                  currentRef.update(
                                                    {
                                                      "transfers":
                                                          currentTransfers,
                                                      "currencies":
                                                          currenciesSend
                                                    },
                                                  );
                                                }

                                                // Get the Sender Data and remove his transfer
                                                /* Get the sender Iban to match with the uid */
                                                String senderUID =
                                                    await ibanCodeToUid(
                                                        senderIbanCode
                                                            .substring(5, 9));

                                                // // /* Get the sender data */
                                                Map senderData =
                                                    await getUserMap(senderUID);
                                                List<dynamic>? senderTransfers =
                                                    senderData['transfers'];
                                                Map receiverCurrencies =
                                                    senderData["currencies"];

                                                if (senderTransfers != null) {
                                                  /* Grab the specific transfer with common transfer_id */
                                                  if (transferID != "") {
                                                    dynamic elementToFind;
                                                    for (var element
                                                        in senderTransfers) {
                                                      if (element[
                                                              'transfer_id'] ==
                                                          transferID) {
                                                        elementToFind = element;
                                                      }
                                                    }

                                                    int foundIndex =
                                                        senderTransfers.indexOf(
                                                            elementToFind, 0);

                                                    // Here modify every field you want of the sender
                                                    // (not the current user)
                                                    elementToFind['type'] =
                                                        "sent";
                                                    receiverCurrencies[
                                                        currency] -= amount;

                                                    senderTransfers[
                                                            foundIndex] =
                                                        elementToFind;
                                                  }
                                                }

                                                /* Get the sender instance from database */
                                                DatabaseReference senderRef =
                                                    FirebaseDatabase.instance
                                                        .ref(
                                                            "users/$senderUID");

                                                /* Update the new transfer and currencies list */
                                                senderRef.update(
                                                  {
                                                    "transfers":
                                                        senderTransfers,
                                                    "currencies":
                                                        receiverCurrencies
                                                  },
                                                );

                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'Transaction accepted'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.check)),
                                          IconButton(
                                              onPressed: () async {
                                                /* Delete the transactions from database of
                                              * both users -> sender and receiver */

                                                /* Delete the current user transaction */
                                                String transferID = "";
                                                List<dynamic>?
                                                    currentTransfers =
                                                    data["transfers"];
                                                if (currentTransfers != null) {
                                                  /* Grab the common transfer_id */
                                                  transferID = data["transfers"]
                                                      [index]["transfer_id"];

                                                  currentTransfers[index]
                                                      ["type"] = "sent";

                                                  /* Get instance of db of the current user*/
                                                  DatabaseReference currentRef =
                                                      FirebaseDatabase.instance
                                                          .ref(
                                                    "users/${FirebaseAuth.instance.currentUser?.uid ?? 'null_'
                                                        'uid'}",
                                                  );

                                                  /* Update the new transfer list */
                                                  currentRef.update(
                                                    {
                                                      "transfers":
                                                          currentTransfers
                                                    },
                                                  );
                                                }

                                                // Get the Sender Data and remove his transfer
                                                /* Get the sender Iban to match with the uid */
                                                String senderIbanCode =
                                                    data['transfers'][index]
                                                        ['iban'];

                                                String senderUID =
                                                    await ibanCodeToUid(
                                                        senderIbanCode
                                                            .substring(5, 9));

                                                // // /* Get the sender data */
                                                Map senderData =
                                                    await getUserMap(senderUID);
                                                List<dynamic>? senderTransfers =
                                                    senderData["transfers"];
                                                if (senderTransfers != null) {
                                                  /* Grab the specific transfer with common transfer_id */
                                                  if (transferID != "") {
                                                    dynamic elementToFind;
                                                    for (var element
                                                        in senderTransfers) {
                                                      if (element[
                                                              "transfer_id"] ==
                                                          transferID) {
                                                        elementToFind = element;
                                                      }
                                                    }

                                                    int foundIndex =
                                                        senderTransfers.indexOf(
                                                            elementToFind, 0);

                                                    elementToFind['type'] =
                                                        "sent";
                                                    senderTransfers[
                                                            foundIndex] =
                                                        elementToFind;
                                                  }
                                                }

                                                /* Get the sender instance from database */
                                                DatabaseReference senderRef =
                                                    FirebaseDatabase.instance
                                                        .ref(
                                                            "users/$senderUID");

                                                /* Update the new transfer list */
                                                senderRef.update(
                                                  {
                                                    "transfers": senderTransfers
                                                  },
                                                );

                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'Transaction declined'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.cancel)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ));
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
                                        title: Text(data['type'] == 'sent'
                                            ? 'To ${data['username']}'
                                            : 'From '
                                                '${data['username']}'),
                                        subtitle: Column(
                                          children: [
                                            Text(
                                                'via ${data['transfers'][index]['iban']}'),
                                            Text(
                                              data['transfers'][index]
                                                      ['currency'] +
                                                  ' ' +
                                                  data['transfers'][index]
                                                          ['amount']
                                                      .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          /* Delete the transactions from database of
                                              * both users -> sender and receiver */

                                          /* Delete the current user transaction */
                                          List<dynamic>? currentTransfers =
                                              data["transfers"];
                                          if (currentTransfers != null) {
                                            currentTransfers.removeAt(index);
                                            /* Get instance of db of the current user*/
                                            DatabaseReference currentRef =
                                                FirebaseDatabase.instance.ref(
                                              "users/${FirebaseAuth.instance.currentUser?.uid ?? 'null_'
                                                  'uid'}",
                                            );

                                            /* Update the new transfer list */
                                            currentRef.update(
                                              {"transfers": currentTransfers},
                                            );
                                          }

                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text(
                                                  'Transaction deleted'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );

                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Export '
                        'as PDF'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
