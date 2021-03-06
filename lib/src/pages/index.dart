import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class IndexPage extends StatefulWidget {
  final Database db;
  final String callName;
  final Function(String, List<Map<String, dynamic>>) onJoin;

  IndexPage(this.db, this.callName, this.onJoin, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  Map<int, bool> _includedIds = Map<int, bool>();
  List<Map<String, dynamic>> _contacts = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get _includedContacts => _contacts.where((Map<String, dynamic> contact) => _includedIds.containsKey(contact['id']) && _includedIds[contact['id']]).toList();

  List<Widget> get _contactWidgets {
    return _contacts.map((Map<String, dynamic> contact) {
      return CheckboxListTile(
        title: Text(contact['first_name'] + ' ' + contact['last_name']),
        value: _includedIds.containsKey(contact['id']) && _includedIds[contact['id']],
        onChanged: (bool include) => _toggleContact(include, contact));
    }).toList();
  }

  _toggleContact(bool include, Map<String, dynamic> contact) {
    setState(() => _includedIds[contact['id']] = include);
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
        onPressed: () => widget.onJoin('Yahtzee', _includedContacts),
        child: Icon(Icons.check)
      ),
    );
  }

  _queryContacts() {
    widget.db.query('contact').then(_setContactsWidgets);
  }

  _setContactsWidgets(List<Map<String, dynamic>> contacts) {
    setState(() => _contacts = contacts);
  }
}
