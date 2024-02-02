import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mypets_app/contanst/app_contanst.dart';

class Principal extends StatelessWidget {
  const Principal({Key? key}) : super(key: key);

  _buildButton({String? title, Color? color, VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color ?? Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            title ?? 'title',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                child: Container(
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        height: MediaQuery.of(context).size.height * .1,
                        child: Text(
            "MyPets: ¡Tu registro completo para tus fieles compañeros!",
            textAlign: TextAlign.center,
            style: GoogleFonts.abel(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 30,
                          ),
                         ),
                        ),
                      
                      SizedBox(height: 120,),
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded( // Registrarse Button
                                child: _buildButton(
                                  title: AppContanst.RegistrarseT,
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/registro');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10), //Log In Button
                              Expanded(
                                child: _buildButton(
                                  title: AppContanst.LogInT,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
