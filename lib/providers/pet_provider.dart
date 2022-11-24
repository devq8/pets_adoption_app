import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

    Dio client = Dio();

    try {
      var response =
          await client.get('https://coded-pets-api-crud.herokuapp.com/pets');

      var body = response.data as List;
      pets = body
          .map(
            (json) => Pet.fromJson(json),
          )
          .toList();
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}
