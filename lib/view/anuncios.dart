import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oxl/model/anuncio.dart';
import 'package:oxl/view/util/configuracoes.dart';
import 'package:oxl/view/widget/itemanuncio.dart';

class Anuncios extends StatefulWidget {
  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> _itens = ["A", "B"];
  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;
  List<DropdownMenuItem<String>> _listaDropEstados = List();
  //String seria o valor e não o titulo
  List<DropdownMenuItem<String>> _listaDropCategorias = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _escolhaItem(String item) {
    switch (item) {
      case "Meus Anúncios":
        Navigator.pushNamed(context, "/meusanuncios");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Entrar/Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      default:
    }
  }

  Future _verificaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    if (user == null) {
      _itens = ["Entrar/Cadastrar"];
    } else {
      _itens = ["Meus Anúncios", "Deslogar"];
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamed(context, "/login");
  }

  Future<Stream<QuerySnapshot>> _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");
    if (_itemSelecionadoEstado != null) {
      query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }
    if (_itemSelecionadoCategoria != null) {
      query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }
    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListener() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarItensDropdown();
    _verificaUsuario();
    _adicionarListener();
  }

  _carregarItensDropdown() {
    _listaDropCategorias = Configuracoes.getCategorias();
    _listaDropEstados = Configuracoes.getEstados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaItem,
            itemBuilder: (context) {
              return _itens.map((String e) {
                return PopupMenuItem(value: e, child: Text(e));
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: DropdownButtonHideUnderline(
                        child: Center(
                  child: DropdownButton(
                      iconEnabledColor: Color(0xff9c27b0),
                      value: _itemSelecionadoEstado,
                      items: _listaDropEstados,
                      onChanged: (estado) {
                        setState(() {
                          _itemSelecionadoEstado = estado;
                          _filtrarAnuncios();
                        });
                      }),
                ))),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),
                Expanded(
                    child: DropdownButtonHideUnderline(
                        child: Center(
                  child: DropdownButton(
                      iconEnabledColor: Color(0xff9c27b0),
                      value: _itemSelecionadoCategoria,
                      items: _listaDropCategorias,
                      onChanged: (categoria) {
                        setState(() {
                          _itemSelecionadoCategoria = categoria;
                          _filtrarAnuncios();
                        });
                      }),
                )))
              ],
            ),
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Column(
                          children: [
                            Text("Carregando"),
                            CircularProgressIndicator()
                          ],
                        ),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (querySnapshot.docs.length == 0) {
                        return Container(
                          padding: EdgeInsets.all(25),
                          child: Text("Sem anuncio"),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_, index) {
                              List<DocumentSnapshot> anuncios =
                                  querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot =
                                  anuncios[index];
                              Anuncio anuncio = Anuncio.fromDocumentSnapshot(
                                  documentSnapshot);
                              return ItemAnuncio(
                                anuncio: anuncio,
                                onTapItem: () {
                                  Navigator.pushNamed(
                                      context, "/detalhesanuncio",
                                      arguments: anuncio);
                                },
                              );
                            }),
                      );
                  }

                  return Container();
                })
          ],
        ),
      ),
    );
  }
}
