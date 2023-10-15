import 'package:flutter/material.dart';
import 'package:checklist/screens/login_screen.dart';

// ignore: must_be_immutable
class BarraLateral extends StatelessWidget {
  final String? name;
  final VoidCallback onNuevaTarea;
  final VoidCallback onEliminarTareas;
  const BarraLateral(
      {Key? key,
      required this.name,
      required this.onNuevaTarea,
      required this.onEliminarTareas})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                '$name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Nueva Tarea'),
            onTap: () {
              Navigator.of(context).pop();
              onNuevaTarea();
            },
          ),
          ListTile(
            title: const Text('Borrar Todo'),
            onTap: () {
              Navigator.of(context).pop();
              onEliminarTareas();
            },
          ),
          ListTile(
            title: const Text('Acerca De'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const MyFormLogin()), // Acerda De
              );
            },
          ),
          ListTile(
            title: const Text('Salir'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
