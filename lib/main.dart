import 'package:flutter/material.dart';
import 'login_page.dart';
int main(){

  runApp(new MyApp());

}

class MyApp extends StatelessWidget{


    @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samuel',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new LoginPage()
    );
  }

}

