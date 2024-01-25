import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mypets_app/dashbo/first/addmascota.dart';

class home extends StatefulWidget {
  final String usr;

  home({required this.usr});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _current = 0;
  dynamic _selectedIndex = {};
  bool subpage = false;

  CarouselController _carouselController = new CarouselController();

  List<dynamic> _products = [
    {
      'title': 'Mascota 1',
      'image': 'assets/images/Mascota1.png',
      'description': 'Perro'
    },
    {
      'title': 'Mascota 2',
      'image': 'android/assets/images/Mascota2.png',
      'description': 'Perro'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: const Color.fromARGB(255, 51, 163, 255),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Bienvenido: ${widget.usr}', style: TextStyle(
  color: Colors.black,
)),
    ),
      body: Container(
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
                }),
            items: _products.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == movie) {
                          _selectedIndex = {};
                        } else {
                          _selectedIndex = movie;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: _selectedIndex == movie
                              ? Border.all(
                                  color: Colors.blue.shade500, width: 3)
                              : null,
                          boxShadow: _selectedIndex == movie
                              ? [
                                  BoxShadow(
                                      color: Colors.blue.shade100,
                                      blurRadius: 30,
                                      offset: Offset(0, 10))
                                ]
                              : [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: Offset(0, 5))
                                ]),
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
                              child: Image.asset(_products[0]['image'],
                                  fit: BoxFit.cover),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              movie['title'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              movie['description'],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList()),
      ),
    );
  }
}
