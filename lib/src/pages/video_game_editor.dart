import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../game_contact_widget.dart';
import '../contact_picker.dart';

class VideoGameEditor extends StatefulWidget {
  final Map<String, dynamic> videoGame;
  final Database db;
  final Function onSave;

  VideoGameEditor(this.videoGame, this.db, this.onSave, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => VideoGameEditorState();
}

class VideoGameEditorState extends State<VideoGameEditor> {
  TextEditingController nameController;
  List<Map<String, dynamic>> gameContacts = List<Map<String, dynamic>>(), contactsToAdd = List<Map<String, dynamic>>();
  List<int> removalIndexes = List<int>();

  List<Map<String, dynamic>> get allContacts => gameContacts + contactsToAdd;

  List<Map<String, dynamic>> get appliedContacts {
    List<Map<String, dynamic>> contacts = List.from(allContacts);

    removalIndexes.sort();
    removalIndexes.reversed.forEach((int index) => contacts.removeAt(index));

    return contacts;
  }

  List<Widget> get gameContactsWidgets {
    int i = 0;

    return appliedContacts.fold(List<Widget>(), (List<Widget> total, Map<String, dynamic> contact) {
      Map<String, dynamic> mappedContact = Map.from(contact);

      mappedContact['i'] = i++;

      total.add(GameContactWidget(mappedContact, removeContact));

      return total;
    });
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.videoGame['name']);

    queryGameContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[Text('Video Game'), Padding(
            padding: EdgeInsets.only(left: 10),
            child: RaisedButton(
              onPressed: addContactEditor,
              child: Text('Add Contact')
            )
          )]
        )
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(
            children: <Widget>[TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name'
                )
              ),
              Flexible(
                child: ListView(
                  children: gameContactsWidgets,
                )
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: Icon(Icons.check)
      ),
    );
  }
  
  queryGameContacts() {
    widget.db.query('video_game_contact', where: 'video_game_id=' + widget.videoGame['id'].toString()).then(queryContacts);
  }

  queryContacts(List<Map<String, dynamic>> gameContacts) {
    if (gameContacts.length > 0) widget.db.query('contact', where: 'id in (' + gameContacts.map((Map<String, dynamic> gameContact) => gameContact['contact_id']).join(', ') + ')').then(setGameContacts);
  }

  setGameContacts(List<Map<String, dynamic>> contacts) {
    setState(() => gameContacts = contacts);
  }
  
  save() {
    Navigator.pop(context);

    widget.onSave(widget.videoGame, {
      'videoGame': {
        'name': nameController.value.text
      },
      'contacts': appliedContacts
    });
  }

  addContactEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPicker(widget.db, addContact),
      ),
    );
  }

  addContact(Map<String, dynamic> values) {
    Navigator.pop(context);

    setState(() => contactsToAdd.add(values));
  }

  removeContact(Map<String, dynamic> contact) {
    setState(() => removalIndexes.add(contact['i']));
  }
}