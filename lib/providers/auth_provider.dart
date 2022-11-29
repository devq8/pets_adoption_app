import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pet_adoption_app/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? username;

  Future<bool> signup(
      {required String username, required String password}) async {
    try {
      //Sending the request to API
      var response = await AuthClient.dio.post('/signup', data: {
        'username': username,
        'password': password,
      });

      //Saving the token into a variable
      var token = response.data['token'];

      //Pluggin the token into the header for using the API
      Client.dio.options.headers[HttpHeaders.authorizationHeader] =
          'Bearer $token';

      this.username = username;

      //Create a preference in the memory
      var pref = await SharedPreferences.getInstance();
      //Save the token in the device
      await pref.setString('token', token);

      return true;
    } on DioError catch (error) {
      print(error.response!.data);
    } catch (error) {
      print(error);
    }

    return false;
  }

  Future<bool> hasToken() async {
    //Get the token from preference memory
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');

    //Check if the token is not available or expired => Don't give access
    if (token == null || JwtDecoder.isExpired(token)) {
      return false;
    }

    //If the token is available and not expired yet => get the username from the token and give access
    var tokenMap = JwtDecoder.decode(token);
    username = tokenMap['username'];
    return false;
  }
}
