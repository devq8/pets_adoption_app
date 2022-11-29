import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_adoption_app/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';

class AddPet extends StatefulWidget {
  AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final nameController = TextEditingController();

  final genderController = TextEditingController();

  final ageController = TextEditingController();

  File? imageFile;

  String? imageError;

  List<Widget> genderIcons = <Widget>[
    Icon(Icons.male),
    Icon(Icons.female),
  ];

  List<bool> gender = [true, false];

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Pet')),
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
              if (imageFile != null)
                Image.file(
                  imageFile!,
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
                    imageFile = File(file.path);
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

                  if (formKey.currentState!.validate()) {
                    await context.read<PetProvider>().addPet(
                          name: nameController.text,
                          gender: genderController.text,
                          age: ageController.text,
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
