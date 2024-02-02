import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import '../../contanst/app_contanst.dart';
class Vacuna {
  String nombrevacuna;String fechaCreacion;
  Vacuna(
    this.nombrevacuna,this.fechaCreacion,
  );
}

class infomasc extends StatelessWidget {
  final VoidCallback onClose;
  final String code;
  infomasc({required this.onClose, required this.code});

  @override
  Widget build(BuildContext context) {
    return _TuPantalla(code: code,onClose: onClose,);
  }
}

class _TuPantalla extends StatefulWidget {
  final String code;
  final VoidCallback onClose;
  _TuPantalla({required this.code,required this.onClose});
  @override
  _TuPantallaState createState() => _TuPantallaState();
}
class _TuPantallaState extends State<_TuPantalla> {

  Mascota mascota = Mascota(/*vacuna: []*/);
  List<Vacuna> items = [];
  @override
  void initState() {
    super.initState();
    cargarDatos();
    cargarVacuna();
  }


  @override
  Widget build(BuildContext context) {
    if (mascota.estadodir == 'I') {
      print( mascota.estadodir);
      mascota.direccion = 'Pendiente';
      // Realizar acciones según sea necesario
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 163, 255),
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 19, 86, 202),
        title: Text('Informacion'),
        // Agregar el botón en la parte superior izquierda
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:widget.onClose,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             const SizedBox(height: TSizes.spacebtwSections),
            mascota.foto != null
                ? Image.memory(
              base64Decode(mascota.foto!),
              fit: BoxFit.cover,
              height: 200,
            )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Nombre de la mascota: ${mascota.nmasc}'),
                   const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Fecha de nacimiento: ${mascota.nacim}'),
                   const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Tipo: ${mascota.tipomasc}'),
                  const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Departamento: ${mascota.depto}'),
                   const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Municipio: ${mascota.muni}'),
                  const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Direccion: ${mascota.direccion}'),
                  const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Telefono: ${mascota.telefono}'),
                  const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Email: ${mascota.mail}'),
                   const SizedBox(height: TSizes.spacebtwInputFields),
                  Text('Codigo: ${mascota.codigo}'),
                  SizedBox(height: 30),
                  // Puedes agregar más detalles según sea necesario
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: Text(items[index].nombrevacuna),
                      subtitle: Text(items[index].fechaCreacion),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> cargarDatos() async {
    try {
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          final mascotaInfo = jsonResponse['info']?[0]['mascota'];
          setState(() {
            mascota = Mascota.fromJson(mascotaInfo);
          });
        } else {
          print("Error in API response: ${jsonResponse['status']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> cargarVacuna() async {
    try {
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_vacuna.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('info') && jsonResponse['info'] is List) {
          List<dynamic> results = jsonResponse['info'];
          items.clear();
          for (var result in results) {
            String nombreVacuna =
                result['nombrevacuna'] ?? 'Nombre Vacuna Desconocido';
            String fecha = result['fecha_creacion'] ?? 'Fecha desconocida';
            Vacuna newItem = Vacuna(nombreVacuna, fecha);
            if (!items.contains(newItem)) {
              items.add(newItem);
            }
          }
          setState(() {});
        } else {
          print('La clave "info" no es una lista en la respuesta JSON.');
        }
      } else {
      }
    } catch (e) {
      print("Error: $e");
      // Manejar excepciones
    }
  }

}

class Mascota {
  String? idmasc;
  String? idtpmasc;
  String? idmuni;
  String? iddepto;
  String? depto;
  String? muni;
  String? dueno;
  String? mail;
  String? telefono;
  String? nmasc;
  String? tipomasc;
  String? direccion;
  String? estadodir;
  String? nacim;
  String? foto;
  String? codigo;
  String? estado;


  //List<Vacuna> vacuna;

  Mascota({
    this.idmasc,
    this.idtpmasc,
    this.idmuni,
    this.iddepto,
    this.depto,
    this.muni,
    this.dueno,
    this.mail,
    this.telefono,
    this.nmasc,
    this.tipomasc,
    this.direccion,
    this.estadodir,
    this.nacim,
    this.foto,
    this.codigo,
    this.estado,
    //required this.vacuna,
  });



  Mascota.fromJson(Map<String, dynamic> json)
      : idmasc = json['idmasc'],
        idtpmasc = json['idtpmasc'],
        idmuni = json['idmuni'],
        iddepto = json['iddepto'],
        depto = json['depto'],
        muni = json['muni'],
        dueno = json['dueno'],
        mail = json['mail'],
        telefono = json['telefono'],
        nmasc = json['nmasc'],
        tipomasc = json['tipomasc'],
        direccion = json['direccion'],
        estadodir = json['estadodir'],
        nacim = json['nacim'],
        foto = json['foto'],
        codigo = json['codigo'],
        estado = json['estado'];
}
