import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Per caricare asset
import 'dart:convert'; // Per la decodifica del JSON
import 'package:be_better_u/Models/food_advice.dart';

// --- FoodAdvice: Pagina per i Consigli Alimentari ---
class FoodAdvice extends StatefulWidget {
  const FoodAdvice({super.key});

  @override
  _FoodAdviceState createState() => _FoodAdviceState();
}

class _FoodAdviceState extends State<FoodAdvice> {
  // Ora aspettiamo un Future di FitnessRecipes (dal file models.dart)
  late Future<FitnessRecipes> _foodAdviceDataFuture;

  @override
  void initState() {
    super.initState();
    _foodAdviceDataFuture = _loadFoodAdviceData();
  }

  // Funzione per caricare il JSON delle ricette di fitness
  Future<FitnessRecipes> _loadFoodAdviceData() async {
    try {
      final String response = await rootBundle
          .loadString('assets/utils/food_advice.json'); // Percorso al file JSON
      final data = json.decode(response);
      return FitnessRecipes.fromJson(
          data); // Parsing con il modello FitnessRecipes condiviso
    } catch (e) {
      debugPrint('Error loading or parsing Food Advice JSON: $e');
      rethrow;
    }
  }

  // Mappa i nomi delle categorie per la visualizzazione in italiano (copiato da HomePage per consistenza)
  String _mapCategoryName(String key) {
    switch (key) {
      case 'colazione':
        return 'Colazione';
      case 'pranzo':
        return 'Pranzo';
      case 'cene':
        return 'Cena';
      case 'spuntini':
        return 'Spuntini';
      default:
        return key;
    }
  }

  final String __backgroundImage =
      'https://images.unsplash.com/photo-1611599537845-1c7aca0091c0';

  // Restituisce un'icona appropriata per ogni categoria (copiato da HomePage per consistenza)
  IconData _getCategoryIcon(String categoryKey) {
    switch (categoryKey) {
      case 'colazione':
        return Icons.free_breakfast;
      case 'pranzo':
        return Icons.lunch_dining;
      case 'cene':
        return Icons.dinner_dining;
      case 'spuntini':
        return Icons.fastfood;
      default:
        return Icons.food_bank;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, // Estende il corpo dietro l'AppBar
        appBar: AppBar(
          title: Text('Consigli Alimentari',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white)),
          backgroundColor: Colors.transparent, // Rendi l'AppBar trasparente
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(__backgroundImage), // Immagine di sfondo
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(
                        0.5), // Colore nero con opacità per l'effetto overlay
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            FutureBuilder<FitnessRecipes>(
              // Il FutureBuilder si aspetta FitnessRecipes
              future: _foodAdviceDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    'Errore nel caricamento dei consigli: ${snapshot.error}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ));
                } else if (snapshot.hasData) {
                  final fitnessRecipes = snapshot.data!; // Ora sono le ricette

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Due colonne
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio:
                            0.9, // Rapporto per adattare il contenuto
                      ),
                      itemCount: fitnessRecipes.categorie.length,
                      itemBuilder: (context, index) {
                        final categoryKey =
                            fitnessRecipes.categorie.keys.elementAt(index);
                        final category = fitnessRecipes.categorie[categoryKey]!;
                        final mappedName = _mapCategoryName(categoryKey);
                        final icon = _getCategoryIcon(categoryKey);

                        return _FoodAdviceCategoryCard(
                          // Utilizza una card specifica per questa pagina
                          categoryName: mappedName,
                          icon: icon,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FoodAdviceCategoryRecipesPage(
                                  // Naviga a una pagina di dettaglio per FoodAdvice
                                  category: category,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                      child: Text('Nessuna ricetta disponibile.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white)));
                }
              },
            ),
          ],
        ));
  }
}

// Widget per la card della categoria nella pagina FoodAdvice (simile a _CategoryCard)
class _FoodAdviceCategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final VoidCallback onTap;

  const _FoodAdviceCategoryCard({
    required this.categoryName,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black, // Imposta il colore nero metallico
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: Colors.white, // Icona con colore primario
              ),
              const SizedBox(height: 16),
              Text(
                categoryName,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pagina per mostrare le ricette di una categoria specifica per FoodAdvice
class FoodAdviceCategoryRecipesPage extends StatelessWidget {
  final CategoriaRicette
      category; // Ora usa CategoriaRicette dal file models.dart

  const FoodAdviceCategoryRecipesPage({super.key, required this.category});

  static const List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1528712306091-ed0763094c98',
    'https://images.unsplash.com/photo-1501959915551-4e8d30928317',
    'https://images.unsplash.com/photo-1568158879083-c42860933ed7',
    'https://images.unsplash.com/photo-1459162141474-3bd9d0fb079d',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Estende il corpo dietro l'AppBar
      appBar: AppBar(
        title: Text(
          '${category.nomeCategoria[0].toUpperCase()}${category.nomeCategoria.substring(1)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent, // Rendi l'AppBar trasparente
        elevation: 0, // Rimuovi l'ombra dell'AppBar
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_backgroundImages[
                    category.ricette.length % _backgroundImages.length]),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Effetto overlay scuro
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0).copyWith(top: kToolbarHeight + MediaQuery.of(context).padding.top + 16.0),
            itemCount: category.ricette.length,
            itemBuilder: (context, index) {
              final ricetta = category
                  .ricette[index]; // Ora usa Ricetta dal file models.dart
              return Card(
                color: Colors.black54, // Colore nero metallico
                elevation: 4.0, // Effetto ombra
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(
                      color: Colors.white, width: 1.0), // Cornice bianca
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ExpansionTile(
                  title: Text(
                    ricetta.nome,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    ricetta.descrizione,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredienti:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          ...ricetta.ingredienti.map((ing) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '• $ing',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              )),
                          const SizedBox(height: 16),
                          Text(
                            'Istruzioni:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          ...ricetta.istruzioni
                              .asMap()
                              .entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '${entry.key + 1}. ${entry.value}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
