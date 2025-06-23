// Modello per una singola ricetta
class Ricetta {
  final String nome;
  final String descrizione;
  final List<String> ingredienti;
  final List<String> istruzioni;

  Ricetta({
    required this.nome,
    required this.descrizione,
    required this.ingredienti,
    required this.istruzioni,
  });

  factory Ricetta.fromJson(Map<String, dynamic> json) {
    return Ricetta(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      ingredienti: List<String>.from(json['ingredienti']),
      istruzioni: List<String>.from(json['istruzioni']),
    );
  }
}

// Modello per una categoria di ricette (es. "colazione")
class CategoriaRicette {
  final String nomeCategoria;
  final List<Ricetta> ricette;

  CategoriaRicette({
    required this.nomeCategoria,
    required this.ricette,
  });

  factory CategoriaRicette.fromJson(String categoryName, List<dynamic> jsonList) {
    return CategoriaRicette(
      nomeCategoria: categoryName,
      ricette: jsonList.map((ricettaJson) => Ricetta.fromJson(ricettaJson)).toList(),
    );
  }
}

// Modello principale che contiene tutte le categorie di ricette
class FitnessRecipes {
  final Map<String, CategoriaRicette> categorie;

  FitnessRecipes({required this.categorie});

  factory FitnessRecipes.fromJson(Map<String, dynamic> json) {
    final Map<String, CategoriaRicette> parsedCategories = {};
    (json['ricette_fitness'] as Map<String, dynamic>).forEach((key, value) {
      parsedCategories[key] = CategoriaRicette.fromJson(key, value as List<dynamic>);
    });
    return FitnessRecipes(categorie: parsedCategories);
  }
}