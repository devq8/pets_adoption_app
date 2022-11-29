import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adoption_app/models/pet_model.dart';
import 'package:pet_adoption_app/providers/auth_provider.dart';
import 'package:pet_adoption_app/providers/pet_provider.dart';
import 'package:pet_adoption_app/screens/add_pet.dart';
import 'package:pet_adoption_app/screens/edit_pet.dart';
import 'package:pet_adoption_app/screens/signup.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var authProvider = AuthProvider();
  var isAuth = await authProvider.hasToken();

  print('isAuth is $isAuth');
  runApp(MyApp(
    authProvider: authProvider,
    initialRoute: isAuth ? '/home' : '/signup',
  ));
}

class MyApp extends StatelessWidget {
  //below variables are added
  final String initialRoute;
  final AuthProvider authProvider;

  MyApp({
    required this.initialRoute,
    required this.authProvider,
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //router is moved to be inside build widget
    final router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/signup',
          builder: ((context, state) => SignUp()),
        ),
        GoRoute(
          path: '/home',
          builder: ((context, state) => HomeScreen()),
        ),
        GoRoute(
          path: '/edit',
          builder: ((context, state) => EditPet(
                pet: state.extra as Pet,
              )),
        ),
        GoRoute(
          path: '/add',
          builder: ((context, state) => AddPet()),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PetProvider()),
        //Add the new Auth provider
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Pets Adoption',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: router,
      ),
    );
  }
}
