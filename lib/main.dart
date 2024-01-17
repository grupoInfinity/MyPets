import 'package:flutter/material.dart';
import 'package:mypets_app/Splash.dart';
import 'package:mypets_app/login.dart';

void main(){
  runApp(MaterialApp(
    routes: {
     '/':(context) => Splash(),
     '/login':(context) => login(),
    },
  ));
}