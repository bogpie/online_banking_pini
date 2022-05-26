import 'dart:ui';

import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  String sellCurrency = "RON";

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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
                            .map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("Selling $value"),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: TextField(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
