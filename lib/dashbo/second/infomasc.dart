import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class infomasc extends StatelessWidget {
  final VoidCallback onClose;

  infomasc({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*QrImageView(
                data: 'FORTNITE ',
                version: QrVersions.auto,
                size: 200.0,
              ),*/
              SizedBox(height: 20.0),
              Text('Escanee el código QR'),
              ElevatedButton(
                onPressed: onClose,
                child: Text('CLICK DE VUELTA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}