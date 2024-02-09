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

class editmasc extends StatefulWidget {
  final VoidCallback onClose;
  final String usr;
  final String code;
  final String idmasc;

  editmasc(
      {required this.onClose,
      required this.code,
      required this.usr,
      required this.idmasc});

  @override
  _editmascState createState() => _editmascState();
}

class _editmascState extends State<editmasc> {
  late DateTime selectedDate;

  //DateTime selectedDate = DateTime.now();
  File? _image;
  late List<Departamento> departamentos = [];
  late List<Municipio> municipios = [];
  late List<Tipomascota> tipomasc = [];
  late List<Vacuna2> tipovac = [];
  String fechaEd = "";
  TextEditingController txtCodigo = TextEditingController();
  TextEditingController txtNomb = TextEditingController();
  TextEditingController txtDir = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double backgroundHeight = 0.0;
  int currentIndex = 0;
  int selectedDepartamentoId = 1;
  int selectedtipomascId = 1;
  int selectedtmuniId = 1;
  int selectedtipovacId = 1;
  bool codeExist = false;
  MascotaLoad mascota = MascotaLoad();
  List<Vacuna> items = [];
  bool isLoading = true;
  String estadom = '';

  @override
  void initState() {
    super.initState();
    tipomasc = [];
    departamentos = [];
    municipios = [];
    tipovac = [];
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    print('Widget reconstruido...');
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 19, 86, 202),
          title: Text('Información mascota',style: TextStyle(color: Colors.white), ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: widget.onClose,
          ),
        ),
        body: GestureDetector(
          onTap: _openImageInFullScreen,
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
                    (_image == null && mascota.foto == null)
                        ? Text(
                            'Imagen no seleccionada',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )
                        : (_image != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.file(
                                  _image!,
                                  height: 300.0,
                                ),
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

                    const SizedBox(height: 30),
                    Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey,
                                onPrimary: Colors.white,
                              ),
                              onPressed: _getImageFromCamera,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.spacebtwInputFields),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey,
                                onPrimary: Colors.white,
                              ),
                              onPressed: _getImageFromGallery,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.0),
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
                        Icons.arrow_drop_down, // Icono de flecha hacia abajo
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
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        prefixIcon: Icon(Iconsax.textalign_justifycenter, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.archive_tick, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
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
                      'Dirección',
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
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDepartamentoId = value!;
                                loadMunicipios(selectedDepartamentoId);
                                //print(selectedDepartamentoId);
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
                                      style:
                                          TextStyle(color: Colors.lightBlue)),
                                );
                              }).toList() ??
                              [],
                          onChanged: (value) {
                            setState(() {
                              selectedtmuniId = value ?? 0;
                            });
                            int selectedPosition = municipios?.indexWhere(
                                    (municipio) =>
                                        municipio.id == selectedtmuniId) ??
                                -1;
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
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
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Iconsax.map_1, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Complete el campo';
                        }
                        return null; // La validación pasó
                      },
                    ),
                    SizedBox(height: 30),
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
                            fechaEd,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Estado',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          //),
                          const SizedBox(width: TSizes.spacebtwInputFields),
                          MySwitch(
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            status: mascota.estado!,
                            onSwitchValueChanged: handleSwitchValueChanged,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          fixedSize: Size(0, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Mascota nuevoMasc = Mascota(
                              id: widget.idmasc,
                              usr: widget.usr,
                              tpmascota: selectedtipomascId,
                              nombre: txtNomb.text,
                              codigo: txtCodigo.text,
                              municipio: selectedtmuniId,
                              dir: txtDir.text,
                              estado: estadom,
                              nacim:
                                  '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                              img: _image,
                            );
                            editMasc(nuevoMasc, (response) {
                              print('Respuesta del servidor: $response');
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Campos invalidos')),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check),
                            // Agrega el icono de "check" aquí
                            const SizedBox(width: 8),
                            // Puedes ajustar el espacio según sea necesario
                            Text("Confirmar cambios"),
                          ],
                        ),
                      ),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () {
                              agregarVacuna(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                              ],
                            ),
                          ),
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
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    alerta(context, "¿Quiere eliminarlo?",
                                        items[index].id);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editMasc(Mascota usuario, Function callback) async {
    try {
      var url =
          'https://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php';
      var request = http.MultipartRequest('POST', Uri.parse(url));

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
        'accionr': 'U',
        'idr': usuario.id,
        'tpmascotar': usuario.tpmascota.toString(),
        'duenor': usuario.usr,
        'munir': usuario.municipio.toString(),
        'direccionr': usuario.dir,
        'nmascr': usuario.nombre,
        'codigor': usuario.codigo,
        'estador': usuario.estado,
        'userr': usuario.usr,
        'nacimr': usuario.nacim,
      });
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = json.decode(responseBody);
      callback(responseData);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Informacion actualizada",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        //widget.onClose();
      } else {
        print("Error en la respuesta: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void agregarVacuna(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Agregar Vacuna",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<int>(
                    key: ValueKey(selectedtipovacId),
                    value: selectedtipovacId,
                    items: tipovac?.map((tipovac) {
                          return DropdownMenuItem<int>(
                            value: tipovac.id,
                            child: Text(
                              tipovac.nombre,
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                          );
                        }).toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        selectedtipovacId = value!;
                        print('Vacuna seleccionada $selectedtipovacId');
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.lightBlue,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      insertVac(context);
                      Navigator.of(context).pop();
                    },
                    child: Text('Agregar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> insertVac(BuildContext context) async {
    try {
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_vacuna.php?accion=I'
          '&idmasc=${widget.idmasc} &idtpvac=$selectedtipovacId&user=${widget.usr}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        if (user['status'] == 1) {
          await cargarVacuna();
          setState(() {});
          Fluttertoast.showToast(
            msg: "Vacuna registrada",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
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

  Future<void> cargarDatos() async {
    try {
      await loadTipomasc();
      await loadDepartamentos();
      await cargarVacuna();
      await loadTipovac();
      final url =
          'http://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C&codigo=${widget.code}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          final mascotaInfo = jsonResponse['info']?[0]['mascota'];
          setState(() {
            mascota = MascotaLoad.fromJson(mascotaInfo);
            txtNomb.text = mascota.nmasc!;
            txtDir.text = mascota.direccion!;
            txtCodigo.text = mascota.codigo!;
            selectedtipomascId = int.parse(mascota.idtpmasc!);
            selectedDepartamentoId = int.parse(mascota.iddepto!);
            selectedtmuniId = int.parse(mascota.idmuni!);
            selectedDate = DateTime.parse(mascota.nacim!);
            fechaEd = DateFormat('dd-MM-yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(mascota.nacim!));
            isLoading = false;
          });
        } else {
          print("Error in API response: ${jsonResponse['status']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
      // }
    } catch (e) {
      print("Error 3: $e");
      setState(() {
        isLoading = false; // Marcar como cargados los datos en caso de error
      });
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
            int id = int.parse(result['id_vacuna'] ?? 'Id');
            String nombreVacuna =
                result['nombrevacuna'] ?? 'Nombre Vacuna Desconocido';
            String fecha = result['fechacr'] ?? 'Fecha desconocida';
            Vacuna newItem = Vacuna(nombreVacuna, fecha, id);
            //Vacuna2 newItem2= Vacuna2(nombreVacuna, fecha,id);
            if (!items.contains(newItem)) {
              items.add(newItem);
            }
          }
        } else {
          print('La clave "info" no es una lista en la respuesta JSON.');
        }
      } else {}
    } catch (e) {
      print("Error: $e");
      // Manejar excepciones
    }
  }

  void alerta(BuildContext context, String mensaje, int idvac) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Información Importante",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          content: Text(
            mensaje,
            style: TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await eliminarVac(context, idvac);
              },
              child: Text(
                "Aceptar",
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminarVac(BuildContext context, int idvac) async {
    try {
      final url = 'http://ginfinity.xyz/MyPets_Admin/servicios/'
          'prc/prc_vacuna.php?accion=D&id=$idvac';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        if (user['status'] == 1) {
          setState(() {
            items.removeWhere((vacuna) => vacuna.id == idvac);
          });
          Fluttertoast.showToast(
            msg: "Vacuna eliminada",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {}
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
        fechaEd =
            '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
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
    if (_image != null || mascota.foto != null) {
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

  Future<void> loadTipomasc() async {
    try {
      tipomasc = await getTipomasc();
      //setState(() {});
    } catch (e) {
      print('Error loading tipo masc: $e');
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

  Future<void> loadTipovac() async {
    try {
      tipovac = await getTipovac();
      //setState(() {});
    } catch (e) {
      print('Error loading tipo vac: $e');
    }
  }

  Future<List<Vacuna2>> getTipovac() async {
    String query1 =
        'https://ginfinity.xyz/MyPets_Admin/servicios/ctg/ctg_tipovacuna.php?accion=C&estado=A&idmasc=${widget.idmasc}';
    final response = await http.get(Uri.parse(query1));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> Vacuna = data['info'];

      return Vacuna.map((json) => Vacuna2.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tipo vacuna');
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

  void handleSwitchValueChanged(bool value) {
    if (value) {
      estadom = 'A';
    } else {
      estadom = 'I';
    }
  }
}

class Vacuna {
  int id;
  String nombrevacuna;
  String fechaCreacion;

  Vacuna(this.nombrevacuna, this.fechaCreacion, this.id);
}

class Vacuna2 {
  final int id;
  final String nombre;

  Vacuna2({required this.id, required this.nombre});

  factory Vacuna2.fromJson(Map<String, dynamic> json) {
    return Vacuna2(id: int.parse(json['id']), nombre: json['descripcion']);
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
    print(json['id']['id'] + ' ' + json['descripcion']);
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

class MascotaLoad {
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
  MascotaLoad({
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

  MascotaLoad.fromJson(Map<String, dynamic> json)
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

class Mascota {
  String id;
  String usr;
  String codigo;
  int tpmascota;
  String nombre;
  int municipio;
  String dir;
  String estado;
  String nacim;
  File? img;

  Mascota({
    required this.id,
    required this.usr,
    required this.codigo,
    required this.tpmascota,
    required this.nombre,
    required this.municipio,
    required this.dir,
    /*required this.stdir,*/
    required this.estado,
    required this.nacim,
    required this.img,
  });
}

typedef OnSwitchValueChanged = void Function(bool value);

class MySwitch extends StatefulWidget {
  final Color activeColor;
  final Color inactiveThumbColor;
  final String status; // Nuevo parámetro para el estado inicial
  final OnSwitchValueChanged? onSwitchValueChanged; // Agregado este parámetro

  MySwitch({
    required this.activeColor,
    required this.inactiveThumbColor,
    required this.status,
    this.onSwitchValueChanged, // Agregado este parámetro en el constructor
  });

  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    // Utilizar el valor de status para determinar el estado inicial
    _switchValue = widget.status.toLowerCase() == 'a';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
            // Llama a la función de devolución de llamada con el nuevo valor
            widget.onSwitchValueChanged?.call(_switchValue);
            if (_switchValue) {
              print('Switch value changed to: A');
            } else {
              print('Switch value changed to: I');
            }
          },
          activeColor: widget.activeColor,
          inactiveThumbColor: widget.inactiveThumbColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
