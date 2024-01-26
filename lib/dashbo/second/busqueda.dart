import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mypets_app/dashbo/second/infomasc.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../first/addmascota.dart';

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
  bool subpage2 = false;
  bool resultScreenOpened2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          subpage2 = true;
        },
        backgroundColor: const Color.fromARGB(255, 51, 163, 255),
        child: Icon(Icons.add),
      ),*/
      body: subpage
          ? infomasc(
              onClose: () {
                setState(() {
                  subpage = false;
                });
              },
              code: qrText)
          :/* subpage2
          ? AddMascota(
          onClose: () {
            setState(() {
              subpage2 = false;
            });
          },
          usr: widget.usr)
          : */Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (controller) =>
                          _onQRViewCreated(controller, context),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 60),
                          TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Introduce un código QR manualmente',
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              _openQRScanner(context);
                            },
                            child: Text('Buscar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _resetScanner() {
    setState(() {
      resultScreenOpened = false;
      qrText = "";
    });
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _openQRScanner(BuildContext context) async {
    String enteredCode = textEditingController.text;

    if (enteredCode.isNotEmpty) {
      setState(() {
        qrText = enteredCode;
        resultScreenOpened = true;
      });

      await searchM(context, qrText); // Esperar a que searchM termine

      if (subpage) {
        // Solo establecer subpage a true si la búsqueda fue exitosa
        setState(() {
          subpage = true;
          resultScreenOpened = false;
        });
      } else {
        // If searchM was not successful, reset scanner
        _resetScanner();
      }
    }
  }

  Future<void> searchM(BuildContext context, String code) async {
    try {
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&estado=A'
          '&codigo=$code';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> masc = json.decode(response.body);
        if (masc['status'] == 1) {
          // subpage se establecerá a true solo si la búsqueda fue exitosa
          subpage = true;
        } else {
          alerta(context, "Código no válido o inactivo", () {
            // Llamada a _resetScanner después de cerrar el cuadro de diálogo
            _resetScanner();
          });
        }
      } else {
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

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && !resultScreenOpened) {
        setState(() {
          qrText = scanData.code!;
          resultScreenOpened = true;
        });

        searchM(context, qrText); // Esperar a que searchM termine

        if (subpage) {
          // Solo establecer subpage a true si la búsqueda fue exitosa
          setState(() {
            subpage = true;
            resultScreenOpened = false;
          });
        } else {
          // If searchM was not successful, reset scanner
          _resetScanner();
        }
      }
    });
  }

  void alerta(BuildContext context, String mensaje, VoidCallback? callback) {
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
                Navigator.of(context).pop();
                if (callback != null) {
                  callback();
                } // Cerrar la alerta
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
