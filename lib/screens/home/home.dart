import 'package:flutter/material.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/config/color_constants.dart';
import 'package:happy_home/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/services/database.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.user, required this.databaseService});
  final User user;
  final DatabaseService databaseService;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int navBarIdx = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: widget.databaseService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User userInfo = snapshot.data!;
            return Scaffold(body: HomeScreen(user: userInfo));
          } else {
            return Scaffold(
              body: Center(
                child: Loading(),
              ),
            );
          }
        });
  }
}
