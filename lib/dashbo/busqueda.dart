import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final String usr;
  QRScannerScreen({required this.usr});
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState(usr: usr);
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final String usr;
  _QRScannerScreenState({required this.usr});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = "";
  bool resultScreenOpened = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
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
                  child: Text('Escanear QR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(result: qrText,usr: usr),
            ),
          ).then((_) {
            setState(() {
              resultScreenOpened = false;
            });
          });
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: qrText,usr: usr),
        ),
      ).then((_) {
        setState(() {
          resultScreenOpened = false;
        });
      });
    }
  }
}

class ResultScreen extends StatelessWidget {
  final String result;
  final String usr;

  ResultScreen({required this.result,required this.usr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
      ),
      body: Center(
        child: Text('Resultado: $result , Bienvenido $usr' ),
      ),
    );
  }
}

