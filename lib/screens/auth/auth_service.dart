import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signin method
  Future<UserCredential> login(String email, String password) async {
    var details = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return details;
  }

  //signup method
  Future<UserCredential> signup(String email, String password) async {
    var details = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return details;
  }
  //signout method

  logout() async {
    await _auth.signOut();
  }
}
