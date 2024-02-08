import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:mypets_app/Components/Text_box.dart';

class CuentaP extends StatefulWidget {
  final String usr;
  CuentaP({required this.usr});

  @override
  State<CuentaP> createState() => _CuentaPState();
}

class _CuentaPState extends State<CuentaP> {
  Map<String, dynamic> userData = {}; // Inicializar userData con un mapa vacío
  late http.Client client;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    // Llamar a la función para cargar los datos del usuario cuando se inicie el widget
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Construir la URL completa con el usuario proporcionado
    String url = 'https://ginfinity.xyz/MyPets_Admin/servicios/sec/sec_usuario.php?accion=C&usr=${widget.usr}';

    try {
      // Realizar la solicitud HTTP
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, convertir la respuesta JSON en un mapa
        Map<String, dynamic> data = json.decode(response.body);
        // Imprimir los datos en la consola
        print('Datos del usuario: $data');
        // Actualizar el estado con los datos del usuario
        if (mounted) {
          setState(() {
            userData = {
              'Usuario': data['info'][0]['usr'],
              'Clave': data['info'][0]['clave'],
              'Nombre': data['info'][0]['nombre'],
              'Apellido': data['info'][0]['apellido'],
              'Email': data['info'][0]['email'],
            };
          });
        }
      } else {
        // Si la solicitud falla, mostrar un mensaje de error
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error: $error');
      // Puedes mostrar un mensaje de error al usuario aquí
    }
  }

  @override
  void dispose() {
    // Cerrar el cliente HTTP cuando se elimine el widget
    client.close();
    super.dispose();
  }

  // Editar Campo
  Future<void> editField(String field, BuildContext context) async {
    TextEditingController textController = TextEditingController(text: userData[field]);

    String? newValue = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Editar " + field),
        content: field == 'Clave'
            ? TextField(
                controller: textController,
                obscureText: true, // Oculta el texto para la contraseña
              )
            : TextField(
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

    if (newValue != null && mounted) {
      setState(() {
        userData[field] = newValue;
      });
      // Enviar los datos actualizados al servidor
      _updateUserData();
    }
  }

  // Función para enviar los datos actualizados al servidor
  Future<void> _updateUserData() async {
  // Construir la URL para la actualización de datos
  String url = 'https://ginfinity.xyz/MyPets_Admin/servicios/sec/sec_usuario.php';
  // Crear el cuerpo de la solicitud con los datos actualizados
  Map<String, String> body = {
    'accion': 'U',
    'usr': widget.usr,
    'clave': userData['Clave'],
    'nombre': userData['Nombre'],
    'apellido': userData['Apellido'],
    'email': userData['Email'],
  };

  try {
    // Realizar la solicitud HTTP
    final response = await client.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      // Imprimir mensaje de éxito en la consola
      print('Datos actualizados correctamente');
    } else {
      // Si la solicitud falla, mostrar un mensaje de error
      throw Exception('Failed to update user data');
    }
  } catch (error) {
    // Manejar errores de red u otros errores
    print('Error: $error');
    // Puedes mostrar un mensaje de error al usuario aquí
  }
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
                    text: userData.isNotEmpty ? userData['Usuario'] ?? '' : 'Cargando...', // Muestra el nombre de usuario si userData no está vacío
                    labelText: "Usuario",
                    onPressed: () => editField("Usuario", context),
                  ),

                  // Clave
                  MyTextBox(
                    text: userData.isNotEmpty ? '*' * (userData['Clave']?.length ?? 0) : 'Cargando...', // Muestra asteriscos para la contraseña si userData no está vacío
                    labelText: "Clave",
                    onPressed: () => editField("Clave", context),
                  ),

                  // Nombre
                  MyTextBox(
                    text: userData.isNotEmpty ? userData['Nombre'] ?? '' : 'Cargando...', // Muestra el nombre si userData no está vacío
                    labelText: "Nombre",
                    onPressed: () => editField("Nombre", context),
                  ),

                  // Apellido
                  MyTextBox(
                    text: userData.isNotEmpty ? userData['Apellido'] ?? '' : 'Cargando...', // Muestra el apellido si userData no está vacío
                    labelText: "Apellido",
                    onPressed: () => editField("Apellido", context),
                  ),

                  // Correo Electronico
                  MyTextBox(
                    text: userData.isNotEmpty ? userData['Email'] ?? '' : 'Cargando...', // Muestra el correo electrónico si userData no está vacío
                    labelText: "Correo Electrónico",
                    onPressed: () => editField("Email", context),
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
 
