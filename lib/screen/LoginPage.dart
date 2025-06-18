import 'package:flutter/material.dart';
import 'package:be_better_u/auth.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class LoginPage extends StatefulWidget {
  final VoidCallback onRegisterTapped;

  const LoginPage({super.key, required this.onRegisterTapped});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   final Auth _auth = Auth();

   void _login() async { // Reso asincrono per poter usare await
    if (_formKey.currentState!.validate()) {
      // Puoi rimuovere questa print in produzione
      print('Login con: Email: ${_emailController.text}, Password: ${_passwordController.text}');

      try {
        await _auth.signInWithMailAndPwd(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Se il login ha successo, lo StreamBuilder in main.dart gestirà la navigazione
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Accesso effettuato con successo!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Nessun utente trovato con questa email.';
            break;
          case 'wrong-password':
            message = 'Password errata. Riprova.';
            break;
          case 'invalid-email':
            message = 'L\'indirizzo email non è valido.';
            break;
          case 'network-request-failed':
            message = 'Errore di connessione. Controlla la tua rete.';
            break;
          default:
            message = 'Errore di accesso: ${e.message}';
            break;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        // Cattura qualsiasi altro errore inatteso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Si è verificato un errore inaspettato: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accedi'),
        centerTitle: true,
        backgroundColor: Colors.grey[850], // Mantenuto il colore del tema
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.fitness_center,
                  size: 100,
                  color: const Color.fromARGB(255, 233, 29, 29),
                ),
                const SizedBox(height: 48),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Inserisci la tua email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Per favore, inserisci la tua email';
                    }
                    if (!value.contains('@')) {
                      return 'Per favore, inserisci un\'email valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Inserisci la tua password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Per favor, inserisci la tua password';
                    }
                    if (value.length < 6) {
                      return 'La password deve essere di almeno 6 caratteri';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Accedi'),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: widget.onRegisterTapped,
                  child: const Text('Non hai un account? Registrati!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}