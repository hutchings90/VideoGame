import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'contact_widget.dart';

class ContactPicker extends StatefulWidget {
  final Database db;
  final Function onPressed;

  ContactPicker(this.db, this.onPressed);

  @override
  State<StatefulWidget> createState() => ContactPickerState();
}

class ContactPickerState extends State<ContactPicker> {
  List<Widget> contactsWidgets = List<Widget>();

  @override
  void initState() {
    queryContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts')
      ),
      body: ListView(
        children: contactsWidgets
      )
    );
  }
  
  queryContacts() {
    widget.db.query('contact').then(setContactsWidgets);
  }

  setContactsWidgets(List<Map<String, dynamic>> contacts) {
    setState(() {
      contactsWidgets = contacts.map((Map<String, dynamic> contact) {
        return FlatButton(
          child: ContactWidget(contact),
          onPressed: () => contactPressed(contact)
        );
      }).toList();
    });
  }

  contactPressed(Map<String, dynamic> contact) {
    widget.onPressed(contact);
  }
}