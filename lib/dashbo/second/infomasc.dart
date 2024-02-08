import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
/*
class infomasc extends StatelessWidget {
  final VoidCallback onClose;
  final String code;

  infomasc({required this.onClose, required this.code});

  @override
  Widget build(BuildContext context) {
    return _TuPantalla(
      code: code,
      onClose: onClose,
    );
  }
}

class _TuPantalla extends StatefulWidget {
  final String code;
  final VoidCallback onClose;

  _TuPantalla({required this.code, required this.onClose});

  @override
  _TuPantallaState createState() => _TuPantallaState();
}*/

class infomasc extends StatefulWidget {
  final String code;
  final VoidCallback onClose;

  infomasc({required this.code, required this.onClose});

  @override
  _infomascState createState() => _infomascState();
}

class _infomascState extends State<infomasc> {
  Mascota mascota = Mascota(/*vacuna: []*/);
  List<Vacuna> items = [];
  TextEditingController txtCodigo = TextEditingController();
  TextEditingController txtNomb = TextEditingController();
  TextEditingController txtDir = TextEditingController();
  TextEditingController txtDepto = TextEditingController();
  TextEditingController txtMunicip = TextEditingController();
  TextEditingController txtTel = TextEditingController();
  TextEditingController txtMail = TextEditingController();
  TextEditingController txtNacim = TextEditingController();
  TextEditingController txtTipomasc = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isEnabled = false;
  double backgroundHeight = 0.0;
  int currentIndex = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    print('Widget reconstruido...');
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 19, 86, 202),
          title: Text(
            'Información mascota',
            style: TextStyle(color: Colors.white), // Cambia el color aquí
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: widget.onClose,
          ),
        ),
        body: GestureDetector(
          //onTap: _openImageInFullScreen,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TuContenidoWidget(),
        ));
  }

  Widget TuContenidoWidget() {
    // Construye aquí el contenido de tu página una vez que los datos estén cargados
    return Container(
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
              const SizedBox(height: TSizes.spacebtwSections),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    (mascota.foto == null)
                        ? Text(
                            'Imagen no seleccionada',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: GestureDetector(
                              onTap: _openImageInFullScreen,
                              child: Image.memory(
                                base64Decode(mascota.foto!),
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            ),
                          ),
                    SizedBox(height: 30.0),

                    TextFormField(
                      enabled: isEnabled,
                      controller: txtTipomasc,
                      decoration: const InputDecoration(
                        labelText: "Tipo mascota",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(Iconsax.pet, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtNomb,
                      decoration: const InputDecoration(
                        labelText: "Nombre de la mascota",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(Iconsax.textalign_justifycenter, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: TSizes.spacebtwInputFields),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtCodigo,
                      decoration: const InputDecoration(
                        labelText: "Codigo",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.archive_tick, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    //const SizedBox(height: TSizes.spacebtwInputFields),
                    SizedBox(height: 20),
                    Text(
                      'Dirección',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      enabled: isEnabled,
                      controller: txtDepto,
                      decoration: const InputDecoration(
                        labelText: "Departamento",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(Iconsax.map, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtMunicip,
                      decoration: const InputDecoration(
                        labelText: "Municipio",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(Iconsax.map, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtDir,
                      decoration: const InputDecoration(
                        labelText: "Residencia ",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.map_1, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtNacim,
                      decoration: const InputDecoration(
                        labelText: "Nacimiento ",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.timer, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Contacto',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtMail,
                      decoration: const InputDecoration(
                        labelText: "Email ",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.sms, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      enabled: isEnabled,
                      controller: txtTel,
                      decoration: const InputDecoration(
                        labelText: "Teléfono ",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.call, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vacunas',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: TSizes.spacebtwInputFields),
                        ],
                      ),
                    ),
                    Container(
                      height: 200, // Ajusta esta altura según sea necesario
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(items[index].nombrevacuna),
                              subtitle: Text(items[index].fechaCreacion),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImageInFullScreen() {
    if (mascota.foto != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: Colors.black.withOpacity(0.7),
              height: MediaQuery.of(context).size.height + backgroundHeight,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    imageProvider: _image != null
                        ? FileImage(_image!)
                        : mascota.foto != null
                            ? MemoryImage(base64Decode(mascota.foto!))
                            : AssetImage('assets/imagen_no_disponible.jpg')
                                as ImageProvider<Object>,
                    heroAttributes: PhotoViewHeroAttributes(tag: currentIndex),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> cargarDatos() async {
    try {
      await cargarVacuna();
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          final mascotaInfo = jsonResponse['info']?[0]['mascota'];
          setState(() {
            mascota = Mascota.fromJson(mascotaInfo);
            txtNomb.text = mascota.nmasc!;
            txtTipomasc.text = mascota.tipomasc!;
            txtDepto.text = mascota.depto!;
            txtMunicip.text = mascota.muni!;
            txtMail.text = mascota.mail!;
            txtCodigo.text = mascota.codigo!;
            txtDir.text = mascota.direccion!;
            print(txtDir.text+' '+mascota.direccion!);
            txtNacim.text = mascota.nacim!;
            txtTel.text = mascota.telefono!;

            isLoading = false;
          });
        } else {
          print("Error in API response: ${jsonResponse['status']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      isLoading = false;
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
            String fecha = result['fechacr'] ?? 'Fecha desconocida';
            Vacuna newItem = Vacuna(nombreVacuna, fecha);
            if (!items.contains(newItem)) {
              items.add(newItem);
            }
          }
          setState(() {});
        } else {
          print('La clave "info" no es una lista en la respuesta JSON.');
        }
      } else {}
    } catch (e) {
      print("Error: $e");
      // Manejar excepciones
    }
  }
}

class Vacuna {
  String nombrevacuna;
  String fechaCreacion;

  Vacuna(
    this.nombrevacuna,
    this.fechaCreacion,
  );
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
