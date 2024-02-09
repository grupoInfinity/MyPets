
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:mypets_app/dashboard.dart';
import 'package:mypets_app/recup/verifUser.dart';
import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: login(),
      ),
    );

class login extends StatelessWidget {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtClave = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> logear(BuildContext context,String usr,String clave) async {
    try {
      final url = 'http://ginfinity.xyz/MyPets_Admin/servicios/sec/sec_usuario.php?accion=LP'
          '&usr=$usr&clave=$clave&estado=A';

      final response = await http.get(Uri.parse(url));
      //logger.d('Solicitando datos a: $url');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 1) {
          List<dynamic> infoList = jsonResponse['info'];

          if (infoList.isNotEmpty) {
            String usuario = infoList[0]['usr'];

            Navigator.push(
              context ,
              MaterialPageRoute(builder: (context) => dashboard(usr: usuario)),
            );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
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
              SizedBox(height: AppBar().preferredSize.height),
              // Alinea el contenido debajo del AppBar

              const SizedBox(height: TSizes.spacebtwSections),
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
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtUser,
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: "Usuario",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon:
                          Icon(Iconsax.user, color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Complete el campo';
                        }
                        return null; // La validación pasó
                      },
                    ),
                    const SizedBox(height: TSizes.spacebtwInputFields),
                    TextFormField(
                      controller: txtClave,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Clave",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Iconsax.password_check,
                              color: Colors.white),
                          suffixIcon:
                          Icon(Iconsax.eye_slash, color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Complete el campo';
                        }
                        return null; // La validación pasó
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
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
                                      logear(context,txtUser.text,txtClave.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Iniciar Sesión",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                GestureDetector(
                                  onTap: () {
                                    // Navegar a la nueva pantalla cuando se toca el texto
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => verifUser(),
                                      ),
                                    );

                                  },

                                  child: Text(
                                    "¿Se te olvidó la contraseña?",
                                    style: TextStyle(color: Colors.white, fontFamily: 'Abel'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
