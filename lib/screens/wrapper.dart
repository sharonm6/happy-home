import 'package:happy_home/components/loading.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/screens/authenticate/authenticate.dart';
import 'package:happy_home/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:happy_home/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // // return either the Home or Authenticate widget
    // if (user == null) {
    //   return Authenticate();
    // } else if (user.uid.isEmpty) {
    //   return Loading();
    // } else {
    //   final databaseService = DatabaseService(uid: user.uid);

    //   return Home(user: user, databaseService: databaseService);
    // }

    if (user == null) {
      return Loading();
    } else {
      // User is not null, check the uid
      if (user.uid.isEmpty) {
        return Authenticate();
      } else {
        final databaseService = DatabaseService(uid: user.uid);
        return Home(
          user: user,
          databaseService: databaseService,
        );
      }
    }
  }
}
