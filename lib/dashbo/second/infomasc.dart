import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import '../../contanst/app_contanst.dart';

class Vacuna {
  String nombrevacuna;
  String fechaCreacion;

  Vacuna(this.nombrevacuna, this.fechaCreacion,);
}

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
  Mascota mascota = Mascota(/*vacuna: []*/);
  List<Vacuna> items = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
    fetchData();
  }

  Future<void> cargarDatos() async {
    try {
      final url =
          'http://192.168.1.11/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=${widget
          .code}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          final mascotaInfo = jsonResponse['info']?[0]['mascota'];
          setState(() {
            mascota = Mascota.fromJson(mascotaInfo);
          });
          /*print('Número de vacunas después de asignar a mascota: ${mascota.vacuna.length}');
            print('Detalles de la vacuna después de asignar a mascota: ${mascota.vacuna}');*/
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

  Future<void> fetchData() async {
    try {
      final url = 'http://192.168.1.11/MyPets_Admin/servicios/prc/prc_vacuna.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Verificar si la clave 'info' existe y es una lista
        if (jsonResponse.containsKey('info') && jsonResponse['info'] is List) {
          List<dynamic> results = jsonResponse['info'];

          items.clear();

          for (var result in results) {
            String nombreVacuna = result['nombrevacuna'] ?? 'Nombre Vacuna Desconocido';
            String fecha = result['fecha_creacion'] ?? 'Fecha desconocida';

            Vacuna newItem = Vacuna(nombreVacuna, fecha);

            if (!items.contains(newItem)) {
              items.add(newItem);
            }
          }
          setState(() {});
        } else {
          // Manejar el caso donde 'info' no es una lista
          print('La clave "info" no es una lista en la respuesta JSON.');
        }
      } else {
        // Manejar la respuesta de error si es necesario
      }
    } catch (e) {
      print("Error: $e");
      // Manejar excepciones
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador de mascotas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre de la mascota: ${mascota.nmasc}'),
                Text('Fecha de nacimiento: ${mascota.nacim}'),
                Text('Nombre de la mascota: ${mascota.depto}'),
                Text('Nombre de la mascota: ${mascota.muni}'),
                Text('Nombre de la mascota: ${mascota.nmasc}'),
                Text('Nombre de la mascota: ${mascota.nmasc}'),
                // Puedes agregar más detalles según sea necesario
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }

  /*
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
                        children: [
                          Expanded(
                            child: ListView.builder(
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
                          ),
                        ]
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
  }*/
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
/*,
        vacuna = (json['info']?[0]['mascota']?['vacuna'] as List<dynamic>?)
                ?.map((v) => Vacuna.fromJson(v))
                .toList() ??
            [];*/
}



