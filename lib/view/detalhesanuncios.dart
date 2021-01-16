import 'package:flutter/material.dart';
import 'package:oxl/main.dart';
import 'package:oxl/model/anuncio.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  Anuncio anuncio;

  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  List<Widget> _getImages() {
    List<String> listaImagens = widget.anuncio.fotos;
    return listaImagens.map((e) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(e), fit: BoxFit.fitWidth)),
      );
    }).toList();
  }

  _ligarTelefone(String fone) async {
    if (await canLaunch(fone)) {
      await launch("tel:$fone");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anuncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getImages(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.white,
                  autoplay: false,
                  dotIncreasedColor: tema.primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "R\$ ${widget.anuncio.preco}",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: tema.primaryColor),
                    ),
                    Text(
                      "${widget.anuncio.titulo}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Contato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${widget.anuncio.telefone}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 16,
                      child: GestureDetector(
                        child: Container(
                          child: Text(
                            "Ligar",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: tema.primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onTap: () {
                          _ligarTelefone(widget.anuncio.telefone);
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
