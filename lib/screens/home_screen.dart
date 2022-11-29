import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adoption_app/providers/pet_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pits Adoption'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          context.push('/add');
        },
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
                shrinkWrap: false,
                padding: EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.7,
                ),
                itemCount: context.watch<PetProvider>().pets.length,
                itemBuilder: (BuildContext context, int index) {
                  var petProvider = context.watch<PetProvider>();
                  var pet = petProvider.pets[index];
                  var genderIcon;

                  if (pet.gender == 'female') {
                    genderIcon = Icon(Icons.female);
                  } else {
                    genderIcon = Icon(Icons.male);
                  }
                  return Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GridTile(
                              footer: Container(
                                height: 45,
                                child: GridTileBar(
                                  title: Text(
                                    pet.name,
                                  ),
                                  subtitle: Text('Age: ${pet.age}'),
                                  trailing: genderIcon,
                                  backgroundColor: Colors.black45,
                                ),
                              ),
                              child: Image.network(
                                pet.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // if (!pet.adopted)
                      //   ElevatedButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           context.read<PetProvider>().patchPet(
                      //                 pet: pet,
                      //                 adopted: true,
                      //               );
                      //         });
                      //       },
                      //       child: Text("Adopt")),

                      ElevatedButton(
                        onPressed: pet.adopted
                            ? null
                            : () {
                                setState(() {
                                  context.read<PetProvider>().patchPet(
                                        pet: pet,
                                        adopted: true,
                                      );
                                });
                              },
                        child: pet.adopted ? Text("Adopted") : Text('Adopt'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                context.push('/edit', extra: pet);
                              },
                              child: Icon(Icons.edit)),
                          ElevatedButton(
                              onPressed: () =>
                                  context.read<PetProvider>().deletePet(pet.id),
                              child: Icon(Icons.delete)),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
