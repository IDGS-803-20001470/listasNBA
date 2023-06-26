import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Elementos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Catalogo de Jugadores de la NBA'),
    );
  }
}
