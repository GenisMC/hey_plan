import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Widgets/register_error.dart';
import '../Globals/globals.dart';
import '../Services/singleton.dart';

class SignInFormsPage extends StatefulWidget {
  const SignInFormsPage({Key? key}) : super(key: key);

  @override
  State<SignInFormsPage> createState() => _SignInFormsPageState();
}

class _SignInFormsPageState extends State<SignInFormsPage> {
  final Singleton singleton = Singleton.instance;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordCheck = TextEditingController();
  final PageController pageController = PageController();

  bool login = false;

  getTextBoxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.8; // Change width %
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [loginForm(), registerForm()],
      controller: pageController,
      scrollDirection: Axis.horizontal,
    );
    //return login ? loginForm() : registerForm();
  }

  void register() async {
    if (_controllerPassword.text == _controllerPasswordCheck.text) {
      var response = await singleton.auth.registerEmail(_controllerEmail.text, _controllerPassword.text);
      if (response is String) {
        showDialog(context: context, builder: (_) => RegisterErrorDialog(response: response.toString()));
      } else {
        if (response != null) {
          Navigator.pushNamed(context, '/newuser');
        } else {
          showDialog(
              context: context,
              builder: (_) => const RegisterErrorDialog(response: "Comprueva que el correo es valido"));
        }
      }
    } else {
      showDialog(context: context, builder: (_) => const RegisterErrorDialog(response: "Las contraseñas no coinciden"));
    }
  }

  Widget loginForm() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("LOGIN", style: GoogleFonts.fredokaOne(fontSize: 30, color: const Color(textColor))),
            TextButton(
                onPressed: () {
                  setState(() {
                    pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                  });
                },
                child: const Text("Registrarse")),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(
                    controller: _controllerEmail,
                    decoration: const InputDecoration(hintText: 'Correo'),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                width: getTextBoxWidth(context),
                child: TextField(
                    controller: _controllerPassword,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Contraseña')),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  var response = await singleton.auth.loginWithEmail(_controllerEmail.text, _controllerPassword.text);
                  if (response is String) {
                    showDialog(context: context, builder: (_) => RegisterErrorDialog(response: response.toString()));
                  } else {
                    Navigator.pushNamed(context, '/scaffold');
                  }
                },
                child: const Text("Entrar")),
          ],
        ),
      ),
    );
  }

  Widget registerForm() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("REGISTRO", style: GoogleFonts.fredokaOne(fontSize: 30, color: const Color(textColor))),
            TextButton(
                onPressed: () {
                  setState(() {
                    pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                  });
                },
                child: Text(
                  "Ya tengo cuenta",
                  style: GoogleFonts.fredokaOne(fontWeight: FontWeight.w100),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                width: getTextBoxWidth(context),
                child: TextField(
                    controller: _controllerEmail,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Correo')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(
                      controller: _controllerPassword,
                      obscureText: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Contraseña'))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(
                      controller: _controllerPasswordCheck,
                      obscureText: true,
                      onSubmitted: (String s) {
                        register();
                      },
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Repetir Contraseña'))),
            ),
            ElevatedButton(
                onPressed: () {
                  register();
                },
                child: const Text("Registrarse")),
          ],
        ),
      ),
    );
  }
}
