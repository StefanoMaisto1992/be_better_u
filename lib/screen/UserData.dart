import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataSection extends StatefulWidget {
  const UserDataSection({super.key});

  @override
  State<UserDataSection> createState() => _UserDataSectionState();
}

class _UserDataSectionState extends State<UserDataSection> {
  // Controller per i campi di testo dei dati utente
  final TextEditingController _firstNameController = TextEditingController(); // Nuovo controller
  final TextEditingController _lastNameController = TextEditingController();  // Nuovo controller
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserPersonalData(); // Carica i dati personali da Firestore all'inizializzazione
  }

  @override
  void dispose() {
    // Dispone i controller quando il widget viene rimosso per evitare perdite di memoria.
    _firstNameController.dispose(); // Dispone il nuovo controller
    _lastNameController.dispose();  // Dispone il nuovo controller
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Carica i dati personali (altezza, peso, età, nome, cognome) dell'utente da Firestore.
  Future<void> _loadUserPersonalData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Se non c'è un utente loggato, resetta i campi
      _firstNameController.clear();
      _lastNameController.clear();
      _heightController.clear();
      _weightController.clear();
      _ageController.clear();
      return;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // Usiamo setState per aggiornare l'interfaccia con i dati caricati
          setState(() {
            _firstNameController.text = (data['firstName'] ?? '').toString();
            _lastNameController.text = (data['lastName'] ?? '').toString();
            _heightController.text = (data['height'] ?? '').toString();
            _weightController.text = (data['weight'] ?? '').toString();
            _ageController.text = (data['age'] ?? '').toString();
          });
        }
      }
    } catch (e) {
      print('Errore durante il caricamento dei dati utente: $e');
      if (mounted) { // Controlla se il widget è ancora montato prima di mostrare lo SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento dati: $e')),
        );
      }
    }
  }

  // Salva i dati personali (altezza, peso, età, nome, cognome) dell'utente su Firestore.
  Future<void> _saveUserPersonalData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Devi essere loggato per salvare i dati.')),
        );
      }
      return;
    }

    try {
      final double? height = double.tryParse(_heightController.text);
      final double? weight = double.tryParse(_weightController.text);
      final int? age = int.tryParse(_ageController.text);
      final String firstName = _firstNameController.text.trim();
      final String lastName = _lastNameController.text.trim();


      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'firstName': firstName,
          'lastName': lastName,
          'height': height,
          'weight': weight,
          'age': age,
          'last_updated': FieldValue.serverTimestamp(), // Aggiunge un timestamp
        },
        SetOptions(merge: true), // Usa merge per non sovrascrivere altri campi esistenti
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dati salvati con successo!')),
        );
      }
    } catch (e) {
      print('Errore durante il salvataggio dei dati utente: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel salvataggio dati: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.6), // Sfondo leggermente trasparente
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'I Tuoi Dati',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _firstNameController,
              labelText: 'Nome',
              keyboardType: TextInputType.text,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _lastNameController,
              labelText: 'Cognome',
              keyboardType: TextInputType.text,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _heightController,
              labelText: 'Altezza (cm)',
              keyboardType: TextInputType.number,
              icon: Icons.height,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _weightController,
              labelText: 'Peso (kg)',
              keyboardType: TextInputType.number,
              icon: Icons.monitor_weight,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _ageController,
              labelText: 'Età (anni)',
              keyboardType: TextInputType.number,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveUserPersonalData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 251, 1, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.4),
                ),
                child: const Text(
                  'Salva Dati',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper per i campi di input
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 65, 48), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

// NUOVA PAGINA: UserDataPage per ospitare UserDataSection
class UserDataPage extends StatelessWidget {
  const UserDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'I Tuoi Dati',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1a2b3c), // Stesso colore del Drawer
        foregroundColor: Colors.white, // Colore dell'icona indietro
      ),
      body: Container(
        // Sfondo degradè per la pagina, simile a quello della LoginPage o del tema
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a2b3c), Color(0xFF2c3e50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          // Centra la sezione dati utente nella pagina
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: UserDataSection(), // Inseriamo qui il componente UserDataSection
          ),
        ),
      ),
    );
  }
}