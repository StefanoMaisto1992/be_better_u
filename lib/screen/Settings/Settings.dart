import 'package:flutter/material.dart';
import 'package:be_better_u/auth.dart'; // Importa il file auth.dart per l'autenticazione

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  Future<String> _getAppVersion() async {
    // Simulate fetching app version
    await Future.delayed(Duration(seconds: 1));
    return '1.0.0'; // Replace with actual app version logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impostazioni'),
      ),
      body: Container(
        // Sfondo degradè per la pagina, simile a quello della LoginPage o del tema
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Version
                ListTile(
                  title: Text('App Version'),
                  subtitle: FutureBuilder<String>(
                    future: _getAppVersion(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error');
                      } else {
                        return Text(snapshot.data ?? 'Unknown');
                      }
                    },
                  ),
                  leading: Icon(Icons.info),
                ),
                Divider(color: Colors.white),

                // Change Password
                ListTile(
                  title: Text('Cambio password'),
                  leading: Icon(Icons.lock),
                  onTap: () {
                    // Navigate to change password screen
                  },
                ),
                Divider(color: Colors.white),

                // Delete Account
                ListTile(
                  title: Text('Delete Account'),
                  leading: Icon(Icons.delete),
                  onTap: () {
                    // Show confirmation dialog for account deletion
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Account'),
                        content: Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle account deletion
                              Navigator.of(context).pop();
                              Auth().signOut(); // Sign out the user
                              Auth()
                                  .deleteAccount(); // Call delete account method
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
