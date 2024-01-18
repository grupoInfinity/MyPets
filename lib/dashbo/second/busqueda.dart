import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mypets_app/dashbo/second/infomasc.dart';

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
                code:qrText
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
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

  void _onQRViewCreated(QRViewController controller) {
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
            subpage=true;
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
    });
  }

  void _openQRScanner() {
    setState(() {
      qrText = textEditingController.text;
      resultScreenOpened = true;
    });

    if (qrText.isNotEmpty) {
        subpage=true;
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
}
