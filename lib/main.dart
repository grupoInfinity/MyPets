import 'package:flutter/material.dart';
import 'package:mypets_app/Splash.dart';
import 'package:mypets_app/login.dart';
import 'package:mypets_app/principal_screen.dart';
import 'package:mypets_app/registro.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
     '/':(context) => Splash(),
     '/login':(context) => login(),
     '/main': (context) => Principal(),
     '/registro': (context) => RegistroP(),
    },
  ));
}
