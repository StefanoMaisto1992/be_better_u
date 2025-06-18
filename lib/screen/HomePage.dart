import 'package:be_better_u/screen/UserData.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core per l'inizializzazione

// HomePage è uno StatefulWidget perché lo sfondo cambierà dinamicamente.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista di URL di immagini di sfondo. In un'app reale, potresti caricarle da un servizio o averle come asset locali.
  // Ho usato placeholder images per la dimostrazione.
  final List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1434596922112-19c563067271',
    'https://images.unsplash.com/photo-1517438322307-e67111335449',
    'https://images.unsplash.com/photo-1517838277536-f5f99be501cd',
    'https://images.unsplash.com/photo-1519505907962-0a6cb0167c73',
  ];

  late String _currentBackgroundImage;
   String _userDisplayName = 'Utente'; // Variabile per il nome/email dell'utente

  @override
  void initState() {
    super.initState();
    // Seleziona un'immagine di sfondo casuale all'inizializzazione dello stato.
    _currentBackgroundImage = _backgroundImages[Random().nextInt(_backgroundImages.length)];
     _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        // Preferisce il displayName se disponibile, altrimenti usa l'email.
        // Se entrambi sono nulli, rimane "Utente".
        _userDisplayName = user.displayName ?? user.email ?? 'Utente';
      });
    } else {
      setState(() {
        _userDisplayName = 'Utente'; // Reset se l'utente non è loggato
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estendi il corpo per occupare l'intera altezza, inclusa l'area sotto l'AppBar.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'APTrainer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Rende la barra trasparente
        elevation: 0, // Nessuna ombra
        iconTheme: const IconThemeData(color: Colors.white), // Colore icona del Drawer
      ),
      // Il Drawer per il menu laterale.
      drawer: Drawer(
        backgroundColor: const Color(0xFF1a2b3c), // Colore di sfondo scuro come il sito di riferimento
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header del Drawer con un'immagine o un logo.
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2c3e50), // Colore più scuro per l'header
                // Puoi aggiungere un'immagine qui se desideri:
                // image: DecorationImage(
                //   image: NetworkImage('URL_DELLA_TUA_IMMAGINE_QUI'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // L'icona dell'utente o un'immagine di profilo
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30, color: Color(0xFF1a2b3c)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ciao \n$_userDisplayName', // Messaggio di benvenuto
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Voci del menu.
              _buildDrawerItem(
              icon: Icons.person, // Icona aggiornata
              text: 'I Tuoi Dati',
              onTap: () {
                Navigator.pop(context); // Chiude il drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserDataPage()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.fitness_center,
              text: 'Aggiungi scheda di allenamento',
              onTap: () {
                Navigator.pop(context); // Chiude il drawer
                // TODO: Naviga alla pagina "Aggiungi scheda di allenamento"
              },
            ),
            _buildDrawerItem(
              icon: Icons.shopping_bag,
              text: 'Prodotti consigliati',
              onTap: () {
                Navigator.pop(context);
                // TODO: Naviga alla pagina "Prodotti consigliati"
              },
            ),
            _buildDrawerItem(
              icon: Icons.food_bank,
              text: 'Consigli alimentari',
              onTap: () {
                Navigator.pop(context);
                // TODO: Naviga alla pagina "Consigli alimentari"
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Impostazioni',
              onTap: () {
                Navigator.pop(context);
                // TODO: Naviga alla pagina "Impostazioni"
              },
            ),
            const Divider(color: Colors.white54), // Divisore per separare le voci
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Esci',
              onTap: () async {
                Navigator.pop(context); // Chiude il drawer
                await FirebaseAuth.instance.signOut(); // Esegue il logout
                // Non c'è bisogno di setState qui, _loadUserData verrà chiamato
                // automaticamente quando il AuthWrapper ricostruirà HomePage o mostrerà LoginPage.
                // Dopo il logout, l'StreamBuilder in MyApp rileverà l'utente nullo e reindirizzerà.
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Sfondo dinamico con un effetto di transizione
          AnimatedSwitcher(
            duration: const Duration(seconds: 1), // Durata della transizione
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey<String>(_currentBackgroundImage), // Chiave per permettere ad AnimatedSwitcher di rilevare il cambio
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_currentBackgroundImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Sovrapposizione scura per rendere il testo leggibile
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          // Contenuto della pagina, centrato o posizionato sopra lo sfondo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Benvenuto in APTrainer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Il tuo percorso verso una vita più sana',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Pulsante di esempio
                ElevatedButton(
                  onPressed: () {
                    // Puoi aggiungere qui la logica per iniziare un workout o navigare
                    // Per la dimostrazione, cambia lo sfondo per mostrare la dinamicità
                    setState(() {
                      _currentBackgroundImage = _backgroundImages[Random().nextInt(_backgroundImages.length)];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 1, 1),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Inizia l\'allenamento',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper per costruire le voci del Drawer.
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white12, // Colore al passaggio del mouse/tocco
    );
  }
}

// Classe per una pagina di login di esempio.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accedi o Registrati'),
        backgroundColor: const Color(0xFF1a2b3c),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a2b3c), Color(0xFF2c3e50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Benvenuto in APTrainer!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Per continuare, accedi o registrati.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    // Logica di esempio per l'accesso anonimo (solo per test)
                    try {
                      await FirebaseAuth.instance.signInAnonymously();
                      // Dopo il login, StreamBuilder in MyApp reindirizzerà a HomePage.
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'operation-not-allowed') {
                        print('Anonymous auth hasn\'t been enabled for this project.');
                      }
                      print(e.message);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A67D8), // Blu-viola
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Accedi come Ospite (Demo)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Qui potresti aggiungere campi per email/password e pulsanti di login/registrazione reali.
                TextButton(
                  onPressed: () {
                    // TODO: Naviga alla pagina di registrazione o apri un dialogo
                  },
                  child: const Text(
                    'Non hai un account? Registrati',
                    style: TextStyle(
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Codice per una semplice app Flutter che utilizza HomePage.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inizializza Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APTrainer App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Colore primario generale
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Font generale per l'app, puoi importare Google Fonts come 'Poppins' o 'Open Sans'
        // se vuoi replicare più fedelmente lo stile del sito.
        fontFamily: 'Roboto', // Sostituisci con il font desiderato
        scaffoldBackgroundColor: Colors.black, // Background nero per il contorno
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          headlineSmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
        ),
        // Stile per i pulsanti (simile al sito di riferimento)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color(0xFF5A67D8), // Blu-viola
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      // Qui gestiamo la logica di routing condizionale
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Ascolta i cambiamenti dello stato di autenticazione
        builder: (context, snapshot) {
          // Se la connessione è in attesa (sta ancora controllando lo stato di autenticazione)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color(0xFF1a2b3c),
            );
          }
          // Se c'è un errore
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Si è verificato un errore di autenticazione.', style: TextStyle(color: Colors.white)),
              ),
              backgroundColor: Color(0xFF1a2b3c),
            );
          }
          // Se c'è un utente loggato (snapshot.hasData è true e snapshot.data non è nullo)
          if (snapshot.hasData && snapshot.data != null) {
            return const HomePage(); // Mostra la HomePage
          } else {
            // Nessun utente loggato, mostra la LoginPage
            return const LoginPage();
          }
        },
      ),
    );
  }
}
