import 'package:flutter/material.dart';
import 'package:mypets_app/Splash.dart';
import 'package:mypets_app/login.dart';
import 'package:mypets_app/principal_screen.dart';

void main(){
  runApp(MaterialApp(
    routes: {
     '/':(context) => Splash(),
     '/login':(context) => login(),
     '/main': (context) => Principal(),
    },
  ));
}