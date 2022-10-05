
import 'package:firebase_auth/firebase_auth.dart';
class AuthenticateService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  get user => auth.currentUser;


  //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );
      print(auth.currentUser?.uid.toString());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await auth.signOut();

    print('signout');
  }

  // signUp(String email, String password) async{
  //   // http.Response response = await http.post(
  //   //     Uri.parse(_url),
  //   //     body: json.encode(
  //   //         {"email": email,
  //   //           "password": password,
  //   //           "returnSecureToken": true
  //   //         },
  //   //     ),
  //   // );
  //   print(response.body);
  // }
}