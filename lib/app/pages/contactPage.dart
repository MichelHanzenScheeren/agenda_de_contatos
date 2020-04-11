import 'dart:io';
import 'package:agendadecontatos/app/models/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool modified = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = widget.contact;
      nameController.text = _editedContact.name;
      emailController.text = _editedContact.email;
      phoneController.text = _editedContact.phone;
    }
  }

  Future<bool> _validatePop() {
    if (modified) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Confirmar"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _validatePop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: () {
            if (_keyForm.currentState.validate()) {
              _editedContact.name = nameController.text;
              _editedContact.email = emailController.text;
              _editedContact.phone = phoneController.text;
              Navigator.pop(context, _editedContact);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _keyForm,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("assets/images/contact.png"),
                      ),
                    ),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file == null)
                        return;
                      else {
                        setState(() {
                          _editedContact.img = file.path;
                        });
                      }
                    });
                  },
                ),
                generateTextField(nameController, "Nome", validate: validator),
                generateTextField(emailController, "Email",
                    tipo: TextInputType.emailAddress),
                generateTextField(phoneController, "Telefone",
                    validate: validator, tipo: TextInputType.phone),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generateTextField(TextEditingController controler, String label,
      {Function validate, TextInputType tipo: TextInputType.text}) {
    return TextFormField(
      controller: controler,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 20),
      ),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (text) {
        if (!modified) {
          modified = true;
        }
      },
      validator: validate,
    );
  }

  String validator(String text) {
    if (text.isEmpty)
      return "Preenchimento obrigatório!";
    else
      return null;
  }
}
