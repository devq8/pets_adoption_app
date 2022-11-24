import 'package:json_annotation/json_annotation.dart';

// part 'pet.g.dart';
@JsonSerializable()
class Pet {
  String name;
  bool adopted;
  String image;
  int age;
  String gender;

  Pet(
      {required this.name,
      required this.adopted,
      required this.image,
      required this.age,
      required this.gender});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      adopted: json['adopted'],
      image: json['image'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}
