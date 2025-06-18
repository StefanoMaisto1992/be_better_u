import 'package:flutter/material.dart';
import 'package:be_better_u/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onLoginTapped;

  const RegistrationPage({super.key, required this.onLoginTapped});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Auth _auth = Auth(); 

  void _register() async { // Reso asincrono
    if (_formKey.currentState!.validate()) {
      print('Registrazione con: Email: ${_emailController.text}, Password: ${_passwordController.text}');

      try {
        await _auth.createAccountWithMailAndPwd(
          email: _emailController.text,
          password: _passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account creato con successo! Ora puoi accedere.')),
        );
        // Potresti voler reindirizzare l'utente alla pagina di login dopo la registrazione
        widget.onLoginTapped(); 
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Questa email è già in uso. Prova ad accedere o usa un\'altra email.';
            break;
          case 'weak-password':
            message = 'La password è troppo debole.';
            break;
          case 'invalid-email':
            message = 'L\'indirizzo email non è valido.';
            break;
          case 'network-request-failed':
            message = 'Errore di connessione. Controlla la tua rete.';
            break;
          default:
            message = 'Errore di registrazione: ${e.message}';
            break;
        }
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrati'),
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
                  Icons.person_add,
                  size: 100,
                  color: const Color.fromARGB(255, 233, 36, 29),
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
                    hintText: 'Crea la tua password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Per favore, crea una password';
                    }
                    if (value.length < 6) {
                      return 'La password deve essere di almeno 6 caratteri';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Conferma Password',
                    hintText: 'Conferma la tua password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Per favore, conferma la tua password';
                    }
                    if (value != _passwordController.text) {
                      return 'Le password non corrispondono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Registrati'),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: widget.onLoginTapped,
                  child: const Text('Hai già un account? Accedi!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}