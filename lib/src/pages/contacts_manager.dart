import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'contact_editor.dart';
import '../contact_widget.dart';

class ContactsManager extends StatefulWidget {
  final Database db;

  ContactsManager(this.db, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ContactsManagerState();
}

class ContactsManagerState extends State<ContactsManager> {
  final String tableName = 'contact';
  List<Widget> contactWidgets = List<Widget>();

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
        children: contactWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addContact,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      )
    );
  }

  queryContacts() {
    widget.db.query(tableName).then(setContactsWidgets);
  }

  setContactsWidgets(List<Map<String, dynamic>> contacts) {
    setState(() => contactWidgets = contacts.map((Map<String, dynamic> contact) => FlatButton(
      child: ContactWidget(contact),
      onPressed: () => _addEditContactPage(contact)
    )).toList());
  }

  addContact() {
    _addEditContactPage({
      'first_name': '',
      'last_name': '',
      'phone_number': ''
    });
  }

  _addEditContactPage(Map<String, dynamic> contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactEditor(contact, saveContact),
      ),
    );
  }

  saveContact(Map<String, dynamic> contact, Map<String, dynamic> values) {
    widget.db.transaction((Transaction transaction) async {
      if (contact.containsKey('id')) transaction.update(tableName, values, where: 'id=' + contact['id'].toString()).then((id) => queryContacts());
      else transaction.insert(tableName, values).then((id) => queryContacts());
    });
  }
}