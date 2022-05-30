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
        title: const Text("History of your transactions"),
      ),
    //   body: FutureBuilder(
    //     builder (context, snapshot) { return ListView.builder(
    //       itemCount: items.length,
    //       itemBuilder: (context, index) {
    //
    //       return ListTile(
    //           title: Text(items[index]),
    //       );
    // );}
      );
  }
}
