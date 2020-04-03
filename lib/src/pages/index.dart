import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class IndexPage extends StatefulWidget {
  final Database db;
  final String callName;
  final Function(String channelName) onJoin;

  IndexPage(this.db, this.callName, this.onJoin, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  Map<int, bool> includedIds = Map<int, bool>();
  List<Map<String, dynamic>> contacts = <Map<String, dynamic>>[];

  List<Widget> get _contactWidgets {
    return contacts.map((Map<String, dynamic> contact) {
      return CheckboxListTile(
        title: Text(contact['first_name'] + ' ' + contact['last_name']),
        value: includedIds.containsKey(contact['id']) && includedIds[contact['id']],
        onChanged: (bool include) => _toggleContact(include, contact));
    }).toList();
  }

  _toggleContact(bool include, Map<String, dynamic> contact) {
    setState(() => includedIds[contact['id']] = include);
  }

  @override
  void initState() {
    _queryContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Flutter QuickStart'),
      ),
      body: ListView(
        children: _contactWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.onJoin('Yahtzee'),
        child: Icon(Icons.check)
      ),
    );
  }

  _queryContacts() {
    widget.db.query('contact').then(setContactsWidgets);
  }

  setContactsWidgets(List<Map<String, dynamic>> dbContacts) {
    setState(() => contacts = dbContacts);
  }
}
