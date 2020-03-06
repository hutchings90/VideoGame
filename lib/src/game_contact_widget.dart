import 'package:flutter/material.dart';

import 'contact_widget.dart';

class GameContactWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final Function onDelete;

  GameContactWidget(this.contact, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[SizedBox(
        child: FlatButton(
          child: Icon(Icons.delete),
          onPressed: remove,
          textColor: Colors.red,
        )
      ), SizedBox(
        child: ContactWidget(contact)
      )]
    );
  }

  remove() {
    onDelete(contact);
  }
}