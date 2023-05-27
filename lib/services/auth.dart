import 'package:happy_home/models/user.dart';
import 'package:happy_home/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // create user obj based on firebase user
  User? _userFromFirebaseUser(firebase_auth.User? user,
      {String name = '', String email = ''}) {
    return User(
        uid: user?.uid ?? '',
        name: name,
        email: email,
        hasCar: false,
        isDarkMode: false,
        cookiesSaved: true,
        localStorageSaved: true,
        geolocationEnabled: true,
        isVegetarian: false,
        isVegan: false);
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(name, email);
      return _userFromFirebaseUser(user, name: name, email: email);
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
