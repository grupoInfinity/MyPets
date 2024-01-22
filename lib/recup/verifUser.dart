import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mypets_app/recup/verifPin.dart';

import '../contanst/app_contanst.dart';

class verifUser extends StatelessWidget {
  final TextEditingController txtUser = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String usuario = "";

  Future<void> logear(BuildContext context, String usr) async {
    try {
      final url = 'http://ginfinity.xyz/MyPets_Admin/servicios/'
          'sec/sec_usuario.php?accion=C&usr=$usr&estado=A';
      final response = await http.get(Uri.parse(url));
      //logger.d('Solicitando datos a: $url');
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);

        if (user['status'] == 1) {
          List<dynamic> infoList = user['info'];

          if (infoList.isNotEmpty) {
            usuario = infoList[0]['usr'];
            final url2 =
                'http://ginfinity.xyz/MyPets_Admin/servicios/sec/sec_usuario.php?accion=U' +
                    '&usorig=$usuario&user=$usuario';
            final response2 = await http.get(Uri.parse(url2));
            if (response2.statusCode == 200) {
              final url3 =
                  'http://ginfinity.xyz/MyPets_Admin/servicios/sec/sec_usuario.php?'
                  'accion=C&usr=$usuario';
              final response3 = await http.get(Uri.parse(url3));
              if (response3.statusCode == 200) {
                Map<String, dynamic> user2 = json.decode(response3.body);
                if (user2['status'] == 1) {
                  List<dynamic> infoList2 = user2['info'];
                  if (infoList2.isNotEmpty) {
                    final url4 =
                        'http://ginfinity.xyz/MyPets_Admin/servicios/PHPMailer.php?user=' +
                            infoList2[0]['usr'] +'&pin=' +infoList2[0]['pin'] +
                            '&email=' +infoList2[0]['email'];
                    final response4 = await http.get(Uri.parse(url4));
                    alerta(context, 'Verifique su bandeja de correos');


                    /*Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => verifPin(usr: usuario),
                        ));*/
                  }
                }
              }
            }
          } else {
            // Mostrar un mensaje de alerta si la lista está vacía
            Fluttertoast.showToast(
              msg: "Credenciales incorrectas",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          // Mostrar un mensaje de alerta si el estado no es 1
          Fluttertoast.showToast(
            msg: "Credenciales incorrectas",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        // Mostrar un mensaje de alerta si la solicitud no es exitosa
        Fluttertoast.showToast(
          msg: "Error en la respuesta: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error: $e");
      //logger.e('Error: $e');
    }
  }
  void alerta(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita cerrar tocando fuera del cuadro de diálogo
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => verifPin(usr: usuario),
                  ),
                ); // Cerrar la alerta
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
                  "Recuperacion de contraseña",
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
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtUser,
                        decoration: const InputDecoration(
                            labelText: "Usuario",
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon:
                            Icon(Iconsax.user, color: Colors.white)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Complete el campo';
                          }
                          return null; // La validación pasó
                        },
                      ),

                      const SizedBox(height: TSizes.spacebtwSections),

                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(41, 150, 189, 1),
                              Color.fromRGBO(41, 150, 189, 1)
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            //AQUI
                            if (_formKey.currentState!.validate()) {
                              logear(context, txtUser.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Campos invalidos')),
                              );
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Confirmar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
}
