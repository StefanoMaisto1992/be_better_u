import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MentalCoaching extends StatefulWidget {
  const MentalCoaching({super.key});

  @override
  MentalCoachingState createState() => MentalCoachingState();
}

class MentalCoachingState extends State<MentalCoaching> {

  @override
  void initState() {
    super.initState();
    loadMotivationalQuotes().then((quotes) {
      setState(() {
        motivationalQuotes = quotes;
      });
    });
  }

  static List<String> motivationalQuotes = [];

  Future<List<String>> loadMotivationalQuotes() async {
    final String jsonString =
        await rootBundle.loadString('assets/utils/motivational_quotes.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> quotesList = jsonData['quotes'];
    return quotesList.cast<String>();
  }

  String? currentQuote;

  void generateMotivationalQuote() {
    final random = Random();
    setState(() {
      int randomIndex = random.nextInt(motivationalQuotes.length);
      // Ensure the same quote is not shown consecutively
      while (currentQuote == motivationalQuotes[randomIndex]) {
        randomIndex = random.nextInt(motivationalQuotes.length);
      }
      currentQuote = motivationalQuotes[randomIndex];
    });
  }

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'a_p.trainer@hotmail.com',
      query: 'subject=Mental Coaching&body=Scrivi qui il tuo messaggio',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Se non è possibile aprire il client email, mostra un messaggio di errore
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossibile aprire il client email.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mental Coaching'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        body: Container(
          // Wrap the entire body with a Container
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0), // Black
                Color.fromARGB(255, 220, 220, 220), // Light Grey
              ],
              begin: Alignment.topCenter, // Adjust gradient direction as needed
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentQuote != null)
                    Text(
                      currentQuote!,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: generateMotivationalQuote,
                    child: Text('Genera Frase Motivazionale'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: sendEmail,
                    child: Text('Invia una Mail'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
