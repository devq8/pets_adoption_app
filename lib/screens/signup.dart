import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adoption_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Signup')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(label: Text('Username')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field!';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(label: Text('Password')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field!';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration:
                        InputDecoration(label: Text('Confirm Password')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field!';
                      }
                      if (value != passwordController.text) {
                        return 'Password does not match!';
                      }
                      return null;
                    },
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var didSignup = await context.read<AuthProvider>().signup(
                            username: usernameController.text,
                            password: passwordController.text,
                          );
                      if (didSignup) {
                        context.go('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Sign up process was not successful!')));
                      }
                    }
                  },
                  child: Text('Sign Up Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
