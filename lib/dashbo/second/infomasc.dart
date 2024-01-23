import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import '../../contanst/app_contanst.dart';


class infomasc extends StatelessWidget {
  final VoidCallback onClose;
  final String code;

  infomasc({required this.onClose, required this.code});

  @override
  Widget build(BuildContext context) {
    return _TuPantalla(code: code);
  }
}

class _TuPantalla extends StatefulWidget {
  final String code;

  _TuPantalla({required this.code});

  @override
  _TuPantallaState createState() => _TuPantallaState();
}

class _TuPantallaState extends State<_TuPantalla> {
  Mascota mascota = Mascota(vacuna: []);

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final url =
          'http://192.168.1.11/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));
      print(response.body);

      if (response.statusCode == 200) {
        // Parse the response JSON
        final jsonResponse = json.decode(response.body);

        // Print the number of vaccines before assigning to mascota
        print('Número de vacunas antes de asignar a mascota: ${jsonResponse['info']?[0]['vacuna']?.length}');
        print('Número de vacunas antes de asignar a mascota: ${jsonResponse['info']?[0]['vacuna']}');

        // Check the status in the response
        if (jsonResponse['status'] == 1) {
          // Update the state with the Mascota data
          setState(() {
            mascota = Mascota.fromJson(jsonResponse['info'][0]['mascota']);
          });

          // Print the number of vaccines after assigning to mascota
          print('Número de vacunas después de asignar a mascota: ${mascota.vacuna.length}');
        } else {
          // Handle the case where the status is not 1 (error)
          print("Error in API response: ${jsonResponse['status']}");
        }
      } else {
        // Handle HTTP errors here, e.g., show an error message
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      // Handle errors here, e.g., show an error message
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
                Text(
                  "Informacion",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
                Form(
                  child: Column(
                    children: [
                      Text('Codigo: ${mascota.codigo}'),
                      Text('Nombre de la mascota: ${mascota.nmasc}'),
                      Text('Fecha de nacimiento: ${mascota.nacim}'),
                      Text('Nombre de la mascota: ${mascota.depto}'),
                      Text('Nombre de la mascota: ${mascota.muni}'),
                      Text('Nombre de la mascota: ${mascota.nmasc}'),
                      Text('Nombre de la mascota: ${mascota.nmasc}'),

                      // Mostrar las vacunas en CardView
                      Column(
                        children: mascota.vacuna.map((vacuna) {
                          print(mascota.vacuna);
                          return Card(
                            child: ListTile(
                              title: Text(
                                  'Nombre de la vacuna: ${vacuna.nombrevacuna}'),
                              subtitle: Text(
                                  'Fecha de la vacuna: ${vacuna.fechaCreacion ?? ""}'),
                            ),
                          );
                        }).toList(),
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

class Mascota {
  String? idmasc;String? idtpmasc;String? idmuni;String? iddepto;String? depto;
  String? muni;String? dueno;String? mail;String? telefono;String? nmasc;
  String? tipomasc;String? direccion;String? estadodir;String? nacim;String? foto;
  String? codigo;String? estado;List<Vacuna> vacuna;

  Mascota({
    this.idmasc, this.idtpmasc, this.idmuni, this.iddepto, this.depto, this.muni,
    this.dueno, this.mail, this.telefono, this.nmasc, this.tipomasc, this.direccion,
    this.estadodir, this.nacim, this.foto, this.codigo, this.estado, required this.vacuna,
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
        estado = json['estado'],
        vacuna = ((json['info']?[0]['vacuna'] as List<dynamic>?) ?? [])
            .map((v) => Vacuna.fromJson(v))
            .toList();
}

class Vacuna {
  String? idvacuna;String? idmascota;String? idtipovacuna;String? nombrevacuna;String? fechaCreacion;

  Vacuna({
    this.idvacuna, this.idmascota, this.idtipovacuna, this.nombrevacuna, this.fechaCreacion,
  });

  Vacuna.fromJson(Map<String, dynamic> json)
      : idvacuna = json['idvacuna'],
        idmascota = json['idmascota'],
        idtipovacuna = json['idtipovacuna'],
        nombrevacuna = json['nombrevacuna'],
        fechaCreacion = json['fecha_creacion'] ?? "";
}
