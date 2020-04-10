import 'dart:io';

import 'package:agendadecontatos/app/models/contact.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact =
          Contact.fromMap(widget.contact.toMap()); //para criar cópia
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact.img != null
                        ? FileImage(File(_editedContact.img))
                        : AssetImage("assets/images/contact.png"),
                  ),
                ),
              ),
              onTap: () {},
            ),
            generateTextField(nameController, "Nome", TextInputType.text,
                foco: true),
            Divider(),
            generateTextField(
                emailController, "Email", TextInputType.emailAddress),
            Divider(),
            generateTextField(phoneController, "Telefone", TextInputType.phone),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget generateTextField(
      TextEditingController controler, String label, TextInputType tipo,
      {bool foco: false}) {
    return TextField(
      controller: controler,
      keyboardType: tipo,
      autofocus: foco,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
