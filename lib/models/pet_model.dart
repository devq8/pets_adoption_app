import 'package:json_annotation/json_annotation.dart';

// part 'pet.g.dart';
@JsonSerializable()
class Pet {
  int id;
  String name;
  bool adopted;
  String image;
  String age;
  String gender;

  Pet({
    required this.id,
    required this.name,
    required this.adopted,
    required this.image,
    required this.age,
    required this.gender,
  });
}
