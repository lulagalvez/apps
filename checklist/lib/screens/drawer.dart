import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BarraLateral extends StatelessWidget {
  final String? name;
  const BarraLateral({Key? key, required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.cyan,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text("$name"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Opcion 2"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Opcion 3"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Opcion 4"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
