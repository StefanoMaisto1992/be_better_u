import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Ottiene l'utente attualmente loggato
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream che notifica i cambiamenti dello stato di autenticazione dell'utente
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Metodo per effettuare il login con email e password.
  ///
  /// Solleva `FirebaseAuthException` in caso di errori di autenticazione
  /// (es. credenziali errate, utente non trovato).
  Future<void> signInWithMailAndPwd({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Metodo per creare un nuovo account utente con email e password.
  ///
  /// Solleva `FirebaseAuthException` in caso di errori (es. email già in uso,
  /// password debole).
  Future<void> createAccountWithMailAndPwd({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  /// Metodo per effettuare il logout dell'utente corrente.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Metodo per inviare un'email di reset password all'indirizzo fornito.
  ///
  /// Solleva `FirebaseAuthException` se l'email non è registrata
  /// o ci sono altri problemi.
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Metodo per aggiornare l'email dell'utente corrente.
  ///
  /// Richiede che l'utente sia stato recentemente autenticato (entro un certo lasso di tempo)
  /// per motivi di sicurezza. Se l'autenticazione è scaduta, `reauthenticateWithCredential`
  /// potrebbe essere necessario prima.
  ///
  /// Solleva `FirebaseAuthException` in caso di errori.
  Future<void> updateEmail({required String newEmail}) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
          code: 'no-user-logged-in', message: 'Nessun utente loggato.');
    }
    await currentUser!.verifyBeforeUpdateEmail(newEmail);
  }

  /// Metodo per aggiornare la password dell'utente corrente.
  ///
  /// Simile all'aggiornamento dell'email, richiede una recente autenticazione.
  ///
  /// Solleva `FirebaseAuthException` in caso di errori.
  Future<void> updatePassword({required String newPassword}) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
          code: 'no-user-logged-in', message: 'Nessun utente loggato.');
    }
    await currentUser!.updatePassword(newPassword);
  }

  /// Metodo per riautenticare l'utente con nuove credenziali.
  ///
  /// Questo è cruciale prima di eseguire operazioni sensibili come
  /// l'aggiornamento di email/password o la cancellazione dell'account,
  /// soprattutto se l'ultima autenticazione è avvenuta troppo tempo fa.
  ///
  /// Accetta `AuthCredential` (es. EmailAuthProvider.credential).
  /// Solleva `FirebaseAuthException` in caso di credenziali non valide.
  Future<void> reauthenticateUser({required AuthCredential credential}) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
          code: 'no-user-logged-in', message: 'Nessun utente loggato.');
    }
    await currentUser!.reauthenticateWithCredential(credential);
  }

  /// Metodo per eliminare l'account dell'utente corrente.
  ///
  /// **ATTENZIONE:** Questa operazione è irreversibile.
  /// L'alert di sicurezza **non può essere gestito direttamente qui**,
  /// ma deve essere mostrato nella UI (ad esempio, usando un AlertDialog)
  /// **prima** di chiamare questo metodo.
  ///
  /// È altamente consigliato riautenticare l'utente prima di chiamare questo metodo
  /// per evitare errori 'requires-recent-login'.
  ///
  /// Solleva `FirebaseAuthException` in caso di errori.
  Future<void> deleteAccount() async {
    if (currentUser == null) {
      throw FirebaseAuthException(
          code: 'no-user-logged-in', message: 'Nessun utente loggato.');
    }
    await currentUser!.delete();
  }
}