import 'package:hey_plan/Services/fire_auth.dart';
import 'package:hey_plan/Services/fire_store.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton instance = Singleton._privateConstructor();

  final AuthService auth = AuthService();
  final FireStore storage = FireStore();
}
