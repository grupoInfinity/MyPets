import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  void initState(){
    super.initState();
    startTimer();
  }
 
   startTimer(){
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
   }

   route(){
    Navigator.pushReplacementNamed(context, '/login');
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(41, 150, 189, 1),
      body: content(),

    );
  }

  Widget content() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network('https://lottie.host/ed9ca44d-269d-4986-9e29-6c4d128abf61/8Tddlqbb3N.json'),
        ],
      ),
    );
  }
}