import 'dart:io';

import 'package:agendadecontatos/app/helpers/contactHelper.dart';
import 'package:agendadecontatos/app/models/contact.dart';
import 'package:agendadecontatos/app/pages/contactPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper _helper = ContactHelper();
  List<Contact> _contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    _helper.getAll().then((data) => setState(() => _contacts = data));
  }

  Future _editContact(Contact contact) async {
    await _helper.update(contact);
  }

  Future _deleteContact(int index) async {
    await _helper.delete(_contacts[index].id);
  }

  Future _createContact(Contact contact) async {
    await _helper.save(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contatos"),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: _showContactPage,
        ),
        body: ListView.builder(
            padding: EdgeInsets.fromLTRB(1, 10, 1, 10),
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              return buildContactList(context, index);
            }));
  }

  Widget buildContactList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.white),
                top: BorderSide(color: Colors.white))),
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _contacts[index].img != null
                          ? FileImage(File(_contacts[index].img))
                          : AssetImage("assets/images/contact.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _generateText(_contacts[index].name, 20.0),
                      _generateText(_contacts[index].email, 17.0),
                      _generateText(_contacts[index].phone, 17.0),
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

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                color: Colors.deepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.call),
                      onPressed: () {
                        launch("tel:${_contacts[index].phone}");
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: FlatButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(ctt: _contacts[index]);
                        },
                      ),
                    ),
                    FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteDialog(context, index);
                      },
                    ),
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tem certeza que deseja excluir?"),
          content: Text("Contatos apagados NÃO podem ser recuperados!"),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCELAR"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("EXCLUIR"),
              onPressed: () async {
                await _deleteContact(index);
                setState(() {
                  _contacts.removeAt(index);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _generateText(String text, double tamanho) {
    return Text(
      text != "" ? text : "Email não informado",
      style: TextStyle(
        fontSize: tamanho,
        color: Colors.white,
      ),
    );
  }

  void _showContactPage({Contact ctt}) async {
    final newContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: ctt)));
    if (newContact != null) {
      await _verifiContacts(ctt, newContact);
      _getAllContacts();
    }
  }

  Future _verifiContacts(Contact ctt, Contact newContact) async {
    if (ctt != null) {
      await _editContact(newContact);
    } else {
      await _createContact(newContact);
    }
  }
}
