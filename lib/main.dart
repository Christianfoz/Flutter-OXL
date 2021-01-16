import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxl/route.dart';
import 'package:oxl/view/anuncios.dart';
import 'package:oxl/view/login.dart';

final ThemeData tema =
    ThemeData(accentColor: Color(0xff7b1fa2), primaryColor: Color(0xff9c27b0));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Anuncios(),
    theme: tema,
    initialRoute: "/",
    onGenerateRoute: RouteGen.generateRoute,
  ));
}
