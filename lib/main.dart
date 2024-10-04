import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/Page/addProduct_Page.dart';
import 'package:flutter_mongo_lab1/Page/Editproduct_Page.dart';
import 'package:flutter_mongo_lab1/Page/Admin.dart';

import 'package:flutter_mongo_lab1/Page/home_screen.dart';
import 'package:flutter_mongo_lab1/Page/login_screen.dart';
import 'package:flutter_mongo_lab1/Page/register.dart';
import 'package:flutter_mongo_lab1/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          title: 'Login Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/home': (context) => HomeScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterPage(),
            '/admin': (context) => HomeAdmin(),
            '/add_product': (context) => AddProductPage(),
          }),
    );
  }
}