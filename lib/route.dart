import 'package:flutter/material.dart';
import 'package:oxl/view/anuncios.dart';
import 'package:oxl/view/detalhesanuncios.dart';
import 'package:oxl/view/login.dart';
import 'package:oxl/view/meuasanuncios.dart';
import 'package:oxl/view/novoanuncio.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => Anuncios());
        break;
      case "/meusanuncios":
        return MaterialPageRoute(builder: (context) => MeusAnuncios());
        break;
      case "/novoanuncio":
        return MaterialPageRoute(builder: (context) => NovoAnuncio());
        break;
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/detalhesanuncio":
        return MaterialPageRoute(builder: (_) => DetalhesAnuncio(args));
        break;
      default:
    }
  }
}
