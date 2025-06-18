import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
import 'LoginPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true; // Stato per mostrare la pagina di login o registrazione

  // Funzione per invertire lo stato e passare tra le pagine
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Restituisce la LoginPage o la RegistrationPage in base allo stato
    return showLoginPage
        ? LoginPage(onRegisterTapped: togglePages) // Passa la funzione per il passaggio
        : RegistrationPage(onLoginTapped: togglePages); // Passa la funzione per il passaggio
  }
}