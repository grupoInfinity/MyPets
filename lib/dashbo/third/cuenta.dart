import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';

class CuentaP extends StatelessWidget {
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Cuenta"), 
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            colors: [
              Color.fromRGBO(18, 69, 140, 1.0),
              Color.fromRGBO(110, 130, 158, 1.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
        

        ),
      ),
    );
  }
}
