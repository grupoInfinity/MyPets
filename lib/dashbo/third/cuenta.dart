import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:mypets_app/Components/Text_box.dart';

class CuentaP extends StatefulWidget {
  final String usr;
  CuentaP({required this.usr}); 

  @override
  State<CuentaP> createState() => _CuentaPState();
}

class _CuentaPState extends State<CuentaP> {
  // User

  // Editar Campo
  Future<void> editField(String field, BuildContext context) async {
    TextEditingController textController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Editar " + field),
        content: TextField(
          controller: textController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newValue = textController.text;
              Navigator.of(context).pop(newValue); // Cierra la alerta y retorna el valor
            },
            child: Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra la alerta sin guardar
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Cuenta")),
        backgroundColor: Color.fromARGB(255, 30, 100, 219),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 46, 116, 214), // Color de fondo
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: TSizes.spacebtwInputFields),
                  // Icono de Usuario
                  Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(height: TSizes.defaultspace),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Text(
                      "Informacion de Usuario",
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: TSizes.spacebtwInputFields),

                  // Usuario
                  MyTextBox(
                    text: "Usuario",
                    sectionName: "Usuario",
                    onPressed: () => editField("Usuario", context),
                  ),

                  // Nombre
                  MyTextBox(
                    text: "Nombre",
                    sectionName: "Nombre",
                    onPressed: () => editField("Nombre", context),
                  ),

                  // Apellido
                  MyTextBox(
                    text: "Apellido",
                    sectionName: "Apellido",
                    onPressed: () => editField("Apellido", context),
                  ),

                  // Correo Electronico
                  MyTextBox(
                    text: "Correo Electronico",
                    sectionName: "Correo Electronico",
                    onPressed: () => editField("Correo Electronico", context),
                  ),

                  // Contraseña
                  MyTextBox(
                    text: "Contraseña",
                    sectionName: "Contraseña",
                    onPressed: () => editField("Contraseña", context),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
