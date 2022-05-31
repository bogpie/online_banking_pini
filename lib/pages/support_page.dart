import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_pini/utils/iban.dart';
import 'dart:convert';

import '../services/user_data.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _TransactionHistory();
}

class _TransactionHistory extends State<SupportPage> {
  Map data = {};
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support page'),
      ),
      body: Center(
        child: SizedBox(
          width: 800,
          child: FutureBuilder(
            future: getAllUsersMap()
                .then((result) => data = result),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: data.values.toList().length,
                itemBuilder: (context, index) {
                  Map userData = data.values.toList()[index];
                  // Print out the items which will be received + 2 buttons
                  if (userData['pending'] == 1) {
                        String userIBAN =
                          userData['IBAN']['RON'];
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
                                          title: Text(userData['username']),
                                          subtitle: Column(
                                              children: [
                                                Text('First name: ' +
                                                    userData['firstName'],
                                                ),
                                                Text('Last name: ' +
                                                    userData['lastName'],
                                                ),
                                                Text('PIN: ' +
                                                    userData['PIN'],
                                                ),
                                                Text('Email: ' +
                                                    userData['email'],
                                                ),
                                                Text('Phone number: ' +
                                                  userData['phoneNumber']),
                                              ]
                                          )
                                      ),
                                    ),
                                    /* Accept the user registration */
                                    IconButton(
                                        onPressed: () async {
                                          String userUID = await
                                                ibanCodeToUid(
                                                    userIBAN.substring(5, 9));

                                          Map userData = await getUserMap(userUID);
                                          Map currenciesMap = userData["currencies"];

                                          /* Put initial money inside a new
                                          * registered acccount */
                                          currenciesMap['EUR'] = 2000;
                                          currenciesMap['RON'] = 2000;
                                          currenciesMap['USD'] = 2000;

                                          DatabaseReference userRef =
                                              FirebaseDatabase.instance.ref(
                                                  "users/$userUID");

                                          // Update the initial balance
                                          // Make pending flag 0;
                                          userRef.update({
                                            "currencies": currenciesMap,
                                            "pending": 0,
                                          });

                                          // Print the Popup
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('User succesfully registered'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );

                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.check)),
                                    /* Decline the user registration */
                                    IconButton(
                                        onPressed: () async {
                                          String userUID = await
                                          ibanCodeToUid(
                                              userIBAN.substring(5, 9));

                                          Map userData = await getUserMap(userUID);

                                          DatabaseReference userRef =
                                          FirebaseDatabase.instance.ref(
                                              "users/$userUID");

                                          // TODO Delete user?
                                          // Make pending flag 0;
                                          userRef.update({
                                            "pending": 0,
                                          });

                                          // Print the popup
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('User declined'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.cancel)),
                                    IconButton(
                                        onPressed: () async {

                                          // Print the popup
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Contact user'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.contact_mail_rounded)),
                                  ],
                                ),
                              ),
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
                                    title: Text(userData['email']),
                                    subtitle: Column(
                                        children: [
                                          Text(
                                              userData['email']),
                                          Text(
                                            userData['email'],
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {

                                    // Print the popup
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Contact user'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.contact_mail_rounded)),
                              IconButton(
                                  onPressed: () async {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Account suspended'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );

                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.not_interested)),
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
