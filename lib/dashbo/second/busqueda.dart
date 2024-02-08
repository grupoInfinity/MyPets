import 'dart:convert';
import 'dart:math';

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

class _QRScannerScreenState extends State<busqueda> with SingleTickerProviderStateMixin {
  final String usr;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String qrText = "";
  bool subpage = false;
  bool resultScreenOpened = false;
  TextEditingController textEditingController = TextEditingController();
  Rect? qrRect;
  bool isLoading = false; // Estado para controlar la animación de carga
  late AnimationController _controller;
  late Animation<double> _animation;

  _QRScannerScreenState({required this.usr});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duración de la animación
    )..repeat(); // Repetir la animación indefinidamente

    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 116, 214),
      body: subpage
          ? infomasc(
          onClose: () {
            setState(() {
              subpage = false;
            });
          },
          code: qrText)
          : Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          if (qrRect != null)
            Positioned(
              left: qrRect!.left,
              top: qrRect!.top,
              width: qrRect!.width,
              height: qrRect!.height,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 3,
                  ),
                ),
                child: null,
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Introduce un código QR manualmente',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre el TextField y el botón
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
          // Widget de animación de carga
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Cambia el color aquí
              ),
            ),
        ],
      ),
    );
  }

  void _resetScanner() {
    if (controller != null) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _openQRScanner(BuildContext context) async {
    String enteredCode = textEditingController.text;

    if (enteredCode.isNotEmpty) {
      qrText = enteredCode;
      resultScreenOpened = true;

      await searchM(context, qrText);
    }
  }

  Future<void> searchM(BuildContext context, String code) async {
    try {
      setState(() {
        isLoading = true; // Activar animación de carga
      });

      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&estado=A&codigo=$code';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> masc = json.decode(response.body);
        if (masc['status'] == 1) {
          setState(() {
            subpage = true;
            resultScreenOpened = false;
          });
        } else {
          alerta(context, "Código no válido o inactivo");
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
    } finally {
      setState(() {
        isLoading = false; // Desactivar animación de carga
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !resultScreenOpened) {
        qrText = scanData.code!;
        resultScreenOpened = true;

        final double width = MediaQuery.of(context).size.width;
        final double height = MediaQuery.of(context).size.height;

        final double qrWidth = width * 0.6; // Ajusta según sea necesario
        final double qrHeight = qrWidth; // Asume un código QR cuadrado

        final double left = (width - qrWidth) / 2;
        final double top = (height - qrHeight) / 2;

        setState(() {
          qrRect = Rect.fromLTWH(left, top, qrWidth, qrHeight);
        });

        await searchM(context, qrText);
      }
    });
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
                Navigator.of(context).pop();
                _resetScanner();
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
