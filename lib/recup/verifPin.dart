import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypets_app/login.dart';
import 'package:mypets_app/recup/cambiarC.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../design/alerta.dart';

class verifPin extends StatelessWidget {
  final String usr;

  verifPin({required this.usr});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool pinCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
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
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultspace),
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('android/assets/images/Logo3.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: AppBar().preferredSize.height),
                // Alinea el contenido debajo del AppBar
                Text(
                  "Ingrese el PIN",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium,
                ),
                const SizedBox(height: TSizes.spacebtwSections),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        onChanged: (value) {

                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Complete el campo';
                          }
                          return null; // La validación pasó
                        },
                        onCompleted: (value) {
                          // Validar el PIN cuando se completa la entrada
                          vPin(context,usr,value);
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          selectedColor: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<void> vPin(BuildContext context,String usr,String pin) async {
    try {
      final url = 'http://192.168.1.11/MyPets_Admin/servicios/'
          'sec/sec_usuario.php?accion=C&usr=$usr&pin=$pin';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        if (user['status'] == 1) {
            pinCorrect = true;
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => cambiarC(usr: usr),
              ),
            );
        } else {
            pinCorrect = false;
            alertas alert =alertas();
            alert.alerta(context, "PIN INCORRECTO");
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



}

