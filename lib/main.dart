import 'package:flutter/material.dart';
import 'package:hasura_flutter/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Hasura Flutter',
    theme: ThemeData(
      primaryColor: Colors.brown
    ),
    home: HomePage(),
  ));
}