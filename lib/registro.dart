import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RegistroP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: sRegistroP(),
    );
  }
}

class sRegistroP extends StatefulWidget {
  sRegistroP({Key? key});

  @override
  _RegistroPState createState() => _RegistroPState();
}

class _RegistroPState extends State<sRegistroP> {
  final TextEditingController txtNomb = TextEditingController();
  final TextEditingController txtApell = TextEditingController();
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtContra = TextEditingController();
  final TextEditingController txtTel = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool userExist = false;

  Future<void> verifUser(String usr) async {
    try {
      if (usr.isEmpty) {
        usr = ".¡¡?";
      }
      final url = 'http://192.168.1.11/MyPets_Admin/servicios/'
          'sec/sec_usuario.php?accion=C&usr=$usr';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        if (user['status'] == 1) {
          setState(() {
            userExist = true;
          });
        } else {
          setState(() {
            userExist = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                Text(
                  "Crea tu Cuenta en MyPets!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spacebtwSections),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: txtNomb,
                              expands: false,
                              decoration: const InputDecoration(
                                labelText: "Nombres",
                                prefixIcon: Icon(Iconsax.user),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Complete el campo';
                                }
                                return null; // La validación pasó
                              },
                            ),
                          ),
                          const SizedBox(width: TSizes.spacebtwInputFields),
                          Expanded(
                            child: TextFormField(
                              controller: txtApell,
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: "Apellidos",
                                  prefixIcon: Icon(Iconsax.user)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Complete el campo';
                                }
                                return null; // La validación pasó
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtUser,
                        decoration: const InputDecoration(
                            labelText: "Usuario",
                            prefixIcon: Icon(Iconsax.user1)),
                        onChanged: (value) {
                          // Llama a tu función de verificación en la base de datos aquí
                          verifUser(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Complete el campo';
                          } else if (userExist) {
                            return 'Usuario ya existe';
                          }
                          return null; // La validación pasó
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtEmail,
                        expands: false,
                        decoration: const InputDecoration(
                            labelText: "Correo Electrónico",
                            prefixIcon: Icon(Icons.email)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un correo electrónico';
                          } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                              .hasMatch(value)) {
                            return 'Por favor, ingrese un correo electrónico válido';
                          }
                          return null; // La validación pasó
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtTel,
                        expands: false,
                        decoration: const InputDecoration(
                            labelText: "Teléfono",
                            prefixIcon: Icon(Iconsax.activity)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Complete el campo';
                          }
                          return null; // La validación pasó
                        },
                      ),
                      TextFormField(
                        controller: txtContra,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Contraseña",
                            prefixIcon: Icon(Iconsax.password_check),
                            suffixIcon: Icon(Iconsax.eye_slash)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Complete el campo';
                          }
                          return null; // La validación pasó
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            print("Botón presionado");

                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Formulario válido, puedes proceder. ni')),
                              );
                              print(
                                  'Correo electrónico válido: ${txtEmail.text}');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Formulario invali. ni')),
                              );
                            }
                          },
                          child: Text("Crear Cuenta"),
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

