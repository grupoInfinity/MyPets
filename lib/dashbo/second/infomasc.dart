import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class infomasc extends StatelessWidget {
  final VoidCallback onClose;
  final String code;
  infomasc({required this.onClose,required this.code});

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
              Text('Bienvenido $code'),
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
  Future<void> searchM(String code) async {
    try {
      final url =
          'http://192.168.1.11/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=$code';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> masc = json.decode(response.body);
        if (masc['status'] == 1) {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => infomasc(onClose: onClose, code: code)),
          );*/
        } else {
          //alerta(context, "Codigo no valido o inactivo");
        }
      }
      else {
        Fluttertoast.showToast(
          msg: "Error en la respuesta: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}