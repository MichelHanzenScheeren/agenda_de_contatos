import 'package:flutter/material.dart';
import 'package:agendadecontatos/app/homePage/HomePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agenda de Contatos",
      home: HomePage(),
    );
  }
}
