import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class Exchange {
  String sell = '';
  String buy = '';
}

class _ExchangePageState extends State<ExchangePage> {
  String sellCurrency = "RON";
  double sellValue = 0;
  String buyCurrency = "EUR";
  double buyValue = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, double> conversionMap = {
    "RON-EUR": 0.20,
    "RON-USD": 0.22,
    "EUR-USD": 1.07,
    "EUR-RON": 4.94,
    "USD-RON": 4.62,
    "USD-EUR": 0.93,
    "RON-RON": 1,
    "EUR-EUR": 1,
    "USD-USD": 1
  };

  final sellController = TextEditingController();
  final buyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonHideUnderline(
                  child: Card(
                    elevation: 5,
                    child: DropdownButton<String>(
                      value: sellCurrency,
                      icon: const Icon(Icons.arrow_downward),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            sellCurrency = newValue!;
                            String sellBuy = sellCurrency + '-' + buyCurrency;
                            double modifier = conversionMap[sellBuy] ?? 1.0;
                            buyController.text =
                                ((double.tryParse(sellController.text) ?? 0) *
                                        modifier)
                                    .toStringAsFixed(2);
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
                              child: Text("Selling $value"),
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
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: sellController,
                  onChanged: (String value) {
                    String sellBuy = sellCurrency + '-' + buyCurrency;
                    double modifier = conversionMap[sellBuy] ?? 1.0;
                    buyController.text =
                        ((double.tryParse(value) ?? 0) * modifier)
                            .toStringAsFixed(2);
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
              Expanded(
                flex: 2,
                child: DropdownButtonHideUnderline(
                  child: Card(
                    elevation: 5,
                    child: DropdownButton<String>(
                      value: buyCurrency,
                      icon: const Icon(Icons.arrow_downward),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            buyCurrency = newValue!;
                            String buySell = buyCurrency + '-' + sellCurrency;
                            double modifier = conversionMap[buySell] ?? 1.0;
                            sellController.text =
                                ((double.tryParse(buyController.text) ?? 0) *
                                        modifier)
                                    .toStringAsFixed(2);
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
                              child: Text("Buying $value"),
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
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: buyController,
                  onChanged: (value) {
                    String buySell = buyCurrency + '-' + sellCurrency;
                    double modifier = conversionMap[buySell] ?? 1.0;
                    sellController.text =
                        ((double.tryParse(value) ?? 0) * modifier)
                            .toStringAsFixed(2);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              if (sellCurrency == buyCurrency) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Currencies are the same'),
                    content: const Text('Choose a different currency'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              else {

              }
            },
            child: const Text('Exchange'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    buyController.dispose();
    sellController.dispose();
    super.dispose();
  }
}
