import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';

class RegistroP extends StatelessWidget {
  RegistroP({Key? key});
  final TextEditingController txtNomb = TextEditingController();
  final TextEditingController txtApell = TextEditingController();
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtContra = TextEditingController();
  final TextEditingController txtTel = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                                 enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                                 )
                              ),
                              
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce tu nombre.';
                                }
                                return null;
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
      prefixIcon: Icon(Iconsax.user),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(10, 59, 99, 1)),
      ),
    ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce tus apellidos.';
                                }
                                return null;
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
    prefixIcon: Icon(Iconsax.user1),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
  ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, introduce tu nombre de usuario.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtEmail,
                        expands: false,
                        decoration: const InputDecoration(
                            labelText: "Correo Electrónico",
                            prefixIcon: Icon(Iconsax.direct)
                            ,
                                  enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)
              ),
                                  )
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, introduce tu correo electrónico.';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(value)) {
                            return 'Por favor, introduce un correo electrónico válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtTel,
                        expands: false,
                        decoration: const InputDecoration(
                            labelText: "Teléfono",
                            prefixIcon: Icon(Iconsax.direct)
                            ,
                                  enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)
              ),
                                  )
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, introduce tu número de teléfono.';
                          }
                          // Puedes agregar una validación adicional según tus necesidades
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtContra,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Contraseña",
                            prefixIcon: Icon(Iconsax.password_check),
                            suffixIcon: Icon(Iconsax.eye_slash)
                            ,
                                  enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)
              ),
                                  )
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, introduce tu contraseña.';
                          }
                          // Puedes agregar una validación adicional según tus necesidades
                          return null;
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // La validación del formulario fue exitosa, puedes realizar acciones adicionales aquí
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Formulario válido, puedes proceder.')),
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
