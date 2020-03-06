import 'package:flutter/material.dart';

class ContactEditor extends StatefulWidget {
  final Map<String, dynamic> contact;
  final Function onSave;

  ContactEditor(this.contact, this.onSave, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ContactEditorState();
}

class ContactEditorState extends State<ContactEditor> {
  TextEditingController firstNameController, lastNameController, phoneNumberController;

  @override
  void initState() {
    firstNameController = TextEditingController(text: widget.contact['first_name']);
    lastNameController = TextEditingController(text: widget.contact['last_name']);
    phoneNumberController = TextEditingController(text: widget.contact['phone_number']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.contact.containsKey('id') ? 'Edit' : 'Create') + ' Contact')
      ),
      body: Column(
        children: <Widget>[TextField(
          controller: firstNameController,
          decoration: InputDecoration(
            labelText: 'First Name'
          )
        ), TextField(
          controller: lastNameController,
          decoration: InputDecoration(
            labelText: 'Last Name'
          )
        ), TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number'
          )
        )]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: Icon(Icons.check)
      ),
    );
  }
  
  save() {
    Navigator.pop(context);
    widget.onSave(widget.contact, {
      'first_name': firstNameController.value.text,
      'last_name': lastNameController.value.text,
      'phone_number': phoneNumberController.value.text
    });
  }
}