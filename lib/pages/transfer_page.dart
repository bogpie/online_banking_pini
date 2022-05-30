import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_banking_pini/utils/iban.dart';

import '../services/user_data.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String currency = 'RON';
  double transferred = 0.0;
  String receiverIbanCode = '';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonHideUnderline(
                      child: Card(
                        elevation: 5,
                        child: DropdownButton<String>(
                          value: currency,
                          icon: const Icon(Icons.arrow_downward),
                          onChanged: (String? newValue) {
                            setState(
                              () {
                                currency = newValue!;
                              },
                            );
                          },
                          items: <String>['RON', 'EUR', 'USD']
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Transfer $value"),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter amount",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      onChanged: (String value) {
                        transferred = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    currency.substring(0, 2) + '00',
                    textScaleFactor: 1.6,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "4 chars",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      onChanged: (String value) {
                        receiverIbanCode = value;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    '0123 4567 8901 2345',
                    textScaleFactor: 1.6,
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () async {
                  Map senderData =
                      await getUserMap(FirebaseAuth.instance.currentUser!.uid);

                  double newSenderBalance =
                      senderData['currencies'][currency] * 1.0 - transferred;


                  if (receiverIbanCode.length != 4) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Enter valid iban code'),
                        content:
                            const Text('Use the unique 4 character user identifier'
                                ' for receiver'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  if (newSenderBalance < 0) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Not enough funds'),
                        content: Text('Transfer less $currency'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  String receiverUid = await ibanCodeToUid(receiverIbanCode);
                  Map receiverData = await getUserMap(receiverUid);

                  senderData["currencies"][currency] = newSenderBalance;

                  double newReceiverBalance =
                      receiverData['currencies'][currency] * 1.0 + transferred;
                  receiverData['currencies'][currency] = newReceiverBalance;

                  DatabaseReference senderRef = FirebaseDatabase.instance.ref(
                    "users/${FirebaseAuth.instance.currentUser?.uid ?? 'null_'
                        'uid'}",
                  );
                  DatabaseReference receiversRef =
                      FirebaseDatabase.instance.ref("users/$receiverUid");

                  String senderIbanCode =
                      FirebaseAuth.instance.currentUser?.uid.substring(0, 4) ?? '';

                  String senderIban = currency.substring(0, 2) +
                      "00 " +
                      senderIbanCode +
                      '0123 4567 '
                          '8901 2345';

                  String receiverIban = currency.substring(0, 2) +
                      "00 " +
                      receiverIbanCode +
                      '0123 4567 '
                          '8901 2345';

                  /* Extract transfer list from senders */
                  List<dynamic>? senderTransfers = senderData["transfers"];

                  if (senderTransfers != null) {
                    senderTransfers.add(
                      {
                          "type": "sent",
                          "iban": receiverIban,
                          "amount": transferred,
                          "currency": currency
                      }
                    );
                  } else {
                     senderTransfers = [
                       {
                         "type": "sent",
                         "iban": receiverIban,
                         "amount": transferred,
                         "currency": currency
                       }
                     ];
                  }

                  /* Extract receiver transfer list */
                  List<dynamic>? receiverTransfers = receiverData["transfers"];

                  if (receiverTransfers != null) {
                    receiverTransfers.add(
                        {
                          "type": "received",
                          "iban": senderIban,
                          "amount": transferred,
                          "currency": currency
                        }
                    );
                  } else {
                    receiverTransfers = [
                      {
                        "type": "received",
                        "iban": senderIban,
                        "amount": transferred,
                        "currency": currency
                      }
                    ];
                  }

                  /* Update the transfers inside database */
                  senderRef.update({"transfers": senderTransfers});
                  receiversRef.update({"transfers": receiverTransfers});

                  /* Update the new currencies inside database */
                  senderRef.update({"currencies": senderData["currencies"]});
                  receiversRef.update({"currencies": receiverData["currencies"]});

                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Successfully transferred'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Transfer'),
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
                child: const Text('History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
