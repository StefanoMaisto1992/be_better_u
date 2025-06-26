import 'package:be_better_u/screen/UserData.dart';
import 'AuthPage.dart'; // Importa la pagina di login
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:be_better_u/screen/FoodAdvice.dart'; // Importa la pagina FoodAdvice
import 'package:be_better_u/screen/MentalCoaching.dart'; // Importa la pagina MentalCoaching
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:be_better_u/screen/Settings/Settings.dart'; // Importa la pagina delle impostazioni

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
    'https://images.unsplash.com/photo-1709315872247-644b7ff5ed10',
    'https://images.unsplash.com/photo-1603734220970-25a0b335ca01',
    'https://images.unsplash.com/photo-1661548352777-c2ff8643a8d1',
    'https://images.unsplash.com/photo-1554454019-8a165b8a3bd8'
  ];

  late String _currentBackgroundImage;
  String _userDisplayName = 'Utente'; // Variabile per il nome/email dell'utente

  @override
  void initState() {
    super.initState();
    // Seleziona un'immagine di sfondo casuale all'inizializzazione dello stato.
    _currentBackgroundImage =
        _backgroundImages[Random().nextInt(_backgroundImages.length)];
    _updatUserInfo(); // Carica le informazioni dell'utente all'inizio
  }

  void _updatUserInfo() async {
    // Ricarica i dati dell'utente quando necessario, ad esempio dopo un login o un logout.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Se l'utente non è loggato, non fare nulla.
    } else {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists) {
        setState(() {
          // Usa il firstname e lastname se disponibili, altrimenti usa l'email.
          // Se entrambi sono nulli, rimane "Utente".
          final data = docSnapshot.data();
          if (data != null &&
              data['firstName'] != null &&
              data['lastName'] != null) {
            _userDisplayName = '${data['firstName']} ${data['lastName']}';
          } else {
            _userDisplayName = user.email ?? 'Utente';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estendi il corpo per occupare l'intera altezza, inclusa l'area sotto l'AppBar.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top / 2), // Adatta il padding
          child: const Text(
            'APTrainer',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(
            255, 0, 2, 4), // Colore di sfondo scuro come il sito di riferimento
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 0, 0, 0), // Colore più scuro per l'header
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // L'icona dell'utente o un'immagine di profilo
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 30, color: Color(0xFF1a2b3c)),
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
              icon: Icons.psychology,
              text: 'Mental coaching',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MentalCoaching()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.food_bank,
              text: 'Consigli alimentari',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FoodAdvice()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Impostazioni',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const Divider(
                color: Colors.white54), // Divisore per separare le voci
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Esci',
              onTap: () async {
                Navigator.pop(context); // Chiude il drawer
                await FirebaseAuth.instance.signOut(); // Esegue il logout
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (Route<dynamic> route) =>
                      false, // Rimuove tutte le route precedenti
                );
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
              key: ValueKey<String>(
                  _currentBackgroundImage), // Chiave per permettere ad AnimatedSwitcher di rilevare il cambio
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_currentBackgroundImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(
                        0.5), // Sovrapposizione scura per rendere il testo leggibile
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
                      _currentBackgroundImage = _backgroundImages[
                          Random().nextInt(_backgroundImages.length)];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 1, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: const Color.fromARGB(
          255, 255, 255, 255),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APTrainer App',
      // Qui gestiamo la logica di routing condizionale
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance
            .authStateChanges(), // Ascolta i cambiamenti dello stato di autenticazione
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
                child: Text('Si è verificato un errore di autenticazione.',
                    style: TextStyle(color: Colors.white)),
              ),
              backgroundColor: Color(0xFF1a2b3c),
            );
          }
          // Se c'è un utente loggato (snapshot.hasData è true e snapshot.data non è nullo)
          if (snapshot.hasData && snapshot.data != null) {
            return const HomePage(); // Mostra la HomePage
          } else {
            // Nessun utente loggato, mostra la LoginPage
            return const AuthPage();
          }
        },
      ),
    );
  }
}
