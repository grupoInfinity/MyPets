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
  Mascota mascota = Mascota(vacunas: []);

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> mascData = json.decode(response.body);
        if (mascData['status'] == 1) {
          setState(() {
            mascota = Mascota.fromJson(mascData['info'][0]['mascota']);
            print("Número de vacunas: ${mascota.vacunas.length}");
            print("Respuesta JSON: $mascData");
          });
        } else {
          //alerta(context, "Codigo no valido o inactivo");
        }
      } else {
        // Error en la respuesta
        // Puedes manejar el error de la forma que prefieras
        // Aquí estoy usando Fluttertoast para mostrar un mensaje
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
                        children: mascota.vacunas.map((vacuna) {
                          return Card(
                            child: ListTile(
                              title: Text('Nombre de la vacuna: ${vacuna.nombrevacuna}'),
                              subtitle: Text('Fecha de la vacuna: ${vacuna.fechaCreacion ?? ""}'),
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
  List<Vacuna> vacunas;

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
    required this.vacunas,
  });

  Mascota.fromJson(Map<String?, dynamic> json)
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
        vacunas = (json['vacunas'] as List<dynamic>? ?? [])
            .map((v) => Vacuna.fromJson(v))
            .toList();
}

class Vacuna {
  String? idvacuna;
  String? idmascota;
  String? idtipovacuna;
  String? nombrevacuna;
  String? fechaCreacion;

  Vacuna({
    this.idvacuna,
    this.idmascota,
    this.idtipovacuna,
    this.nombrevacuna,
    this.fechaCreacion,
  });

  Vacuna.fromJson(Map<String?, dynamic> json)
      : idvacuna = json['idvacuna'],
        idmascota = json['idmascota'],
        idtipovacuna = json['idtipovacuna'],
        nombrevacuna = json['nombrevacuna'],
        fechaCreacion = json['fecha_creacion'];
}