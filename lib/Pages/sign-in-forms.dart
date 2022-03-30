import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _controllerPasswordCheck =
      TextEditingController();

  bool login = false;

  getTextBoxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.8; // Change width %
  }

  @override
  Widget build(BuildContext context) {
    return login ? loginForm() : registerForm();
  }

  AlertDialog responseDialog(String response) {
    return AlertDialog(
      title: const Text("Error de registro"),
      content: Text(response),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cerrar"))
      ],
    );
  }

  void register() async {
    if (_controllerPassword.text ==
        _controllerPasswordCheck.text) {
      var response = await singleton.auth.registerEmail(
          _controllerEmail.text, _controllerPassword.text);
      if (response is String) {
        showDialog(
            context: context,
            builder: (_) => responseDialog(response.toString()));
      } else {
        if(response != null) {
          Navigator.pushNamed(context, '/newuser');
        }
        else{
          showDialog(
              context: context,
              builder: (_) => responseDialog("Comprueva que el correo es valido"));
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (_) =>
              responseDialog("Las contraseñas no coinciden"));
    }
  }

  Widget loginForm() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("LOGIN",
                style: GoogleFonts.fredokaOne(
                    fontSize: 30, color: const Color(textColor))),
            TextButton(
                onPressed: () {
                  setState(() {
                    login = false;
                  });
                },
                child: const Text("Registrarse")),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(controller: _controllerEmail)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(
                      controller: _controllerPassword, obscureText: true)),
            ),
            ElevatedButton(
                onPressed: () async {
                  var response = await singleton.auth.loginWithEmail(
                      _controllerEmail.text, _controllerPassword.text);
                  if (response is String) {
                    showDialog(
                        context: context,
                        builder: (_) => responseDialog(response.toString()));
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
            Text("REGISTRO",
                style: GoogleFonts.fredokaOne(
                    fontSize: 30, color: const Color(textColor))),
            TextButton(
                onPressed: () {
                  setState(() {
                    login = true;
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
                    decoration:
                        const InputDecoration(border: OutlineInputBorder())),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(
                      controller: _controllerPassword,
                      obscureText: true,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                  width: getTextBoxWidth(context),
                  child: TextField(
                      controller: _controllerPasswordCheck,
                      obscureText: true,
                      onSubmitted: (String s){
                        register();
                      },
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()))),
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
