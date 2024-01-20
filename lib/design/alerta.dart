import 'package:flutter/material.dart';

class alertas{
  void alerta(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Información Importante",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          content: Text(
            mensaje,
            style: TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar la alerta
              },
              child: Text(
                "Aceptar",
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
