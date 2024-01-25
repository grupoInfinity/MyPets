import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';

class AddMascota extends StatelessWidget {
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
                SizedBox(height: AppBar().preferredSize.height),
                Center(
  child: Text(
    "Crea un nuevo perfil para tu mascota",
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
        ),
  ),
),
                const SizedBox(height: TSizes.spacebtwSections),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Campo 1",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: Icon(Iconsax.user, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Campo 2",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          prefixIcon: Icon(Iconsax.user, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Campo 3",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Iconsax.user1, color: Colors.white),
                        ),
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
                          prefixIcon: Icon(Iconsax.activity, color: Colors.white),
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
                          prefixIcon: Icon(Iconsax.password_check, color: Colors.white),
                        
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
                          onPressed: () {
                            
                           
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
    );
  }
}
