import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_adoption_app/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';

class EditPet extends StatefulWidget {
  EditPet({required this.pet, super.key});
  final Pet pet;

  @override
  State<EditPet> createState() => _EditPetState();
}

class _EditPetState extends State<EditPet> {
  final nameController = TextEditingController();

  final genderController = TextEditingController();
  final adoptedController = TextEditingController();

  final ageController = TextEditingController();

  File? imageFile;

  String? imageError;

  List<Text> adoption = <Text>[
    Text('Not Adopted'),
    Text('Adopted'),
  ];
  List<Icon> genderIcons = <Icon>[
    Icon(Icons.male),
    Icon(Icons.female),
  ];

  List<bool> gender = [];
  List<bool> adoptedList = [];
  bool adopted = false;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.pet.name;
    if (widget.pet.gender == 'male') {
      gender = [true, false];
    } else {
      gender = [false, true];
    }
    ageController.text = widget.pet.age;
    print(widget.pet.adopted);
    if (widget.pet.adopted) {
      adoptedList = [false, true];
    } else {
      adoptedList = [true, false];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet.name)),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text('Gender'),
              SizedBox(
                height: 10,
              ),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    if (index == 0) {
                      gender = [true, false];
                      genderController.text = 'male';
                    } else {
                      gender = [false, true];
                      genderController.text = 'female';
                    }
                    // for (int i = 0; i < _selectedWeather.length; i++) {
                    //   _selectedWeather[i] = i == index;
                    // }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.white,
                fillColor: Colors.blue[200],
                color: Colors.blue[400],
                isSelected: gender,
                children: genderIcons,
              ),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text('Age'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required!';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    if (index == 0) {
                      adoptedList = [true, false];
                      adopted = true;
                    } else {
                      adoptedList = [false, true];
                      adopted = false;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.white,
                fillColor: Colors.blue[200],
                color: Colors.blue[400],
                isSelected: adoptedList,
                children: adoption,
              ),
              SizedBox(
                height: 20,
              ),
              if (imageFile != null)
                Image.file(
                  imageFile!,
                  width: 200,
                  height: 200,
                )
              else
                Image.network(
                  widget.pet.image,
                  width: 200,
                  height: 200,
                ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  var file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (file == null) {
                    print('User did not select an image');
                    return;
                  }

                  setState(() {
                    imageFile = File(file!.path);
                    imageError = null;
                  });
                },
                child: Text('Add Image'),
              ),
              if (imageError != null)
                Text(
                  imageError!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imageFile == null) {
                    setState(() {
                      imageError = 'Required field!';
                    });
                  }

                  if (formKey.currentState!.validate() && imageFile != null) {
                    await context.read<PetProvider>().editPet(
                          id: widget.pet.id,
                          name: nameController.text,
                          gender: genderController.text,
                          age: ageController.text,
                          adopted: adopted,
                          image: imageFile!,
                        );
                    context.pop();
                  }
                },
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
