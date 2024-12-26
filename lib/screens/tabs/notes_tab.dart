import 'package:flutter/material.dart';

class NotesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Center(
        child: Text('Notes Content'),
      ),
    );
  }
} 