import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet_model.dart';
import 'package:pet_adoption_app/providers/pet_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pits Adoption'),
      ),
      body: context.watch<PetProvider>().isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                context.watch<PetProvider>().loadPets();
              },
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: context.watch<PetProvider>().pets.length,
                itemBuilder: (BuildContext context, int index) {
                  var petProvider = context.watch<PetProvider>();
                  var pet = petProvider.pets[index];
                  var genderIcon;
                  var adopted;
                  if (pet.gender == 'female') {
                    genderIcon = Icon(Icons.female);
                  } else {
                    genderIcon = Icon(Icons.male);
                  }
                  if (pet.adopted) {
                    adopted = GridTileBar(
                      backgroundColor: Colors.white54,
                      title: Text(
                        'Adopted',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    adopted = null;
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridTile(
                      header: adopted,
                      footer: GridTileBar(
                        title: Text(
                          pet.name,
                        ),
                        subtitle: Text('Age: ${pet.age}'),
                        trailing: genderIcon,
                        backgroundColor: Colors.black45,
                      ),
                      child: Image.network(
                        pet.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
