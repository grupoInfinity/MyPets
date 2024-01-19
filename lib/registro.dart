import 'package:flutter/material.dart';
import 'package:mypets_app/contanst/app_contanst.dart';
import 'package:iconsax/iconsax.dart';

class RegistroP extends StatelessWidget {
  const RegistroP({Key? key});

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultspace),
            child: Column(
              children: [
                SizedBox(height: AppBar().preferredSize.height), // Alinea el contenido debajo del AppBar
                Text(
                  "Crea tu Cuenta en MyPets!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spacebtwSections),
                Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                labelText: "Nombre",
                                prefixIcon: Icon(Iconsax.user),
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.spacebtwInputFields),
                          Expanded(
                            child: TextFormField(
                              expands: false,
                              decoration: const InputDecoration(labelText: "Apellido", prefixIcon: Icon(Iconsax.user)
                              ),
                            ),
                          ),
                         
                          
                          
                      
                        ],
                      ),
                       const SizedBox(height: TSizes.spacebtwInputFields),
                           
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(labelText: "Correo Electronico", prefixIcon: Icon(Iconsax.direct)
                              ),
                            ),
                      const SizedBox(height: TSizes.spacebtwInputFields),
                            TextFormField(
                              
                              decoration: const InputDecoration(labelText: "Usuario", prefixIcon: Icon(Iconsax.user1)
                              ),
                            ),
                          
                     TextFormField(
                            obscureText: true,
                              
                              decoration: const InputDecoration(labelText: "Contraseña", prefixIcon: Icon(Iconsax.password_check),
                              suffixIcon: Icon(Iconsax.eye_slash)
                              ),
                            ),
                            const SizedBox(height: TSizes.spacebtwSections),
                            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: Text("Crear Cuenta")),)
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
