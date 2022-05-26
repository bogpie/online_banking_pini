import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  String sellCurrency = "EUR";
  double sellValue = 0;
  String buyCurrency = "USD";
  double buyValue = 0;
  Map<Map<String, String>, double> conversionMap = {
    {"RON": "EUR"}: 0.20,
    {"RON": "USD"}: 0.22,
    {"EUR": "USD"}: 1.07,
    {"EUR": "RON"}: 4.94,
    {"USD": "RON"}: 4.62,
    {"USD": "EUR"}: 0.93,
    {"RON": "RON"}: 1,
    {"EUR": "EUR"}: 1,
    {"USD": "USD"}: 1
  };

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
                          },
                        );
                      },
                      items: <String>['RON', 'EUR', 'USD']
                          .where((element) => element != buyCurrency)
                          .toList()
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
              const Expanded(
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
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
              const Expanded(
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
