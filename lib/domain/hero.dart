class Hero {
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

  //Lista
  final List<String> height;
  final List<String> weight;

  const Hero({
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
}