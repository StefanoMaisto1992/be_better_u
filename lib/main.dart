// ignore_for_file: deprecated_member_use

import 'package:be_better_u/auth.dart';
import 'package:be_better_u/screen/AuthPage.dart';
import 'package:be_better_u/screen/HomePage.dart';
import 'package:flutter/material.dart';
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
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be Better U',
      // Definizione del tema per abbinare il design del sito
      theme: ThemeData(
        brightness: Brightness.dark, // Tema scuro generale
        // Colore primario (usato raramente direttamente, ma imposta il tono)
        primaryColor: const Color(0xFF00060B), // Molto scuro, quasi nero

        // Sfondo generale dell'app
        scaffoldBackgroundColor: const Color(0xFF1A202C), // Sfondo principale scuro

        // Colore accento principale per i widget interattivi e il testo evidenziato
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 170, 46, 39), // Un verde/ciano brillante come colore seme
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255, 170, 46, 39), // Colore primario per i widget
          onPrimary: Colors.black, // Colore del testo/icone sui widget primari
          secondary: const Color.fromARGB(189, 247, 15, 2), // Colore secondario, simile all'accento
          onSecondary: Colors.black,
          // ignore: duplicate_ignore
          // ignore: deprecated_member_use
          background: const Color.fromARGB(255, 0, 1, 4), // Sfondo
          onBackground: Colors.white, // Colore testo su sfondo
          surface: const Color.fromARGB(255, 0, 0, 0), // Superfici come card, dialoghi
          onSurface: Colors.white70, // Testo su superfici
        ),

        // Tema per i campi di input (TextFormField)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromARGB(255, 82, 82, 83), // Sfondo più chiaro per i campi input
          labelStyle: const TextStyle(color: Colors.white70), // Colore etichetta
          hintStyle: TextStyle(color: Colors.grey[400]), // Colore testo suggerito
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Bordi arrotondati
            borderSide: BorderSide.none, // Nessun bordo visibile di default
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 230, 0, 0), // Bordo accento quando attivo
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.transparent, // Nessun bordo visibile quando non attivo
              width: 0,
            ),
          ),
        ),

        // Tema per i bottoni elevati (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 240, 14, 2), // Colore di accento per i bottoni
            foregroundColor: const Color.fromARGB(255, 253, 253, 253), // Testo biaco su button rosso
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bordi arrotondati
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Padding generoso
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Tema per i bottoni di testo (TextButton)
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 245, 242, 242), // Colore accento secondario per i link
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Tema per la barra dell'app (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A202C), // Sfondo della barra dell'app come lo sfondo principale
          elevation: 0, // Nessuna ombra per un look piatto
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Tema per le icone
        iconTheme: const IconThemeData(
          color: Colors.white, // Colore accento per le icone
          size: 24,
        ),
      ),
      home: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('✅ Firebase inizializzato correttamente'),
      ),
    );
  }
}
