import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/client.dart';
import 'package:pet_adoption_app/models/pet_model.dart';

class PetProvider extends ChangeNotifier {
  List<Pet> pets = [];

  bool isLoading = true;

  //Class Constructor
  PetProvider() {
    loadPets();
  }
  void loadPets() async {
    isLoading = true;
    notifyListeners();
    pets.clear();
    Dio client = Dio();

    try {
      var response =
          await client.get('https://coded-pets-api-crud.herokuapp.com/pets/');

      var petsJsonList = response.data as List;

      for (int i = 0; i < petsJsonList.length; i++) {
        var petJson = petsJsonList[i] as Map;
        var pet = Pet(
          id: petJson['id'],
          name: petJson['name'],
          adopted: petJson['adopted'],
          image: petJson['image'],
          age: petJson['age'].toString(),
          gender: petJson['gender'],
        );
        pets.add(pet);
      }
    } on DioError catch (e, st) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> editPet({
    required int id,
    required String name,
    required String gender,
    required String age,
    required bool adopted,
    required File image,
  }) async {
    var response = await Client.dio.put('${id}',
        data: FormData.fromMap({
          'name': name,
          'gender': gender,
          'age': age,
          'adopted': adopted,
          'image': await MultipartFile.fromFile(image.path),
        }));

    loadPets();
  }

  Future<void> patchPet({
    required Pet pet,
    String? name,
    String? gender,
    String? age,
    bool? adopted,
    File? image,
  }) async {
    var response = await Client.dio.patch('${pet.id}',
        data: FormData.fromMap({
          if (name != null) 'name': name,
          if (gender != null) 'gender': gender,
          if (age != null) 'age': age,
          if (adopted != null) 'adopted': adopted,
          if (image != null) 'image': await MultipartFile.fromFile(image.path),
        }));

    loadPets();
  }

  Future<void> addPet({
    required String name,
    required String gender,
    required String age,
    required File image,
  }) async {
    var response = await Client.dio.post('/',
        data: FormData.fromMap({
          'name': name,
          'gender': gender,
          'age': age,
          'adopted': false,
          'image': await MultipartFile.fromFile(image.path),
        }));

    loadPets();
  }

  void deletePet(int id) async {
    await Client.dio.delete('${id}');
    loadPets();
  }
}
