import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Pages/explore.dart';
import 'package:hey_plan/Pages/newuser.dart';
import 'package:hey_plan/Pages/plans.dart';
import 'package:hey_plan/Pages/profile.dart';
import 'package:hey_plan/Pages/scaffold.dart';
import 'package:hey_plan/Pages/sign-in-forms.dart';
import 'package:hey_plan/Pages/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      //locale: const Locale('es'),
      //localizationsDelegates: const [
      //  S.delegate,
      //  GlobalMaterialLocalizations.delegate,
      //  GlobalWidgetsLocalizations.delegate,
      //  GlobalCupertinoLocalizations.delegate
      //],
      //supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primaryColor: const Color(backgroundColor),
        scaffoldBackgroundColor: const Color(backgroundColor),
        appBarTheme: const AppBarTheme(color: Color(accentColor)),
        bottomAppBarColor: const Color(darkerAccentColor),
        hintColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(cursorColor)),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: const Color(textButtonColor))),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.black)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(inputBorderColor),width: inputBorderWidth)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(inputBorderColor),width: inputBorderWidth)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(inputBorderColorFocused),width: inputBorderWidth)
          ),
          labelStyle: TextStyle(
              color: Colors.black,
              fontSize: defaultFontSize,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: defaultFontSize,
          )

        ),
      ),
      routes: {
        '/': (context) => const StartPage(),
        '/scaffold': (context) => const ScaffoldPage(),
        '/profile': (context) => const ProfilePage(),
        '/plans': (context) => const PlansPage(),
        '/explore': (context) => const ExplorePage(),
        '/newuser': (context) => const NewUserPage(),
        '/signin': (context) => const SignInFormsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
