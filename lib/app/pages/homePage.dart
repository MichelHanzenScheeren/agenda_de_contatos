import 'package:agendadecontatos/app/helpers/contactHelper.dart';
import 'package:agendadecontatos/app/models/contact.dart';
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

    _helper.getAll().then((data) {
      setState(() {
        _contacts = data;
      });
    });
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
          onPressed: () {},
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              return buildContactList(context, index);
            }));
  }

  Widget buildContactList(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        color: Colors.black,
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/contact.png"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _contacts[index].name ?? "Não informado",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _contacts[index].email ?? "Não informado",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    _contacts[index].phone ?? "Não informado",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
