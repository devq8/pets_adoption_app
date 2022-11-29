import 'package:dio/dio.dart';

class Client {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://coded-pets-api-crud.herokuapp.com/pets/',
    ),
  );
}

class AuthClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://coded-pets-api-auth.herokuapp.com/',
    ),
  );
}
