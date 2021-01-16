import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxl/model/anuncio.dart';
import 'package:oxl/view/widget/itemanuncio.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuario;

  _recuperaUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    String _idUsuario = user.uid;
  }

  _removerAnuncio(String id) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus-anuncios")
        .doc(_idUsuario)
        .collection("anuncios")
        .doc(id)
        .delete()
        .then((_) {
      db.collection("anuncios").doc(id).delete();
    });
  }

  Stream<QuerySnapshot> _adicionarListener() {
    _recuperaUsuario();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus-anuncios")
        .doc(_idUsuario)
        .collection("anuncios")
        .snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListener();
  }

  @override
  Widget build(BuildContext context) {
    var carregaDados = Center(
      child: Column(
        children: [Text("Carregando"), CircularProgressIndicator()],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus anuncios"),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregaDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro");
              } else {
                QuerySnapshot data = snapshot.data;
                return ListView.builder(
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> anuncios = data.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[index];
                    Anuncio anuncio =
                        Anuncio.fromDocumentSnapshot(documentSnapshot);
                    return ItemAnuncio(
                      anuncio: anuncio,
                      onPressedRemover: () {
                        showDialog(
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("Deseja remover o produto?"),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        _removerAnuncio(anuncio.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Confirmar",
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ],
                              );
                            },
                            context: context);
                      },
                    );
                  },
                  itemCount: data.docs.length,
                );
              }
          }
          return Container();
        },
        stream: _controller.stream,
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/novoanuncio");
          }),
    );
  }
}
