import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mypets_app/dashbo/first/addmascota.dart';

class Home extends StatefulWidget {
  final String usr;

  Home({required this.usr});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  dynamic _selectedIndex = {};
  bool subpage = false;

  CarouselController _carouselController = CarouselController();

  List<dynamic> _mascotas = []; // Lista para almacenar las mascotas del usuario

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener las mascotas del usuario
    fetchMascotas();
  }

  Future<void> fetchMascotas() async {
    try {
      final url = 'https://ginfinity.xyz/MyPets_Admin/servicios/prc/prc_mascota.php?accion=C'; // Reemplaza con la URL de tu endpoint
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic>? mascotasList = jsonResponse['info']?[0]['mascota'];
        if (mascotasList != null) {
          setState(() {
            _mascotas = mascotasList;
          });
        }
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
        // Aquí puedes manejar el error de la solicitud HTTP si es necesario
      }
    } catch (e) {
      print('Error: $e');
      // Aquí puedes manejar cualquier otro error que pueda ocurrir durante el proceso
    }
  }

  Uint8List tryDecodeBase64(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      print("Error decodificando base64: $e");
      // Puedes devolver una imagen de error o cualquier valor predeterminado
      return Uint8List.fromList([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(subpage);
          subpage = true;
        },
        backgroundColor: const Color.fromARGB(255, 51, 163, 255),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Bienvenido: ${widget.usr}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:subpage
          ? AddMascota(
          onClose: () {
            setState(() {
              subpage = false;
            });
          },
          usr: widget.usr)
          :  Container(
        width: double.infinity,
        height: double.infinity,
        child: CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 430.0,
            aspectRatio: 16 / 9,
            viewportFraction: 0.70,
            enlargeCenterPage: true,
            pageSnapping: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: _mascotas.map((mascota) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedIndex == mascota) {
                        _selectedIndex = {};
                      } else {
                        _selectedIndex = mascota;
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: _selectedIndex == mascota
                          ? Border.all(color: Colors.blue.shade500, width: 3)
                          : null,
                      boxShadow: _selectedIndex == mascota
                          ? [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 320,
                            margin: EdgeInsets.only(top: 10),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: mascota['foto'] != null
                                ? Image.memory(
                                    tryDecodeBase64(mascota['foto']),
                                    fit: BoxFit.cover,
                                  )
                                : Placeholder(), // Placeholder si no hay imagen disponible
                          ),
                          SizedBox(height: 20),
                          Text(
                            mascota['nmasc'], // Nombre de la mascota
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            mascota['tipomasc'], // Tipo de mascota
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
