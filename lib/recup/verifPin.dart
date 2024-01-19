import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class verifPin extends StatelessWidget {
  final String usr;
  verifPin({required this.usr});
  final TextEditingController txtPin = TextEditingController();

  /*Future<void> logear(BuildContext context) async {
    try {
      final url = 'http://192.168.1.11/MyPets_Admin/servicios/'
          'sec/sec_usuario.php?accion=C&usr=$usr&estado=A';
      final response = await http.get(Uri.parse(url));
      //logger.d('Solicitando datos a: $url');
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);

        if (user['status'] == 1) {
          List<dynamic> infoList = user['info'];

          if (infoList.isNotEmpty) {
            usuario = infoList[0]['usr'];
            final url2 =
                'http://192.168.1.11/MyPets_Admin/servicios/sec/sec_usuario.php?accion=U' +
                    '&usorig=$usuario&user=$usuario';
            final response2 = await http.get(Uri.parse(url2));
            if (response2.statusCode == 200) {
              final url3 =
                  'http://192.168.1.11/MyPets_Admin/servicios/sec/sec_usuario.php?'
                  'accion=C&usr=$usuario';
              final response3 = await http.get(Uri.parse(url3));
              if (response3.statusCode == 200) {
                Map<String, dynamic> user2 = json.decode(response3.body);
                if (user['status'] == 1) {
                  List<dynamic> infoList2 = user['info'];
                  if (infoList.isNotEmpty) {
                    final url4 =
                        'http://192.168.1.11/MyPets_Admin/servicios/PHPMailer.php?user=' +
                            infoList[0]['usr'] +'&pin=' +infoList[0]['pin'] +
                            '&email=' +infoList[0]['email'];
                    final response4 = await http.get(Uri.parse(url4));
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => verif(idUs: idUs),
                      ),
                    );
                    /*if (response4.statusCode == 200) {

                    }*/
                  }
                }
              }
            }
            /*Navigator.push(
              context ,
              MaterialPageRoute(builder: (context) => dashboard(usr: usuario)),
            );*/
          } else {
            // Mostrar un mensaje de alerta si la lista está vacía
            Fluttertoast.showToast(
              msg: "Credenciales incorrectas",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          // Mostrar un mensaje de alerta si el estado no es 1
          Fluttertoast.showToast(
            msg: "Credenciales incorrectas",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        // Mostrar un mensaje de alerta si la solicitud no es exitosa
        Fluttertoast.showToast(
          msg: "Error en la respuesta: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error: $e");
      //logger.e('Error: $e');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
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
            child: Column(
              children: <Widget>[
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
                Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 395,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.0, top: 0.1),
                          child: Text(
                            "Recuperacion de clave",
                            style: TextStyle(
                              fontFamily: 'GemunuLibre',
                              fontSize: 34,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(243, 243, 243, 243),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10.0,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: txtPin,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Usuario",
                                            hintStyle:
                                            TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(243, 243, 243, 243),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10.0,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(41, 150, 189, 1),
                                        Color.fromRGBO(41, 150, 189, 1)
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //AQUI
                                      //logear(context, txtPin.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Confirmar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
