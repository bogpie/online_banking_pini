import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

// RO00 CODE
// EU00 CODE
Future<String> ibanToUid(String iban) async {
  final ref = FirebaseDatabase.instance.ref();

  final DataSnapshot usersSnapshot = await ref.child('users').get();
  Map usersMap = jsonDecode(jsonEncode(usersSnapshot.value));

  MapEntry userEntry = usersMap.entries.firstWhere(
    (element) =>
        element.key
            .toString() //
            .substring(1, 4) ==
        iban.substring(4, 7),
  );

  return userEntry.key;
}
