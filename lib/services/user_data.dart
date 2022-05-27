import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<Map> getUserMap(String uid) async {
  final ref = FirebaseDatabase.instance.ref();

  // final usersSnapshot = await ref.child('users').get();
  // Map usersMap = jsonDecode(jsonEncode(usersSnapshot.value));

  final DataSnapshot snapshot =
      await ref.child('users/$uid').get();
  Map map = jsonDecode(jsonEncode(snapshot.value));
  return map;
}

