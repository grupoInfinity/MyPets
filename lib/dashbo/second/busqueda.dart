import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mypets_app/dashbo/second/infomasc.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class busqueda extends StatefulWidget {
  final String usr;

  busqueda({required this.usr});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState(usr: usr);
}

class _QRScannerScreenState extends State<busqueda> {
  final String usr;

  _QRScannerScreenState({required this.usr});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = "";
  bool resultScreenOpened = false;
  TextEditingController textEditingController = TextEditingController();
  bool subpage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: subpage
            ? infomasc(
                onClose: () {
                  setState(() {
                    subpage = false;
                  });
                },
                code: qrText)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated:(controller) => _onQRViewCreated(controller, context),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Resultado: $qrText'),
                          SizedBox(height: 10),
                          TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Introduce un código QR manualmente',
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Abre el escáner QR manualmente
                              _openQRScanner();
                            },
                            child: Text('Buscar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  Future<void> searchM(BuildContext context, String code) async {
    try {
      final url =
          'http://192.168.1.11/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&estado=A'
          '&codigo=$code';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> masc = json.decode(response.body);
        if (masc['status'] == 1) {
          subpage = true;
          resultScreenOpened = false;
        } else {
          alerta(context, "Codigo no valido o inactivo");

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

  void _onQRViewCreated(QRViewController controller,BuildContext context) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && !resultScreenOpened) {
        setState(() {
          qrText = scanData.code!;
          resultScreenOpened = true;
        });

        if (qrText.isNotEmpty) {
          /*subpage = true;
          resultScreenOpened = false;*/
          searchM(context,qrText);
        }
      }
    });
  }

  void _openQRScanner() {
    setState(() {
      qrText = textEditingController.text;
      resultScreenOpened = true;
    });

    if (qrText.isNotEmpty) {
      subpage = true;
      resultScreenOpened = false;
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: qrText, usr: usr),
        ),
      ).then((_) {
        setState(() {
          resultScreenOpened = false;
        });
      });*/
    }
  }
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
                Navigator.of(context).pop();// Cerrar la alerta
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
