import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  final Map<String, dynamic> contact;

  ContactWidget(this.contact);

  @override
  Widget build(BuildContext context) {
    String text = '';
    String firstName = contact['first_name'].toString();
    String lastName = contact['last_name'].toString();
    String phoneNumber = contact['phone_number'].toString();

    if (firstName.length > 0) text += firstName;

    if (lastName.length > 0) {
      if (text.length > 0) text += ' ';

      text += lastName;
    }

    if (phoneNumber.length > 0) {
      if (text.length > 0) text += ', ';

      if (phoneNumber.length != 10) text += phoneNumber;
      else text += '(' + phoneNumber.substring(0, 3) + ') ' + phoneNumber.substring(3, 6) + '-' + phoneNumber.substring(6);
    }

    return Text(text);
  }
}