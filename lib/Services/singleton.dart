import 'package:hey_plan/Services/fire_auth.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton instance = Singleton._privateConstructor();

  final AuthService auth = AuthService();
}
