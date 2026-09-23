class HeroNetworkEntity {
  //Atributos de identificações:
  final int id;
  final String name;
  final String image;

  //Atributos de habilidades:
  final int intelligence;
  final int strength;
  final int speed;
  final int durability;
  final int power;
  final int combat;

  //Atributos de gênero:
  final String gender;
  final String race;

  //Lista:
  final List<String> height;
  final List<String> weight;

  //Construtor:
  const HeroNetworkEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
  });

  factory HeroNetworkEntity.fromJson(Map<String, dynamic> json) {
    return HeroNetworkEntity(
      //Representação dos atributos de identificação do JSON:
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ? ['md'] ?? '',

      //Representação dos atributos de habilidades do JSON:
      intelligence: json['powerstats'] ? ['intelligence'] ?? 0,
      strength: json['powerstats'] ? ['strength'] ?? 0,
      speed: json['powerstats'] ? ['speed'] ?? 0,
      durability: json['powerstats'] ? ['durability'] ?? 0,
      power: json['powerstats'] ? ['power'] ?? 0,
      combat: json['powerstats'] ? ['combat'] ?? 0,

      //Representação dos atributos de gênero e raça do JSON:
      gender: json['appearance'] ? ['gender'] ?? '',
      race: json['appearance'] ? ['race'] ?? '',
      height: List<String>.from(
          json['appearance'] ? ['height'] ?? []
      ),
      weight: List<String>.from(
        json['appearance'] ? ['weight'] ?? []
      ),
    );
  }
}