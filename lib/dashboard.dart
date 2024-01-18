import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class dashboard extends StatelessWidget {
  final String usr;

  dashboard({required this.usr});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Text('Bienvenido '+usr),
            ],
          ),
        ),
      ),
    );
  }
}