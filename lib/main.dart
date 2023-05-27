import 'package:happy_home/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:happy_home/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: User(
            uid: '',
          ),
          catchError: (context, error) {
            print('Error occurred: $error ');
            return User(uid: ''); // Provide a fallback user value
          },
        ),
      ],
      child: MaterialApp(home: Wrapper(), debugShowCheckedModeBanner: false),
    );
  }
}
