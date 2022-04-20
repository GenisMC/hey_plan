import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? user;

  AuthService() {
    FirebaseAuth.instance.userChanges().listen((User? loggedUser) {
      user = loggedUser;
    });
  }

  /// Exit and delete current user data
  Future logout() async {
    user = null;
    return await FirebaseAuth.instance.signOut();
  }

  ///
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential).timeout(const Duration(seconds: 10));
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  Future updateDisplayName(String displayName) async {
    try {
      await user?.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return 1;
    }
    return 0;
  }

  Future registerEmail(String emailParam, String passParam) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailParam, password: passParam)
          .timeout(const Duration(seconds: 10));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return "La contraseña és demasiado sencilla";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return "La cuenta ya existe con ese correo";
      }
    } catch (e) {
      print(e);
    }
    return "Error de connexión";
  }

  Future loginWithEmail(String emailParam, String passParam) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailParam, password: passParam)
          .timeout(const Duration(seconds: 10));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No existe ese usuario';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'La contraseña no es correcta';
      }
    }
    return 'Error, vuelva a intentarlo mas tarde';
  }
}
