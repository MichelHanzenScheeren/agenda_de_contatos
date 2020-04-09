import 'package:agendadecontatos/app/pages/contactPage.dart';
import 'package:flutter/material.dart';
import 'package:agendadecontatos/app/pages/homePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agenda de Contatos",
      home: ContactPage(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
    );
  }
}
