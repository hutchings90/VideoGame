import 'package:flutter/material.dart';

class VideoGameWidget extends StatelessWidget {
  final Map<String, dynamic> videoGame;
  final Function onPressed;

  VideoGameWidget(this.videoGame, { this.onPressed });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => onPressed(videoGame),
      child: Text(videoGame['name'])
    );
  }
}