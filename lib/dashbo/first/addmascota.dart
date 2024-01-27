import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:slidable_button/slidable_button.dart';

class AddMascota extends StatefulWidget {
  final VoidCallback onClose;
  final String usr;
  AddMascota({required this.onClose, required this.usr});

  @override
  _AddMascotaState createState() => _AddMascotaState();
}

class _AddMascotaState extends State<AddMascota> {

  File? _image;
  Future<void> _getImageFromCamera() async {
    final pickedFile =await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  String _convertImageToBase64(File image) {
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
  late List<Departamento> departamentos= [];
  late List<Municipio> municipios= [];
  int selectedDepartamentoId = 0;
  //bool activado = false;
  String activado ="";
  TextEditingController txtCodigo = TextEditingController();
  TextEditingController txtNomb = TextEditingController();
  TextEditingController txtDir = TextEditingController();

  @override
  void initState() {
    super.initState();
    departamentos = [];
    municipios = [];
    loadDepartamentos();
  }

  //loadDepartamentos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 86, 202),
        title: Text('Registro de mascota'),
        // Agregar el botón en la parte superior izquierda
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:widget.onClose,
        ),
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
                SizedBox(height: AppBar().preferredSize.height),
                Center(
                  child: Text(
                    "Crea un nuevo perfil para tu mascota ${widget.usr}",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: TSizes.spacebtwSections),
                Form(
                  child: Column(
                    children: [
                      DropdownButton<int>(
                        value: selectedDepartamentoId,
                        items: departamentos.map((departamento) {
                          return DropdownMenuItem<int>(
                            value: departamento.id,
                            child: Text(departamento.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDepartamentoId = value!;
                            loadMunicipios(selectedDepartamentoId);
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        value:  municipios != null && municipios.isNotEmpty
                            ? "${municipios[0].nombre} (${municipios[0].departamentoId})" : '',
                        items: municipios?.map((municipio) {
                          return DropdownMenuItem<String>(
                            value: "${municipio.nombre} (${municipio.departamentoId})",
                            child: Text(municipio.nombre),
                          );
                        }).toSet().toList() ?? [],
                        onChanged: (value) {
                          // Hacer algo con el municipio seleccionado
                          print('Municipio seleccionado: $value');
                        },
                      ),
                      TextFormField(
                        controller: txtNomb,
                        decoration: const InputDecoration(
                          labelText: "Nombre de la mascota",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: Icon(Iconsax.user, color: Colors.white),
                        ),
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
                          prefixIcon: Icon(Iconsax.user, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        controller: txtDir,
                        decoration: const InputDecoration(
                          labelText: "Direccion ",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Iconsax.user1, color: Colors.white),
                        ),
                      ),
                      //Text('Estado: ${activado ? 'Activo' : 'Inactivo'}'),
                      SizedBox(height: 20),
                      HorizontalSlidableButton(
                        width: MediaQuery.of(context).size.width / 3,
                        buttonWidth: 60.0,
                        //color: Theme.of(context).accentColor.withOpacity(0.5),
                        buttonColor: Theme.of(context).primaryColor,
                        dismissible: false,
                        label: Center(child: Text('Slide Me')),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Left'),
                              Text('Right'),
                            ],
                          ),
                        ),
                        onChanged: (position) {
                          setState(() {
                            if (position == SlidableButtonPosition.start) {
                              activado = 'I';
                            } else {
                              activado = 'A';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: "Campo 4",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: "Campo 5",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon:
                              Icon(Iconsax.activity, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Campo 6",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon:
                              Icon(Iconsax.password_check, color: Colors.white),
                        ),
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
                          onPressed: () {},
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
    );
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
      print('Departamentos: $departamentos');
      print('Municipios cargados: $municipios');
      setState(() {

      });
    } catch (e) {
      print('Error loading municipios: $e');
    }
  }
  Future<List<Departamento>> getDepartamentos() async {
    final response =
    await http.get(Uri.parse('https://ginfinity.xyz/MyPets_Admin/servicios/ctg/ctg_depto.php?accion=C&estado=A'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> departamentosData = data['info'];

      return departamentosData.map((json) => Departamento.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departamentos');
    }
  }

  Future<List<Municipio>> getMunicipios(int departamentoId) async {
    final response = await
    http.get(Uri.parse('http://ginfinity.xyz//MyPets_Admin/servicios/ctg/ctg_muni.php?accion=C&estado=A&idDepto=$departamentoId'));
    /*final response = await
    http.get(Uri.parse('http://192.168.1.11//MyPets_Admin/servicios/ctg/ctg_muni.php?accion=C&estado=A&idDepto=$departamentoId'));
*/
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> municipiosData = data['info'];

      return municipiosData.map((json) => Municipio.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load municipios');
    }/*
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Municipio.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load municipios');
    }*/
  }
}


class Departamento {
  final int id;
  final String nombre;

  Departamento({required this.id, required this.nombre});

  // Método para convertir un mapa a un objeto Departamento
  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(id: int.parse(json['id']), nombre: json['descripcion']);
  }
}

class Municipio {
  final int id;
  final String nombre;
  final int departamentoId;

  Municipio({required this.id, required this.nombre, required this.departamentoId});

  // Método para convertir un mapa a un objeto Municipio

  factory Municipio.fromJson(Map<String, dynamic> json) {
   /* int id = int.parse(json/*['id']*/['id']);
    print("ID: $id");*/
    return Municipio(
      id: int.parse(json['id']['id']),
      nombre: json['descripcion'],
      departamentoId: int.parse(json['id']['id_depto'])
      /*id: int.parse(json['id']),
      nombre: json['descripcion'],
      departamentoId: int.parse(json/*['id']*/['id_depto']),*/
    );
  }
}
