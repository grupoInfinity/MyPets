import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String labelText; // Agrega un nuevo parámetro labelText
  final void Function()? onPressed;

  const MyTextBox({
    Key? key,
    required this.text,
    required this.labelText, // Agrega este parámetro
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LabelText predeterminado
              Text(
                labelText,
                style: TextStyle(color: Colors.grey[500]),
              ),
              // Boton Para Editar
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          // Texto
          Text(text),
        ],
      ),
    );
  }
}