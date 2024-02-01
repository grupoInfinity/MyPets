import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

class AddMascota extends StatefulWidget {
  final VoidCallback onClose;
  final String usr;

  AddMascota({required this.onClose, required this.usr});

  @override
  _AddMascotaState createState() => _AddMascotaState();
}

class _AddMascotaState extends State<AddMascota> {
  DateTime selectedDate = DateTime.now();
  File? _image;
  late List<Departamento> departamentos = [];
  late List<Municipio> municipios = [];
  late List<Tipomascota> tipomasc = [];
  int currentIndex = 0;
  String municp = "";
  TextEditingController txtCodigo = TextEditingController();
  TextEditingController txtNomb = TextEditingController();
  TextEditingController txtDir = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double backgroundHeight = 0.0;
  int selectedDepartamentoId = 1;
  int selectedtipomascId = 1;
  int selectedtmuniId = 1;
  bool codeExist = false;

  @override
  void initState() {
    super.initState();
    tipomasc = [];
    departamentos = [];
    municipios = [];
    loadTipomasc();
    loadDepartamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 19, 86, 202),
          title: Text(
            'Registro de mascota',
            style: TextStyle(
              color: Colors.white, // Color blanco para el texto
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: widget.onClose,
          ),
        ),
        body: GestureDetector(
          onTap: _openImageInFullScreen,
          child: Container(
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
                          Text(
                            'Tipo de mascota',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          DropdownButton<int>(
                            value: selectedtipomascId,
                            items: tipomasc.map((tipomasc) {
                              return DropdownMenuItem<int>(
                                value: tipomasc.id,
                                child: Text(
                                  tipomasc.nombre,
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedtipomascId = value!;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              // Icono de flecha hacia abajo
                              color: Colors
                                  .lightBlue, // Cambia el color según tus preferencias
                            ),
                          ),

                          SizedBox(height: 20),
                          TextFormField(
                            controller: txtNomb,
                            decoration: const InputDecoration(
                              labelText: "Nombre de la mascota",
                              labelStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon:
                                  Icon(Iconsax.user, color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Complete el campo';
                              }
                              return null; // La validación pasó
                            },
                          ),
                          SizedBox(height: TSizes.spacebtwInputFields),
                          TextFormField(
                            controller: txtCodigo,
                            decoration: const InputDecoration(
                              labelText: "Codigo",
                              labelStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon:
                                  Icon(Iconsax.user, color: Colors.white),
                            ),
                            onChanged: (value) {
                              // Llama a tu función de verificación en la base de datos aquí
                              verifCode(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Complete el campo';
                              } else if (codeExist) {
                                return 'Ese codigo ya existe';
                              }
                              return null; // La validación pasó
                            },
                          ),
                          //const SizedBox(height: TSizes.spacebtwInputFields),
                          SizedBox(height: 20),
                          Text(
                            'Direccion',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<int>(
                                  value: selectedDepartamentoId,
                                  items: departamentos.map((departamento) {
                                    return DropdownMenuItem<int>(
                                      value: departamento.id,
                                      child: Text(
                                        departamento.nombre,
                                        style:
                                            TextStyle(color: Colors.lightBlue),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDepartamentoId = value!;
                                      loadMunicipios(selectedDepartamentoId);
                                      print(selectedDepartamentoId);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    // Icono de flecha hacia abajo
                                    color: Colors
                                        .white, // Cambia el color según tus preferencias
                                  ),
                                ),
                              ),
                              const SizedBox(width: TSizes.spacebtwInputFields),
                              DropdownButton<int>(
                                value: selectedtmuniId,
                                items: municipios?.toSet().map((municipio) {
                                      return DropdownMenuItem<int>(
                                        value: municipio.id,
                                        child: Text(municipio.nombre,
                                            style: TextStyle(
                                                color: Colors.lightBlue)),
                                      );
                                    }).toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    selectedtmuniId = value ?? 0;
                                  });
                                  int selectedPosition = municipios?.indexWhere(
                                          (municipio) =>
                                              municipio.id ==
                                              selectedtmuniId) ??
                                      -1;
                                  print(
                                      'Seleccionado: $selectedtmuniId, Posición: $selectedPosition');
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  // Icono de flecha hacia abajo
                                  color: Colors
                                      .white, // Cambia el color según tus preferencias
                                ),
                              ),
                              //),*/
                            ],
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: txtDir,
                            decoration: const InputDecoration(
                              labelText: "Residencia ",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon:
                                  Icon(Iconsax.home, color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Complete el campo';
                              }
                              return null; // La validación pasó
                            },
                          ),
                          SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text('Nacimiento'),
                                ),
                              ),
                              const SizedBox(width: TSizes.spacebtwInputFields),
                              Expanded(
                                child: Text(
                                  '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          _image == null
                              ? Text(
                                  'Imagen no seleccionada',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )
                              : Image.file(
                                  _image!,
                                  height: 300.0,
                                ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _getImageFromCamera,
                                  child: Text('Tomar foto'),
                                ),
                              ),
                              const SizedBox(width: TSizes.spacebtwInputFields),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _getImageFromGallery,
                                  child: Text('Galeria'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                fixedSize: Size(0, 50),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_image != null) {
                                    Mascota nuevoMasc = Mascota(
                                        usr: widget.usr,
                                        tpmascota: selectedtipomascId,
                                        nombre: txtNomb.text,
                                        codigo: txtCodigo.text,
                                        municipio: selectedtmuniId,
                                        dir: txtDir.text,
                                        nacim:
                                            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                                        img: _image);
                                    //insertMasc(/*context,*/ nuevoMasc,);
                                    insertMasc(nuevoMasc, (response) {
                                      print(
                                          'Respuesta del servidor: $response');
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Imagen no seleccionada')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Campos vacios')),
                                  );
                                }
                              },
                              child: Text("Agregar Mascota"),
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
        ));
  }

  void insertMasc(Mascota usuario, Function callback) async {
    try {
      var url =
          'https://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Adjuntar imagen si está presente
      if (usuario.img != null) {
        var imageFile = File(usuario.img!.path);
        if (imageFile.existsSync()) {
          request.files
              .add(await http.MultipartFile.fromPath('fotor', imageFile.path));
        } else {
          print("Error: File does not exist at path: ${imageFile.path}");
          return;
        }
      }
      request.fields.addAll({
        'accionr': 'I',
        'tpmascotar': usuario.tpmascota.toString(),
        'duenor': usuario.usr,
        'munir': usuario.municipio.toString(),
        'direccionr': usuario.dir,
        'estadodirr': 'I',
        'nmascr': usuario.nombre,
        'codigor': usuario.codigo,
        'estador': 'A',
        'userr': usuario.usr,
        'nacimr': usuario.nacim,
      });

      // Enviar la solicitud usando el cliente HTTP local
      var response = await request.send();
      // Leer la respuesta del servidor
      var responseBody = await response.stream.bytesToString();
      // Decodificar el JSON de la respuesta
      var responseData = json.decode(responseBody);
      // Llamar al callback con la respuesta
      callback(responseData);
      // Verificar la respuesta
      if (response.statusCode == 200) {
        // Handle success response
        widget.onClose();
      } else {
        print("Error en la respuesta: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
      print('print $_image');
    });
  }

  void _openImageInFullScreen() {
    if (_image != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              // Cierra el diálogo al tocar el fondo negro
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: Colors.black.withOpacity(0.7),
              height: MediaQuery.of(context).size.height + backgroundHeight,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // Esta función se ejecutará cuando toques la imagen en pantalla completa
                    // Puedes realizar cualquier acción adicional aquí si es necesario
                    Navigator.pop(
                        context); // Cierra el diálogo al tocar la imagen
                  },
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent, // Cambiado a transparente
                    ),
                    imageProvider: FileImage(_image!),
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

  Future<void> loadTipomasc() async {
    try {
      tipomasc = await getTipomasc();
      setState(() {});
    } catch (e) {
      print('Error loading municipios: $e');
    }
  }

  Future<void> loadDepartamentos() async {
    try {
      departamentos = await getDepartamentos();
      setState(() {
        selectedDepartamentoId = departamentos[0].id;
      });
      loadMunicipios(selectedDepartamentoId);
    } catch (e) {
      print('Error loading departamentos: $e');
    }
  }

  Future<void> loadMunicipios(int departamentoId) async {
    try {
      municipios = await getMunicipios(departamentoId);
      setState(() {
        selectedtmuniId = municipios[0].id;
      });
    } catch (e) {
      print('Error loading municipios: $e');
    }
  }

  Future<List<Departamento>> getDepartamentos() async {
    final response = await http.get(Uri.parse(
        'https://ginfinity.xyz/MyPets_Admin/servicios/ctg/ctg_depto.php?accion=C&estado=A'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> departamentosData = data['info'];
      return departamentosData
          .map((json) => Departamento.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load departamentos');
    }
  }

  Future<List<Municipio>> getMunicipios(int departamentoId) async {
    final response = await http.get(Uri.parse(
        'http://ginfinity.xyz//MyPets_Admin/servicios/ctg/ctg_muni.php?accion=C&estado=A&idDepto=$departamentoId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> municipiosData = data['info'];

      return municipiosData.map((json) => Municipio.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load municipios');
    }
  }

  Future<List<Tipomascota>> getTipomasc() async {
    final response = await http.get(Uri.parse(
        'https://ginfinity.xyz//MyPets_Admin/servicios/ctg/ctg_tipomascota.php?accion=C&estado=A'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> tpmascData = data['info'];

      return tpmascData.map((json) => Tipomascota.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tipo mascota');
    }
  }

  Future<void> verifCode(String code) async {
    try {
      if (code.isEmpty) {
        code = ".¡¡?";
      }
      final url = 'http://ginfinity.xyz/MyPets_Admin/servicios/'
          'prc/prc_mascota.php?accion=C&codigo=$code';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        if (user['status'] == 1) {
          setState(() {
            codeExist = true;
          });
        } else {
          setState(() {
            codeExist = false;
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
}

class Departamento {
  final int id;
  final String nombre;

  Departamento({required this.id, required this.nombre});

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(id: int.parse(json['id']), nombre: json['descripcion']);
  }
}

class Municipio {
  final int id;
  final String nombre;
  final int departamentoId;

  Municipio(
      {required this.id, required this.nombre, required this.departamentoId});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
        id: int.parse(json['id']['id']),
        nombre: json['descripcion'],
        departamentoId: int.parse(json['id']['id_depto']));
  }
}

class Tipomascota {
  final int id;
  final String nombre;

  Tipomascota({required this.id, required this.nombre});

  factory Tipomascota.fromJson(Map<String, dynamic> json) {
    print(json['id'] + ' ' + json['descripcion']);
    return Tipomascota(
      id: int.parse(json['id']),
      nombre: json['descripcion'],
    );
  }
}

class Mascota {
  String usr;
  String codigo;
  int tpmascota;
  String nombre;
  int municipio;
  String dir;

  /*String stdir;String estado;*/
  String nacim;
  File? img;

  Mascota({
    required this.usr,
    required this.codigo,
    required this.tpmascota,
    required this.nombre,
    required this.municipio,
    required this.dir,
    /*required this.stdir,
    required this.estado,*/
    required this.nacim,
    required this.img,
  });
}
