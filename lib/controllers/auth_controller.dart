import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/providers/user_provider.dart';
import 'package:flutter_mongo_lab1/varibles.dart';
import 'package:flutter_mongo_lab1/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController {

  Future<UserModel> login(
      BuildContext context, String username, String password) async {
    print(apiURL);

    final response = await http.post(Uri.parse("$apiURL/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ));
    print(response.statusCode);
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Response data: $data'); 
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      throw Exception('Error: Invalid response structure');
    }
  }

  Future<void> register(BuildContext context, String username, String password,
      String name, String role, String email) async {
    final Map<String, dynamic> registerData = {
      "username": username,
      "password": password,
      "name": name,
      "role": role,
      "email": email,
    };

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(registerData),
    );
    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print('Registration failed');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<void> refreshToken(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userProvider.refreshToken}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      final accessToken = data['accessToken'];
      userProvider.updateAccessToken(accessToken); 
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
